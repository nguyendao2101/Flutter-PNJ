import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/by_cart_view_model.dart';
import 'package:get/get.dart';

import '../../../view_model/profile_view_model.dart';
import '../../app_bar/personal_apbar.dart';
import '../button/bassic_button.dart';

class Addresses extends StatefulWidget {
  const Addresses({super.key});

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, String> _addresses = {}; // Variable to hold the addresses
  final controller = Get.put(ByCartViewModel());
  Future<Map<String, String>>? _locationsFuture;
  late Map<String, String> addresses = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationsFuture = controller.listenToAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProfile(title: 'Addresses'),
      body: FutureBuilder<Map<String, String>>(
        future: _locationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi khi tải dữ liệu: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            addresses = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                String key = addresses.keys.elementAt(index);
                String address = addresses[key]!;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.blue),
                    title: Text("Địa chỉ $key", style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),),
                    subtitle: Text(address, style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteAddressFromFirebase(key); // Gọi hàm xóa
                        setState(() {
                          addresses.remove(key);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Không có địa chỉ nào.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressModal(context),
        backgroundColor: Color(0xffEF5350),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddAddressModal(BuildContext context) {
    TextEditingController nameAddressController = TextEditingController();
    TextEditingController streetController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController countryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Add Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameAddressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff979797).withOpacity(0.1),
                      label: const Text('Address Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: countryController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff979797).withOpacity(0.1),
                      label: const Text('Country'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff979797).withOpacity(0.1),
                      label: const Text('City'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: streetController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff979797).withOpacity(0.1),
                      label: const Text('Street'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 24),
                  BasicAppButton(
                    onPressed: () async {
                      await uploadAddressToFirebase(
                        nameAddressController,
                        streetController,
                        cityController,
                        countryController,
                      );
                      setState(() {
                      }); // Cập nhật lại Future để FutureBuilder chạy lại
                      FocusScope.of(context).unfocus();
                    },
                    title: 'Add',
                    sizeTitle: 16,
                    fontW: FontWeight.w500,
                    colorButton: const Color(0xffA02334),
                    height: 50,
                    radius: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadAddressToFirebase(
      TextEditingController nameAddressController,
      TextEditingController streetController,
      TextEditingController cityController,
      TextEditingController countryController) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;
      String nameAddress = nameAddressController.text.trim();
      String street = streetController.text.trim();
      String city = cityController.text.trim();
      String country = countryController.text.trim();

      if (nameAddress.isEmpty || street.isEmpty || city.isEmpty || country.isEmpty) {
        throw Exception("All fields are required.");
      }

      await FirebaseDatabase.instance.ref('users/$userId/addAddress/$nameAddress').set({
        'street': street,
        'city': city,
        'country': country,
      });
      addresses[nameAddress] = "$street, $city, $country";
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address added successfully!")));
      Navigator.pop(context);
      nameAddressController.clear();
      streetController.clear();
      cityController.clear();
      countryController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add address: $e")));
    }
  }
  Future<void> deleteAddressFromFirebase(String addressKey) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      await FirebaseDatabase.instance.ref('users/$userId/addAddress/$addressKey').remove();
      setState(() {
        addresses.remove(addressKey);
      });
      print("✅ Địa chỉ đã được xóa: $addressKey");
    } catch (e) {
      print("❌ Lỗi khi xóa địa chỉ: $e");
    }
  }

}

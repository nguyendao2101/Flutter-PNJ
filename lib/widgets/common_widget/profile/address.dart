import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pnj/view_model/by_cart_view_model.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  // Biến lưu vị trí hiện tại
  String? _currentLocationAddress;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _locationsFuture = controller.listenToAddress();
    _getCurrentLocation(); // Lấy vị trí hiện tại khi khởi tạo
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
              itemCount: addresses.length + 1, // Thêm 1 cho địa chỉ hiện tại
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Vị trí hiện tại
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading:
                          const Icon(Icons.my_location, color: Colors.green),
                      title: const Text(
                        "Location:",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        _currentLocationAddress ?? 'Đang lấy địa chỉ...',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh,
                            color: Colors.blue), //nút bấm
                        onPressed: () {
                          _getCurrentLocation(); // Cập nhật lại vị trí khi nhấn nút
                        },
                      ),
                    ),
                  );
                }

                // Các địa chỉ lấy từ Firebase
                String key = addresses.keys.elementAt(
                    index - 1); // Trừ 1 vì index 0 là địa chỉ hiện tại
                String address = addresses[key]!;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    title: Text(
                      "Địa chỉ $key",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    subtitle: Text(
                      address,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteAddressFromFirebase(key);
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
        backgroundColor: const Color(0xffEF5350),
        child: const Icon(Icons.add, color: Colors.white),
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
                      setState(() {});
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

      if (nameAddress.isEmpty ||
          street.isEmpty ||
          city.isEmpty ||
          country.isEmpty) {
        throw Exception("All fields are required.");
      }

      await FirebaseDatabase.instance
          .ref('users/$userId/addAddress/$nameAddress')
          .set({
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to add address: $e")));
    }
  }

  Future<void> deleteAddressFromFirebase(String addressKey) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      await FirebaseDatabase.instance
          .ref('users/$userId/addAddress/$addressKey')
          .remove();
      setState(() {
        addresses.remove(addressKey);
      });
      print("✅ Địa chỉ đã được xóa: $addressKey");
    } catch (e) {
      print("❌ Lỗi khi xóa địa chỉ: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ GPS chưa bật!');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Quyền vị trí bị từ chối!');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Quyền vị trí bị từ chối vĩnh viễn!');
        return;
      }

      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Lấy địa chỉ từ tọa độ
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String fullAddress =
            '${place.street}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}';
        //số nhà - tên phường - tên quận - tên tỉnh - quốc gia
        TextEditingController nameAddressController =
            TextEditingController(text: "hiện tại");

        TextEditingController streetController = TextEditingController(
            text: place.street?.isNotEmpty == true ? place.street! : 'k');

        TextEditingController cityController = TextEditingController(
            text: place.subLocality?.isNotEmpty == true ? place.subLocality! : 'k');

        TextEditingController countryController = TextEditingController(
            text: place.administrativeArea?.isNotEmpty == true ? place.administrativeArea! : 'k');
        await uploadAddressWithoutPop(
          nameAddressController,
          streetController,
          cityController,
          countryController,
        );
        setState(() {
          _currentLocationAddress = fullAddress;
        });
      }
    } catch (e) {
      print('❌ Lỗi lấy vị trí: $e');
    }
  }

  Future<void> uploadAddressWithoutPop(
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

    if (nameAddress.isEmpty ||
        street.isEmpty ||
        city.isEmpty ||
        country.isEmpty) {
      throw Exception("All fields are required.");
    }

    await FirebaseDatabase.instance
        .ref('users/$userId/addAddress/$nameAddress')
        .set({
      'street': street,
      'city': city,
      'country': country,
    });

    // Cập nhật map addresses local
    addresses[nameAddress] = "$street, $city, $country";

    setState(() {});

    // Thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address added successfully!")),
    );

    // Xóa nội dung các controller sau khi thêm (giữ nguyên BottomSheet)
    nameAddressController.clear();
    streetController.clear();
    cityController.clear();
    countryController.clear();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to add address: $e")),
    );
  }
}
}

import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  double _minPrice = 100000;
  double _maxPrice = 10000000;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.all(16),
      title: Text("Chọn khoảng giá", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giá:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text("${_minPrice.toInt()} - ${_maxPrice.toInt()}"),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 100000,
            max: 10000000,
            divisions: 100,
            labels: RangeLabels(
              _minPrice.toInt().toString(),
              _maxPrice.toInt().toString(),
            ),
            activeColor: Colors.red,
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Hủy"),
        ),
        TextButton(
          onPressed: () {
            print("Selected Price Range: $_minPrice - $_maxPrice");
            Navigator.pop(context, [_minPrice, _maxPrice]);
          },
          child: Text("Áp dụng"),
        ),
      ],
    );
  }
}

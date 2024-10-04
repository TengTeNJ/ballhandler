import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
];

class DropDownView extends StatefulWidget {
  const DropDownView({super.key});

  @override
  State<DropDownView> createState() => _DropDownViewState();
}

class _DropDownViewState extends State<DropDownView> {
  @override
  Widget build(BuildContext context) {
    // return CustomDropdown<String>(
    //   decoration:CustomDropdownDecoration(
    //
    //     //expandedFillColor: Constants.baseStyleColor
    //   ),
    //   hintText: 'Select job role',
    //   items: _list,
    //   initialItem: _list[0],
    //   onChanged: (value) {
    //    // log('changing value to: $value');
    //   },
    // );
    return Container();
  }
}

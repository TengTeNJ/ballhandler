import 'package:code/views/profile/profile_grid_view.dart';
import 'package:flutter/material.dart';
class ProfileGridListView extends StatefulWidget {
  const ProfileGridListView({super.key});

  @override
  State<ProfileGridListView> createState() => _ProfileGridListViewState();
}

class _ProfileGridListViewState extends State<ProfileGridListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileGridView(),
            ProfileGridView(),
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileGridView(),
            ProfileGridView(),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class drawerListItems extends StatefulWidget {
  String name;
  IconData icon;

  final VoidCallback onTap;

  drawerListItems({
    Key? key,
    required this.name,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  State<drawerListItems> createState() => _drawerListItemsState();
}

class _drawerListItemsState extends State<drawerListItems> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w, top: 0.0.h),
        child: Container(
          height: 45.h,
          // color: Colors.yellow,
          child: Row(
            children: [
              Text(
                widget.name,
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                width: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../utils/Constants.dart';
import '../views/settings/settings_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool plusButtonHide;

  const CustomAppBar(
      {required this.title,
      this.height = kToolbarHeight,
      this.plusButtonHide = false,
      Key? key})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
        color: Color(0xFF4a76b8),
      ),
      height: height,
      child: Column(
        children: [
          vHeight20(),
          vHeight20(),
          Row(
            children: [
              plusButtonHide
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                    )
                  : const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  vHeight10(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      todayDate(),
                      style: const TextStyle(
                        color: Color(0xFF77E6B6),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              !plusButtonHide
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Settings())),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

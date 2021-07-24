import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar()
      : super(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            titleSpacing: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                width: 150,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/logo_2.png',
                  ),
                ),
              ),
            ),
          ),
        );
}

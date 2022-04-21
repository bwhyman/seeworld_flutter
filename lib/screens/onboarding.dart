import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:seeworld_flutter/screens/home.dart';

import '../constants/Theme.dart';

class Onboarding extends StatelessWidget {
  static const String name = '/onboarding';

  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imgs/onboarding-free.png"),
                    fit: BoxFit.cover))),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: MediaQuery.of(context).size.height * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset("assets/imgs/logo.png", scale: 3.5),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text("SeeWorld",
                                style: TextStyle(
                                    color: NowUIColors.white,
                                    fontWeight: FontWeight.w600)))),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Designed By",
                            style: TextStyle(
                                color: NowUIColors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3)),
                        const SizedBox(width: 5.0),
                        Image.asset("assets/imgs/invision-white-slim.png",
                            scale: 7.0)
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(NowUIColors.info),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Home.name);
                      },
                      child: const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16, bottom: 16),
                          child: Text("GET STARTED",
                              style: TextStyle(
                                  fontSize: 22.0, color: NowUIColors.white))),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}

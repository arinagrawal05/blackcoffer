// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:blackcoffer/Services/functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/ui_helper.dart';

class EnterPhonepage extends StatefulWidget {
  @override
  _EnterPhonepageState createState() => _EnterPhonepageState();
}

class _EnterPhonepageState extends State<EnterPhonepage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        // key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.network(
                          "https://i.pinimg.com/736x/0e/c9/ff/0ec9ff29111e6f00f91a6d46799cdea4.jpg",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        decoration: InputDecoration(
                            labelText: "Enter phone",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 14, left: 10),
                              child: UiHelper.heading1(
                                "+91 ",
                                20,
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            )),
                        minLines: 1,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 200,
                ),
                provider.state == ViewState.phoneProcessing
                    ? const CircularProgressIndicator()
                    : customButton("Verify", () {
                        if (_phoneController.text.length == 10) {
                          sendPhoneNumber(_phoneController.text);
                        } else {
                          AppUtils.showSnackMessage("Invalid Phone number");
                        }
                      }, context),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber(String phone) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phone.trim();

    ap.signInWithPhone(context, "+91$phoneNumber");
  }
}

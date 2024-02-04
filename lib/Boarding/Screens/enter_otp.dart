import 'package:blackcoffer/Vedio/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import '../../Widgets/colors.dart';
import '../../Widgets/custom_button.dart';
import '../../Services/functions.dart';

class EnterOtpPage extends StatefulWidget {
  final String verificationId, phone;
  const EnterOtpPage(
      {super.key, required this.verificationId, required this.phone});

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  String? otpCode = "";
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 30),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  width: 170,
                  height: 170,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorPalatte.primaryColor.withOpacity(0.1),
                  ),
                  child: Image.network(
                    "https://cdni.iconscout.com/illustration/premium/thumb/otp-authentication-security-5053897-4206545.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter the OTP send to your phone number",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        labelText: "Enter OTP",
                        border: OutlineInputBorder(
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
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: !isLoading
                      ? customButton("Verify", () {
                          if (otpCode!.length == 6) {
                            verifyOtp(context, otpCode!);
                          } else {
                            AppUtils.showSnackMessage("Enter 6-Digit code");
                          }
                        }, context)
                      : const CircularProgressIndicator(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Didn't receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Resend New Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorPalatte.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        ap.setSignIn().then(
          (value) {
            navigateslide(HomeScreen(), context);
          },
        );
      },
    );
  }
}

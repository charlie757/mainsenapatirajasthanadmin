import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/custombtn.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/customtextfield.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';
import 'package:mainsenapatirajasthanadmin/utils/routes.dart';
import 'package:mainsenapatirajasthanadmin/utils/showcircleprogressdialog.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  fetchLogin() async {
    if (emailController.text.isEmpty) {
      emailError = true;
      setState(() {});
    } else {
      emailError = false;
      setState(() {});
    }
    if (passwordController.text.isEmpty) {
      passwordError = true;
      setState(() {});
    } else {
      passwordError = false;
      setState(() {});
    }
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      showCircleProgressDialog(context);
      adminLoginRef
          .where('email', isEqualTo: emailController.text)
          .where('password', isEqualTo: passwordController.text)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          Get.back();
          showErrorDialog(
            context,
          );
        } else {
          Get.offAllNamed(Routes.adminDashboard);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213865),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextfield(
                  hintText: 'Enter email',
                  controller: emailController,
                  isValidation: emailError,
                  onTap: () {}),
              const SizedBox(
                height: 15,
              ),
              CustomTextfield(
                  hintText: 'Enter password',
                  controller: passwordController,
                  isObscureText: true,
                  isValidation: passwordError,
                  onTap: () {}),
              const SizedBox(
                height: 25,
              ),
              CustomBtn(
                  title: 'Login',
                  height: 45,
                  width: double.infinity,
                  onTap: () {
                    fetchLogin();
                  })
            ],
          ),
        ),
      ),
    );
  }

  showErrorDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              constraints: const BoxConstraints(
                  maxHeight: 100, minHeight: 100, maxWidth: 200, minWidth: 200),
              child: Column(
                children: [
                  const Text(
                    'User does not exist',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomBtn(
                      title: "Okay",
                      height: 40,
                      width: 100,
                      onTap: () {
                        Get.back();
                      })
                ],
              ),
            ),
          );
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_courses/screens/entryPoint/entry_point.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  bool isObscurePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  cursorColor: const Color(0xFFF77D8E).withOpacity(0.5),
                  controller: txtNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/ios.svg",
                          height: 10,
                          colorFilter: ColorFilter.mode(
                              const Color(0xFFF77D8E).withOpacity(0.5),
                              BlendMode.srcIn)),
                    ),
                  ),
                ),
              ),
              const Text(
                "Email",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  cursorColor: const Color(0xFFF77D8E).withOpacity(0.5),
                  controller: txtEmailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your e-mail address.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    ),
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  cursorColor: const Color(0xFFF77D8E).withOpacity(0.5),
                  controller: txtPasswordController,
                  obscureText: isObscurePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isObscurePassword = !isObscurePassword;
                        });
                      },
                      child: Icon(
                        !isObscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: !isObscurePassword
                            ? const Color(0xFFF77D8E).withOpacity(0.5)
                            : Colors.grey,
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        txtNameController.text.trim();
                        txtEmailController.text.trim();
                        txtPasswordController.text.trim();
                      });
                    }
                    register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(CupertinoIcons.arrow_right,
                      color: Colors.white),
                  label: const Text(
                    "Register",
                    style: TextStyle(
                        fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Future<void> register() async {
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        password: txtEmailController.text.trim(),
        email: txtEmailController.text.trim(),
      );

      // Add the user's name to Firestore after registering
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': txtNameController.text.trim(),
        'email': txtEmailController.text.trim(),
        // Add other user details if needed
      });

      if (_formKey.currentState!.validate()) {
        success.fire();
        Future.delayed(
          const Duration(seconds: 2),
          () {
            setState(() {
              isShowLoading = false;
            });
            confetti.fire();
          },
        );
        Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const EntryPoint(),
              ),
            );
          },
        );
      }
    } on FirebaseException catch (e) {
      String errorMessage = "";

      switch (e.code) {
        case 'weak-password':
          errorMessage = "Password provided is too weak";
          break;
        case 'email-already-in-use':
          errorMessage = "Account already exists!";
          break;
        case 'invalid-email':
          errorMessage = "Email address is not valid";
          break;
        case 'operation-not-allowed':
          errorMessage = "Server in maintenance";
          break;
        default:
          // Handle other FirebaseException codes here
          break;
      }

      error.fire();
      Future.delayed(
        const Duration(seconds: 2),
        () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 1.55,
                left: 10,
                right: 10),
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            content: Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ));

          setState(() {
            isShowLoading = false;
          });
          reset.fire();
        },
      );
    } finally {
      if (!_formKey.currentState!.validate()) {
        setState(() {
          isShowLoading = false;
        });
      }
    }
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

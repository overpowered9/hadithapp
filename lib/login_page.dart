import 'package:flutter/material.dart';
import 'package:mad_project/Signin_page.dart';
import 'package:mad_project/home.dart';
import 'package:mad_project/pallets.dart';
import 'package:mad_project/resources/authFireBase.dart';
import 'package:mad_project/widgets/gradient_button.dart';
import 'package:mad_project/widgets/input_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  final TextEditingController _emailCOntroller = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _PasswordCOntroller = TextEditingController();

  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailCOntroller.text, password: _PasswordCOntroller.text);
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailCOntroller.text);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailCOntroller.dispose();
    _PasswordCOntroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Image.asset('assets/signin_balls.png',color: Pallete.backgroundColor,),
              const SizedBox(
                height: 35,
              ),
              const Text(
                'Log in',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 10,
              ),
              LoginField(
                textEditingController: _emailCOntroller,
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 15,
              ),
              LoginField(
                textEditingController: _PasswordCOntroller,
                hintText: 'Password',
                isPass: true,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 15,
              ),
              GradientButton(
                txt: 'Log in',
                fun: loginUser,
                prog: _isLoading,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SigninPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Sign Up.",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Pallete.gradient2),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

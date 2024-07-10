import 'package:flutter/material.dart';
import 'package:mad_project/home.dart';
import 'package:mad_project/login_page.dart';
import 'package:mad_project/pallets.dart';
import 'package:mad_project/resources/authFireBase.dart';
import 'package:mad_project/widgets/gradient_button.dart';
import 'package:mad_project/widgets/input_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

    final TextEditingController _emailCOntroller = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _PasswordCOntroller = TextEditingController();
  final TextEditingController _userNameCOntroller = TextEditingController();
    bool _isLoading = false;
    
     showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
   @override
  void dispose() {
    super.dispose();
    _emailCOntroller.dispose();
    _PasswordCOntroller.dispose();
    _userNameCOntroller.dispose();
  }
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      userName: _userNameCOntroller.text,
      email: _emailCOntroller.text,
      password: _PasswordCOntroller.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailCOntroller.text);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  const Home()));
    }
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
              const Text('Sign Up',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 25,
              ),
              LoginField(textEditingController: _userNameCOntroller,hintText: 'Enter username',textInputType: TextInputType.text,),
              const SizedBox(height: 15,),
              LoginField(textEditingController: _emailCOntroller,hintText: 'Email',textInputType: TextInputType.emailAddress,),
              const SizedBox(height: 15,),
              LoginField(textEditingController: _PasswordCOntroller,hintText: 'Password',isPass: true,textInputType: TextInputType.text,),
              const SizedBox(height: 15,),
              GradientButton(txt: 'Sign Up',fun: signUpUser,prog: _isLoading,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Already have an account?"),
              ),
              GestureDetector(
                onTap: () {
                   Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    " Log in",
                    style: TextStyle(fontWeight: FontWeight.w500,
                    color: Pallete.gradient2),
                  ),
                ),
              ),
              ],
              )
            ],
            ),
          )
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/auth/sign_in/sign_in_bloc.dart';
import 'package:randolina/app/auth/sign_in/widgets/sign_in_button.dart';
import 'package:randolina/app/auth/sign_up/sign_up_screen.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';

/* 
  ? todo add focus node and when clicking on next you move to the next field
  ? add input validation as the user types 
*/

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final SignInBloc bloc;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final Auth auth = context.read<Auth>();
    bloc = SignInBloc(auth: auth);
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      final String username = _usernameController.text;
      final String password = _passwordController.text;
      bloc.signIn(username, password);
    }
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _usernameController,
        textInputAction: TextInputAction.next,
        validator: (String? value) {
          // if (value != null) {
          //   if (!validator.usernameSubmitValidator.isValid(value)) {
          //     return 'error';
          //   }
          // }
          // return null;
        },
        decoration: InputDecoration(
          hintText: 'User name...',
          fillColor: fillColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: borderColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: _passwordController,
        validator: (String? value) {
          // if (value != null) {
          //   if (!validator.passwordRegisterSubmitValidator.isValid(value)) {
          //     return 'error';
          //   }
          // }
          // return null;
        },
        decoration: InputDecoration(
          hintText: 'Password...',
          fillColor: fillColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: borderColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_2.png',
                  width: 700,
                ),
                const SizedBox(
                  height: 100,
                ),
                _buildUsernameField(),
                _buildPasswordField(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password ?',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ),
                SignInButton(
                  callback: _signIn,
                ),
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromRGBO(41, 67, 107, 1.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromRGBO(41, 67, 107, 1.0),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Creat an account Now',
                    style: TextStyle(
                      color: Color.fromRGBO(64, 163, 219, 1.0),
                      decoration: TextDecoration.underline,
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
}

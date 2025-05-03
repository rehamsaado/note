
import 'package:flutter/material.dart';

import '../../constant/link_api.dart';
import '../../global_widget/app_text_field.dart';
import '../../global_widget/crud.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  bool isLoading = false;
  Crud _crud = Crud();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();

  signUp() async {
   if(formState.currentState!.validate()){
     isLoading = true;
     setState(() {});
     var response = await _crud.postRequest(linkSignUp, {
       "name": name.text,
       "email": email.text,
       "pass": pass.text,
     });
     isLoading = false;
     setState(() {});
     if (response['status'] == 'success') {
       Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
     } else {
       print(" Sign up fail");
     }
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Form(
                      key: formState,
                      child: Column(
                        children: [
                          AppTextField(
                            hint: "name",
                            mycontroller: name,
                            valid: (val) {
                              return  validInput(val!, 2, 20);

                            },
                          ),
                          AppTextField(
                            hint: "email",
                            mycontroller: email,
                            valid: (val) {
                              return  validInput(val!, 5, 20);
                            },
                          ),
                          AppTextField(
                            hint: "password",
                            mycontroller: pass,
                            valid: (val) {
                              return validInput(val!, 5, 20);
                            },
                          ),
                          MaterialButton(
                            onPressed: () {
                              signUp();
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            child: Text("Sign Up "),
                          ),
                          Container(height: 10),
                          InkWell(
                            child: Text("Login"),
                            onTap: () {
                              Navigator.of(context).pushNamed("login");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

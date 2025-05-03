
import 'package:flutter/material.dart';

import '../../constant/link_api.dart';
import '../../global_widget/app_text_field.dart';
import '../../global_widget/crud.dart';
import '../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Crud crud = Crud();

  // TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool isLoading = false;

  login() async {
    if (formState.currentState!.validate()) {
      // isLoading = true;
      // setState(() {});
      var response = await crud.postRequest(linkLogin, {
        "email": email.text,
        "pass": pass.text,
      });
      print(response);
      print(response["id"]); // هنا صار الخطأ
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        sharedPref.setString("id", response["data"]["id"].toString());
        sharedPref.setString("name", response["data"]["name"]);
        sharedPref.setString("pass", response["data"]["pass"]);
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil("home", (route) => false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("صح")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("خطأ")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
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
                          // AppTextField(
                          //   hint: "name",
                          //   mycontroller: name,
                          //   valid: (val) {
                          //    return validInput(val!, 1, 20);
                          //   },
                          // ),
                          AppTextField(
                            hint: "email",
                            mycontroller: email,
                            valid: (val) {
                              return validInput(val!, 5, 20);
                            },
                          ),
                          AppTextField(
                            hint: "password",
                            mycontroller: pass,
                            valid: (val) {
                              return validInput(val!, 3, 20);
                            },
                          ),
                          MaterialButton(
                            onPressed: () {
                              login();
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            child: Text("Login"),
                          ),
                          Container(height: 10),
                          InkWell(
                            child: Text("Sign up"),
                            onTap: () {
                              Navigator.of(context).pushNamed("signUp");
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

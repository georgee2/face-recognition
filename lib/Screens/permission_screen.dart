import 'package:final_bassem/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool permission = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: HexColor("2F409C"),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            const Text(
              'sign-in',
              style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                      )
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10),
                        child: TextFormField(
                          validator: (val) {
                            if (val != 'kante') {
                              return 'wrong password';
                            } else {
                              return null;
                            }
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      MaterialButton(
                        onPressed: () async{
                          if(passwordController.text == 'kante') {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const Home()));
                            SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
                            _sharedPreferences.setBool('permission', true);
                          }
                        },
                        child: Container(
                          height: 55.0,
                          width: 270.0,
                          decoration: BoxDecoration(
                            color: HexColor("2F409C"),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 50.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: const Align(
                            child: Text(
                              'SignIn',
                              style: TextStyle(color: Colors.white, fontSize: 30.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

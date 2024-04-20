import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent.'),
        ),
      );
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }


  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5FC),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () async {},
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical &&
              notification.metrics.pixels > 0 &&
              MediaQuery.of(context).viewInsets.bottom > 0) {
            // Scroll up when the keyboard appears
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }

          return false;
        },
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {

                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Enter the email address associated',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'with your account.',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(25.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(labelText: 'Email'),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty || !value.contains('@')) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 30.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _resetPassword();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(15),
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                        ),
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF5B9FCC),
                                                Color(0xFF187EC3),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          width: 200.0,
                                          height: 40.0,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Reset Password',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        label: Text(''),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

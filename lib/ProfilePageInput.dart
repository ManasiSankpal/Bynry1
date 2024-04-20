import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
class ProfileInputPage extends StatefulWidget {
  @override
  _ProfileInputPageState createState() => _ProfileInputPageState();
}

class _ProfileInputPageState extends State<ProfileInputPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  File? _image;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateController.text = picked.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Edit Your Information',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone, // Set the keyboard type to phone
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  labelStyle: TextStyle(fontSize: 16.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: fullNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  labelStyle: TextStyle(fontSize: 16.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: dateController,
                onTap: () {
                  _selectDate(context); // Show the date picker when tapped
                },
                decoration: InputDecoration(
                  labelText: 'Member Since',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  labelStyle: TextStyle(fontSize: 16.0),
                ),
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // Save user input and navigate back to ProfilePage
                  // You can save the values to your preferred storage or state management solution.
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    String userId = user?.uid ?? '';

                    // Save profile information to Firestore
                    await FirebaseFirestore.instance.collection('users').doc(userId).set({
                      'name': fullNameController.text,
                      'phone': phoneController.text,
                      'memberSince': dateController.text,
                      'userId': user?.uid,
                    });

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  } catch (error) {
                    print('Error saving profile: $error');
                    // Handle error, e.g., show an error message
                  }
                },
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

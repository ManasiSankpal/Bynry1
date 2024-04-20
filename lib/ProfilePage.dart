import 'dart:io';
import 'package:bynry1/ProfilePageInput.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profileImagePath = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String phone = '';
  String name = '';

  String memberSince = '';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    // Fetch additional user information when the page is loaded
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;

    try {
      // Replace "users" with your actual collection name in Firestore
      var userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

      if (userDoc.exists) {
        setState(() {
          // Assign values from the document to the variables
          phone = userDoc['phone'] ?? 'N/A';
          name = userDoc['name'] ?? 'N/A';
          memberSince = userDoc['memberSince'] ?? 'N/A';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Image picked: ${pickedFile.path}');
      _handleEditedImage(pickedFile.path);
    }
  }

  void _handleEditedImage(String imagePath) {
    setState(() {
      _profileImagePath = imagePath;
    });
  }

  void _removeImage() {
    setState(() {
      _profileImagePath = 'assets1/default_avatar.png';
    });
  }

  void _viewImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: Image.asset(
              _profileImagePath,
              fit: BoxFit.cover,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  bool _isAssetPath() {
    return _profileImagePath.startsWith('assets1/');
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () async {
                  Navigator.pop(context); // Close the modal
                  await _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.remove),
                title: Text('Remove'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _removeImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text('View'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _viewImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String email = user?.email ?? 'N/A';


    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Profile'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print('Edit Image');
                        _showOptionsModal(context);
                      },
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: _isAssetPath()
                            ? AssetImage(_profileImagePath) as ImageProvider
                            : FileImage(File(_profileImagePath)) as ImageProvider,
                      ),
                    ),
                    Text('Hello $name',style: TextStyle(fontSize: 30,color: Colors.white) ,),Text('Hello $name',style: TextStyle(fontSize: 30,color: Colors.white) ,),
                    Text(email),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.red),
                      title: Text(email),
                    ),
                    SizedBox(height: 26.0),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.green),
                      title: Text('Name: $name'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.blue),
                      title: Text('Phone: $phone'),
                    ),
                    SizedBox(height: 26.0),

                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.purple),
                      title: Text('Member Since: $memberSince'),
                    ),
                    SizedBox(height: 26.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileInputPage()),
                        );
                      },
                      child: Text('Edit Profile'),
                    ),
                    SizedBox(height: 36.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

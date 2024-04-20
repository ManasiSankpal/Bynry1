import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BillForm(),
    );
  }
}

class BillForm extends StatefulWidget {
  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  String _billName = '';
  double _amount = 0.0;
  DateTime? _dueDate;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Bill'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Bill Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bill name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _billName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _dueDate = picked;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text(
                      _dueDate == null
                          ? 'Due Date: Not set'
                          : 'Due Date: ${_dueDate!.year}-${_dueDate!.month}-${_dueDate!.day}',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {

                      FirebaseFirestore firestore = FirebaseFirestore.instance;


                      User? user = FirebaseAuth.instance.currentUser;
                      String userId = user?.uid ?? '';


                      await firestore.collection('users').doc(userId).collection('bills').add({
                        'billName': _billName,
                        'amount': _amount,
                        'dueDate': _dueDate,
                      });


                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bill added successfully')),
                      );


                      _formKey.currentState!.reset();
                      setState(() {
                        _dueDate = null; // Reset due date
                      });
                    } catch (error) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add bill: $error')),
                      );
                    }
                  }
                },
                child: Text('Add Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

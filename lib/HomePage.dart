import 'package:bynry1/ProfilePageInput.dart';
import 'package:bynry1/bills.dart';
import 'package:bynry1/payments.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bynry1/IconSlider.dart';
import 'package:bynry1/ProfilePage.dart';
import 'package:bynry1/menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String name = '';
  String greeting='';
  String _selectedMonth = 'this_month';
  String bill='';
  //String name = user?.email ?? 'N/A';

  int _selectedIndex = 0;

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
      // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
      // Navigate to the bills page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BillForm()),
        );
        break;
      case 2:

        break;
      case 1:
      // Navigate to the bills page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileInputPage()),
        );
        break;
      default:
        break;
    }
  }
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    fetchUserData();
    _setGreeting();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;

    try {
      // Replace "users" with your actual collection name in Firestore
      var userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

      if (userDoc.exists) {
        setState(() {


          name = userDoc['name'] ?? 'N/A';

        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) {
      setState(() {
        greeting = 'Good night';
      });
    } else if (hour < 12) {
      setState(() {
        greeting = 'Good morning';
      });
    } else if (hour < 18) {
      setState(() {
        greeting = 'Good afternoon';
      });
    } else if (hour < 21) {
      setState(() {
        greeting = 'Good evening';
      });
    } else {
      setState(() {
        greeting = 'Good night';
      });
    }
  }





  Widget _buildForm(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 1400),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(225, 95, 27, .3),
              blurRadius: 20,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            IconSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm1(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 1400),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bills').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show progress indicator while loading data
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {

            double progress = snapshot.data!.docs.length / 10; // Assuming total 10 bills

            // Calculate total bill amount
            double totalBillAmount = 0;
            snapshot.data!.docs.forEach((doc) {
              totalBillAmount += doc['amount'] ?? 0;
            });

            // Format the total bill amount
            String formattedBillAmount = totalBillAmount.toStringAsFixed(2);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(225, 95, 27, .3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Bills $formattedBillAmount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Center(

                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: Text('Pay Now'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Container(
                      width: 300, // Set the width of the container
                      height: 200, // Set the height of the container
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),


                ],
              ),
            );
          }
          return SizedBox(); // Return an empty container if no data available
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade800,
                    Colors.blue.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 80),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text('Hello $name',style: TextStyle(fontSize: 30,color: Colors.white) ,),
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text('$greeting', style: TextStyle(fontSize: 30, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),

                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Stack(
                        children: [



                          Container( // Nested Container

                            decoration: BoxDecoration(
                              //color: Colors.blue,
                            ),

                            child: _buildForm(context),
                          ),

                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: _selectedMonth,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedMonth = newValue!;

                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Text('This Month'),
                                    value: 'this_month',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Last Month'),
                                    value: 'last_month',
                                  ),

                                ],
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Bills $bill',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: _buildForm1(context),
                          ),
                        ],
                      ),
                    ),
                  ),





                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.black,
                  onPressed: () {
                    // Add notification icon onPressed action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          _onItemTapped(context, index);
        },
      ),
    );
  }
}

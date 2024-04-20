import 'package:bynry1/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


PageTransition customPageTransition(Widget page) {
  return PageTransition(
    type: PageTransitionType.rightToLeft,
    child: page,
  );
}

final FirebaseAuth _auth = FirebaseAuth.instance;


Future<void> _signOut(BuildContext context) async {
  try {
    await _auth.signOut();
    // Clear user's login state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false); // Set isLoggedIn to false

    // Navigate to the LoginScreen and remove all previous routes from the stack
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  } catch (e) {
    print('Error during sign out: $e');
  }
}



Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sign Out Confirmation'),
        content: Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _signOut(context); // Sign out when confirmed
            },
            child: Text('Sign Out'),
          ),
        ],
      );
    },
  );
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String email = user?.email ?? 'N/A'; // User email
    String name = user?.displayName ?? 'N/A'; // User phone number

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to light black
      appBar: AppBar(
        title: Text('Menu Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle the back button press with a custom transition
            Navigator.of(context).pop();
          },
        ),
      ),

      body: Center(
        // child: Text('This is the menu page content.'),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'N/A'),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/default_avatar.png'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context)
                    .push(customPageTransition(HomeScreen()));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.feedback),
            //   title: Text('FeedBack'),
            //   onTap: () {
            //     Navigator.of(context)
            //         .push(customPageTransition(FeedbackForm()));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.account_circle),
            //   title: Text('Profile'),
            //   onTap: () {
            //     Navigator.of(context).push(customPageTransition(ProfilePage()));
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                // Replace 'Text to share' with the content you want to share
                Share.share('Sharing The app');
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.chat_bubble),
            //   title: Text('Chat Bot'),
            //   onTap: () {
            //     Navigator.of(context)
            //         .push(customPageTransition(ChatbotScreen1()));
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _showSignOutConfirmationDialog(context); // Show confirmation dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:bynry1/ProfilePageInput.dart';
import 'package:bynry1/bills.dart';
import 'package:bynry1/compaints.dart';
import 'package:bynry1/orders.dart';
import 'package:bynry1/payments.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IconSlider extends StatelessWidget {
  final List<String> iconAssetPaths = [
    'assets1/2584894.png',
    'assets1/payments.png',
    'assets1/order.png',
    'assets1/complaints.png',
    'assets1/update.png',
    'assets1/settings.png',

  ];

  final List<String> iconNames = [
    'BILL',
    'PAYMENTS',
    'ORDER',
    'COMPLAINTS',
    'UPDATES',
    'SETTINGS',


  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: iconAssetPaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 10.0, top: 15.0),
            child: GestureDetector(
              onTap: () {
                if (iconNames[index] == 'BILLS') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BillForm()),
                  );
                } else if (iconNames[index] == 'PAYMENTS') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentForm()),
                  );
                } else if (iconNames[index] == 'ORDER') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderForm()),
                  );
                }
                else if (iconNames[index] == 'COMPLAINTS') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComplaintForm()),
                  );
                }
                else if (iconNames[index] == 'SETTINGS') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileInputPage()),
                  );
                }

              },
              child: Container(
                width: 80,
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                  color: Colors.white,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      iconAssetPaths[index],
                      width: 45,
                      height: 45,

                    ),
                    SizedBox(height: 4),
                    Text(
                      iconNames[index],
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}

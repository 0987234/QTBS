import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class help extends StatefulWidget {
  @override
  State<help> createState() => _StartState();
}

class _StartState extends State<help> {
  final String websiteUrl = "https://riphah.edu.pk/transport-info/";
  final String phoneNumber = "tel:(051) 5912890";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Help',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/helpcenter.png',
                  height: 150,
                  width: 200,
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Support Center',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        letterSpacing: 1.2,
                        fontFamily: "Oswald",
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'For inquiries, please visit our website:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontFamily: "Oswald",
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 5),
                      child: GestureDetector(
                        onTap: () {
                          launch(websiteUrl);
                        },
                        child: Text(
                          websiteUrl,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            letterSpacing: 1.2,
                            fontFamily: "Oswald",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 17),
                    Text(
                      'For immediate assistance, call us at:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontFamily: "Oswald",
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        launch('tel:$phoneNumber');
                      },
                      child: Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          letterSpacing: 1.2,
                          fontFamily: "Oswald",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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

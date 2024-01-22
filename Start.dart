import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:test_project/UI/module/Student/student%20registration/stu-registration.dart';

class Start extends StatefulWidget {
  final String selectRoute;
  final String fee;
  final String bus;
  final String voucherDocumentID;
  final String voucherURL;
  Start(
      {required this.selectRoute,
      required this.fee,
      required this.bus,
      required this.voucherDocumentID,
      required this.voucherURL});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  bool isFinished = false;
  final PageTransitionType _pageTransitionType = PageTransitionType.fade;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.cyan[100],
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 265),
            child: Column(children: [
              Center(
                child: const Image(
                  height: 320,
                  width: 400,
                  image: AssetImage('assets/Stu anima.jpg'),
                ),
              ),
            ]),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 600),
            child: Column(
              children: [
                Text(
                  'Efficient and reliable shift-based transport for students',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, // Makes the text bold
                      fontStyle:
                          FontStyle.italic, // Adds an italic style for elegance
                      fontSize: 18, // Adjust the font size as needed
                      color: Colors
                          .black, // Change the color to your desired color
                      letterSpacing:
                          1.2, // Adjust the letter spacing for elegance

                      fontFamily: "Oswald"),
                ),
                const Center(
                    child: Text(
                  ' Our shift-based transport service offers an exclusive interface designed for the convienece of university students',
                  style: TextStyle(
                    fontFamily: "Oswald",
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                )),
              ],
            ),
          ),
          //Get Started button
          SizedBox(
            height: 10,
          ),

          // Padding(
          //   padding: EdgeInsets.only(left: 100, right: 10, top: 690),
          //   child: Container(
          //     height: 50,
          //     width: 150,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.indigo),
          //     child: ElevatedButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => register(
          //               selectRoute: selectRoute,
          //               fee: fee,
          //               voucherDocumentID: voucherDocumentID,
          //               voucherURL: voucherURL,
          //               bus: bus,
          //             ),
          //           ),
          //         );
          //       },
          //       child: const Center(
          //         child: Text(
          //           'Get Started',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //               fontSize: 18,
          //               fontFamily: "Oswald",
          //               color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ),
          // )

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 70, right: 30, top: 690),
                    child: SwipeableButtonView(
                      activeColor: Color(0xff3398f6),
                      buttonText: 'Get Started',
                      //   style:GoogleFonts.poppins(
                      //   fontSize: 20,
                      // fontWeight: FontWeight.bold,
                      // color: Colors.white),

                      buttonWidget: Container(
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      isFinished: isFinished,
                      onWaitingProcess: () {
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            isFinished = true;
                          });
                        });
                      },
                      onFinish: () async {
                        await Navigator.push(
                          context,
                          PageTransition(
                            type: _pageTransitionType,
                            child: register(
                              selectRoute: widget.selectRoute,
                              fee: widget.fee,
                              voucherDocumentID: widget.voucherDocumentID,
                              voucherURL: widget.voucherURL,
                              bus: widget.bus,
                            ),
                          ),
                        );
                        setState(() {
                          isFinished = false;
                        });
                      },
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

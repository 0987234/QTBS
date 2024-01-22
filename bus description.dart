import 'package:flutter/material.dart';

class bdescription extends StatelessWidget {
  const bdescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            const SizedBox(
              height: 80,
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/b_desc.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 100, top: 10, right: 10, bottom: 140),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align the content to the bottom
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/bus_icon.png',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Name: LSTB68',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'color: blue',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Total: 45 seats',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE665ADAD), // Background color using hex code
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Check Your Email",
                      style: TextStyle(
                        fontSize: 42, // Text size
                        fontWeight: FontWeight.bold, // Bold text
                        color: Color(0xFF002B36), // Text color using hex code
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing between the text elements
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "We sent a reset code to xxx@gmail.com. Enter the 5-digit code mentioned in the email.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18, // Text size
                          fontWeight: FontWeight.w500, // Medium-weight text
                          color: Color(0xFFE0E0E0), // Text color using hex code
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // Spacing before the code fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) => SizedBox(
                          width: 50, // Width for each text field
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded borders
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 300, // Fixed width for button
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal, // Button background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15), // Adjusted vertical padding
                          ),
                          child: const Text(
                            "Verify Code",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20, // Position from top
              left: 10, // Position from left
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 30,
                color: const Color(0xFF002B36), // Color for the arrow icon
                onPressed: () {
                  Navigator.pop(context); // Action when the icon is tapped
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

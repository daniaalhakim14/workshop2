import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../../ViewModel/account_viewmodel.dart';
import 'account_page.dart';
import 'insight_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  final UserInfoModule userInfo;

  const HomePage({super.key, required this.userInfo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 69,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 40, left: 55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.teal,
                  size: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Hello,\n${widget.userInfo.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        height: 0.8
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom: 10,left: 30,right: 30),
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'RM ****',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.visibility_off),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'View All Wallets',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spending Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SpendingTile(
                  icon: Icons.lunch_dining,
                  title: 'Lunch',
                  subtitle: 'Nasi Ayam Merah',
                  amount: '- RM 5.00',
                  date: '04 October, 2024 at 11:50 AM',
                  category: 'Food & Drinks',
                  backgroundColor: Colors.green[100],
                ),
                SpendingTile(
                  icon: Icons.home,
                  title: 'Rumah Sewa',
                  subtitle: 'Bayar sewa',
                  amount: '- RM 150.00',
                  date: '03 October, 2024 at 09:30 AM',
                  category: 'Home',
                  backgroundColor: Colors.orange[100],
                ),
                SpendingTile(
                  icon: Icons.shopping_cart,
                  title: 'Barang Dapur',
                  subtitle: 'Telur, Susu dan Ayam',
                  amount: '- RM 17.35',
                  date: '02 October, 2024 at 19:50 PM',
                  category: 'Groceries',
                  backgroundColor: Colors.green[100],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF002B36), // Dark blue
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Home Tab - Active Tab
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home_outlined,
                color: Color(0xFF65ADAD), // Highlighted color for active tab
                size: 30,
              ),
            ),

            // Insight Tab
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (homeContext) => Insight(userInfo: widget.userInfo), // Pass UserModel
                  ),
                );
              },
              icon: Image.asset(
                'lib/Icons/three lines.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            // Notification Tab
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (homeContext) => Noti(userInfo: widget.userInfo), // Pass UserModel
                  ),
                );
              },
              icon: Image.asset(
                'lib/Icons/notification.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),

            // Account Tab
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => AccountViewModel(),
                      child: Account(userInfo: widget.userInfo),
                    ),
                  ),
                );

              },
              icon: Image.asset(
                'lib/Icons/safe.png',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpendingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final String category;
  final Color? backgroundColor;

  const SpendingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.category,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns items at the start vertically
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: backgroundColor ?? Colors.grey[200],
                radius: 24,
                child: Icon(icon, color: Colors.teal),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: category == 'Food & Drinks' || category == 'Groceries' || category == 'Home' ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black, // Set the date text color to black
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications Page'),
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: const Text('Account'),
      ),
      body: const Center(
        child: Text('Account Page'),
      ),
    );
  }
}
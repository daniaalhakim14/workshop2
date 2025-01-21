import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/SignupLoginPage_model.dart';
import '../../ViewModel/account_viewmodel.dart';
import '../../ViewModel/app_appearance_viewmodel.dart';
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
    return Consumer<AppAppearanceViewModel>(
      builder: (context, appAppearanceViewModel, child) {
        final isDarkMode = appAppearanceViewModel.isDarkMode;
        final backgroundColor = isDarkMode ? Colors.black : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 69,
            backgroundColor: isDarkMode ? Colors.black : const Color(0xFF65ADAD),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 40, left: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<AccountViewModel>(
                    builder: (context, accountViewModel, child) {
                      final avatarBytes = accountViewModel.avatarBytes;
                      final isLoading = accountViewModel.isLoading;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            key: ValueKey(avatarBytes != null
                                ? DateTime.now().millisecondsSinceEpoch
                                : 'default_avatar'),
                            radius: 20,
                            backgroundColor:
                            isDarkMode ? Colors.grey[800] : Colors.white,
                            backgroundImage: avatarBytes != null
                                ? MemoryImage(avatarBytes)
                                : null,
                            child: avatarBytes == null && !isLoading
                                ? const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 40,
                            )
                                : null,
                          ),
                          if (isLoading)
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkMode ? Colors.white : Colors.black,
                              ),
                              strokeWidth: 2,
                            ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello,\n${widget.userInfo.name}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            height: 0.8,
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
                color: isDarkMode ? Colors.black : Colors.blue,
                width: double.infinity,
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10, left: 30, right: 30),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[700] : Colors.teal[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Balance',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black87,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'RM ****',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.visibility_off,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'View All Wallets',
                              style: TextStyle(
                                color: isDarkMode ? Colors.teal : Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                isDarkMode ? Colors.teal : Colors.blue,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spending Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.black87 : Colors.black87,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        color: isDarkMode ? Colors.teal : Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: isDarkMode ? Colors.teal : Colors.blue,
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
                      backgroundColor:
                      isDarkMode ? Colors.black87 : Colors.green[100],
                    ),
                    SpendingTile(
                      icon: Icons.home,
                      title: 'Rumah Sewa',
                      subtitle: 'Bayar sewa',
                      amount: '- RM 150.00',
                      date: '03 October, 2024 at 09:30 AM',
                      category: 'Home',
                      backgroundColor:
                      isDarkMode ? Colors.black87 : Colors.orange[100],
                    ),
                    SpendingTile(
                      icon: Icons.shopping_cart,
                      title: 'Barang Dapur',
                      subtitle: 'Telur, Susu dan Ayam',
                      amount: '- RM 17.35',
                      date: '02 October, 2024 at 19:50 PM',
                      category: 'Groceries',
                      backgroundColor:
                      isDarkMode ? Colors.black87 : Colors.green[100],
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: isDarkMode ? Colors.black : const Color(0xFF002B36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.home_outlined,
                    color: isDarkMode
                        ? Colors.teal
                        : const Color(0xFF65ADAD), // Highlight active tab
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Insight(userInfo: widget.userInfo),
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
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Noti(userInfo: widget.userInfo),
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
      },
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
    final isDarkMode = Provider.of<AppAppearanceViewModel>(context).isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.white,
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
                      color: category == 'Food & Drinks' ||
                          category == 'Groceries' ||
                          category == 'Home'
                          ? Colors.black
                          : Colors.grey,
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

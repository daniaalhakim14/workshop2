import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_appearance_viewmodel.dart';

class AppAppearance extends StatefulWidget {
  final int userId;

  const AppAppearance({super.key, required this.userId});

  @override
  _AppAppearanceState createState() => _AppAppearanceState();
}

class _AppAppearanceState extends State<AppAppearance> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<AppAppearanceViewModel>(context, listen: false);
    viewModel.initialize(widget.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAppearanceViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('App Appearance'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: viewModel.isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: viewModel.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              'App Appearance',
              style: TextStyle(
                color: viewModel.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: viewModel.isDarkMode ? Colors.black : Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appearance Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: viewModel.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: !viewModel.matchSystemTheme && viewModel.isDarkMode,
                    onChanged: (value) async {
                      await viewModel.setDarkMode(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value ? 'Dark Mode Enabled' : 'Dark Mode Disabled',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    'Match System Theme',
                    style: TextStyle(
                      color: viewModel.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: viewModel.matchSystemTheme,
                    onChanged: (value) async {
                      await viewModel.setMatchSystemTheme(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('System theme match updated'),
                        ),
                      );
                    },
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

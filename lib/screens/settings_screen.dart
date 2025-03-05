import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade900, Colors.grey.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              secondary: Icon(Icons.dark_mode, color: Colors.amber.shade700),
              title: Text('Dark Mode',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: darkMode,
              onChanged: (value) => setState(() => darkMode = value),
            ),
            SwitchListTile(
              secondary:
                  Icon(Icons.notifications, color: Colors.amber.shade700),
              title: Text('Notifications',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: notifications,
              onChanged: (value) => setState(() => notifications = value),
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.amber.shade700),
              title: Text('Language',
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: DropdownButton<String>(
                value: language,
                items: ['English', 'Arabic'].map((String lang) {
                  return DropdownMenuItem(value: lang, child: Text(lang));
                }).toList(),
                onChanged: (value) => setState(() => language = value!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

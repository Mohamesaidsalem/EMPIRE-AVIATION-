import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_flight_screen.dart';
import 'settings_screen.dart';
import 'pilots_screen.dart';
import 'flight_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> flightLogs = [];

  @override
  void initState() {
    super.initState();
    _loadFlightLogs();
  }

  Future<void> _loadFlightLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? logsString = prefs.getString('flightLogs');
    if (logsString != null) {
      setState(() {
        flightLogs = List<Map<String, dynamic>>.from(json.decode(logsString));
      });
    }
  }

  Future<void> _saveFlightLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('flightLogs', json.encode(flightLogs));
  }

  Future<void> _addFlight(BuildContext context) async {
    // ضفنا context كباراميتر
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddFlightScreen()));
    if (result != null) {
      setState(() {
        flightLogs.add({
          'flightNumber': result['flightNumber'],
          'date': result['journeyStart'],
          'routes': result['routes'],
          'journeyStart': result['journeyStart'],
          'journeyEnd': result['journeyEnd'],
          'bookingRef': result['bookingRef'],
          'aircraftReg': result['aircraftReg'],
          'aircraftType': result['aircraftType'],
          'flightType': result['flightType'],
          'captain': result['captain'],
          'firstOfficer': result['firstOfficer'],
          'ogmCrew': result['ogmCrew'],
        });
      });
      await _saveFlightLogs();
    }
  }

  void _showFlightDetails(BuildContext context, int index) {
    // ضفنا context كباراميتر
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FlightDetailsScreen(flightData: flightLogs[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Logs',
            style: Theme.of(context).textTheme.headlineSmall),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade700, Color.fromARGB(255, 173, 105, 2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: flightLogs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_takeoff,
                        size: 80, color: Colors.grey.shade400),
                    SizedBox(height: 16),
                    Text('No Flights Added Yet',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: flightLogs.length,
                itemBuilder: (context, index) {
                  return _buildFlightCard(context, index);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addFlight(context), // عدينا الـ context هنا
        backgroundColor: Colors.amber.shade700,
        child: Icon(Icons.add),
        tooltip: 'Add New Flight',
      ),
    );
  }

  Widget _buildFlightCard(BuildContext context, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () =>
              _showFlightDetails(context, index), // عدينا الـ context هنا
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight, size: 40, color: Colors.amber.shade700),
                SizedBox(height: 12),
                Text(
                  "Flight: ${flightLogs[index]['flightNumber']}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Date: ${flightLogs[index]['date']}",
                    style: Theme.of(context).textTheme.bodyMedium),
                if (flightLogs[index]['routes'] != null)
                  Text("Routes: ${flightLogs[index]['routes'].length}",
                      style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.amber.shade700,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('Pilot Dashboard',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildDrawerItem(
                context, Icons.home, 'Home', () => Navigator.pop(context)),
            _buildDrawerItem(context, Icons.add, 'Add Flight',
                () => _addFlight(context)), // عدينا الـ context هنا
            _buildDrawerItem(
                context,
                Icons.person,
                'Pilots',
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PilotsScreen()))),
            _buildDrawerItem(
                context,
                Icons.settings,
                'Settings',
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()))),
            _buildDrawerItem(
                context, Icons.logout, 'Logout', () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber.shade700),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
      hoverColor: Colors.amber.shade700.withOpacity(0.1),
    );
  }
}

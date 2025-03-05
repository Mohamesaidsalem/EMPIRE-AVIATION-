import 'package:flutter/material.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/time_field_widget.dart';
import '../utils/time_calculations.dart';
import '../utils/pilots_data.dart';

class AddFlightScreen extends StatefulWidget {
  @override
  _AddFlightScreenState createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController journeyStartController = TextEditingController();
  final TextEditingController journeyEndController = TextEditingController();
  final TextEditingController bookingRefController = TextEditingController();

  String? aircraftReg = "T7 - PYR";
  String? aircraftType = "GL7500";
  String? flightType;
  String? captain;
  String? firstOfficer;
  String? ogmCrew;

  List<Map<String, dynamic>> routes = [];

  @override
  void initState() {
    super.initState();
    addRoute();
  }

  void addRoute() {
    setState(() {
      routes.add({
        'dateController': TextEditingController(),
        'fromController': TextEditingController(),
        'toController': TextEditingController(),
        'takeoffController': TextEditingController(),
        'landingController': TextEditingController(),
        'brakesOffController': TextEditingController(),
        'brakesOnController': TextEditingController(),
        'flightTimeController': TextEditingController(),
        'blockTimeController': TextEditingController(),
        'distanceController': TextEditingController(),
        'fuelController': TextEditingController(),
        'takeoffIndicate': 'Day',
        'landingIndicate': 'Captain',
        'paxController': TextEditingController(),
        'startUtcController': TextEditingController(),
        'startLocalController': TextEditingController(),
        'totalDutyController': TextEditingController(),
        'expanded': true,
      });
    });
  }

  void deleteRoute(int index) {
    setState(() => routes.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Route ${index + 1} deleted!',
              style: TextStyle(color: Colors.white))),
    );
  }

  void toggleRoute(int index) {
    setState(() {
      routes[index]['expanded'] = !(routes[index]['expanded'] as bool);
    });
  }

  void saveRoute(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Route ${index + 1} saved!',
              style: TextStyle(color: Colors.white))),
    );
  }

  void calculateTimes(Map<String, dynamic> route) {
    setState(() {
      route['blockTimeController'].text = calculateDifference(
          route['brakesOffController'].text, route['brakesOnController'].text);
      route['flightTimeController'].text = calculateDifference(
          route['takeoffController'].text, route['landingController'].text);
      route['totalDutyController'].text = calculateDifference(
          route['startUtcController'].text, route['startLocalController'].text);
    });
  }

  void saveData() {
    if (_formKey.currentState!.validate() &&
        flightNumberController.text.isNotEmpty) {
      Map<String, dynamic> flightData = {
        'flightNumber': flightNumberController.text,
        'journeyStart': journeyStartController.text,
        'journeyEnd': journeyEndController.text,
        'bookingRef': bookingRefController.text,
        'aircraftReg': aircraftReg,
        'aircraftType': aircraftType,
        'flightType': flightType,
        'captain': captain,
        'firstOfficer': firstOfficer,
        'ogmCrew': ogmCrew,
        'routes': routes
            .map((route) => {
                  'date': route['dateController'].text,
                  'from': route['fromController'].text,
                  'to': route['toController'].text,
                  'takeoff': route['takeoffController'].text,
                  'landing': route['landingController'].text,
                  'brakesOff': route['brakesOffController'].text,
                  'brakesOn': route['brakesOnController'].text,
                  'flightTime': route['flightTimeController'].text,
                  'blockTime': route['blockTimeController'].text,
                  'distance': route['distanceController'].text,
                  'fuel': route['fuelController'].text,
                  'takeoffIndicate': route['takeoffIndicate'],
                  'landingIndicate': route['landingIndicate'],
                  'pax': route['paxController'].text,
                  'startUtc': route['startUtcController'].text,
                  'startLocal': route['startLocalController'].text,
                  'totalDuty': route['totalDutyController'].text,
                })
            .toList(),
      };
      Navigator.pop(context, flightData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Flight #${flightNumberController.text} with ${routes.length} routes saved!',
                style: TextStyle(color: Colors.white))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter a flight number!',
                style: TextStyle(color: Colors.white))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Add Flight ${flightNumberController.text.isEmpty ? '' : '#${flightNumberController.text}'}',
            style: Theme.of(context).textTheme.headlineSmall),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection('Flight Information', Icons.flight,
                    _buildFlightInfoSection()),
                SizedBox(height: 16),
                _buildSection(
                    'Crew Information', Icons.people, _buildCrewInfoSection()),
                SizedBox(height: 16),
                _buildSection('Routes', Icons.route, _buildRoutesSection()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        backgroundColor: Colors.amber.shade700,
        child: Icon(Icons.save),
        tooltip: 'Save All Data',
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.amber.shade700),
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        children: [Padding(padding: EdgeInsets.all(16), child: content)],
      ),
    );
  }

  Widget _buildFlightInfoSection() {
    return Column(
      children: [
        TextFieldWidget(
          controller: flightNumberController,
          label: 'Flight Number',
          icon: Icons.confirmation_number,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownWidget(
                label: 'Aircraft Registration',
                value: aircraftReg,
                items: ["T7 - PYR", "T7 - ABC", "T7 - XYZ"],
                onChanged: (value) => setState(() => aircraftReg = value),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DropdownWidget(
                label: 'Aircraft Type',
                value: aircraftType,
                items: ["GL7500", "Boeing 737", "Airbus A320"],
                onChanged: (value) => setState(() => aircraftType = value),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DatePickerWidget(
                label: 'Journey Start Date',
                controller: journeyStartController,
                onDateSelected: (date) => journeyStartController.text =
                    "${date.toLocal()}".split(' ')[0],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DatePickerWidget(
                label: 'Journey End Date',
                controller: journeyEndController,
                onDateSelected: (date) => journeyEndController.text =
                    "${date.toLocal()}".split(' ')[0],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextFieldWidget(
            controller: bookingRefController,
            label: 'Booking Ref#',
            icon: Icons.book),
        SizedBox(height: 12),
        DropdownWidget(
          label: 'Type of Flight',
          value: flightType,
          items: [
            'Domestic',
            'International',
            'Revenue',
            'Ferry',
            'Maintenance',
            'Test flight',
            'Training',
            'Demo',
            'Company',
            'Owner',
            'Mercy'
          ],
          onChanged: (value) => setState(() => flightType = value),
        ),
      ],
    );
  }

  Widget _buildCrewInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownWidget(
                label: 'Captain',
                value: captain,
                items: PilotsData.pilots,
                onChanged: (value) => setState(() => captain = value),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DropdownWidget(
                label: 'First Officer',
                value: firstOfficer,
                items: PilotsData.pilots,
                onChanged: (value) => setState(() => firstOfficer = value),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        DropdownWidget(
          label: 'OGM Crew',
          value: ogmCrew,
          items: ["Crew 1", "Crew 2", "Crew 3"],
          onChanged: (value) => setState(() => ogmCrew = value),
        ),
      ],
    );
  }

  Widget _buildRoutesSection() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: addRoute,
          icon: Icon(Icons.add),
          label: Text('Add Route'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade700,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        SizedBox(height: 16),
        ...routes.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> route = entry.value;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading:
                    Icon(Icons.flight_takeoff, color: Colors.amber.shade700),
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade900, Colors.grey.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Route ${index + 1} - Flight #${flightNumberController.text}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                initiallyExpanded: route['expanded'] as bool,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.save, color: Colors.amber.shade700),
                      onPressed: () => saveRoute(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteRoute(index),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DatePickerWidget(
                          label: 'Route Date',
                          controller: route['dateController'],
                          onDateSelected: (date) => route['dateController']
                              .text = "${date.toLocal()}".split(' ')[0],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                controller: route['fromController'],
                                label: 'From',
                                icon: Icons.flight_takeoff,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFieldWidget(
                                controller: route['toController'],
                                label: 'To',
                                icon: Icons.flight_land,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TimeFieldWidget(
                                controller: route['takeoffController'],
                                label: 'Takeoff',
                                onChanged: (_) => calculateTimes(route),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TimeFieldWidget(
                                controller: route['landingController'],
                                label: 'Landing',
                                onChanged: (_) => calculateTimes(route),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TimeFieldWidget(
                                controller: route['brakesOffController'],
                                label: 'Brakes Off',
                                onChanged: (_) => calculateTimes(route),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TimeFieldWidget(
                                controller: route['brakesOnController'],
                                label: 'Brakes On',
                                onChanged: (_) => calculateTimes(route),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                controller: route['flightTimeController'],
                                label: 'Flight Time',
                                icon: Icons.timer,
                                enabled: false,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFieldWidget(
                                controller: route['blockTimeController'],
                                label: 'Block Time',
                                icon: Icons.timer,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                controller: route['distanceController'],
                                label: 'Distance (NM)',
                                icon: Icons.straighten,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFieldWidget(
                                controller: route['fuelController'],
                                label: 'Fuel Used (kg)',
                                icon: Icons.local_gas_station,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(color: Colors.grey.shade300),
                        Text('Indicate',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownWidget(
                                label: 'Takeoff',
                                value: route['takeoffIndicate'],
                                items: ['Day', 'Night'],
                                onChanged: (value) => setState(
                                    () => route['takeoffIndicate'] = value),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: DropdownWidget(
                                label: 'Landing',
                                value: route['landingIndicate'],
                                items: ['Captain', 'First Officer'],
                                onChanged: (value) => setState(
                                    () => route['landingIndicate'] = value),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFieldWidget(
                          controller: route['paxController'],
                          label: 'Pax',
                          icon: Icons.people,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        Divider(color: Colors.grey.shade300),
                        Text('Duty Period',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TimeFieldWidget(
                                controller: route['startUtcController'],
                                label: 'Start UTC',
                                onChanged: (_) => calculateTimes(route),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TimeFieldWidget(
                                controller: route['startLocalController'],
                                label: 'Start Local',
                                onChanged: (_) => calculateTimes(route),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFieldWidget(
                          controller: route['totalDutyController'],
                          label: 'Total Duty',
                          icon: Icons.timer,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

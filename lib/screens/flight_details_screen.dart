import 'package:flutter/material.dart';

class FlightDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> flightData;

  FlightDetailsScreen({required this.flightData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight #${flightData['flightNumber']}',
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
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFlightInfo(context),
              SizedBox(height: 16),
              _buildCrewInfo(context),
              SizedBox(height: 16),
              _buildRoutesList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightInfo(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                'Flight Information',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child:
                        Text('Flight Number: ${flightData['flightNumber']}')),
                Expanded(
                    child: Text('Booking Ref#: ${flightData['bookingRef']}')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child:
                        Text('Journey Start: ${flightData['journeyStart']}')),
                Expanded(
                    child: Text('Journey End: ${flightData['journeyEnd']}')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: Text('Aircraft Reg: ${flightData['aircraftReg']}')),
                Expanded(
                    child:
                        Text('Aircraft Type: ${flightData['aircraftType']}')),
              ],
            ),
            SizedBox(height: 8),
            Text('Flight Type: ${flightData['flightType']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCrewInfo(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                'Crew Information',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('Captain: ${flightData['captain']}')),
                Expanded(
                    child:
                        Text('First Officer: ${flightData['firstOfficer']}')),
              ],
            ),
            SizedBox(height: 8),
            Text('OGM Crew: ${flightData['ogmCrew']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutesList(BuildContext context) {
    List<dynamic> routes = flightData['routes'] ?? [];
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                'Routes (${routes.length})',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 12),
            ...routes.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> route = entry.value;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Route ${index + 1} - Date: ${route['date']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800),
                        ),
                        Divider(color: Colors.grey.shade300),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: Text('From: ${route['from']}')),
                            Expanded(child: Text('To: ${route['to']}')),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: Text('Takeoff: ${route['takeoff']}')),
                            Expanded(
                                child: Text('Landing: ${route['landing']}')),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child:
                                    Text('Brakes Off: ${route['brakesOff']}')),
                            Expanded(
                                child: Text('Brakes On: ${route['brakesOn']}')),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                    'Flight Time: ${route['flightTime']}')),
                            Expanded(
                                child:
                                    Text('Block Time: ${route['blockTime']}')),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child:
                                    Text('Distance: ${route['distance']} NM')),
                            Expanded(
                                child: Text('Fuel Used: ${route['fuel']} kg')),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300),
                        Text('Indicate',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                    'Takeoff: ${route['takeoffIndicate']}')),
                            Expanded(
                                child: Text(
                                    'Landing: ${route['landingIndicate']}')),
                            Expanded(child: Text('Pax: ${route['pax']}')),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300),
                        Text('Duty Period',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: Text('Start UTC: ${route['startUtc']}')),
                            Expanded(
                                child: Text(
                                    'Start Local: ${route['startLocal']}')),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Total: ${route['totalDuty']}'),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

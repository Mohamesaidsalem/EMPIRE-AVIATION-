import 'package:flutter/material.dart';
import '../utils/pilots_data.dart'; // ضيفنا الـ Import

class PilotsScreen extends StatefulWidget {
  @override
  _PilotsScreenState createState() => _PilotsScreenState();
}

class _PilotsScreenState extends State<PilotsScreen> {
  final TextEditingController _pilotController = TextEditingController();

  void _addPilot() {
    if (_pilotController.text.isNotEmpty) {
      setState(() {
        PilotsData.pilots.add(_pilotController.text);
        _pilotController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Pilot added successfully!',
                style: TextStyle(color: Colors.white))),
      );
    }
  }

  void _removePilot(String pilot) {
    setState(() => PilotsData.pilots.remove(pilot));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('$pilot removed!', style: TextStyle(color: Colors.white))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilots', style: Theme.of(context).textTheme.headlineSmall),
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pilotController,
                    decoration: InputDecoration(
                      labelText: 'Add New Pilot',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon:
                          Icon(Icons.person_add, color: Colors.amber.shade700),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _addPilot,
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: PilotsData.pilots.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.amber.shade700),
                      title: Text(PilotsData.pilots[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removePilot(PilotsData.pilots[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

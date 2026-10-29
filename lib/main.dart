import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// CHANGED: Must be StatefulWidget to handle setState for Pickers
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // STATE VARIABLES FOR PICKERS
  DateTime _selectedDate = DateTime.now();
  String _selectedHouse = 'Slytherin';
  final List<String> _houses = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];

  // --- PICKER LOGIC METHODS ---

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
        ),
      ),
    );
  }

  // 3. Cupertino House Wheel Picker (Modal Sheet)
  void _showCupertinoHousePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: _houses.indexOf(_selectedHouse),
          ),
          onSelectedItemChanged: (int index) {
            setState(() {
              _selectedHouse = _houses[index];
            });
          },
          children: _houses.map((house) => Center(child: Text(house))).toList(),
        ),
      ),
    );
  }

  // --- UI BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitView(context);
          } else {
            return _buildLandscapeView(context);
          }
        },
      ),
    );
  }

  Widget _buildPortraitView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- BLUE BOX SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'KEVINSON ANAK KATA',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text('BCS25020006', style: TextStyle(fontSize: 14, color: Colors.white)),
                  const Divider(height: 30, thickness: 1, color: Colors.white30),
                  const Text(
                    'Personal Life Goal / Quote:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"I just want make my family happy in the future. I want make more money and going travel to my favourite place :). Love yourself."',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- LOCATION SECTION ---
            TitleSection(name: 'Tun Hotel', location: 'Kuching, Sarawak', starCount: 43),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/hotel_IMG.jpg', height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),

            // --- EXERCISE 2.3: INTERACTIVE PICKERS SECTION ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interactive Pickers (Lab 2.2)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    // Display Selected Values
                    Text('Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('Selected House: $_selectedHouse',
                        style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // 1. Material Date Picker Button (No const because of onPressed)
                    OutlinedButton.icon(
                      onPressed: () => _selectMaterialDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Material Date Picker'),
                    ),
                    const SizedBox(height: 10),

                    // 2. Cupertino Date Picker Button (No const because of onPressed)
                    OutlinedButton.icon(
                      onPressed: () => _showCupertinoDatePicker(context),
                      icon: const Icon(CupertinoIcons.calendar),
                      label: const Text('Cupertino Date Picker (Modal Sheet)'),
                    ),
                    const SizedBox(height: 20),

                    // 3. Material Dropdown
                    Row(
                      children: [
                        const Text('Material Dropdown: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedHouse,
                            isExpanded: true,
                            items: _houses.map((String house) {
                              return DropdownMenuItem<String>(value: house, child: Text(house));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() { _selectedHouse = newValue!; });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 4. Cupertino House Wheel Picker Button (Fixed Icon & No const)
                    OutlinedButton.icon(
                      onPressed: () => _showCupertinoHousePicker(context),
                      icon: const Icon(CupertinoIcons.list_bullet), // FIXED: Changed from .picker
                      label: const Text('Cupertino House Wheel Picker'),
                    ),
                  ],
                ),
              ),
            ),

            // Space for scrolling test
            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }

  // Landscape view with FIXED errors
  Widget _buildLandscapeView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 40, backgroundColor: Colors.white, backgroundImage: const AssetImage('assets/profile.jpg')),
                  const SizedBox(height: 10),
                  const Text('KEVINSON ANAK KATA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                  const Text('BCS25020006', style: TextStyle(fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 10),
                  const Text('"I just want make my family happy in the future. I want make more money and going travel to my favourite place :). Love yourself."', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleSection(name: 'Tun Hotel', location: 'Kuching, Sarawak', starCount: 43),
                  const SizedBox(height: 16),
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/hotel_IMG.jpg', height: 200, width: double.infinity, fit: BoxFit.cover)),
                  const SizedBox(height: 20),

                  // FIXED: Removed const and fixed icon name here too
                  OutlinedButton.icon(
                      onPressed: () => _selectMaterialDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Pick Date')
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                      onPressed: () => _showCupertinoHousePicker(context),
                      icon: const Icon(CupertinoIcons.list_bullet), // FIXED: Changed from .picker
                      label: const Text('Pick House')
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Exercise 2.1: Deconstructed Title Section Widget
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({super.key, required this.name, required this.location, required this.starCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(location, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}
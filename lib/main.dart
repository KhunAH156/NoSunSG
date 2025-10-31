import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(NoSunSGApp());
}

class NoSunSGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoSun SG',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1E1E1E),
        primaryColor: Colors.deepPurpleAccent,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedHour = 7;
  bool isAm = true;
  String selectedLine = 'East–West Line';
  String selectedDirection = 'Towards Pasir Ris';
  String? selectedStation;
  String? recommendedSide;
  List<Map<String, dynamic>>? segmentRecommendations;

  final mrtLines = ['East–West Line', 'North–South Line'];

  final Map<String, List<String>> lineDirections = {
    'East–West Line': ['Towards Pasir Ris', 'Towards Tuas Link'],
    'North–South Line': ['Towards Marina South Pier', 'Towards Jurong East'],
  };

  // MRT station coordinates and ordering
  final Map<String, List<Map<String, dynamic>>> lineStations = {
    'East–West Line': [
      {'name': 'Pasir Ris', 'lat': 1.373234, 'lng': 103.949343},
      {'name': 'Tampines', 'lat': 1.354467, 'lng': 103.943325},
      {'name': 'Simei', 'lat': 1.343237, 'lng': 103.953343},
      {'name': 'Tanah Merah', 'lat': 1.327309, 'lng': 103.946479},
      {'name': 'Bedok', 'lat': 1.324043, 'lng': 103.930205},
      {'name': 'Kembangan', 'lat': 1.320998, 'lng': 103.913433},
      {'name': 'Eunos', 'lat': 1.319809, 'lng': 103.902888},
      {'name': 'Paya Lebar', 'lat': 1.318214, 'lng': 103.893133},
      {'name': 'Aljunied', 'lat': 1.316474, 'lng': 103.882762},
      {'name': 'Kallang', 'lat': 1.311532, 'lng': 103.871372},
      {'name': 'Lavender', 'lat': 1.307577, 'lng': 103.863155},
      {'name': 'Bugis', 'lat': 1.300747, 'lng': 103.855873},
      {'name': 'City Hall', 'lat': 1.293119, 'lng': 103.852089},
      {'name': 'Raffles Place', 'lat': 1.284001, 'lng': 103.85155},
      {'name': 'Tanjong Pagar', 'lat': 1.276385, 'lng': 103.846771},
      {'name': 'Outram Park', 'lat': 1.280319, 'lng': 103.839459},
      {'name': 'Tiong Bahru', 'lat': 1.286555, 'lng': 103.826956},
      {'name': 'Redhill', 'lat': 1.289674, 'lng': 103.816787},
      {'name': 'Queenstown', 'lat': 1.294867, 'lng': 103.805902},
      {'name': 'Commonwealth', 'lat': 1.302439, 'lng': 103.798326},
      {'name': 'Buona Vista', 'lat': 1.307337, 'lng': 103.790046},
      {'name': 'Dover', 'lat': 1.311414, 'lng': 103.778596},
      {'name': 'Clementi', 'lat': 1.314925, 'lng': 103.765341},
      {'name': 'Chinese Garden', 'lat': 1.342436, 'lng': 103.732582},
      {'name': 'Lakeside', 'lat': 1.344264, 'lng': 103.720797},
      {'name': 'Boon Lay', 'lat': 1.33862, 'lng': 103.705817},
      {'name': 'Pioneer', 'lat': 1.337645, 'lng': 103.69742},
      {'name': 'Joo Koon', 'lat': 1.327826, 'lng': 103.678318},
      {'name': 'Gul Circle', 'lat': 1.319809, 'lng': 103.66083},
      {'name': 'Tuas Crescent', 'lat': 1.321091, 'lng': 103.649075},
      {'name': 'Tuas West Road', 'lat': 1.330075, 'lng': 103.639636},
      {'name': 'Tuas Link', 'lat': 1.340371, 'lng': 103.636866},
    ],
    'North–South Line': [
      {'name': 'Jurong East', 'lat': 1.333207, 'lng': 103.742308},
      {'name': 'Bukit Batok', 'lat': 1.349069, 'lng': 103.749596},
      {'name': 'Bukit Gombak', 'lat': 1.359043, 'lng': 103.751863},
      {'name': 'Choa Chu Kang', 'lat': 1.385417, 'lng': 103.744316},
      {'name': 'Yew Tee', 'lat': 1.397383, 'lng': 103.747523},
      {'name': 'Kranji', 'lat': 1.425302, 'lng': 103.762049},
      {'name': 'Marsiling', 'lat': 1.432579, 'lng': 103.77415},
      {'name': 'Woodlands', 'lat': 1.436984, 'lng': 103.786406},
      {'name': 'Admiralty', 'lat': 1.440625, 'lng': 103.800933},
      {'name': 'Sembawang', 'lat': 1.449133, 'lng': 103.82006},
      {'name': 'Yishun', 'lat': 1.429666, 'lng': 103.835044},
      {'name': 'Khatib', 'lat': 1.417423, 'lng': 103.832995},
      {'name': 'Yio Chu Kang', 'lat': 1.381765, 'lng': 103.844923},
      {'name': 'Ang Mo Kio', 'lat': 1.370025, 'lng': 103.849588},
      {'name': 'Bishan', 'lat': 1.35092, 'lng': 103.848206},
      {'name': 'Braddell', 'lat': 1.34055, 'lng': 103.847098},
      {'name': 'Toa Payoh', 'lat': 1.332405, 'lng': 103.847436},
      {'name': 'Novena', 'lat': 1.320089, 'lng': 103.843405},
      {'name': 'Newton', 'lat': 1.31383, 'lng': 103.838021},
      {'name': 'Orchard', 'lat': 1.304041, 'lng': 103.831792},
      {'name': 'Somerset', 'lat': 1.300508, 'lng': 103.838428},
      {'name': 'Dhoby Ghaut', 'lat': 1.299169, 'lng': 103.845799},
      {'name': 'City Hall', 'lat': 1.293119, 'lng': 103.852089},
      {'name': 'Raffles Place', 'lat': 1.284001, 'lng': 103.85155},
      {'name': 'Marina Bay', 'lat': 1.276481, 'lng': 103.854598},
      {'name': 'Marina South Pier', 'lat': 1.271422, 'lng': 103.863581},
    ],
  };

  List<String> get availableDirections => lineDirections[selectedLine] ?? [];

  List<String> get availableStations {
    List<Map<String, dynamic>> stations = lineStations[selectedLine] ?? [];
    return stations.map((s) => s['name'] as String).toList();
  }

  void clearRecommendation() {
    setState(() {
      recommendedSide = null;
      segmentRecommendations = null;
    });
  }

  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    double dLon = (lon2 - lon1) * pi / 180;
    double y = sin(dLon) * cos(lat2 * pi / 180);
    double x =
        cos(lat1 * pi / 180) * sin(lat2 * pi / 180) -
        sin(lat1 * pi / 180) * cos(lat2 * pi / 180) * cos(dLon);
    double bearing = atan2(y, x);
    return (bearing * 180 / pi + 360) % 360;
  }

  List<Widget> _buildSegmentRecommendations(bool isSmallScreen) {
    if (segmentRecommendations == null) return [];

    // Group consecutive segments with same side recommendation
    List<Map<String, dynamic>> grouped = [];
    for (var segment in segmentRecommendations!) {
      if (grouped.isEmpty || grouped.last['side'] != segment['side']) {
        grouped.add({
          'from': segment['from'],
          'to': segment['to'],
          'side': segment['side'],
        });
      } else {
        grouped.last['to'] = segment['to'];
      }
    }

    return grouped.map((group) {
      bool isLeft = group['side'] == 'Left';
      return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isLeft ? Colors.blue.shade700 : Colors.orange.shade700,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isLeft ? Icons.arrow_back : Icons.arrow_forward,
                color: isLeft ? Colors.blue.shade300 : Colors.orange.shade300,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${group['from']} → ${group['to']}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sit on ${group['side']} side for shade',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void confirmSelection() {
    int hour24 = isAm ? selectedHour % 12 : (selectedHour % 12) + 12;

    // Check if it's nighttime (8 PM to 6 AM)
    if (hour24 >= 20 || hour24 < 6) {
      setState(() {
        recommendedSide = "There's no sun you silly goose";
        segmentRecommendations = null;
      });
      return;
    }

    double sunAngle = getSunAngle(hour24);

    // Get station list
    List<Map<String, dynamic>> stations = lineStations[selectedLine] ?? [];

    // Determine travel direction
    // For East-West Line: Pasir Ris is at index 0, Tuas Link is at the end
    // For North-South Line: Jurong East is at index 0, Marina South Pier is at the end
    bool isTowardsEnd =
        selectedDirection.contains('Tuas Link') ||
        selectedDirection.contains('Marina South Pier');

    List<Map<String, dynamic>> segmentInfo = [];
    String overallRecommendation = '';

    // If no station selected, show all segments for the entire line
    if (selectedStation == null) {
      if (isTowardsEnd) {
        // Show all segments from start to end
        for (int i = 0; i < stations.length - 1; i++) {
          var from = stations[i];
          var to = stations[i + 1];
          double bearing = calculateBearing(
            from['lat'],
            from['lng'],
            to['lat'],
            to['lng'],
          );
          double relativeSunAngle = (sunAngle - bearing + 360) % 360;
          String sidePref = relativeSunAngle <= 180 ? 'Left' : 'Right';

          segmentInfo.add({
            'from': from['name'],
            'to': to['name'],
            'side': sidePref,
          });
        }
      } else {
        // Show all segments from end to start
        for (int i = stations.length - 1; i > 0; i--) {
          var from = stations[i];
          var to = stations[i - 1];
          double bearing = calculateBearing(
            from['lat'],
            from['lng'],
            to['lat'],
            to['lng'],
          );
          double relativeSunAngle = (sunAngle - bearing + 360) % 360;
          String sidePref = relativeSunAngle <= 180 ? 'Left' : 'Right';

          segmentInfo.add({
            'from': from['name'],
            'to': to['name'],
            'side': sidePref,
          });
        }
      }
    } else {
      // Station is selected, show segments from that station
      int currentStationIndex = stations.indexWhere(
        (s) => s['name'] == selectedStation,
      );

      if (currentStationIndex == -1) return;

      // Analyze each segment from current station
      if (isTowardsEnd) {
        // Going towards the end of the line (increasing index)
        for (int i = currentStationIndex; i < stations.length - 1; i++) {
          var from = stations[i];
          var to = stations[i + 1];
          double bearing = calculateBearing(
            from['lat'],
            from['lng'],
            to['lat'],
            to['lng'],
          );
          double relativeSunAngle = (sunAngle - bearing + 360) % 360;
          String sidePref = relativeSunAngle <= 180 ? 'Left' : 'Right';

          segmentInfo.add({
            'from': from['name'],
            'to': to['name'],
            'side': sidePref,
          });
        }
      } else {
        // Going towards the start of the line (decreasing index)
        for (int i = currentStationIndex; i > 0; i--) {
          var from = stations[i];
          var to = stations[i - 1];
          double bearing = calculateBearing(
            from['lat'],
            from['lng'],
            to['lat'],
            to['lng'],
          );
          double relativeSunAngle = (sunAngle - bearing + 360) % 360;
          String sidePref = relativeSunAngle <= 180 ? 'Left' : 'Right';

          segmentInfo.add({
            'from': from['name'],
            'to': to['name'],
            'side': sidePref,
          });
        }
      }
    }

    // Count which side is recommended more
    int leftCount = segmentInfo.where((s) => s['side'] == 'Left').length;
    int rightCount = segmentInfo.where((s) => s['side'] == 'Right').length;
    overallRecommendation = leftCount >= rightCount
        ? 'Left Side'
        : 'Right Side';

    setState(() {
      recommendedSide = overallRecommendation;
      segmentRecommendations = segmentInfo;
    });
  }

  double getSunAngle(int hour) {
    // Sun path approximation in Singapore (roughly East to West)
    // 6 AM: 90° (East), 12 PM: 180° (South), 6 PM: 270° (West)
    if (hour < 6 || hour >= 19) return 0; // Night time, no sun concern

    if (hour >= 6 && hour < 12) {
      // Morning: East (90°) to South (180°)
      double progress = (hour - 6) / 6.0;
      return 90 + (progress * 90);
    } else {
      // Afternoon: South (180°) to West (270°)
      double progress = (hour - 12) / 7.0;
      return 180 + (progress * 90);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final clockSize = isSmallScreen ? 180.0 : 220.0;
    final maxInputWidth = screenWidth * 0.85;

    return Scaffold(
      appBar: AppBar(title: Text('NoSun SG'), backgroundColor: Colors.black87),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 20,
        ),
        child: Column(
          children: [
            Text(
              'Select Time',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 20),
            // Top digital display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 12,
                    vertical: isSmallScreen ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedHour.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAm = true;
                          clearRecommendation();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isAm
                              ? Colors.deepPurpleAccent
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'AM',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAm = false;
                          clearRecommendation();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: !isAm
                              ? Colors.deepPurpleAccent
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PM',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Circular clock dial
            CircularTimeDial12Hour(
              hour: selectedHour,
              size: clockSize,
              onHourChanged: (val) {
                setState(() {
                  selectedHour = val;
                  clearRecommendation();
                  HapticFeedback.lightImpact();
                });
              },
            ),
            SizedBox(height: 30),
            Container(
              constraints: BoxConstraints(
                maxWidth: maxInputWidth.clamp(280, 400),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'MRT Line',
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                dropdownColor: Colors.grey[900],
                value: selectedLine,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.deepPurpleAccent,
                ),
                style: TextStyle(color: Colors.white, fontSize: 15),
                items: mrtLines
                    .map(
                      (line) =>
                          DropdownMenuItem(value: line, child: Text(line)),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedLine = val!;
                    // Reset direction to first option of new line
                    selectedDirection = availableDirections.first;
                    selectedStation = null;
                    clearRecommendation();
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                maxWidth: maxInputWidth.clamp(280, 400),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Direction',
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                dropdownColor: Colors.grey[900],
                value: selectedDirection,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.deepPurpleAccent,
                ),
                style: TextStyle(color: Colors.white, fontSize: 15),
                items: availableDirections
                    .map(
                      (dir) => DropdownMenuItem(value: dir, child: Text(dir)),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedDirection = val!;
                    clearRecommendation();
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                maxWidth: maxInputWidth.clamp(280, 400),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Boarding Station',
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                dropdownColor: Colors.grey[900],
                value: selectedStation,
                hint: Text(
                  'Select station',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.deepPurpleAccent,
                ),
                style: TextStyle(color: Colors.white, fontSize: 15),
                isExpanded: true,
                items: availableStations
                    .map(
                      (station) => DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedStation = val;
                    clearRecommendation();
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 32 : 40,
                  vertical: isSmallScreen ? 14 : 16,
                ),
                minimumSize: Size(0, 48),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
              ),
            ),
            SizedBox(height: 30),
            if (recommendedSide != null)
              Column(
                children: [
                  Text(
                    'Recommended Side To Sit:',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    recommendedSide!,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  if (segmentRecommendations != null &&
                      segmentRecommendations!.isNotEmpty) ...[
                    SizedBox(height: 30),
                    Text(
                      'Shade by Segment:',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: maxInputWidth.clamp(280, 500),
                      ),
                      child: Column(
                        children: _buildSegmentRecommendations(isSmallScreen),
                      ),
                    ),
                  ],
                ],
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 12-hour circular dial widget with hand and tip circle
class CircularTimeDial12Hour extends StatelessWidget {
  final int hour;
  final double size;
  final Function(int) onHourChanged;

  CircularTimeDial12Hour({
    required this.hour,
    this.size = 220.0,
    required this.onHourChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset center = box.size.center(Offset.zero);
        Offset vector = details.localPosition - center;
        double angle = atan2(vector.dy, vector.dx);
        double deg = angle * 180 / pi;
        double normalized = (deg + 90 + 360) % 360;
        int newHour = (normalized / 30).round();
        newHour = newHour == 0 ? 12 : newHour;
        onHourChanged(newHour);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[850],
        ),
        child: CustomPaint(
          painter: ClockPainter(hour: hour),
          size: Size(size, size),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final int hour;

  ClockPainter({required this.hour});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final numberRadius = radius * 0.7;

    // Calculate hand position first
    final handAngle = ((hour % 12) * 30 - 90) * pi / 180;
    final handLength = numberRadius;
    final handEnd = Offset(
      center.dx + handLength * cos(handAngle),
      center.dy + handLength * sin(handAngle),
    );

    // Draw clock hand
    final handPaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, handEnd, handPaint);

    // Draw center circle
    final centerCirclePaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 6, centerCirclePaint);

    // Draw tip circle (before hour numbers so it goes behind)
    final tipCirclePaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;

    canvas.drawCircle(handEnd, 22, tipCirclePaint);

    // Draw hour numbers (on top of everything)
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final x = center.dx + numberRadius * cos(angle);
      final y = center.dy + numberRadius * sin(angle);

      final textSpan = TextSpan(
        text: '$i',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: i == hour ? Colors.white : Colors.grey[400],
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Center the text at the calculated position
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return oldDelegate.hour != hour;
  }
}

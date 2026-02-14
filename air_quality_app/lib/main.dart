import 'package:flutter/material.dart';
import 'models/air_quality_model.dart';
import 'services/air_quality_service.dart';
import 'utils/aqi_color.dart';
import 'services/location_service.dart';

void main() {
  runApp(const AirQualityApp());
}

class AirQualityApp extends StatelessWidget {
  const AirQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AirQuality? airQuality;
  bool isLoading = false;
  bool showResult = false;
  String error = '';

  final TextEditingController cityController = TextEditingController();
  final FocusNode cityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    cityFocusNode.addListener(() {
      if (cityFocusNode.hasFocus) {
        setState(() {
          showResult = false;
        });
      }
    });
  }

  Future<void> fetchAirQuality() async {
    setState(() {
      isLoading = true;
      error = '';
      showResult = true;
    });

    try {
      final result =
          await AirQualityService.fetchAirQualityByCity(cityController.text);

      setState(() {
        airQuality = result;
      });
    } catch (e) {
      setState(() {
        error = 'Şehir bulunamadı';
        showResult = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchByLocation() async {
    setState(() {
      isLoading = true;
      showResult = true;
    });

    try {
      final position = await LocationService.getCurrentLocation();

      final result = await AirQualityService.fetchAirQualityByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        airQuality = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        showResult = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  LinearGradient get backgroundGradient {
    if (!showResult || airQuality == null) {
      return const LinearGradient(
        colors: [Colors.white, Colors.white],
      );
    }
    return getAqiGradient(airQuality!.aqi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hava Kalitesi'),
        centerTitle: true,
        backgroundColor: showResult && airQuality != null
            ? getAqiGradient(airQuality!.aqi).colors.last
            : Colors.green,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: cityController,
                  focusNode: cityFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Şehir gir (örn: Istanbul)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: fetchAirQuality,
                  child: const Text('Hava Kalitesini Getir'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: fetchByLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Bulunduğum Yer'),
                ),
                const SizedBox(height: 24),
                if (isLoading) const CircularProgressIndicator(),
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (airQuality != null && showResult)
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'AQI: ${airQuality!.aqi}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            airQuality!.level,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            airQuality!.description,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

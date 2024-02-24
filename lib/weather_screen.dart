import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets_data.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String,dynamic>>? weather;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String,dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "An unexpexted error occurred";
      }
      return data;
    } catch (e) {
      log('Error fetching weather data: $e');
      throw 'An unexpected error occured';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.w200,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    weather = getCurrentWeather();
                  });
                },
                icon: const Icon(
                  Icons.refresh,
                )),
          ],
        ),
        body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            final currentWeather = data['list'][0];
            final currentTemp = currentWeather['main']['temp'];
            final currentSky = currentWeather['weather'][0]['main'];
            final currentPressure = currentWeather['main']['pressure'];
            final currentWindSpeed = currentWeather['wind']['speed'];
            final currentHumidity = currentWeather['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // const SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       HourlyForecast(
                  //           time: '09:00',
                  //           icon: Icons.cloud,
                  //           temperature: '101.17'),
                  //       HourlyForecast(
                  //           time: '10:00',
                  //           icon: Icons.cloud,
                  //           temperature: '102.17'),
                  //       HourlyForecast(
                  //           time: '11:00',
                  //           icon: Icons.cloud,
                  //           temperature: '103.17'),
                  //       HourlyForecast(
                  //           time: '12:00',
                  //           icon: Icons.cloud,
                  //           temperature: '104.17'),
                  //       HourlyForecast(
                  //           time: '13:00',
                  //           icon: Icons.sunny,
                  //           temperature: '105.17'),
                  //       HourlyForecast(
                  //           time: '14:00',
                  //           icon: Icons.sunny,
                  //           temperature: '106.17'),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hourlyForecast = data['list'][index + 1];
                          final hourlyTemp =
                              hourlyForecast['main']['temp'].toString();
                          final hourlySky =
                              hourlyForecast['weather'][0]['main'].toString();
                          final time = DateTime.parse(hourlyForecast['dt_txt']);

                          return HourlyForecast(
                              time: DateFormat.j().format(time),
                              temperature: hourlyTemp,
                              icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny);
                        }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}

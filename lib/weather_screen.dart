import 'dart:convert';
import 'dart:ui';
import 'dart:developer';
import 'package:flutter/material.dart';
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
  double temp = 0;
  bool isLoading = false;
  @override
  void initState(){
    super.initState();
    getCurrentWeather();
  }
  Future getCurrentWeather() async {
    try{
      setState(() {
        isLoading = true;
      });
      String cityName="London";
    final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);
      if(data['cod']!='200'){
        throw "An error occurred";
      }
      setState(() {
        temp = data['list'][0]['main']['temp'];
        isLoading = false;
      });
    }catch(e){
      e.toString();
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
                onPressed: () {},
                icon: const Icon(
                  Icons.refresh,
                )),
          ],
        ),
        body: isLoading 
        ? const RefreshProgressIndicator() :
        Padding(
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
                              '$temp K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.cloud,
                              size: 64,
                            ),
                            const Text(
                              'Rain',
                              style: TextStyle(
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
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForecast(
                      time:'09:00',
                      icon:Icons.cloud,
                      temperature: '101.17'
                    ),
                    HourlyForecast(
                      time:'10:00',
                      icon:Icons.cloud,
                      temperature: '102.17'
                    ),
                    HourlyForecast(
                      time:'11:00',
                      icon:Icons.cloud,
                      temperature: '103.17'
                    ),
                    HourlyForecast(
                      time:'12:00',
                      icon:Icons.cloud,
                      temperature: '104.17'
                    ),
                    HourlyForecast(
                      time:'13:00',
                      icon:Icons.sunny,
                      temperature: '105.17'
                    ),
                    HourlyForecast(
                      time:'14:00',
                      icon:Icons.sunny,
                      temperature: '106.17'
                    ),
                  ],
                ),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfo(
                    icon: Icons.water_drop,
                    label:'Humidity',
                    value:'94'
                  ),
                  AdditionalInfo(
                    icon: Icons.air,
                    label:'Wind Speed',
                    value:'7.67'
                  ),
                  AdditionalInfo(
                    icon: Icons.beach_access,
                    label:'Pressure',
                    value:'1008'
                  ),
                ],
              )
            ],
          ),
        ));
  }
}



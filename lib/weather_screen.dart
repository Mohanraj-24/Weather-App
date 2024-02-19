import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Weather App',style: TextStyle(
            fontWeight: FontWeight.w200,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.refresh,)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card( 
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('100 ° F',style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.cloud,size: 64,
                        ),
                        Text('Rain',style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height:20),
            const Placeholder(
              fallbackHeight: 150,    
            ),
            const SizedBox(height:20),
            const Placeholder(
              fallbackHeight: 150,    
            ), 
          ],
        ),
      )
    );
  }
}
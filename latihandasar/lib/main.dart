import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Hewan {
  String nama;
  double berat;

  Hewan(this.nama, this.berat);

  void makan() {
    berat += 1;
  }

  void lari() {
    berat -= 0.5;
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Hewan kucing = Hewan("Kucing", 4.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Pertemuan 9 - Hewan"),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${kucing.nama}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Berat: ${kucing.berat.toStringAsFixed(1)} kg",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        kucing.makan();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text("Makan"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        kucing.lari();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text("Lari"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
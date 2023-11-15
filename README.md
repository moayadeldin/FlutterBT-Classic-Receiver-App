# FlutterBT-Classic-Receiver-App

Illustrative example of sending periodic data from HC-05 Bluetooth Classic device to Flutter application integrating Bluetooth Classic devices and modules with Flask API to be deployed in Flutter applications.

## Main Goal

Sending data from HC-05 module with Classic Bluetooth connection to Flutter Application seems to be a challenging task since the only flutter module implementation `flutter_bluetooth_serial` provides no documentation with outdated example in there repo. Moreover, most of examples provided by the community is also outdated. To solve this problem, most developers tend to add a third-party device (usually another Microcontroller) acting as a receiver from Bluetooth module and delivering it to Flutter using a Backend service (e.g: FireBase) which will result in more costs, overwhelming in many cases and requiring an active internet connection.

## Features

This is an up-to-date example of sending periodic data from HC-05 as a Classic Bluetooth Module to Flutter app integrating Bluetooth Classic and Flask API together instead of `flutter_bluetooth_serial` offering the following improvments:

* Ability to send data from HC-05 without having the cost of getting another microcontroller as a third party device.
* Ability to send data from HC-05 to Flutter app without having active internet connection. (Both devices have to be on the same network though)
* Having Flask API connected with the HC-05 is a turnaround to easily integrate classic Bluetooth module devices to iOS applications which doesn't support direct connection in between unlike Android devices.

## Hardware and Microcontroller Installation

This is a circuit overview of how HC-05 module is connected to the laptop using Arduino UNO with voltage divider.

![image](https://github.com/moayadeldin/FlutterBT-Classic-Receiver-App/assets/100358671/e211078d-8d89-4021-9f96-f04f6e72dc7a)

The code uploaded on the Arduino UNO device to send a periodic data is randomly picking up a number from 1 to 100 and send it every 10 seconds which the flutter application is designed to is shown

```cpp
#include "Arduino.h"
#include <SoftwareSerial.h>

const byte rxPin = 9;
const byte txPin = 8;
SoftwareSerial BTSerial(rxPin, txPin); // RX, TX

unsigned long previousMillis = 0; // will store last time a random number was sent
const long interval = 10000;  // interval at which to send a random number (milliseconds)

void setup() {
  // define pin modes for tx, rx:
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  BTSerial.begin(38400);
  Serial.begin(38400);
  randomSeed(analogRead(0));  // initialize random seed
}

void loop() {
  // send a random number every 10 seconds
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    int randomNumber = random(1, 101);  // generate random number between 1 and 100
    BTSerial.print(randomNumber);  // send the random number to the Bluetooth device
    Serial.println(randomNumber);
  }
}
```

## Installation

After configuring the Hardware to run the app, follow these steps:

1. Clone repository
2. Change directory to project's directory
`git clone https://github.com/moayadeldin/FlutterBT-Classic-Receiver-App` then `cd FlutterBT-Classic-Receiver-App`
3. You need to have Flutter installed in your device in order to run the application properly, if not you can follow with their documentation [here](https://docs.flutter.dev/get-started/install)
4. After running the application using `flutter run` open another terminal then change directory to flask-api folder `cd flask-api`.
5. In the new terminal write run the Flask API file using `run app.py`

## Testing

In order for the application to run properly on your Android/iOS device, you should configure the IP address in `main.dart` file to the same IP address of the device's network you are running API on.

The application was tested on Galaxy A7 Tab with One UI Core Version of 5.1 and Android version 13. Moreover, it was also tested using Android Emulator on Windows 10



## Acknowledgments

Circuit design screenshot mentioned above is taken from the following video tutorial on Youtube: [Adding Bluetooth to Your Arduino Project with an HC-05 or HC-06 Bluetooth Module](https://www.youtube.com/watch?v=NXlyo0goBrU&t=382s)



## FoodRescue - Connecting Food Suppliers to Rescuers to Mitigate Food Waste 

An Android app written in Flutter using Firestore and Firebase Authentication. State managed Provider.

## Firestore Database Setup Diagram

## Description


## Screenshots

Welcome Page               |  Supplier Sign Up               | Rescuer Sign Up              
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/welcome_page.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/welcome_page.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/welcome_page.png)|






## Setup
We recommend a shallow clone: `git clone --depth 1 https://github.com/EddieXu123/ILuvFood`

If you would like to use our preexisting Firebase setup, you should be all set to use our `android/app/google-services.json` file. 

We developed in the Visual Studio Code IDE, with the Dart and Flutter extensions. We highly recommend using the Pixel_3a emulator running API_30. The emulator can be set up within Android Studio. Note: iOS emulation is not currently supported due to hardware constraints. 

Run a `flutter pub get` to download the necessary Flutter dependencies. Then click "Run without Debugging" to launch the emulator. **Make sure to run without debugging**, there are [documented problems](https://github.com/FirebaseExtended/flutterfire/issues/3475) of Firebase exceptions not being caught even with try/catches. 




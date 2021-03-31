## FoodRescue - Connecting Food Suppliers to Rescuers to Mitigate Food Waste 

An Android app written in Flutter using Firestore and Firebase Authentication. State managed Provider.

## Firestore Database Setup Diagram

## Description

## Setup
We recommend a shallow clone: `git clone --depth 1 https://github.com/EddieXu123/ILuvFood`

If you would like to use our preexisting Firebase setup, you should be all set to use our `android/app/google-services.json` file. 

We developed in the Visual Studio Code IDE, with the Dart and Flutter extensions. We highly recommend using the Pixel_3a emulator running API_30. The emulator can be set up within Android Studio. Note: iOS emulation is not currently supported due to hardware constraints. 

Run a `flutter pub get` to download the necessary Flutter dependencies. Then click "Run without Debugging" to launch the emulator. **Make sure to run without debugging**, there are [documented problems](https://github.com/FirebaseExtended/flutterfire/issues/3475) of Firebase exceptions not being caught even with try/catches. 

## Email Confirmation
Note that ordering an item will send an email confirmation to the email used to register the rescuer account. 
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/welcome_page.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/email_confirm.jpg)


## Screenshots

Welcome Page               |  Supplier Sign Up               | Rescuer Sign Up              
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/welcome_page.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_signup.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/rescuer_signup.png)|

Map of Suppliers               |  Favorites               | Rescuer Profile              
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/map.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/favorites.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/rescuer_profile.png)|

Supplier Info View               |  Supplier Offerings               | Checkout              
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_view.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_offerings.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/checkout.png)|

Checkout Confirmation               |  Order Status               | Rescuer Order History              
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/confirmation.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/order_status.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/rescuer_order_history.png)|

Rescuer Past Orders               |  Supplier Home               | Supplier Listings View              
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/rescuer_past_order.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_home.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_listings.png)|

Supplier Profile               |  SupplierOrders       
:-------------------------:|:-------------------------:
![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_profile.png)|![](https://github.com/EddieXu123/ILuvFood/blob/readme/screenshots/supplier_orders.png)|



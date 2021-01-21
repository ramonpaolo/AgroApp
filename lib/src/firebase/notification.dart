import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
configNotification() async {
  _firebaseMessaging.autoInitEnabled();
  _firebaseMessaging.getToken().then((token) => print(token));
  _firebaseMessaging.setAutoInitEnabled(true);
}

receiveMessage() async {
  _firebaseMessaging.configure(onResume: (message) async {
    print("Received message: $message");
  }, onLaunch: (message) async {
    print("Launch message: $message");
  });
}

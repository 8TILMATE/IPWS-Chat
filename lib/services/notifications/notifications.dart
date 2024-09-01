import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications{
  final _firebaseMessaging = FirebaseMessaging.instance;
  late String token;
  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission(
      alert: true,
     announcement: false,
     badge: true,
     carPlay: false,
     criticalAlert: false,
     provisional: false,
     sound: true
    );
    final fcmToken= await _firebaseMessaging.getToken();
    token=fcmToken!;
    print("Token: "+fcmToken.toString());
  }
}
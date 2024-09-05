//import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:googleapis_auth/auth_io.dart' as auth;

import 'package:http/http.dart' as http;

class Notifications{
  //final _firebaseMessaging = FirebaseMessaging.instance;
  late String? token;
Future<String> getAccessToken() async {
  // Your client ID and client secret obtained from Google Cloud Console
  final serviceAccountJson = {
   "-"
};

 List<String> scopes = [
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/firebase.database",
 "https://www.googleapis.com/auth/firebase.messaging"
];
 
 http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );

  // Obtain the access token
  auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
    client
  );

  // Close the HTTP client
  client.close();

  // Return the access token
  return credentials.accessToken.data;

}
  Future<void> initNotifications() async
  {
  final String serverKey = await getAccessToken() ; // Your FCM server key
  final  currentFCMToken = await FirebaseMessaging.instance.getToken();
  token=currentFCMToken;
  }
  Future<void> sendNotifications(String message,String username,String tokenas) async{
  final String serverKey = await getAccessToken() ; // Your FCM server key
  final  currentFCMToken = await FirebaseMessaging.instance.getToken();
  token=currentFCMToken;
      print("fcmkey : $currentFCMToken");
    final body = {
          "message": 
    {
      "token": tokenas,
      "notification": 
      {
        "title": username,
        "body": message,  
      }
    }
  };
    
    var url = Uri.parse("https://fcm.googleapis.com/v1/projects/ipws-chatting/messages:send");
    var response = await http.post(url,headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $serverKey"
    }, body:jsonEncode(body));
    print('Response status: ${response.statusCode}'); 
    print('Response body: ${response.body}');
  }
  
}
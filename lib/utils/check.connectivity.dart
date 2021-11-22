import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> connectivity() async{
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
      return true;
  }
  return false;
}


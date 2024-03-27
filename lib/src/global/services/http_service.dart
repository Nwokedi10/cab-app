import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:udrive/src/features/registration/views/add_phone_screen.dart';
import 'package:udrive/src/features/registration/views/verify_code_screen.dart';
import 'package:udrive/src/global/controller/location_controller.dart';
import 'package:udrive/src/global/model/custom_bool.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/model/query_place.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/model/delivery.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';

import '../../src_barrel.dart';
import '../model/trip.dart';

class HttpService with DioErrorHandler {
  static final _dio = Dio()
    ..interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        Failure failure;
        switch (e.type) {
          case DioErrorType.connectTimeout:
            failure = Failure(message: ErrorStrings.connectionTimeout);
            break;
          case DioErrorType.cancel:
            failure = Failure(message: ErrorStrings.requestCanceled);
            break;
          case DioErrorType.sendTimeout:
            failure = Failure(message: ErrorStrings.sendTimeout);
            break;
          case DioErrorType.receiveTimeout:
            failure = Failure(message: ErrorStrings.receiveTimeout);
            break;
          case DioErrorType.response:
            {
              print(e.response);
              final String message = handleError(e.response?.data["errors"]);
              failure = Failure(message: message);
              break;
            }
          case DioErrorType.other:
            failure = Failure(message: ErrorStrings.unknown);
            break;
        }
        Ui.showSnackBar(failure.message!);
        e.response == null ? handler.reject(e) : handler.resolve(e.response!);
      },
    ));
  // static const String apikey = "AIzaSyDWkS9V0btAWQ0MHYpOgMwuOcfofkqE53o";
  static const String fwpubk =
      "FLWPUBK_TEST-64953d45682fc3531464b30e961ba11f-X";
  static const String apikey = "AIzaSyB7pu47JYQyH6cZft-2RTFbhLTmvfxAMcs";

  static const baseURL = "http://muanya.pythonanywhere.com/api/user/";
  static const homeURL = "http://muanya.pythonanywhere.com/api/";
  static const rideURL = "http://muanya.pythonanywhere.com/ride/";
  static const accountsURL = "http://muanya.pythonanywhere.com/accounts/";
  static const walletURL = "${accountsURL}wallet/";

  static Options walletOptions = Options(headers: {
    "Content-Type": "application/json",
    "api-key": "LuPKzAhiFnUlaYz6nLzkmodYM0NUjPfZ",
  });
  static final successCodes = [
    200,
    201,
    202,
    203,
    204,
    205,
    206,
    207,
    208,
    226
  ];

  static Options get authOptions => Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${MyPrefs.getJWT()}",
      });

  static Future<List<QueryPlace>> searchAllPlaces(String query) async {
    final uri =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apikey&radius=500&components=country:ng";
    final res = await _dio.get(uri);

    if (isSuccess(res.statusCode)) {
      final c = res.data;
      List<QueryPlace> g = [];
      for (Map<String, dynamic> item in c["predictions"]) {
        QueryPlace ref = QueryPlace.fromJSON(item);
        g.add(ref);
      }
      print(g);
      return g;
    }
    return [];
  }

  static Future<LatLng?> getPlaceLocation(String id) async {
    final uri =
        "https://maps.googleapis.com/maps/api/geocode/json?place_id=$id&key=$apikey";
    final res = await _dio.get(uri);

    if (isSuccess(res.statusCode)) {
      final c = res.data["results"] as List;
      if (c.isNotEmpty) {
        double lat = c[0]["geometry"]["location"]["lat"];
        double lng = c[0]["geometry"]["location"]["lng"];
        return LatLng(lat, lng);
      }
      return null;
    }
    return null;
  }

  static Future<Loc?> getMyLocation(LatLng llng) async {
    final uri =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${llng.latitude},${llng.longitude}&key=$apikey";
    final res = await _dio.get(uri);

    if (isSuccess(res.statusCode)) {
      final c = res.data["results"] as List;
      if (c.isNotEmpty) {
        String fad = c[0]["formatted_address"];
        TextEditingController tec = TextEditingController(text: fad);
        return Loc(name: tec, llng: llng);
      }
      return null;
    }
    return null;
  }

  static Future<Directions> getDirections(LatLng src, LatLng dst,
      {List<LatLng>? stoplocs}) async {
    String wp = "";
    if (stoplocs?.isNotEmpty ?? false) {
      wp += "&waypoints=";
      for (var ele in stoplocs!) {
        wp += "|${ele.latitude},${ele.longitude}";
      }
    }
    final uri =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${src.latitude},${src.longitude}&destination=${dst.latitude},${dst.longitude}&key=$apikey$wp";
    final res = await _dio.get(uri);

    if (isSuccess(res.statusCode)) {
      return Directions.fromMap(res.data);
    }
    return Directions();
  }

  static Future<bool> signUp(
      String fullname, String email, String password) async {
    const uri = "${baseURL}register/";

    final res = await _dio.post(uri, data: {
      "email": email,
      "first_name": fullname.split(" ")[0],
      "last_name": fullname.split(" ")[1],
      "password": password
    });

    if (isSuccess(res.statusCode)) {
      final c = res.data;
      User user = User(
        id: c["user"]["pk"],
        email: c["user"]["email"],
        firstName: c["user"]["first_name"],
        lastName: c["user"]["last_name"],
      );
      await MyPrefs.saveJWT(c["access_token"], id: user.id);

      return true;
    }

    return false;
  }

  static Future<void> setPusherId() async {
    String jwt = MyPrefs.getJWT();

    final BeamsAuthProvider beamsProvider = BeamsAuthProvider()
      ..authUrl = 'http://muanya.pythonanywhere.com/ride/device/secure-oauth/'
      ..headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $jwt"
      }
      ..queryParams = {'page': '1'}
      ..credentials = 'omit';
    try {
      print(MyPrefs.localUser().id);
      await PusherBeams.instance.setUserId(
          MyPrefs.localUser().id,
          beamsProvider,
          (error) => {
                if (error != null) {print(error)}

                // Success! Do something...
              });
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == "PusherAlreadyRegisteredAnotherUserIdException") {
          Ui.showSnackBar("${e.message!}\nYou might not use notification");
        } else {
          Ui.showSnackBar(e.message ?? ErrorStrings.unknown);
        }
      } else {
        Ui.showSnackBar(e.toString());
      }
    }
  }

  static Future<bool> addPhone(String rphone) async {
    const uri = "${baseURL}add_phone/";
    String phone = UtilFunctions.formatPhone(rphone);

    final res =
        await _dio.post(uri, data: {"phone": phone}, options: authOptions);

    if (isSuccess(res.statusCode)) {
      MyPrefs.savePhone(phone);
      return true;
    }
    return false;
  }

  static Future<bool> signGoogle(GoogleSignInAccount credential) async {
    String uri = "${homeURL}google/auth/";
    final auth = await credential.authentication;

    final msg = {"id_token": auth.idToken};
    final res = await _dio.post(uri, data: msg);

    if (isSuccess(res.statusCode)) {
      final c = res.data;
      print(c);
      User user = User(
        id: c["user"]["pk"],
        email: c["user"]["email"],
        image: credential.photoUrl ?? "",
        firstName: c["user"]["first_name"],
        lastName: c["user"]["last_name"],
      );

      await MyPrefs.saveJWT(c["access_token"]);
      await MyPrefs.writeData(MyPrefs.mpLoggedInURLPhoto, user.image);
      final isV = await checkPhone();
      if (isV.isTrue) {
        final cd = await getUserDetails(c["access_token"]);
        if (cd != null) {
          cd.id = user.id;
          cd.image = user.image;
          await MyPrefs.login(c["access_token"], cd, is3rdParty: true);
          await MyPrefs.loginRaw();
        } else {
          final c = await HttpService.completeSignUp();
          return c;
        }
      } else {
        // if (isV.a) {
        //   Get.to(VerifyCodeScreen());
        // } else {
        Get.to(AddPhoneScreen());
        // }
        return false;
      }

      return true;
    }
    GoogleSignIn().disconnect();
    return false;
  }

  static Future<bool> signApple(
      AuthorizationCredentialAppleID credential) async {
    String uri = "${homeURL}apple/auth/";

    final msg = {
      // "id_token": Uri.decodeFull(credential.identityToken!),
      // "code": Uri.decodeFull(credential.authorizationCode),
      "id_token": credential.identityToken!,
      "code": credential.authorizationCode,
      "user": "null",
      "state": ""
    };
    final res = await _dio.post(uri, data: msg);

    if (isSuccess(res.statusCode)) {
      final c = res.data;
      print(c);
      User user = User(
        id: c["user"]["pk"],
        email: c["user"]["email"],
        firstName: c["user"]["first_name"],
        lastName: c["user"]["last_name"],
      );

      await MyPrefs.saveJWT(c["access_token"]);
      final isV = await checkPhone();
      if (isV.isTrue) {
        final cd = await getUserDetails(c["access_token"]);
        if (cd != null) {
          cd.id = user.id;
          await MyPrefs.login(c["access_token"], cd, is3rdParty: true);
          await MyPrefs.loginRaw();
        } else {
          final c = await HttpService.completeSignUp();
          return c;
        }
      } else {
        // if (isV.a) {
        //   Get.to(VerifyCodeScreen());
        // } else {
        Get.to(AddPhoneScreen());
        // }
        return false;
      }

      return true;
    }
    return false;
  }

  static Future<bool> forgotPassword(String email) async {
    const uri = "${homeURL}forgot-password/";

    final res = await _dio.post(uri, data: {"email": email});
    return isSuccess(res.statusCode);
  }

  static Future<String> getPasswordToken(String code, String email) async {
    const uri = "${homeURL}password-reset-token/";

    final res = await _dio.post(uri, data: {"code": code, "email": email});
    if (isSuccess(res.statusCode)) {
      final c = res.data["data"]["token"] ?? "";

      return c;
    }

    return "";
  }

  static Future<bool> changePassword(String token, String password) async {
    const uri = "${homeURL}reset-password/";

    final res =
        await _dio.post(uri, data: {"token": token, "password": password});
    return isSuccess(res.statusCode);
  }

  static Future<TwinBool> checkPhone() async {
    const uri = "${baseURL}check_phone/";

    final res = await _dio.post(uri, options: authOptions);
    if (isSuccess(res.statusCode)) {
      final c = !UtilFunctions.nullOrEmpty(res.data["data"]["phone"]);
      if (c) {
        await MyPrefs.savePhone(res.data["data"]["phone"]);
      }
      final d = res.data["data"]["verified"] ?? false;

      return TwinBool(a: c, b: d);
    }

    return const TwinBool();
  }

  static Future<bool> verifyPhone(String code) async {
    final uri = "${homeURL}verify_phone/$code/";

    final res = await _dio.get(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"]["verified"];
      if (!c) {
        Ui.showSnackBar("Invalid OTP");
        return false;
      }
      return true;
    }

    return false;
  }

  static Future<bool> login(String email, String password) async {
    const uri = "${homeURL}login/";

    final res =
        await _dio.post(uri, data: {"email": email, "password": password});

    if (isSuccess(res.statusCode)) {
      final c = res.data;
      User user = User(
        id: c["user"]["pk"],
        email: c["user"]["email"],
        firstName: c["user"]["first_name"],
        lastName: c["user"]["last_name"],
      );

      await MyPrefs.saveJWT(c["access_token"]);

      final isV = await checkPhone();
      if (isV.isTrue) {
        final cd = await getUserDetails(c["access_token"]);
        if (cd != null) {
          cd.id = user.id;
          await MyPrefs.login(c["access_token"], cd, is3rdParty: false);

          await MyPrefs.loginRaw();
        } else {
          final c = await completeSignUp();
          return c;
        }
      } else {
        // if (isV.a) {
        //   Get.to(VerifyCodeScreen());
        // } else {
        Get.to(AddPhoneScreen());
        // }
        return false;
      }
      return true;
    }

    return false;
  }

  static Future<bool> completeSignUp() async {
    const uri = "${homeURL}customer/register/";
    String img = MyPrefs.localUser().image;

    final res = await _dio.post(uri,
        data: {"profile_pic": img, "rating": 4.0, "status": true},
        options: authOptions);

    if (isSuccess(res.statusCode)) {
      final d = await MyPrefs.getUpdatedUser();
      return d;
    }

    return false;
  }

  static Future<bool> logout() async {
    const uri = "${homeURL}logout/";

    final res = await _dio.post(uri, options: authOptions);
    await MyPrefs.logout();

    return isSuccess(res.statusCode);
  }

  static Future<bool> uploadImage(String f) async {
    const uri = "${homeURL}uploads/";
    File file = File(f);
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final res = await _dio.post(uri, data: formData, options: authOptions);

    if (isSuccess(res.statusCode)) {
      await MyPrefs.getUpdatedUser();
      return true;
    }
    return false;
  }

  static Future<User?> getUserDetails(String jwt) async {
    const uri = "${homeURL}get_details/";
    print(jwt);
    final res = await _dio.get(uri,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwt",
        }));

    if (isSuccess(res.statusCode)) {
      final c = res.data;
      print(c);
      User user = User(
        email: c["data"]["email"],
        image: c["data"]["profile_pic"] ?? Assets.defUser,
        phone: c["data"]["phone"] ?? "",
        firstName: c["data"]["first_name"],
        lastName: c["data"]["last_name"],
      );
      if (c["data"]["wallet"] == null) {
        await MyPrefs.writeData(MyPrefs.walletVerif, 0);
      } else {
        await MyPrefs.writeData(MyPrefs.walletVerif, 3);
      }

      return user;
    }
    return null;
  }

  //RIDE SERVICES
  static Future<String> requestRide(Loc start, Loc end, Directions dirt) async {
    const uri = "${rideURL}request-ride/";

    final res = await _dio.post(uri,
        data: {
          "start_longitude": start.llng!.longitude,
          "start_latitude": start.llng!.latitude,
          "stop_longitude": end.llng!.longitude,
          "stop_latitude": end.llng!.latitude,
          "start_location_name": start.name!.value.text,
          "stop_location_name": end.name!.value.text,
          "distance": dirt.totalDistance, // in metres
          "expected_duration": dirt.totalDuration, //  in seconds
          "by_wallet": MyPrefs.readData(MyPrefs.mpUdrivePaym) == "Udrive Wallet"
        },
        options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"]["job"];
      return c;
    }

    return "";
  }

  static Future<bool> cancelRide(String id, String reason) async {
    final uri = "${rideURL}cancel-job/$id/";
    final controller = Get.find<LocationController>();

    final res = await _dio.post(uri,
        data: {
          "longitude": controller.currentLocation.value.longitude,
          "latitude": controller.currentLocation.value.latitude,
          "heading": 0,
          "reason": reason
        },
        options: authOptions);

    return (isSuccess(res.statusCode));
  }

  static Future<double> getCost(int duration, int distance) async {
    print(duration);
    print(distance);
    const uri = "${rideURL}get-cost/";

    final res = await _dio.post(uri,
        data: {"distance": distance, "expected_duration": duration},
        options: authOptions);

    if (isSuccess(res.statusCode)) {
      return res.data["data"]["cost"];
    }
    return 0;
  }

  static Future<Driver?> getDriverDetail(String jobId) async {
    final uri = "${rideURL}get-driver/ride/$jobId/";

    final res = await _dio.post(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"];
      return Driver(
        firstName: c["first_name"],
        lastName: c["last_name"],
        image: c["profile_pic"],
        phone: c["phone"],
        rating: c["rating"],
        car: Car(
            image: c["car_front_pic"],
            name: c["car_brand"] + " " + c["car_number"] + " " + c["car_year"],
            plateNo: c["license_number"]),
        locationData: null,
      );
    }

    return null;
  }

  static Future<Loc?> getDriverLocation(String jobId) async {
    final uri = "${rideURL}get-driver-loc/$jobId/";

    final res = await _dio.post(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"];
      return Loc(
          llng: LatLng(c["latitude"], c["longitude"]), heading: c["heading"]);
    }

    return null;
  }

  static Future<List<Trip>> getRideHistory() async {
    const uri = "${rideURL}rider-ride-history/ride/";

    final res = await _dio.post(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"] as List<dynamic>;
      List<Trip> fg = [];
      for (var i = 0; i < c.length; i++) {
        final f = c[i];
        if (f["driver_data"] == null ||
            f["end_time"] == null ||
            f["start_time"] == null) {
          continue;
        }

        fg.add(Trip.fromJSON(f));
      }
      return fg;
    }
    return [];
  }

  //ERRAND SERVICES
  static Future<String> requestErrand(
      Loc start, Loc end, Directions dirt) async {
    const uri = "${rideURL}request-errand/";

    final res = await _dio.post(uri,
        data: {
          "start_longitude": start.llng!.longitude,
          "start_latitude": start.llng!.latitude,
          "stop_longitude": end.llng!.longitude,
          "stop_latitude": end.llng!.latitude,
          "start_location_name": start.name!.value.text,
          "stop_location_name": end.name!.value.text,
          "distance": dirt.totalDistance, // in metres
          "expected_duration": dirt.totalDuration, //  in seconds
          "by_wallet": MyPrefs.readData(MyPrefs.mpUdrivePaym) == "Udrive Wallet"
        },
        options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"]["job"];
      return c;
    }

    return "";
  }

  static Future<bool> cancelErrand(String id, String reason) async {
    final uri = "${rideURL}cancel-errand/$id/";
    final controller = Get.find<LocationController>();

    final res = await _dio.post(uri,
        data: {
          "longitude": controller.currentLocation.value.longitude,
          "latitude": controller.currentLocation.value.latitude,
          "heading": 0,
          "reason": reason
        },
        options: authOptions);

    return (isSuccess(res.statusCode));
  }

  static Future<List<Delivery>> getErrandHistory() async {
    const uri = "${rideURL}rider-ride-history/errand/";

    final res = await _dio.post(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"] as List<dynamic>;
      // print(c);
      List<Delivery> fg = [];
      for (var i = 0; i < c.length; i++) {
        final f = c[i];
        if (f["driver_data"] == null ||
            f["end_time"] == null ||
            f["start_time"] == null) {
          continue;
        }

        fg.add(Delivery.fromJSON(f));
      }
      return fg;
    }
    return [];
  }

  //DELIVERY
  static Future<String> requestDelivery(Loc start, Loc end, Directions dirt,
      String recpname, String recpphone, String item) async {
    const uri = "${rideURL}request-delivery/";

    final res = await _dio.post(uri,
        data: {
          "start_longitude": start.llng!.longitude,
          "start_latitude": start.llng!.latitude,
          "stop_longitude": end.llng!.longitude,
          "stop_latitude": end.llng!.latitude,
          "start_location_name": start.name!.value.text,
          "stop_location_name": end.name!.value.text,
          "distance": dirt.totalDistance, // in metres
          "expected_duration": dirt.totalDuration, //  in seconds
          "by_wallet":
              MyPrefs.readData(MyPrefs.mpUdrivePaym) == "Udrive Wallet",
          "recipient_name": recpname,
          "recipient_phone": recpphone,
          "item_name": item
        },
        options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"]["job"];
      return c;
    }

    return "";
  }

  static Future<bool> cancelDelivery(String id, String reason) async {
    final uri = "${rideURL}cancel-delivery/$id/";
    final controller = Get.find<LocationController>();

    final res = await _dio.post(uri,
        data: {
          "longitude": controller.currentLocation.value.longitude,
          "latitude": controller.currentLocation.value.latitude,
          "heading": 0,
          "reason": reason
        },
        options: authOptions);

    return (isSuccess(res.statusCode));
  }

  static Future<List<Delivery>> getDeliveryHistory() async {
    const uri = "${rideURL}rider-ride-history/delivery/";

    final res = await _dio.post(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"] as List<dynamic>;
      // print(c);
      List<Delivery> fg = [];
      for (var i = 0; i < c.length; i++) {
        final f = c[i];
        if (f["driver_data"] == null ||
            f["end_time"] == null ||
            f["start_time"] == null) {
          continue;
        }

        fg.add(Delivery.fromJSON(f));
      }
      return fg;
    }
    return [];
  }

  static Future<Driver?> getDeliveryDriverDetail(
      String jobId, DeliveryMode dm) async {
    final uri = "${rideURL}get-driver/${dm.name.toLowerCase()}/$jobId/";
    print(uri);

    final res = await _dio.post(uri, options: authOptions);

    if (isSuccess(res.statusCode)) {
      final c = res.data["data"];
      return Driver(
        firstName: c["first_name"],
        lastName: c["last_name"],
        image: c["profile_pic"],
        phone: c["phone"],
        rating: c["rating"],
        locationData: null,
      );
    }

    return null;
  }

  //WALLET SERVICES
  static Future<bool> createWallet() async {
    const uri = "${walletURL}create/";

    final res = await _dio.post(uri, options: authOptions);
    return isSuccess(res.statusCode);
  }

  static Future<bool> makePayment(BuildContext context, int cost) async {
    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: fwpubk,
        currency: "NGN",
        redirectUrl: "https://udriverides.com",
        txRef:
            "tx-udrive-ride-${MyPrefs.localUser().id}-${DateTime.now().millisecondsSinceEpoch}",
        amount: cost.toString(),
        customer: Customer(
            email: MyPrefs.localUser().email,
            name: MyPrefs.localUser().fullName,
            phoneNumber: MyPrefs.localUser().phone),
        paymentOptions: "ussd, card, barter, payattitude",
        meta: {"user_id": MyPrefs.localUser().id},
        customization: Customization(title: "Udrive Trip Payment"),
        isTestMode: true);

    final c = await flutterwave.charge();
    final d = await verifyTransaction(c.transactionId ?? "");
    if ((c.success ?? false) && d) {
      return true;
    } else {
      return d;
    }
  }

  static Future<bool> verifyTransaction(String id) async {
    const uri = "${accountsURL}transaction/verify/";

    final res = await _dio.post(uri,
        data: {"transaction_id": id}, options: authOptions);
    return isSuccess(res.statusCode);
  }

  static Future<num> getWalletBalance() async {
    const uri = "${walletURL}balance/";

    final res = await _dio.get(uri, options: authOptions);
    if (isSuccess(res.statusCode)) {
      return res.data["data"]["balance"];
    }
    return 0;
  }

  static String handleError(dynamic msg) {
    // String errMsg = "";
    // msg.forEach((key, value) {
    //   errMsg += "$key, ${value.join("\n")}";
    // });
    if (msg is List) {
      if (msg.length == 1) {
        return msg[0];
      }
      return msg.join("\n");
    }
    return msg.toString();
  }

  static bool isSuccess(int? a) {
    return successCodes.contains(a);
  }
}

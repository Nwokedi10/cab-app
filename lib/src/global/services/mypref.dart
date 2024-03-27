import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:udrive/src/features/home/controllers/booking_controller.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/controllers/message_controller.dart';
import 'package:udrive/src/features/home/controllers/password_controller.dart';
import 'package:udrive/src/features/home/controllers/payment_controller.dart';
import 'package:udrive/src/features/home/controllers/settings_controller.dart';
import 'package:udrive/src/features/home/controllers/wallet_controller.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/registration/controllers/registration_controller.dart';
import 'package:udrive/src/global/controller/location_controller.dart';
import 'package:udrive/src/features/home/models/card.dart' as cd;
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/plugin/jwt.dart';
import 'package:udrive/src/src_barrel.dart';

class MyPrefs {
  static const String mpLoggedInEmail = "mpLoggedInEmail";
  static const String mpLoggedInURLPhoto = "mpLoggedInURLPhoto";
  static const String mpLoggedInPhone = "mpLoggedInPhone";
  static const String mpIsLoggedIn = "mpIsLoggedIn";
  static const String mpUserID = "mpUserID";
  static const String mpUserJWT = "mpUserJWT";
  static const String mpLoginExpiry = "mpLoginExpiry";
  static const String mpLatLng = "mpLatLng";
  static const String hasOpenedOnboarding = "hasOpenedOnboarding";
  static const String mpUserRole = "mpUserRole";
  static const String mpFirstName = "mpFirstName";
  static const String mpLastName = "mpLastName";
  static const String mpLogin3rdParty = "mpLogin3rdParty";

  //car details
  static const String mpCarPlateNo = "mpCarPlateNo";
  static const String mpCarBrand = "mpCarBrand";
  static const String mpCarYear = "mpCarYear";
  static const String mpCarFrontImage = "mpCarFrontImage";
  static const String mpCarBackImage = "mpCarBackImage";
  static const String mpCarColor = "mpCarColor";
  static const String mpDriverLicense = "mpDriverLicense";
  static const String mpExpiryDate = "mpExpiryDate";
  static const String mpDriverLicenseImage = "mpDriverLicenseImage";

  //acc details
  static const String mpBankAcctName = "mpBankAcctName";
  static const String mpBankName = "mpBankName";
  static const String mpBankAcctNo = "mpBankAcctNo";

  //ride details
  static const String mpHomeLocationLLNG = "mpHomeLocationLLNG";
  static const String mpHomeLocationName = "mpHomeLocationName";

  //acc details
  static const String mpUdriveAcctBank = "mpUdriveAcctBank";
  static const String mpUdriveAcctNo = "mpUdriveAcctNo";
  static const String mpUdriveAcctName = "mpUdriveAcctName";
  static const String mpUdriveWalletId = "mpUdriveWalletId";

  //card details
  static const String mpUdriveCardName = "mpUdriveCardName";
  static const String mpUdriveCardNo = "mpUdriveCardNo";
  static const String mpUdriveCardCVV = "mpUdriveCardCVV";
  static const String mpUdriveCardED = "mpUdriveCardED";

  //payment method
  static const String mpUdrivePaym = "mpUdrivePaym";
  static const String walletVerif = "UGWALLETVERIFCODE";

  static final homeController = Get.find<HomeController>();
  static final settingsController = Get.find<SettingsController>();

  static final _prefs = GetStorage();

  static Future<void> writeData(String key, dynamic value) async {
    await _prefs.write(key, value);
  }

  static dynamic readData(String key) {
    return _prefs.read(key);
  }

  // static void listenToStorageChanges(String k, void Function(dynamic) v) {
  //   _prefs.listenKey(k, (j) {
  //     final jwt = readData(mpUserJWT);
  //     final id = readData(mpUserID);
  //     if (jwt == "" || id == "") return;
  //     v(j);
  //   });
  // }

  static String getJWT() {
    return (readData(mpUserJWT) ?? "").toString();
  }

  static Future<bool> login(String jwt, User user,
      {bool is3rdParty = false}) async {
    await rawLogin(user);
    await saveJWT(jwt);
    await _prefs.write(mpLogin3rdParty, is3rdParty);
    await HttpService.setPusherId();

    // await HttpService.toggleDeviceToken();
    return true;
  }

  static Future<void> saveJWT(String jwt, {String? id}) async {
    final msg = Jwt.parseJwt(jwt);
    await _prefs.write(mpLoginExpiry, msg["exp"]);
    await _prefs.write(mpUserJWT, jwt);
    if (id != null) {
      await _prefs.write(mpUserID, id);
    }
  }

  static Future<void> loginRaw() async {
    await _prefs.write(mpIsLoggedIn, true);
  }

  static bool hasOpened() {
    bool a = _prefs.read(hasOpenedOnboarding) ?? false;
    if (a == false) {
      _prefs.write(hasOpenedOnboarding, true);
    }
    return a;
  }

  static Future<bool> isLoggedIn() async {
    final e = _prefs.read(mpLoginExpiry) ?? 0;
    if (DateTime.now().millisecondsSinceEpoch > e * 1000) {
      // await logout();
      return false;
    }
    return _prefs.read(mpIsLoggedIn) ?? false;
  }

  static bool isRawLoggedIn() {
    return _prefs.read(mpIsLoggedIn) ?? false;
  }

  static Future<void> saveLoc(LatLng llng) async {
    // if(llng is LatLng || llng is LatLng)
    await _prefs.write(mpLatLng, [llng.latitude, llng.longitude]);
  }

  static List<dynamic> getLoc() {
    List<dynamic> llng = _prefs.read(mpLatLng) ?? [];
    return llng;
  }

  static Future<void> saveHomeLoc(Loc loc) async {
    // if(llng is LatLng || llng is LatLng)
    await _prefs
        .write(mpHomeLocationLLNG, [loc.llng!.latitude, loc.llng!.longitude]);
    await _prefs.write(mpHomeLocationName, loc.name!.value.text);
  }

  static Loc getHomeLoc() {
    List<dynamic> llng = _prefs.read(mpHomeLocationLLNG) ?? [];
    if (llng.isNotEmpty) {
      TextEditingController tec =
          TextEditingController(text: _prefs.read(mpHomeLocationName));
      return Loc(name: tec, llng: LatLng(llng[0], llng[1]));
    }
    return Loc();
  }

  static User localUser() {
    return User(
      firstName: _prefs.read(mpFirstName) ?? "",
      lastName: _prefs.read(mpLastName) ?? "",
      id: _prefs.read(mpUserID) ?? "",
      email: _prefs.read(mpLoggedInEmail) ?? "",
      phone: _prefs.read(mpLoggedInPhone) ?? "",
      image: _getUserImage(),
    );
  }

  static String _getUserImage() {
    final c = _prefs.read(mpLoggedInURLPhoto);
    return UtilFunctions.nullOrEmpty(c) ? Assets.defUser : c;
  }

  static rawLogin(User user) async {
    await _prefs.write(mpFirstName, user.firstName);
    await _prefs.write(mpLastName, user.lastName);
    await _prefs.write(mpLoggedInURLPhoto,
        UtilFunctions.returnNullEmpty(user.image, Assets.defUser));
    await _prefs.write(mpUserID, user.id);
    await _prefs.write(mpLoggedInEmail, user.email);
    await _prefs.write(mpLoggedInPhone, user.phone);
    homeController.currentUser.value = user;
    settingsController.userImage.value = user.image;
  }

  static savePhone(String phone) async {
    await _prefs.write(mpLoggedInPhone, phone);
    homeController.currentUser.value.phone = phone;
  }

  static saveEmail(String email) async {
    await _prefs.write(mpLoggedInEmail, email);
  }

  static Future<bool> updateUser(User user) async {
    await _prefs.write(mpFirstName, user.firstName);
    await _prefs.write(mpLastName, user.lastName);
    await _prefs.write(mpLoggedInURLPhoto, user.image);
    await _prefs.write(mpLoggedInPhone, user.phone);
    homeController.currentUser.value = user;
    // if (user.devToken == "") {
    //   await HttpService.toggleDeviceToken();
    // }
    return true;
  }

  static Future<bool> getUpdatedUser() async {
    final oldUser = localUser();
    final c = await HttpService.getUserDetails(getJWT());
    if (c != null) {
      c.id = oldUser.id;
      await HttpService.setPusherId();
      await rawLogin(c);
      await loginRaw();
      return true;
    }
    return false;
  }

  static listenToPrefChanges(String key, ValueSetter callback) {
    _prefs.listenKey(key, (value) {
      callback(value);
    });
  }

  static Future<void> logout() async {
    final b = _prefs.read(mpLogin3rdParty) ?? false;
    if (b) {
      final c = await GoogleSignIn().isSignedIn();
      if (c) {
        await GoogleSignIn().disconnect();
      }
    }
    await PusherBeams.instance.clearDeviceInterests();
    await PusherBeams.instance.clearAllState();
    await eraseAllExcept(MyPrefs.hasOpenedOnboarding);
  }

  static injectDependencies() async {
    Get.put(BookingController());
    Get.put(RegistrationController());
    Get.put(PaymentController());
    Get.put(HomeController());
    Get.put(RideController());
    Get.put(DeliveryController());
    Get.put(MessageController());
    Get.put(PasswordController());
    Get.put(SettingsController());
    Get.put(WalletController());
  }

  static eraseAllExcept(String key) async {
    final allKeys = List.from(_prefs.getKeys());
    for (var element in allKeys) {
      if (element == key) continue;
      await _prefs.remove(element);
    }
  }

  static Future<bool> googleLogin() async {
    // GoogleSignIn().disconnect();
    GoogleSignInAccount? user;
    try {
      user = await GoogleSignIn(
        clientId: GetPlatform.isAndroid
            ? null
            : "694883210979-7gn41vja544b62bg2hjed9r81c922n5m.apps.googleusercontent.com",

        // scopes: [
        //   'email',
        //   'https://www.googleapis.com/auth/contacts.readonly',
        // ],
      ).signIn();
    } catch (e) {
      print(e);
      Ui.showSnackBar(e.toString(), title: "Error");

      return false;
    }

    if (user != null) {
      final b = await HttpService.signGoogle(user);
      return b;
    }
    return false;
  }

  static Future<bool> appleLogin() async {
    AuthorizationCredentialAppleID credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        state: "${HttpService.homeURL}/api/auth/callbacks/signin-with-apple/",
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: "com.udrivelogistics.app",
            redirectUri: Uri.parse(
                "${HttpService.homeURL}/api/auth/callbacks/signin-with-apple/")),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } catch (e) {
      print(e);
      Ui.showSnackBar(e.toString());
      return false;
    }
    print(credential.identityToken);

    if (credential.identityToken != null) {
      // if (GetPlatform.isAndroid) {
      final b = await HttpService.signApple(credential);
      return b;
      // } else {
      //   final b = await HttpService.signAppleForApple(credential);
      //   return b;
      // }
    }
    return false;
  }

  static Future<void> createWallet(
      String acctNo, String acctName, String acctBank, String walletID) async {
    await _prefs.write(mpUdriveAcctNo, acctNo);
    await _prefs.write(mpUdriveAcctName, acctName);
    await _prefs.write(mpUdriveAcctBank, acctBank);
    await _prefs.write(mpUdriveWalletId, walletID);
  }

  static Future<void> saveCard(cd.Card card) async {
    await _prefs.write(mpUdriveCardName, card.cardName);
    await _prefs.write(mpUdriveCardNo, card.cardNo);
    await _prefs.write(mpUdriveCardCVV, card.cardCVV);
    await _prefs.write(mpUdriveCardED, card.cardExpiryDate);
  }

  static cd.Card? getCardDetails() {
    if (_prefs.read(mpUdriveCardCVV) == null) return null;
    return cd.Card(
        cardCVV: _prefs.read(mpUdriveCardCVV),
        cardNo: _prefs.read(mpUdriveCardNo),
        cardName: _prefs.read(mpUdriveCardName),
        cardExpiryDate: _prefs.read(mpUdriveCardED));
  }

  static Future<void> savePaymentMethod(String paym) async {
    await _prefs.write(mpUdrivePaym, paym);
  }
}

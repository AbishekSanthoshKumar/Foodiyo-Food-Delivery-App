// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/models/sellers.dart';
import 'package:foodiyo/restaurant/rest_home_screen.dart';
import 'package:foodiyo/widgets/error_dialog.dart';
import 'package:foodiyo/widgets/loading_dialog.dart';
import 'package:foodiyo/widgets/snackbar.dart';
import 'package:foodiyo/widgets/text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestLogin extends StatelessWidget {
  RestLogin({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  loginValidation(BuildContext context) {
    final email = emailController.text;
    final pwd = pwdController.text;
    if (email.isEmpty || pwd.isEmpty) {
      callCustomSnackbar(context, 'Please Enter all values');
    } else {
      login(context);
    }
  }

  login(BuildContext context) async {
    showDialog(context: context, builder: (context) => const MyLoadingDialog());
    User? currentUser;
    await firebaseAuths
        .signInWithEmailAndPassword(
            email: emailController.text, password: pwdController.text)
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => MyErrorDialog(msg: error.message.toString()));
    });

    if (currentUser != null) {
      readDataAndSaveDataLocally(currentUser!).then((val) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(
          builder: (context) => RestHomeScreen(currentUser: currentUser!),
        );
        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
      });
    }
  }

  readDataAndSaveDataLocally(User user) async {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(user.uid)
        .get()
        .then((snapshot) async {
      await sharedPreferences!.setString('uid', user.uid);
      await sharedPreferences!.setString('type', 'Restaurant');
      await sharedPreferences!.setString('email', snapshot.data()!["email"]);
      await sharedPreferences!
          .setString('location', snapshot.data()!['location']);
      await sharedPreferences!.setString('name', snapshot.data()!['name']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Restaurant Login'),
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/detailbgs.jpg'),
                  fit: BoxFit.fitHeight)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset('images/Foodiyo.png'),
              ),
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                isObscure: false,
                txt: emailController,
                hintText: 'Email',
                iconData: Icons.email_outlined,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                textInputType: TextInputType.visiblePassword,
                isObscure: true,
                txt: pwdController,
                hintText: 'Password',
                iconData: Icons.lock_outline,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () => loginValidation(context),
                  icon: const Icon(Icons.login),
                  label: const Text('Login')),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RestSignUp())),
                        child: const Text(
                          'Sign-Up',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class RestSignUp extends StatefulWidget {
  const RestSignUp({Key? key}) : super(key: key);

  @override
  State<RestSignUp> createState() => _RestSignUpState();
}

class _RestSignUpState extends State<RestSignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? pos;
  List<Placemark>? placemarkList;

  String sellerImgUrl = "";
  String newCompleteAddress = "";

  getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position newposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    pos = newposition;
    placemarkList =
        await placemarkFromCoordinates(pos!.latitude, pos!.longitude);
    Placemark pmarkList = placemarkList![0];

    newCompleteAddress =
        '${pmarkList.name}, ${pmarkList.locality}, ${pmarkList.subAdministrativeArea}, ${pmarkList.administrativeArea}, ${pmarkList.postalCode}, ${pmarkList.country}';

    locationController.text = newCompleteAddress;
  }

  Future<void> getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  signupFormValidation() async {
    final name = nameController.text;
    final email = emailController.text;
    final phone = phoneController.text;
    final location = locationController.text;
    final pwd = pwdController.text;
    final confirm = confirmController.text;
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return MyErrorDialog(msg: 'Please Select An Image!');
          });
    } else if (email.isEmpty ||
        pwd.isEmpty ||
        name.isEmpty ||
        confirm.isEmpty ||
        phone.isEmpty ||
        location.isEmpty) {
      callCustomSnackbar(context, 'Please Enter All The Values!');
    } else if (phone.length != 10) {
      callCustomSnackbar(context, 'Phone number should be 10 digits');
    } else if (pwd != confirm) {
      callCustomSnackbar(context, 'Passwords don\'t match');
    } else {
      showDialog(
          context: context, builder: (context) => const MyLoadingDialog());
      String filename = DateTime.now().microsecondsSinceEpoch.toString();
      fstorage.Reference ref = fstorage.FirebaseStorage.instance
          .ref()
          .child('Sellers')
          .child(filename);
      fstorage.UploadTask uploadTask = ref.putFile(File(imageXFile!.path));
      fstorage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      await taskSnapshot.ref.getDownloadURL().then((url) {
        sellerImgUrl = url;
        final seller = Sellers(
          name: nameController.text,
          email: emailController.text,
          location: locationController.text,
          phone: phoneController.text,
          photoURL: sellerImgUrl,
        );

        //save info to firestore
        signUpAndAuthenticateSeller(seller);
      });
    }
  }

  signUpAndAuthenticateSeller(Sellers seller) async {
    User? currentUser;

    await firebaseAuths
        .createUserWithEmailAndPassword(
            email: seller.email.trim(), password: pwdController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((onError) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return MyErrorDialog(msg: onError.message.toString());
          });
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!, seller).then((value) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(
            builder: (context) => RestHomeScreen(currentUser: currentUser!));
        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
      });
    }
  }

  saveDataToFirestore(User currentUser, Sellers seller) async {
    //save data in firestore
    final docUser =
        FirebaseFirestore.instance.collection('sellers').doc(currentUser.uid);
    seller.id = docUser.id;
    final json = seller.toJson();
    docUser.set(json);

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('uid', seller.id!);
    await sharedPreferences!.setString('type', 'Restaurant');
    await sharedPreferences!.setString('email', seller.email);
    await sharedPreferences!.setString('password', pwdController.text);
    await sharedPreferences!.setString('name', seller.name);
    await sharedPreferences!.setString('photoUrl', sellerImgUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Restaurant Sign-Up'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/detailbgs.jpg'),
                fit: BoxFit.fitHeight)),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1000,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 18 / 100,
                    backgroundImage: imageXFile == null
                        ? null
                        : FileImage(File(imageXFile!.path)),
                    child: imageXFile == null
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 60,
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLength: 17,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Name',
                        labelStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        helperStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(Icons.person_outline, color: Colors.white,)
                      ),
                      cursorColor: Colors.white,
                      controller: nameController,
                    ),
                  ),
                      CustomTextField(
                        textInputType: TextInputType.emailAddress,
                        txt: emailController,
                        hintText: 'Email',
                        iconData: Icons.email_outlined,
                        isObscure: false,
                        enabled: true,
                      ),
                      CustomTextField(
                        textInputType: TextInputType.phone,
                        txt: phoneController,
                        hintText: 'Phone',
                        iconData: Icons.phone_android,
                        isObscure: false,
                        enabled: true,
                      ),
                      CustomTextField(
                        textInputType: TextInputType.visiblePassword,
                        txt: pwdController,
                        hintText: 'Password',
                        iconData: Icons.lock_outline,
                        isObscure: true,
                        enabled: true,
                      ),
                      CustomTextField(
                        textInputType: TextInputType.visiblePassword,
                        txt: confirmController,
                        hintText: 'Confirm Password',
                        iconData: Icons.lock_outline,
                        isObscure: true,
                        enabled: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                textInputType: TextInputType.text,
                                txt: locationController,
                                hintText: 'Address',
                                iconData: Icons.location_on_outlined,
                                isObscure: false,
                                enabled: true,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape:
                                    const CircleBorder(side: BorderSide.none),
                              ),
                              child: const Icon(Icons.location_on_outlined),
                              onPressed: () {
                                getCurrentLocation();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    signupFormValidation();
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

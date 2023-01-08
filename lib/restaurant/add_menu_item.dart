import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/models/rest_menu.dart';
import 'package:foodiyo/widgets/error_dialog.dart';
import 'package:foodiyo/widgets/loading_dialog.dart';
import 'package:foodiyo/widgets/snackbar.dart';
import 'package:foodiyo/widgets/text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:image_picker/image_picker.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({Key? key}) : super(key: key);

  @override
  State<AddMenuItem> createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemVegController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String sellerName = sharedPreferences!.getString('name')!;

  XFile? imageXFile;

  final ImagePicker _picker = ImagePicker();

  String sellerImgUrl = "";

  final items = [
    'Bread',
    'Butter',
    'Cheese',
    'Chicken',
    'Chickpea',
    'Chilli',
    'Coconut',
    'Curd',
    'Dal',
    'Egg',
    'Fish',
    'Flour',
    'Garlic',
    'Ghee',
    'Lemon',
    'Maida',
    'Meat',
    'Milk',
    'Noodles',
    'Oregano',
    'Patty',
    'Rice',
    'Scallion',
    'Scallops',
    'Shrimp',
    'Sugar',
    'Vegetables'
  ];

  final vegs = ['Veg', 'Non-Veg'];

  String? vegValue;
  String? ingValue1;
  String? ingValue2;
  String? ingValue3;

  Future<void> getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  addItemValidation() async {
    final name = itemNameController.text;
    final price = itemPriceController.text;
    final veg = vegValue;
    final description = descriptionController.text;
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return MyErrorDialog(msg: 'Please Select An Image!');
          });
    } else if (name.isEmpty ||
        price.isEmpty ||
        vegValue!.isEmpty ||
        ingValue1!.isEmpty ||
        description.isEmpty) {
      callCustomSnackbar(context, 'Please Enter All The Required Fields!');
    } else {
      showDialog(
          context: context, builder: (context) => const MyLoadingDialog());
      String filename = name;
      fstorage.Reference ref = fstorage.FirebaseStorage.instance
          .ref()
          .child('$sellerName Menu')
          .child(filename);
      fstorage.UploadTask uploadTask = ref.putFile(File(imageXFile!.path));
      fstorage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      await taskSnapshot.ref.getDownloadURL().then((url) {
        sellerImgUrl = url;

        //save info to firestore
        saveDataToFirestore(name, sellerImgUrl, price, veg!, ingValue1!,
                ingValue2, ingValue3, description)
            .then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          callCustomSnackbar(context, 'Item Added Successfully');
        });
      });
    }
  }

  saveDataToFirestore(
      String name,
      String sellerImgUrl,
      String price,
      String veg,
      String ingr1,
      String? ingr2,
      String? ingr3,
      String description) async {
    final menu = Menu(
      photoURL: sellerImgUrl,
      name: name,
      price: price,
      veg: veg,
      ingredient1: ingr1,
      ingredient2: ingr2,
      ingredient3: ingr3,
      description: description,
    );

    //save data in firestore
    final docUser =
        FirebaseFirestore.instance.collection('${sellerName}_menu').doc(name);
    menu.id = docUser.id;
    final json = menu.toJson();
    docUser.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1100,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/detailbgs.jpg'),
                  fit: BoxFit.fitHeight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: getImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
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
                  const Text('* Indicates Compulsory Fields',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLength: 19,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Name of item *',
                        labelStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        helperStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(null),
                      ),
                      cursorColor: Colors.white,
                      controller: itemNameController,
                    ),
                  ),
                  CustomTextField(
                    isObscure: false,
                    txt: itemPriceController,
                    hintText: 'Price *',
                    textInputType: TextInputType.number,
                  ),
                  Container(
                    height: 60,
                    width: 320,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.withOpacity(0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            hint: const Text('Veg/Non-Veg*'),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: Colors.blueGrey,
                            value: vegValue,
                            items: vegs.map(buildVegItem).toList(),
                            onChanged: (value) =>
                                setState(() => vegValue = value)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 320,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.withOpacity(0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            hint: const Text('Ingredient 1 *'),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: Colors.blueGrey,
                            value: ingValue1,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => ingValue1 = value)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 320,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.withOpacity(0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            hint: const Text('Ingredient 2'),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: Colors.blueGrey,
                            value: ingValue2,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => ingValue2 = value)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 320,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.withOpacity(0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            hint: const Text('Ingredient 3'),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: Colors.blueGrey,
                            value: ingValue3,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => ingValue3 = value)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    isObscure: false,
                    txt: descriptionController,
                    hintText: 'Description *',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      addItemValidation();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildVegItem(String item) => DropdownMenuItem(
        child: Text(item,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        value: item,
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        child: Text(item,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        value: item,
      );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/models/rest_menu.dart';
import 'package:foodiyo/widgets/snackbar.dart';

class UpdateMenuItem extends StatefulWidget {
  const UpdateMenuItem({Key? key, required this.menu}) : super(key: key);
  final Menu menu;

  @override
  State<UpdateMenuItem> createState() => _UpdateMenuItemState();
}

class _UpdateMenuItemState extends State<UpdateMenuItem> {
  TextEditingController name = TextEditingController();

  TextEditingController price = TextEditingController();

  TextEditingController desc = TextEditingController();

  String? vegValue;

  final vegs = ['Veg', 'Non-Veg'];

  @override
  Widget build(BuildContext context) {
    name.text = widget.menu.name;
    price.text = widget.menu.price;
    desc.text = widget.menu.description;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Update Menu Item'),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/detailbgs.jpg'),
                  fit: BoxFit.fitHeight)),
          child: Column(
            children: [
              const SizedBox(
                height: 160,
              ),
              UpdateTextField(
                txt: name,
                hint: 'Name',
                type: TextInputType.text,
              ),
              UpdateTextField(
                txt: price,
                hint: 'Price',
                type: TextInputType.number,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                        onChanged: (value) => setState(() => vegValue = value)),
                  ),
                ),
              ),
              UpdateTextField(
                txt: desc,
                hint: 'Description',
                type: TextInputType.text,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (name.text.isEmpty ||
                        price.text.isEmpty ||
                        vegValue!.isEmpty ||
                        desc.text.isEmpty) {
                      callCustomSnackbar(
                          context, 'Please Enter All The Values');
                    } else {
                      final docUser = FirebaseFirestore.instance
                          .collection(
                              '${sharedPreferences!.get('name').toString()}_menu')
                          .doc(widget.menu.id);
                      docUser.update({
                        'name': name.text,
                        'price': price.text,
                        'veg': vegValue!,
                        'description': desc.text,
                      }).then((value) {
                        Navigator.pop(context);
                        callCustomSnackbar(
                            context, 'Item Updated Successfully');
                      });
                    }
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Update')),
            ],
          ),
        ));
  }

  DropdownMenuItem<String> buildVegItem(String item) => DropdownMenuItem(
        child: Text(item,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        value: item,
      );
}

class UpdateTextField extends StatelessWidget {
  const UpdateTextField(
      {Key? key, required this.txt, required this.type, required this.hint})
      : super(key: key);
  final TextEditingController txt;
  final TextInputType type;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFormField(
        keyboardType: type,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blueGrey.withOpacity(0.7),
            errorStyle: const TextStyle(fontWeight: FontWeight.bold),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: hint,
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            prefixIcon: Icon(null, color: Colors.white.withOpacity(0.9))),
        cursorColor: Theme.of(context).primaryColor,
        controller: txt,
      ),
    );
  }
}

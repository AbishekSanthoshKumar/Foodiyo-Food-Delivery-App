import 'package:flutter/material.dart';
import 'package:foodiyo/models/rest_menu.dart';

class FoodDisplay extends StatelessWidget {
  const FoodDisplay({Key? key, required this.menu}) : super(key: key);
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('images/detailbgs.jpg'))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),

              //Image
              SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    offset: const Offset(-1, 10),
                                    blurRadius: 10,
                                  )
                                ]),
                            margin: const EdgeInsets.all(15),
                            child: Image.network(
                              menu.photoURL,
                              fit: BoxFit.cover,
                            )),
                      )
                    ],
                  )),

              //Details
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        menu.name,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //FoodQty(food),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          'Rs. ${menu.price}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Divider(color: Colors.blueGrey[100], thickness: 1),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Ingredients',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // Ingredients
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) =>
                            ingredientBuild(index, menu)!,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(width: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Divider(color: Colors.blueGrey[100], thickness: 1),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'About',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          menu.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIcon(IconData icon, String text, Color color) {
    return Center(
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget? ingredientBuild(int index, Menu menu) {
    String? string;
    switch (index + 1) {
      case 1:
        string = menu.ingredient1;
        break;
      case 2:
        string = menu.ingredient2;
        break;
      case 3:
        string = menu.ingredient3;
        break;
    }
    return string == null ? 
      Container() 
      : Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'images/ingredients/$string.png',
            height: 60,
          ),
          Text(string)
        ],
      ),
    );
  }
}

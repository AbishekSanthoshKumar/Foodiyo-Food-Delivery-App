import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('About Foodiyo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/Foodiyo.png'),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.50),
                      1: FractionColumnWidth(0.55),
                    },
                    children: [
                      buildRow(['CEO', 'Abishek Santhosh Kumar']),
                      buildRow([
                        'Headquarters',
                        'Foodiyo Business Park, Whitefield, Bengaluru'
                      ]),
                      buildRow(['Version', '1.0']),
                      buildRow(['Organization', 'Foodiyo Inc.']),
                      buildRow(['Developers', 'Abishek Santhosh Kumar\n\n']),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'About:\n\t\t\t\t\t\t\t\t\t\tIn the modern age of technology, food delivery apps are a trend. Ordering foods to our home has become a habit for most people, especially those who live in cities. People prefer Home Deliveries rather than Takeaways. FOODIYO provides a space where customers can use without having to step outside their doorstep. Customers can order meals to their addresses and compare prices of various meals between restaurants. \n\n\t\t\t\t\t\t\t\t\t\tIn this platform, users can log in using their phone numbers and email addresses. Customers can add products or meals to their cart and place the order to their doorstep. Most importantly, he/she will require an account to place an order. If they have any issues, they can also contact the customer care executives.',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells) {
    return TableRow(
        children: cells
            .map((cell) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    cell,
                    style: const TextStyle(fontSize: 17),
                  ),
                ))
            .toList());
  }
}

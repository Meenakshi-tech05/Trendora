import 'package:flutter/material.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final List<String> addresses = [
    "Home - Kowdiar, Trivandrum",

    "Office - Technopark, Trivandrum",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Address")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            addresses.add("New Address");
          });
        },

        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: addresses.length,

        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),

              title: Text(addresses[index]),

              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    addresses.removeAt(index);
                  });
                },

                icon: const Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }
}

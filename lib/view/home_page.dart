import 'package:app_api/controller/contact_controller.dart';
import 'package:app_api/model/contact.dart';
import 'package:app_api/view/contact_add_page.dart';
import 'package:app_api/view/contact_edit_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ContactController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getDataPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Person'),
      ),
      body: SafeArea(
          child: FutureBuilder<List<Contact>>(
        future: controller.getDataPerson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Contact person = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(person.gambar!),
                    ),
                    title: Text(person.nama),
                    subtitle: Text(person.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        setState(() {
                          controller.deletePerson(person.id!);
                        });
                      },
                    ),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContactEditPage(data: person.toMap()),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonAddPage(),
            ),
          );
        },
      ),
    );
  }
}

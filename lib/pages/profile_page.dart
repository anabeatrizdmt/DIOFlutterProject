import 'package:dioproject/pages/bmi_records_page.dart';
import 'package:dioproject/services/app_storage_service.dart';
import 'package:dioproject/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AppStorageService storage = AppStorageService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    nameController.text = await storage.getUserName();
    emailController.text = await storage.getUserEmail();
    setState(() {});
  }

  _saveData() async {
    storage.setUserName(nameController.text);
    storage.setUserEmail(emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
          userName: nameController.text, userEmail: emailController.text),
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextField(
                  controller: nameController,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Email:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields!'),
                            ),
                          );
                          return;
                        }
                        _saveData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data saved!'),
                          ),
                        );
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BmiRecordsPage()));
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

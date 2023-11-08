import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController textEditingController = TextEditingController();
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    sharedPreferences = context.read<SharedPreferences>();
    String name = sharedPreferences.getString("name") ?? "";
    if (name != "") {
      textEditingController.text = name;
    }
    super.initState();
  }

  void changeName() {
    sharedPreferences.setString("name", textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text("Your nickname:"),
                const SizedBox(height: 10),
                TextField(
                  controller: textEditingController,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: changeName,
                child: const Text("SAVE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

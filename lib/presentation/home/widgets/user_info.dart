import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool showAddLine = false;
  TextEditingController textEditingController = TextEditingController();
  late SharedPreferences sharedPreferences;
  String? name;
  String? _filePath;
  @override
  void initState() {
    sharedPreferences = context.read<SharedPreferences>();
    name = sharedPreferences.getString("name");
    _filePath = sharedPreferences.getString("image");

    super.initState();
  }

  void onCompleteAddName() {
    setState(() {
      showAddLine = false;
    });
    name = textEditingController.text;
    sharedPreferences.setString("name", textEditingController.text);
    textEditingController.clear();
    setState(() {});
  }

  void onNameTap() {
    setState(() {
      showAddLine = true;
    });
  }

  void saveImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    String newFilePath = '${appDocumentsDir.path}/${image!.name}'; // 3

    await image.saveTo(newFilePath);
    setState(() {
      _filePath = newFilePath;
    });

    await sharedPreferences.setString("image", newFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: saveImage,
              child: _filePath != null
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(
                            File(
                              _filePath!,
                            ),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        "assets/camer.png",
                        fit: BoxFit.fill,
                        height: 90,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                showAddLine
                    ? Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 160,
                            child: TextField(
                              controller: textEditingController,
                              onEditingComplete: onCompleteAddName,
                              decoration: const InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: (name ?? "namename").length > 20 ? 1 : 0,
                              child: Text(
                                name ?? "namename",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  height: 20 / 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: onNameTap,
                              child: Image.asset(
                                "assets/pen.png",
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

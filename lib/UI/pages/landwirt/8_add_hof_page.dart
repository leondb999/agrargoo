import 'dart:io';
import 'dart:typed_data';

import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/layout_widgets.dart';

class AddHofPage extends ConsumerStatefulWidget {
  const AddHofPage({Key? key}) : super(key: key);
  static const routename = '/add-hof';

  @override
  _AddHofPageState createState() => _AddHofPageState();
}

class _AddHofPageState extends ConsumerState<AddHofPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final standortController = TextEditingController();
  var routeData;

  File? uploadedImage;
  String? uploadedImageURL = "";

  void clearData() {
    nameController.text = '';
    standortController.text = '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () {
      routeData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    }).then(
      (value) => routeData == null
          ? Future.delayed(Duration.zero, () {
              clearData();
              final hofProvider =
                  p.Provider.of<HofProvider>(context, listen: false);
              hofProvider.loadValues(HofModel());
            })
          : Future.delayed(
              Duration.zero,
              () {
                print("routeData: $routeData");
                nameController.text = routeData['hofName'];
                standortController.text = routeData['standort'];

                final hofProvider =
                    p.Provider.of<HofProvider>(context, listen: false);
                HofModel anzeige = HofModel(
                  hofID: routeData['hofID'],
                  besitzerID: routeData['besitzerID'],
                  hofName: routeData['hofName'],
                  standort: routeData['standort'],
                  hofImageURL: routeData['hofImageURL'],
                );
                hofProvider.loadValues(anzeige);
                setState(() {
                  uploadedImageURL = routeData['hofImageURL'];
                });
              },
            ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    standortController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hofProvider = p.Provider.of<HofProvider>(context);
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;

    print(
        "hof Name: ${hofProvider.hofName}, standort: ${hofProvider.standort}, besitzerID: ${hofProvider.getBesitzerID}, hofID: ${hofProvider.getHofID}");
    return Scaffold(
      appBar: AppBar(title: Text('Add Hof ')),
      body: SafeArea(
        child: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ///Name Input Field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Hof Name ';
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Enter Hof Name '),
                      onChanged: (val) => hofProvider.changeHofName(val),
                    ),
                    SizedBox(height: 20),

                    ///Standort Input Field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Standort';
                        }
                        return null;
                      },
                      controller: standortController,
                      decoration: InputDecoration(hintText: 'Enter Standort'),
                      onChanged: (val) => hofProvider.changeStandort(val),
                    ),
                    SizedBox(height: 20),

                    ///Upload Button
                    ElevatedButton(
                      child: Text('UPLOAD FILE'),
                      onPressed: () async {
                        var picked = await FilePicker.platform.pickFiles();

                        if (picked != null) {
                          print("fileName: ${picked.files.first.name}");
                          String fileExtension =
                              getFileExtension(picked.files.first.name);
                          print("FileType: $fileExtension");
                          Uint8List fileBytes = picked.files.first.bytes!;
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference ref =
                              storage.ref("${hofProvider.hofID}$fileExtension");
                          await ref.putData(fileBytes);
                          String urlString = await ref.getDownloadURL();
                          print("getDownloadURL(): $urlString");
                          setState(() {
                            uploadedImageURL = urlString;
                          });
                        }
                      },
                    ),

                    /// Add Buttn
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          hofProvider.besitzerID = userID;
                          hofProvider.hofImageURL = uploadedImageURL;
                          hofProvider.saveData();
                          Navigator.of(context).pop();
                        }
                      },
                    ),

                    ///Delete Button
                    ElevatedButton(
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        hofProvider.removeData();
                        Navigator.of(context).pop();
                      },
                    ),

                    ///Show Uploaded File
                    uploadedImageURL!.isNotEmpty
                        ? Image.network(uploadedImageURL!)
                        : Text("No Image Uploaded Yet"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

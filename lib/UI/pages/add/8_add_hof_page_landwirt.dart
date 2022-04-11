import 'dart:io';
import 'dart:typed_data';

import 'package:agrargo/controllers/hof_controller.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
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
  HofModel hofModel = HofModel();
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
      print("routeData: $routeData");
      String? userID = ref.read(authControllerProvider.notifier).state?.uid;
      setState(() {
        hofModel.besitzerID = userID;
      });
      print("hofmodel: besitzerID ${hofModel.besitzerID}");
    }).then(
      (value) => routeData == null
          ? Future.delayed(Duration.zero, () {
              clearData();
              String? userID =
                  ref.read(authControllerProvider.notifier).state?.uid;
              setState(() {
                hofModel.besitzerID = userID;
              });
            })
          : Future.delayed(
              Duration.zero,
              () {
                ///Befülle Input Felder
                nameController.text = routeData['hofName'];
                standortController.text = routeData['standort'];

                ///Befülle Hofmodel mit Daten aus dem vorherigen Screen (über Route)
                hofModel.hofID = routeData['hofID'];
                hofModel.hofName = routeData['hofName'];
                hofModel.standort = routeData['standort'];
                hofModel.hofImageURL = routeData['hofImageURL'];

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

  double progress = 0.0;
  @override
  Widget build(BuildContext context) {
    final hofProvider = p.Provider.of<HofProvider>(context);
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;
    setState(() {
      hofModel.besitzerID = userID;
    });
    print(
        "hof Name: ${hofModel.hofName}, standort: ${hofModel.standort}, besitzerID: ${hofModel.besitzerID}, hofID: ${hofModel.hofID}");

    print("progress: ${progress.toString()}");
    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: true),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Center(
                        child: Text("Einen neuen Hof hinzufügen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E6C49)))),
                    SizedBox(height: 50),

                    ///Show Uploaded File
                    uploadedImageURL!.isNotEmpty
                        ? Image.network(
                            uploadedImageURL!,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;

                              return Center(
                                // child: CircularProgressIndicator(),
                                child: Container(
                                  height: 100.0,
                                  width: 100.0,
                                  child: LiquidCircularProgressIndicator(
                                    value: progress / 100,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.green),
                                    backgroundColor: Colors.white,
                                    direction: Axis.vertical,
                                    center: Text(
                                      "${progress.toInt()}%",
                                      style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontSize: 25.0),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Text("No Image Uploaded Yet"),

                    SizedBox(height: 30),

                    ///Name Input Field
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bitte einen Hofnamen angeben';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Hofname'),
                        onChanged: (val) {
                          setState(() {
                            hofModel.hofName = val;
                          });
                        }),
                    SizedBox(height: 20),

                    ///Standort Input Field
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bitte einen Standort angeben';
                          }
                          return null;
                        },
                        controller: standortController,
                        decoration: InputDecoration(hintText: 'Standort'),
                        onChanged: (val) {
                          setState(() {
                            hofModel.standort = val;
                          });
                        }),
                    SizedBox(height: 50),

                    ///Upload Button
                    ElevatedButton(
                      child: Text('Bild hochladen'),
                      onPressed: () async {
                        FilePickerResult? picked =
                            await FilePicker.platform.pickFiles();

                        if (picked != null) {
                          String fileExtension =
                              getFileExtension(picked.files.first.name);

                          Uint8List fileBytes = picked.files.first.bytes!;
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference reference =
                              storage.ref("${hofProvider.hofID}$fileExtension");
                          UploadTask task = FirebaseStorage.instance
                              .ref("${hofProvider.hofID}$fileExtension")
                              .putData(fileBytes);

                          task.snapshotEvents.listen((event) {
                            var x = ((event.bytesTransferred.toDouble() /
                                    event.totalBytes.toDouble()) *
                                100);
                            setState(() {
                              progress = x;
                            });
                          });
                          String url = await reference.getDownloadURL();

                          setState(() {
                            uploadedImageURL = url;
                            hofModel.hofImageURL = url;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9FB98B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20)),
                    ),

                    SizedBox(height: 40),

                    /// Add Button
                    ElevatedButton(
                        child: Text('Speichern'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print(
                                "hofmodel: hofID: ${hofModel.hofID}, besitzerID: ${hofModel.besitzerID}, hofName: ${hofModel.hofName}, standort: ${hofModel.standort}");
                            if (hofModel.hofImageURL == null) {
                              setState(() {
                                ///Default Image als Hof Bild
                                hofModel.hofImageURL =
                                    'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none';
                              });
                            }
                            ref
                                .read(hofModelFirestoreControllerProvider
                                    .notifier)
                                .saveHof(hofModel);

                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9FB98B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        )),
                    SizedBox(height: 20),

                    ///Delete Button
                    ElevatedButton(
                      child: Text('Löschen'),
                      onPressed: () {
                        ref
                            .read(hofModelFirestoreControllerProvider.notifier)
                            .removeHof(hofModel.hofID!);

                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20)),
                    ),
                    SizedBox(height: 100),
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

import 'package:agrargo/controllers/jobanzeige_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';

///https://github.com/Mashood97/flutter_firestore/blob/master/lib/screens/edit_add_product.dart
class AddEditJobanzeige extends ConsumerStatefulWidget {
  const AddEditJobanzeige({Key? key}) : super(key: key);
  static const routename = '/add-edit-jobanzeige';

  @override
  _AddEditJobanzeigeState createState() => _AddEditJobanzeigeState();
}

class _AddEditJobanzeigeState extends ConsumerState<AddEditJobanzeige> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  var routeData;
  void clearData() {
    nameController.text = '';
    priceController.text = '';
  }

  String? _hofName = "";
  String? _standort = "";
  bool? isSwitched = true;
  bool? checkStatus;
  JobanzeigeModel anzeige = JobanzeigeModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () {
      routeData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      String? userID = ref.read(authControllerProvider.notifier).state?.uid;
      print("routeData: $routeData");

      ///Hof Daten | um eine Jobanzeige zu einem Hof & User zuzuordnen, werden beim laden der Seite automaitsch HofID, UserID in der anzeige gespeichert
      setState(() {
        anzeige.hofID = routeData['hofID'];
        anzeige.auftraggeberID = userID;
        anzeige.status = isSwitched;
        _hofName = routeData['hofName'];
        _standort = routeData['standort'];
      });
    }).then(
      (value) => routeData == null
          ? Future.delayed(Duration.zero, () {})
          : Future.delayed(
              Duration.zero,
              () {
                nameController.text = routeData['titel'];
                setState(() {
                  isSwitched = routeData['status'];
                  checkStatus = routeData['status'];
                });

                anzeige.titel = routeData['titel'];
                anzeige.status = routeData['status'];
                anzeige.jobanzeigeID = routeData['jobanzeigeID'];
              },
            ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;
    if (anzeige.titel != null) {
      print(
          "jobanzeige: titel ${anzeige.titel}, hofID: ${anzeige.hofID}, auftraggeberID: ${anzeige.auftraggeberID}, status: ${anzeige.status}");
    }
    print("hello");

    return Scaffold(
      appBar: AppBar(title: Text('Add / Edit Jobangebot Screen')),
      body: SafeArea(
        child: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Titel';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration:
                            InputDecoration(hintText: 'Enter Jobangebot Titel'),
                        onChanged: (val) {
                          // jobanzeigeProvider.changeJobanzeigeTitel(val),
                          setState(() {
                            anzeige.titel = val;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),

                    isSwitched!
                        ? Text(
                            "Anzeige wird veröffentlicht, Status: Active | isSwitched = $isSwitched",
                            style: TextStyle(color: Colors.green),
                          )
                        : Text(
                            'Anzeige nicht veröffentlicht, Status: Deactivated | isSwitched = $isSwitched',
                            style: TextStyle(color: Colors.red),
                          ),
                    Switch(
                        value: isSwitched!,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            anzeige.status = isSwitched;
                          });
                          //jobanzeigeProvider.changeStatus(isSwitched!);
                        }),

                    /// Add Buttn
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(jobanzeigeModelFirestoreControllerProvider
                                  .notifier)
                              .saveJobanzeige(anzeige);

                          Navigator.of(context).pop();
                        }
                      },
                    ),

                    ///Delete Button
                    ElevatedButton(
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        if (anzeige.jobanzeigeID != null) {
                          ref
                              .read(jobanzeigeModelFirestoreControllerProvider
                                  .notifier)
                              .removeJobanzeige(anzeige.jobanzeigeID!);
                        }

                        Navigator.of(context).pop();
                      },
                    ),

                    Container(
                      height: 200,
                      child: Column(
                        children: [
                          Text('Vorschau'),
                          Text("HofID: ${anzeige.hofID}"),
                          Text("AuftraggeberID: $userID"),
                          Text("HofName: $_hofName"),
                          Text('Standort: $_standort'),
                          Text('Anzeigen Titel: ${nameController.text}'),
                        ],
                      ),
                    )
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

import 'package:agrargo/controllers/jobanzeige_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/layout_widgets.dart';

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
  int _currentPrice = 10;
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
        anzeige.stundenLohn = routeData['stundenLohn'];
        _currentPrice = routeData['stundenLohn'];
        _hofName = routeData['hofName'];
        _standort = routeData['standort'];
      });
      print("anzeige.stundenLohn: ${anzeige.stundenLohn}");
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
          "jobanzeige: titel ${anzeige.titel}, hofID: ${anzeige.hofID}, auftraggeberID: ${anzeige.auftraggeberID}, status: ${anzeige.status}, stundenLohn: ${anzeige.stundenLohn}");
    }
    print("hello");

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
                        child: Text("Eine neue Anzeige hinzufügen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E6C49)))),
                    SizedBox(height: 80),

                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Titel der Anzeige';
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: 'Bitte gib einen Titel ein'),
                        onChanged: (val) {
                          // jobanzeigeProvider.changeJobanzeigeTitel(val),
                          setState(() {
                            anzeige.titel = val;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Stundenlohn: $_currentPrice€/h'),
                    NumberPicker(
                      value: _currentPrice,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) {
                        setState(() {
                          _currentPrice = value;
                          anzeige.stundenLohn = value;
                        });
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    isSwitched!
                        ? Text(
                            "Anzeige wird veröffentlicht",
                            style: TextStyle(color: Colors.green),
                          )
                        : Text(
                            'Anzeige nicht veröffentlicht',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                    Switch(
                        activeColor: Color(0xFF9FB98B),
                        value: isSwitched!,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            anzeige.status = isSwitched;
                          });
                          //jobanzeigeProvider.changeStatus(isSwitched!);
                        }),

                    SizedBox(height: 30),

                    /// Add Buttn
                    ElevatedButton(
                      child: Text('Speichern'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(jobanzeigeModelFirestoreControllerProvider
                                  .notifier)
                              .saveJobanzeige(anzeige);

                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9FB98B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20)),
                    ),

                    SizedBox(height: 20),

                    ///Delete Button
                    ElevatedButton(
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20)),
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

                    /*
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
                      ),
                     */
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

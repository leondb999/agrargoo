import 'package:agrargo/controllers/jobanzeige_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/user_model.dart';
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
  final beschreibungController = TextEditingController();
  final priceController = TextEditingController();
  var routeData;
  bool? edit = false;
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
  DateTimeRange? selectedDateRange;

  ///Alle Qualifikationen Firebase
  List<QualifikationModel>? fireQualifikationList = [];

  ///Ausgewählte Qualifikationen Firebase
  List<QualifikationModel>? fireSelectedQualifikationList = [];

  ///Ausgewählte Qualifikationen setState(){}
  List<QualifikationModel>? selectedQualifikationList = [];

  ///Get all Qualifikationen
  Future<List<QualifikationModel>> getAllQualifikationen() async {
    ///Alle Qualifikationen
    List<QualifikationModel> alleQualifikationenList = [];

    ///1. Hole alle Qualifikationen aus Firestore
    await FirebaseFirestore.instance
        .collection('qualifikationen')
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        QualifikationModel quali = QualifikationModel(
            qualifikationID: doc.id, qualifikationName: doc['name']);
        alleQualifikationenList.add(quali);
      });
    });
    // print("all qualifikationModelList: $alleQualifikationenList");
    return alleQualifikationenList;
  }

  ///Date Range Picker
  void _showDateRangePicker(
      JobanzeigeModel jobanzeige, DateTime startDate, DateTime endDate) async {
    print("userLoggedIn.startDate: ${jobanzeige.startDate}");
    final DateTimeRange? result = await showDateRangePicker(
      //  initialEntryMode: DatePickerEntryMode.calendar,
      context: context,
      initialDateRange: jobanzeige.startDate == DateTime(1700)
          ? DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now(),
            )
          : DateTimeRange(
              start: jobanzeige.startDate!, end: jobanzeige.endDate!),
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      print("result DateRage.start: ${result.start.toString()}");
      setState(() {
        selectedDateRange = result;
        anzeige.startDate = result.start;
        anzeige.endDate = result.end;

        print("selectedDateRange: $selectedDateRange");
      });
    }
  }

  ///Select Qualifikationen
  void openFilterDialog(JobanzeigeModel jobanzeigeModel) async {
    await FilterListDialog.display<QualifikationModel>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Wähle Qualifikationen aus',
      height: 500,
      listData: fireQualifikationList!,
      selectedListData: selectedQualifikationList,
      choiceChipLabel: (item) {
        return item!.qualifikationName;
      },
      validateSelectedItem: (list, val) {
        return list!.contains(val);
      },
      controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
      onItemSearch: (qualifikation, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return qualifikation.qualifikationName!
            .toLowerCase()
            .contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedQualifikationList = List.from(list!);
          print(
              "---------------------------------------------------------------------------------------------------");
          print("selectedQualifikasationLisast: $selectedQualifikationList");
          print(
              "---------------------------------------------------------------------------------------------------");
          List<String> ids = [];
          list.forEach((qualifikation) {
            if (ids.contains(qualifikation.qualifikationID) == false) {
              ids.add(qualifikation.qualifikationID!);
            }
          });
          anzeige.qualifikationList = ids;
          print(" anzeige.qualifikationList: ${anzeige.qualifikationList}");
        });

        Navigator.pop(context);
        setState(() {
          selectedQualifikationList = [];
        });
      },
    );
  }

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
        anzeige.beschreibung = routeData['beschreibung'];
        anzeige.qualifikationList = routeData['qualifikationList'];
        anzeige.startDate = routeData['startDate'];
        anzeige.endDate = routeData['endDate'];
        _currentPrice = routeData['stundenLohn'];
        _hofName = routeData['hofName'];
        _standort = routeData['standort'];
        edit = routeData["edit"];
      });
      print("anzeige.stundenLohn: ${anzeige.stundenLohn}");
    }).then(
      (value) => routeData == null
          ? Future.delayed(Duration.zero, () {})
          : Future.delayed(
              Duration.zero,
              () {
                beschreibungController.text = routeData["beschreibung"];
                nameController.text = routeData['titel'];
                setState(() {
                  isSwitched = routeData['status'];
                  checkStatus = routeData['status'];
                });

                anzeige.titel = routeData['titel'];
                anzeige.beschreibung = routeData['beschreibung'];
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
          "jobanzeige: titel ${anzeige.titel}, hofID: ${anzeige.hofID}, auftraggeberID: ${anzeige.auftraggeberID}, status: ${anzeige.status}, stundenLohn: ${anzeige.stundenLohn}, qualifikationList. ${anzeige.qualifikationList}");
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
                    Center(
                        child: edit == true
                            ? Text("Anzeige bearbeiten",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF586015)))
                            : Text("Eine neue Anzeige hinzufügen",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF586015)))),
                    SizedBox(height: 80),

                    ///Titel Textfield()
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

                    ///Beschreibung Textfield()
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Beschreibung der Anzeige';
                          }
                          return null;
                        },
                        controller: beschreibungController,
                        decoration: InputDecoration(
                            hintText: 'Bitte gib eine Beschreibung ein'),
                        onChanged: (val) {
                          // jobanzeigeProvider.changeJobanzeigeTitel(val),
                          setState(() {
                            anzeige.beschreibung = val;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),

                    ///StundenLohn NumberPicker()
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
                    TextButton(
                      child: Text(
                        "Verfügbaren Zeitraum wählen",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFA7BB7B)),
                      ),
                      onPressed: () {
                        _showDateRangePicker(
                          anzeige,
                          anzeige.startDate!,
                          anzeige.endDate!,
                        );
                      },
                    ),

                    SizedBox(height: 30),

                    ///TODO qualifikationPicker
                    TextButton(
                      onPressed: () async {
                        var allList = await getAllQualifikationen();
                        setState(() {
                          fireQualifikationList = allList;
                        });
                        print("fireQualifikationList: $fireQualifikationList");

                        anzeige.qualifikationList!.forEach((selectedID) {
                          fireQualifikationList!.forEach((qualifikation) {
                            if (qualifikation.qualifikationID == selectedID) {
                              if (selectedQualifikationList!
                                      .contains(qualifikation) ==
                                  false) {
                                setState(() {
                                  selectedQualifikationList!.add(qualifikation);
                                });
                              }
                            }
                          });
                        });

                        print(
                            "selectedQualifikationList: $selectedQualifikationList");
                        openFilterDialog(anzeige);
                      },
                      child: Text(
                        "Qualifikationen hinzufügen",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFA7BB7B)),
                      ),
                      // color: Colors.blue,
                    ),

                    ///Active/deactivate Anzeige Switch()
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
                        activeColor: Color(0xFFA7BB7B),
                        value: isSwitched!,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            anzeige.status = isSwitched;
                          });
                          //jobanzeigeProvider.changeStatus(isSwitched!);
                        }),

                    SizedBox(height: 30),

                    ///Save Button
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
                          primary: Color(0xFFA7BB7B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20)),
                    ),

                    SizedBox(height: 20),

                    ///Delete Button
                    edit == true
                        ? ElevatedButton(
                            child: Text('Löschen'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20)),
                            onPressed: () {
                              if (anzeige.jobanzeigeID != null) {
                                ref
                                    .read(
                                        jobanzeigeModelFirestoreControllerProvider
                                            .notifier)
                                    .removeJobanzeige(anzeige.jobanzeigeID!);
                              }

                              Navigator.of(context).pop();
                            },
                          )
                        : Text(""),

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

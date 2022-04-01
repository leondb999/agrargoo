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

  String? _hofID = "";
  String? _hofName = "";
  String? _standort = "";
  bool? isSwitched = true;
  bool? checkStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () {
      routeData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        _hofID = routeData['hofID'];
        _hofName = routeData['hofName'];
        _standort = routeData['standort'];
      });
      print("AddJobanzeige: $_hofID");
    }).then(
      (value) => routeData == null
          ? Future.delayed(Duration.zero, () {
              clearData();
              final jobanzeigeProvider =
                  p.Provider.of<JobanzeigeProvider>(context, listen: false);

              jobanzeigeProvider.loadValues(JobanzeigeModel());
            })
          : Future.delayed(
              Duration.zero,
              () {
                print("routeData: $routeData");
                nameController.text = routeData['titel'];
                setState(() {
                  isSwitched = routeData['status'];
                  checkStatus = routeData['status'];
                });
                final jobanzeigeProvider =
                    p.Provider.of<JobanzeigeProvider>(context, listen: false);
                JobanzeigeModel anzeige = JobanzeigeModel(
                  titel: routeData['titel'],
                  hofID: routeData['hofID'],
                  jobanzeigeID: routeData['jobanzeigeID'],
                  auftraggeberID: routeData['auftraggeberID'],
                  status: routeData['status'],
                );
                jobanzeigeProvider.loadValues(anzeige);
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
    final jobanzeigeProvider = p.Provider.of<JobanzeigeProvider>(context);
    print("jobanzeigeProvider: ${jobanzeigeProvider.titel}");
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;

    print(
        "jobanzeige titel: ${jobanzeigeProvider.titel}, status: ${jobanzeigeProvider.status}, auftraggeberID: ${jobanzeigeProvider.getAuftraggeberID}, hofID: ${jobanzeigeProvider.getHofID}");
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
                      onChanged: (val) =>
                          jobanzeigeProvider.changeJobanzeigeTitel(val),
                    ),
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
                          });
                          jobanzeigeProvider.changeStatus(isSwitched!);
                        }),

                    /// Add Buttn
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          jobanzeigeProvider.status = jobanzeigeProvider.status;
                          jobanzeigeProvider.auftraggeberID = userID;
                          jobanzeigeProvider.hofID = _hofID;
                          jobanzeigeProvider.status = isSwitched!;
                          jobanzeigeProvider.saveData();
                          Navigator.of(context).pop();
                        }
                      },
                    ),

                    ///Delete Button
                    ElevatedButton(
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        jobanzeigeProvider.removeData();
                        Navigator.of(context).pop();
                      },
                    ),

                    Container(
                      height: 200,
                      child: Column(
                        children: [
                          Text('Vorschau'),
                          Text("HofID: $_hofID"),
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

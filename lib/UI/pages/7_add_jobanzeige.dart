import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/repositories/jobanzeige_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

///https://github.com/Mashood97/flutter_firestore/blob/master/lib/screens/edit_add_product.dart
class AddEditJobanzeige extends StatefulWidget {
  const AddEditJobanzeige({Key? key}) : super(key: key);
  static const routename = '/addeditjobanzeige';

  @override
  _AddEditJobanzeigeState createState() => _AddEditJobanzeigeState();
}

class _AddEditJobanzeigeState extends State<AddEditJobanzeige> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  var routeData;
  void clearData() {
    nameController.text = '';
    priceController.text = '';
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
              final jobanzeigeProvider =
                  Provider.of<JobanzeigeProvider>(context, listen: false);
              jobanzeigeProvider.loadValues(Jobanzeige());
            })
          : Future.delayed(
              Duration.zero,
              () {
                print("routeData: $routeData");
                nameController.text = routeData['titel'];

                final jobanzeigeProvider =
                    Provider.of<JobanzeigeProvider>(context, listen: false);
                Jobanzeige anzeige = Jobanzeige(
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
    final jobanzeigeProvider = Provider.of<JobanzeigeProvider>(context);
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

                    /// Add Buttn
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          jobanzeigeProvider.status = true;
                          jobanzeigeProvider.auftraggeberID = 'LeonsID1234';
                          jobanzeigeProvider.hofID = "Leon's HofID 1234";
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
                        if (_formKey.currentState!.validate()) {
                          jobanzeigeProvider.saveData();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
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

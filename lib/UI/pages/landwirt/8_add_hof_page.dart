import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';

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
                  standort: routeData['standort'],
                );
                hofProvider.loadValues(anzeige);
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
                          return 'Gib den Namen deines Hofes an  ';
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'Gib den Namen deines Hofes an '),
                      onChanged: (val) => hofProvider.changeHofName(val),
                    ),
                    SizedBox(height: 20),

                    ///Standort Input Field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Gib den Standort an';
                        }
                        return null;
                      },
                      controller: standortController,
                      decoration:
                          InputDecoration(hintText: 'Gib den Standort an'),
                      onChanged: (val) => hofProvider.changeStandort(val),
                    ),
                    SizedBox(height: 20),

                    /// Add Buttn
                    ElevatedButton(
                      child: Text("Speichern"),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9FB98B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          hofProvider.besitzerID = userID;
                          hofProvider.saveData();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    ///Delete Button
                    ElevatedButton(
                      child: Text("Löschen"),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9FB98B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        hofProvider.removeData();
                        Navigator.of(context).pop();
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

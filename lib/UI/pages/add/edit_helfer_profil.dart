import 'package:agrargo/controllers/jobanzeige_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:filter_list/filter_list.dart';
import '../../../controllers/auth_controller.dart';
import 'package:agrargo/widgets/add-update-widgets.dart';
/*
///https://github.com/Mashood97/flutter_firestore/blob/master/lib/screens/edit_add_product.dart
class EditHelfer extends ConsumerStatefulWidget {
  const EditHelfer({Key? key}) : super(key: key);
  static const routename = '/edit-helfer-page';

  @override
  _EditHelferState createState() => _EditHelferState();
}

class _EditHelferState extends ConsumerState<EditHelfer> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final qualifikationsTagController = TextfieldTagsController();
  var routeData;
  var distanceToField;
  List<String> qualifikationsSelectedList = [];
  List<QualifikationModel>? selectedQualifikationList = [];
  List<QualifikationModel> qualifikationList = [
    QualifikationModel(qualifikationName: "Landarbeit", avatar: "user.png"),
    QualifikationModel(qualifikationName: "Traktor fahren", avatar: "user.png"),
    QualifikationModel(qualifikationName: "Ava", avatar: "user.png"),
    QualifikationModel(qualifikationName: "Bella", avatar: "user.png"),
    QualifikationModel(qualifikationName: "Bernadette", avatar: "user.png"),
    QualifikationModel(qualifikationName: "Carol", avatar: "user.png"),
    QualifikationModel(qualifikationName: "Claire", avatar: "user.png"),
  ];
  void clearData() {
    nameController.text = '';
    priceController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<QualifikationModel>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Select Users',
      height: 500,
      listData: qualifikationList,
      selectedListData: selectedQualifikationList,
      choiceChipLabel: (item) => item!.qualifikationName,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.qualifikationName!
            .toLowerCase()
            .contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedQualifikationList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    final userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;
    print("userLoggedIn: $userLoggedIn");
    print("qualifikationsList: ${qualifikationsSelectedList}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Helfer Profil'),
      ),
      body: SafeArea(
        child: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    /// Input Field Tags Field
                    textFieldTags(qualifikationsTagController, distanceToField),
                    TextButton(
                      onPressed: _openFilterDialog,
                      child: Text(
                        "Filter Dialog",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      // color: Colors.blue,
                    ),
                    ElevatedButton(
                      child: Text("Add"),
                      onPressed: () {
                        qualifikationsSelectedList.add(nameController.text);
                        // jobanzeigeProvider
                        //   .changeJobanzeigeTitel(nameController.text);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Edit Button
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          /*    ref
                              .read(jobanzeigeModelFirestoreControllerProvider
                                  .notifier)
                              .saveJobanzeige(anzeige);
                          */

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    /*
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
                    */
                    Container(
                      height: 200,
                      child: Column(
                        children: [
                          Text('Vorschau'),
                          Text("Name: ${userLoggedIn.name}"),
                          Text("UserID: $userID"),
                          Text("Landwirt: ${userLoggedIn.landwirt}"),
                          Text('Anzeigen Titel: ${nameController.text}'),
                        ],
                      ),
                    ),
                    qualifikationsSelectedList.isEmpty
                        ? Text("No Qualifikation")
                        : ListView.builder(itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                    "${qualifikationsSelectedList[index]}"),
                              ),
                            );
                          }),
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
*/

import 'package:agrargo/controllers/jobanzeige_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

Widget textFieldTags(TextfieldTagsController qualifikationsTagController,
    double distanceToField) {
  return Column(
    children: [
      TextFieldTags(
        textfieldTagsController: qualifikationsTagController,
        initialTags: const [
          'pick',
          'your',
          'favorite',
          'programming',
          'language'
        ],
        textSeparators: const [' ', ','],
        letterCase: LetterCase.normal,
        validator: (String tag) {
          if (tag == 'php') {
            return 'No, please just no';
          } else if (qualifikationsTagController.getTags!.contains(tag)) {
            return 'you already entered that';
          }
          return null;
        },
        inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
          return ((context, sc, tags, onTagDelete) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: tec,
                focusNode: fn,
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 74, 137, 92),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 74, 137, 92),
                      width: 3.0,
                    ),
                  ),
                  helperText: 'Enter Qualifikationen...',
                  helperStyle: const TextStyle(
                    color: Color.fromARGB(255, 74, 137, 92),
                  ),
                  hintText:
                      qualifikationsTagController.hasTags ? '' : "Enter tag...",
                  errorText: error,
                  prefixIconConstraints:
                      BoxConstraints(maxWidth: distanceToField * 0.74),
                  prefixIcon: tags.isNotEmpty
                      ? SingleChildScrollView(
                          controller: sc,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: tags.map((String tag) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                color: Color.fromARGB(255, 74, 137, 92),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Text(
                                      '#$tag',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      print("$tag selected");
                                      print("hello");
                                    },
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 14.0,
                                      color: Color.fromARGB(255, 233, 233, 233),
                                    ),
                                    onTap: () {
                                      onTagDelete(tag);
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList()),
                        )
                      : null,
                ),
                onChanged: onChanged,
                onSubmitted: onSubmitted,
              ),
            );
          });
        },
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 74, 137, 92),
          ),
        ),
        onPressed: () {
          qualifikationsTagController.clearTags();
        },
        child: const Text('CLEAR TAGS'),
      ),
    ],

/*
                      tagsStyler: TagsStyler(
                          tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
                          tagDecoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          tagCancelIcon: Icon(Icons.cancel,
                              size: 18.0, color: Colors.blue[900]),
                          tagPadding: const EdgeInsets.all(6.0)),
                      textFieldStyler: TextFieldStyler(),
                      onTag: (tag) {
                        listTag.add(tag);
                        print('tag: $listTag');
                      },
                      onDelete: (tag) {},
                      */
  );
}

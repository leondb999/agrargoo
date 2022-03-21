import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'UI/landing_page.dart';

void main() {
  runApp(MyApp());
}

final HttpLink httpLink =
    HttpLink("https://api.randevu.technology/getParticipantTypes");

GraphQLClient qlClient =
    GraphQLClient(link: httpLink, cache: GraphQLCache(store: HiveStore()));

final AuthLink authLink = AuthLink(
    getToken: () async => "Bearer sk_sand-79116408b11c4d3e8ca691a8d1935ee0");

final Link link = authLink.concat(httpLink);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore())),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Agrargo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(title: 'Agrargo'),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _test();
}

class _test extends State<test> {
  @override
  Widget build(BuildContext context) => Query(
        options: QueryOptions(
          document: gql("""
          query ReadRepositories(\$nRepositories: Int!) {
            viewer {
              repositories(last: \$nRepositories) {
                nodes {
                  id
                  name
                  viewerHasStarred
                }
              }
            }
          }
        """), // this is the query string you just created
          variables: {
            'nRepositories': 50,
          },
          pollInterval: const Duration(seconds: 10),
        ),
        // Just like in apollo refetch() could be used to manually trigger a refetch
        // while fetchMore() can be used for pagination purpose
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          List? repositories =
              result.data?['viewer']?['repositories']?['nodes'];

          if (repositories == null) {
            return const Text('No repositories');
          }

          return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repository = repositories[index];

                return Text(repository['name'] ?? '');
              });
        },
      );
}

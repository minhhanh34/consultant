import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate {



  @override
  List<Widget>? buildActions(BuildContext context) {
    return [Container()];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const BackButtonIcon();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

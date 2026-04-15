import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myminiblog/viewmodals/search_viewmodel.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _query = TextEditingController();

  void _onSubmit(String value) {
    if (value.isNotEmpty) {
      Provider.of<SearchViewModel>(context, listen: false).searchUser(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(209, 237, 229, 229),
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Consumer<SearchViewModel>(
        builder: (context, data, child) {
          _query.text = data.currQuery;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search People",
                    border: InputBorder.none,
                    suffixIcon: data.currQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _query.clear();
                        data.clearSearch();
                      },
                    )
                        : null,
                  ),
                  controller: _query,
                  onSubmitted: _onSubmit,
                  textInputAction: TextInputAction.search,
                ),
              ),

              Expanded(
                child: () {
                  if (data.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (data.errorMessage.isNotEmpty) {
                    return Center(child: Text("Error: ${data.errorMessage}"));
                  }
                  return ListView.builder(
                    itemCount: data.users.length,
                    itemBuilder: (context, index) {
                      final user = data.users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  );
                }(),
              ),
            ],
          );
        },
      ),
    );
  }
}

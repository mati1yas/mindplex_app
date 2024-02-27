import 'package:flutter/material.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({
    super.key,
    required TextEditingController searchTextEditingController,
    required this.searchController,
  }) : searchTextEditingController = searchTextEditingController;

  final TextEditingController searchTextEditingController;
  final SearchPageController searchController;

  FocusNode _focusNode = FocusNode();

  void performSearch() {
    if (searchTextEditingController.text.isNotEmpty) {
      searchController.fetchSearchResults(searchTextEditingController.text);

      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                focusNode: _focusNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: searchTextEditingController,
                textAlign: TextAlign.end,
                onFieldSubmitted: (String value) {
                  searchController.isSearchResultPage.value = true;

                  performSearch();
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {},
                validator: (value) {},
              ),
            ),
            Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: GestureDetector(
                  onTap: () => performSearch(),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/lists/language_list.dart';
import 'package:learnd/screens/screens.dart';
import 'package:learnd/widgets/widgets.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ColorPallete.backgroundColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
            
              controller: _textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorPallete.componentsBackgroundColor,
                border: InputBorder.none,
                  suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _textController.clear();
                },
              ),
                hintText: "Search",
              ),
             
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<SearchCubit>().searchUsers(value.trim());
                }
              },
            ),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return Center(child: Text(state.failure.message));
              case SearchStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.languages.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.languages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final language = state.languages[index];
                          return ListTile(
                            title: Text(
                              language.language,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: ColorPallete.lightTextColor),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                              LanguageScreen.routeName,
                              arguments: LanguageScreenArgs(
                                  language: language.language),
                            ),
                          );
                        },
                      )
                    : Center(child: Text('No languages found((('));
              default:
                return Padding(
                  padding: const EdgeInsets.only(left: 24, top: 20,right: 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Filters",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15,),
                      Expanded(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: (2 / 1),
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: languages.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Center(
                              child: SearchContainer(
                                name: languages[index],
                                onTap: () => Navigator.of(context).pushNamed(
                                  LanguageScreen.routeName,
                                  arguments: LanguageScreenArgs(
                                      language: languages[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

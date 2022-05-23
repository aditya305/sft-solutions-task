import 'package:flutter/material.dart';
import 'package:stic_soft_task/models/models.dart';
import 'package:stic_soft_task/presentation/home_screen/home_screen.dart';
import 'package:stic_soft_task/services/read_json_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  late List<ProductDataModel> initialList;
  List _resultList = [];
  Future? resultsLoaded;

  @override
  void initState() {
    getOneList();
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void getOneList() async {
    initialList = await ReadJsonSingleton.ReadJsonData();
  }

  @override
  dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    debugPrint(searchController.text);
    searchResult();
  }

  getList() async {
    searchResult();
    return "complete";
  }

  searchResult() {
    var showResults = [];
    if (searchController.text.isNotEmpty) {
      for (ProductDataModel item in initialList) {
        String abc = item.name.toLowerCase() + item.description.toLowerCase();
        if (searchController.text.contains(abc)) {
          showResults.add(item);
        } else {
          showResults = List.from(initialList);
        }
      }
    }
    setState(() {
      _resultList = showResults;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        return false;
      },
      child: SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 14, 12, 10),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                  fillColor: Color(0xffF0F0F0),
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context)
                        .size
                        .height, //height of TabBarView
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _resultList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 7.0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            title: Text(
                              _resultList[index].name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            subtitle: Text(
                              _resultList[index].description,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              _resultList[index].quantity.toString(),
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

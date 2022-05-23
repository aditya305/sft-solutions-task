import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stic_soft_task/models/models.dart';
import 'package:stic_soft_task/presentation/search_screen/search_screen.dart';
import 'package:stic_soft_task/services/read_json_service.dart';
import 'package:stic_soft_task/services/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();
  late Timer _timer;

  List<ProductDataModel> recomList = [];

  @override
  void initState() {
    super.initState();
    getList();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) => changeQuantity(),
    );
  }

  void getList() async {
    recomList = await ReadJsonSingleton.ReadJsonData();
    setState(() {});
  }

  @override
  void dispose() {
    // print("dispose");
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe5e5e5),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Products",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              ),
              icon: const Icon(
                Icons.search,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: TextField(
                readOnly: true,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 14, 12, 10),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                  fillColor: Color(0xffFafafa),
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: recomList.isEmpty
                  ? const Center(
                      child: Text(
                          "Please wait for 2 seconds. The data is loading"),
                    )
                  : Scrollbar(
                      controller: _controller,
                      interactive: true,
                      thumbVisibility: true,
                      trackVisibility: true,
                      thickness: 9.0,
                      radius: const Radius.circular(50.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        controller: _controller,
                        itemCount: recomList.length,
                        padding: const EdgeInsets.all(10.0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 7.0),
                        itemBuilder: (context, index) {
                          return Card(
                            color: const Color(0xffFFFFFF),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                title: Text(
                                  recomList[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                subtitle: Text(
                                  recomList[index].description,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                trailing: Text(
                                  recomList[index].quantity.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ));
  }

  void changeQuantity() {
    if (recomList.isEmpty) {
    } else {
      final int index = Random().nextInt(recomList.length);
      // print("old ${recomList[index]}");
      ProductDataModel pd = recomList[index];
      pd = pd.copyWith(quantity: (pd.quantity - 1) <= 0 ? 0 : pd.quantity - 1);
      recomList.removeAt(index);
      recomList.insert(index, pd);
      setState(() {});
      NotificationService().showNotifications(
        1,
        // "title",
        "Only ${pd.quantity} ${pd.name} available now",
        // "body",
        // 10,
      );
    }
    // print("new ${recomList[index]}");
  }
}

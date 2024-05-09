import 'dart:math';

import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:assign/data/repositories/fetchdatarepository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assign/presentation/pages/tablepage.dart';

import '../controllers/datafetchcontroller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataFetchController datasourcecontroller = Get.put(DataFetchController());
  final TextEditingController _searchController = TextEditingController();
  final String routeName = '/country_view';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithSearchSwitch(
          backgroundColor: Color.fromARGB(255, 253, 63, 63),
          onChanged: (text) {
            datasourcecontroller.setfiterString(text);
          },
          appBarBuilder: (context) {
            return AppBar(
              title: const Text('Countries'),
              backgroundColor: Color.fromARGB(255, 1, 0, 75),
              actions: const [
                AppBarSearchButton(),
              ],
            );
          },
        ),
        body: GetBuilder<DataFetchController>(
          builder: (controller) => datasourcecontroller
                  .fetchdataResponse.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(46, 49, 146, 0.733),
                      Color.fromRGBO(27, 255, 255, 0.671)
                    ],
                  )),
                  child: RefreshIndicator(
                    onRefresh: () {
                      return FetchdataRepositoryImpl().fetchdata();
                    },
                    backgroundColor: Colors.teal,
                    color: Colors.white,
                    displacement: 200,
                    strokeWidth: 5,
                    child: ListView.builder(
                      itemCount: datasourcecontroller.fetchdataResponse.length,
                      itemBuilder: (_, index) {
                        return ExpansionTile(
                            title: Text(
                              datasourcecontroller.fetchdataResponse[index].key
                                  .toString(),
                              style:
                                  TextStyle(fontFamily: 'Lato', fontSize: 20),
                            ),
                            children: [
                              ...datasourcecontroller
                                  .fetchdataResponse[index].value.entries
                                  .map((e) {
                                return ListTile(
                                  onTap: () {
                                    print(e.value.first);
                                    Navigator.pushNamed(
                                      context,
                                      routeName,
                                      arguments: e.value.first,
                                    );
                                  },
                                  title: cardComponent(e),
                                );
                              })
                            ]);
                      },
                    ),
                  ),
                ),
        ));
  }

  Widget cardComponent(countryModel) {
    countryModel = countryModel.value.first;
    return SizedBox(
      height: 100,
      child: Card(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      countryModel['flags']['png'],
                    )),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: Colors.redAccent,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        countryModel['name']['common'],
                        maxLines: 2,
                        style: const TextStyle(
                            fontFamily: 'Times new roman',
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                      )),
                  Container(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: Text('Population : ${countryModel['population']}',
                          style: const TextStyle(
                              fontFamily: 'Ariel',
                              color: Colors.black,
                              overflow: TextOverflow.clip))),
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                          'Capital : ${countryModel['capital'] != null ? countryModel['capital'][0] : ''}',
                          style: const TextStyle(
                              fontFamily: 'Ariel',
                              color: Colors.black,
                              overflow: TextOverflow.clip))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

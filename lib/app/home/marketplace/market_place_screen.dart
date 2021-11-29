import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:randolina/app/home/marketplace/new_product/add_product_screen.dart';
import 'package:randolina/app/models/event.dart';
import 'package:randolina/app/models/product.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/auth.dart';
import 'package:randolina/services/database.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({Key? key}) : super(key: key);

  @override
  _MarketPlaceScreenState createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextStyle textstyle;
  late int tabIndex;
  final bool isClient = false;
  final RefreshController _refreshController = RefreshController();
  late ValueNotifier<List<Event>> currentlyChosenEventsNotifier;

  @override
  void initState() {
    currentlyChosenEventsNotifier = ValueNotifier([]);
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => setState(() {}));
    textstyle = TextStyle(
      color: darkBlue,
      fontWeight: FontWeight.w800,
    );

    super.initState();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            if (!isClient && _tabController.index == 0) ...[
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 8.0, right: 8, left: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddProductScreen(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ajouter',
                        style:
                            TextStyle(color: Color.fromRGBO(51, 77, 115, 0.78)),
                      ),
                      Icon(Icons.add, color: Color.fromRGBO(51, 77, 115, 0.78))
                    ],
                  ),
                ),
              ),
            ],
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return Center(
                    child: Text(
                        "length product in BDD: ${snapshot.data!.docs.length}"),
                  );
                } else {
                  return Center(
                    child: Text('BDD is Empty'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

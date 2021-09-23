import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home_admin/sites/new_site_screen.dart';
import 'package:randolina/app/home_admin/sites/site.dart';
import 'package:randolina/app/home_admin/sites/sites_bloc.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({Key? key}) : super(key: key);

  @override
  _SitesScreenState createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  late final SitesBloc sitesBloc;
  late final Stream<List<Site>> stream;

  @override
  void initState() {
    sitesBloc = SitesBloc(database: context.read<Database>());
    stream = sitesBloc.getSites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('localisation'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewSiteScreen(
                      sitesBloc: sitesBloc,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
        body: StreamBuilder<List<Site>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Site> items = snapshot.data!;
              if (items.isNotEmpty) {
                return _buildList(items);
              } else {
                return EmptyContent();
              }
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: "Can't load items right now",
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Site> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0,
                            )
                          ],
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewSiteScreen(
                                  sitesBloc: sitesBloc,
                                  site: items[index],
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(0.0)),
                          ),
                          child: Text('Edit'),
                        ),
                      ),
                    ),
                    Text(
                      items[index].title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sitesBloc.deleteSite(items[index]);
                      },
                      icon: Icon(Icons.delete),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      color: Color.fromRGBO(51, 77, 115, 0.05),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 8,
                      ),
                      child: Text(
                        items[index].url,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

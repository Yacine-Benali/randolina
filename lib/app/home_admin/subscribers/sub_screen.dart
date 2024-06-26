import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home_admin/admin_logout.dart';
import 'package:randolina/app/home_admin/subscribers/sub_bloc.dart';
import 'package:randolina/app/home_admin/subscribers/sub_search.dart';
import 'package:randolina/app/home_admin/subscribers/sub_tile.dart';
import 'package:randolina/app/models/subscription.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';
import 'package:tuple/tuple.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({Key? key}) : super(key: key);

  @override
  _SubScreenState createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  late Stream<List<Tuple2<Subscription, User>>> unapprovedUsers;
  late final SubBloc bloc;
  late List<Tuple2<Subscription, User>> usersList = [];

  @override
  void initState() {
    bloc = SubBloc(database: context.read<Database>());
    unapprovedUsers = bloc.getUnApporvedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: StreamBuilder<List<Tuple2<Subscription, User>>>(
        stream: unapprovedUsers,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              actions: [AdminLogout()],
              iconTheme: IconThemeData(color: darkBlue),
              title: Text(
                'Club et Agence',
                style: TextStyle(color: Colors.black),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 25,
                  ),
                  color: darkBlue,
                  onPressed: () {
                    if (usersList.isNotEmpty) {
                      showSearch(
                        context: context,
                        delegate: SubSearch(subBloc: bloc, users: usersList),
                      ).then((value) => setState(() {}));
                    }
                  },
                ),
              ),
            ),
            body: buildBody(snapshot),
          );
        },
      ),
    );
  }

  Widget buildBody(AsyncSnapshot<List<Tuple2<Subscription, User>>> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      final List<Tuple2<Subscription, User>> items = snapshot.data!;
      usersList = items;

      if (items.isNotEmpty) {
        final List<Widget> list = [];
        for (final Tuple2<Subscription, User> user in items) {
          final temp = SubTile(
            key: Key(user.item1.id),
            tuple: user,
            subBloc: bloc,
          );
          list.add(temp);
        }

        return SingleChildScrollView(child: Column(children: list));
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: EmptyContent(
            title: '',
            message: '',
          ),
        );
      }
    } else if (snapshot.hasError) {
      logger.severe(snapshot.error);
      return EmptyContent(
        title: "Quelque chose s'est mal passé",
        message: "Impossible de charger les éléments pour le moment",
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}

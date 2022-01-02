import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home_admin/admin_logout.dart';
import 'package:randolina/app/home_admin/approved/approved_bloc.dart';
import 'package:randolina/app/home_admin/approved/approved_user_tile.dart';
import 'package:randolina/app/home_admin/approved/nested_screens/approved_screen_search.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';
import 'package:randolina/utils/logger.dart';

class ApprovedScreen extends StatefulWidget {
  const ApprovedScreen({Key? key}) : super(key: key);

  @override
  _ApprovedScreenState createState() => _ApprovedScreenState();
}

class _ApprovedScreenState extends State<ApprovedScreen> {
  late Stream<List<User>> unapprovedUsers;
  late final ApprovedBloc bloc;
  late List<User> usersList = [];

  @override
  void initState() {
    bloc = ApprovedBloc(database: context.read<Database>());
    unapprovedUsers = bloc.getUnApporvedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: StreamBuilder<List<User>>(
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
                    logger.info(usersList.length);
                    if (usersList.isNotEmpty) {
                      showSearch(
                        context: context,
                        delegate: ApproveSearch(
                          approvedBloc: bloc,
                          users: usersList,
                        ),
                      );
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

  Widget buildBody(AsyncSnapshot<List<User>> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      final List<User> items = snapshot.data!;
      usersList = items;
      if (items.isNotEmpty) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            return ApprovedUserTile(
              user: items[index],
              bloc: bloc,
            );
          },
        );
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
      return EmptyContent(
        title: "Quelque chose s'est mal passé",
        message: "Impossible de charger les éléments pour le moment",
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}

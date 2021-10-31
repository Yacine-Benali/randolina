import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randolina/app/home_admin/approved/agency_detail_screen.dart';
import 'package:randolina/app/home_admin/approved/approved_bloc.dart';
import 'package:randolina/app/home_admin/approved/club_detail_screen.dart';
import 'package:randolina/app/models/agency.dart';
import 'package:randolina/app/models/club.dart';
import 'package:randolina/app/models/user.dart';
import 'package:randolina/common_widgets/empty_content.dart';
import 'package:randolina/constants/app_colors.dart';
import 'package:randolina/services/database.dart';

class ApprovedScreen extends StatefulWidget {
  const ApprovedScreen({Key? key}) : super(key: key);

  @override
  _ApprovedScreenState createState() => _ApprovedScreenState();
}

class _ApprovedScreenState extends State<ApprovedScreen> {
  late Stream<List<User>> unapprovedUsers;
  late final ApprovedBloc bloc;

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
              iconTheme: IconThemeData(color: darkBlue),
              title: Text(
                'Club et Agence',
                style: TextStyle(color: Colors.black),
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
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: EmptyContent(
            title: 'Aucun message ne suit les personnes pour commencer',
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

  Widget _buildList(List<User> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        final miniUser = items[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(47),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: miniUser.profilePicture,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text(miniUser.name),
          subtitle: Text(miniUser.username),
          onTap: () {
            if (miniUser is Club) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ClubDetailScreen(club: miniUser, bloc: bloc),
                ),
              );
            }
            if (miniUser is Agency) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AgencyDetailScreen(agency: miniUser, bloc: bloc),
                ),
              );
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:randolina/app/home_admin/sites/site.dart';
import 'package:randolina/app/home_admin/sites/sites_bloc.dart';
import 'package:randolina/common_widgets/custom_elevated_button.dart';
import 'package:randolina/common_widgets/custom_text_field.dart';

class NewSiteScreen extends StatefulWidget {
  const NewSiteScreen({
    Key? key,
    required this.sitesBloc,
    this.site,
  }) : super(key: key);

  final SitesBloc sitesBloc;
  final Site? site;

  @override
  _NewSiteScreenState createState() => _NewSiteScreenState();
}

class _NewSiteScreenState extends State<NewSiteScreen> {
  late String title;
  late String url;
  late String id;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    if (widget.site != null) {
      title = widget.site!.title;
      url = widget.site!.url;
      id = widget.site!.id;
    } else {
      id = widget.sitesBloc.database.getUniqueId();
      title = '';
      url = '';
    }
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Ajouter',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextForm(
                initialValue: title,
                title: 'titre',
                hintText: 'titre',
                titleStyle: TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (t) {
                  title = t;
                },
                validator: (t) {
                  if (t != null) {
                    if (t.isEmpty) {
                      return 'error';
                    }
                  } else {
                    return 'error';
                  }
                },
              ),
              CustomTextForm(
                initialValue: url,
                title: 'lien',
                hintText: 'lien',
                titleStyle: TextStyle(color: Colors.black, fontSize: 16),
                onChanged: (t) {
                  url = t;
                },
                validator: (t) {
                  if (t != null) {
                    if (t.isEmpty) {
                      return 'error';
                    }
                  } else {
                    return 'error';
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
                child: CustomElevatedButton(
                  buttonText: Text('enregistrer'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final Site site = Site(title: title, url: url, id: id);
                      await widget.sitesBloc.createSite(site);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  minHeight: 60,
                  minWidth: 600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

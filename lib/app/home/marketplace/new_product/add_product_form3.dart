import 'package:flutter/material.dart';
import 'package:randolina/app/home/marketplace/widgets/new_button.dart';
import 'package:randolina/app/home/marketplace/widgets/pickers/rgb_picker_page.dart';

class AddProductForm3 extends StatefulWidget {
  const AddProductForm3({
    Key? key,
    required this.colors,
    required this.sizes,
    required this.onNextPressed,
  }) : super(key: key);
  final List<dynamic>? colors;
  final List<dynamic>? sizes;
  final void Function({
    required List<dynamic> colors,
    required List<dynamic> sizes,
  }) onNextPressed;

  @override
  _AddProductForm3State createState() => _AddProductForm3State();
}

class _AddProductForm3State extends State<AddProductForm3> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int value = 0;
  late Color? color;
  late String? size;
  Orientation orientation = Orientation.portrait;
  late List<dynamic> colors = [];
  late List<dynamic> sizes = [];

  @override
  void initState() {
    if (widget.colors != null) {
      colors = widget.colors!;
    }
    if (widget.sizes != null) {
      sizes = widget.sizes!;
    }
    super.initState();
  }

  Widget buildTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(51, 77, 115, 0.88),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future showErreur(String title) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildTitle('Erreur'),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(title),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget buildCircelColor(Color? color, Icon? icon) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            if (icon != null) {
              // ignore: parameter_assignments
              color = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RGBPickerPage(),
                ),
              );
              if (color != null) {
                print(colors);
                print('diohgr $color');
                // ignore: parameter_assignments
                if (!colors.contains(color!.value)) {
                  // ignore: parameter_assignments
                  colors.add(color!.value);
                } else {
                  showErreur('Couleur deja choisie');
                }
              }
              setState(() {});
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(66),
              border: icon != null
                  ? Border.all(
                      width: 2,
                      color: Color(0xFF40BFFF),
                    )
                  : Border.all(
                      color: Color(0xFFEBF0FF),
                    ),
            ),
            child: Center(
              child: color == Color(0xFFEBF0FF) ? icon : null,
            ),
          ),
        ),
        if (icon == null)
          GestureDetector(
            onTap: () {
              // ignore: parameter_assignments
              colors.remove(color!.value.toString());
              setState(() {});
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.cancel, color: Colors.grey),
            ),
          ),
      ],
    );
  }

// ignore: avoid_positional_boolean_parameters
  Widget buildCircelSized(String title, bool select) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            if (select) {
              size = await selectSized();
              if (size != null) {
                if (!sizes.contains(size)) {
                  sizes.add(size);
                } else {
                  showErreur('Taille deja choisie');
                }
              }

              setState(() {});
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(66),
              border: select
                  ? Border.all(
                      width: 2,
                      color: Color(0xFF40BFFF),
                    )
                  : Border.all(
                      color: Color(0xFFEBF0FF),
                    ),
            ),
            child: Center(
              child: !select
                  ? Text(title)
                  : Icon(Icons.add, color: Color(0xFF40BFFF)),
            ),
          ),
        ),
        if (!select)
          GestureDetector(
            onTap: () {
              sizes.remove(title);
              setState(() {});
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.cancel, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Future<String?> selectSized() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildTitle('Entrer la taille'),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                            hintText: 'Entrer la taille',
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Entrer une valeur';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            size = value;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Navigator.pop(context, size);
                            }
                          },
                          child: Text("Soumettre"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 40, right: 30, bottom: 7),
            child: ListView(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTitle('Ajouter les couleurs'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 200,
                  child: CustomScrollView(
                    slivers: [
                      // This one is scrolled first
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 3 : 6),
                        delegate: SliverChildListDelegate([
                          buildCircelColor(
                            Color(0xFFEBF0FF),
                            Icon(Icons.add, color: Color(0xFF40BFFF)),
                          ),
                          for (int i = 0; i < colors.length; i++)
                            buildCircelColor(
                              Color(int.parse(colors[i].toString())),
                              null,
                            ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Color(0xFF000000).withOpacity(0.37),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 40, right: 30, bottom: 7),
            child: ListView(
              //   mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTitle('Ajouter les tailles'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 200,
                  child: CustomScrollView(
                    slivers: [
                      // This one is scrolled first
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 3 : 6),
                        delegate: SliverChildListDelegate([
                          buildCircelSized(
                            '',
                            true,
                          ),
                          for (int i = 0; i < sizes.length; i++)
                            buildCircelSized(
                              sizes[i].toString(),
                              false,
                            ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 20),
          child: NextButton(
            onPressed: () {
              widget.onNextPressed(
                colors: colors,
                sizes: sizes,
              );
            },
          ),
        ),
      ],
    );
  }
}

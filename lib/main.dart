import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: PickIcon(),
  ));
}

class PickIcon extends StatefulWidget {
  @override
  _PickIconState createState() => _PickIconState();
}

class _PickIconState extends State<PickIcon> {
  ValueNotifier valueNotifier = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Icon Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                return valueNotifier.value != ''
                    ? Icon(MdiIcons.fromString(valueNotifier.value))
                    : Container();
              },
            ),
            RaisedButton(
              child: Text("Pick Icon"),
              onPressed: () => myPickIcon(),
            ),
          ],
        ),
      ),
    );
  }

  myPickIcon() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick an Icon!"),
            content: MyIconDialogContent(valueNotifier),
          );
        });
  }
}

class MyIconDialogContent extends StatefulWidget {
  final ValueNotifier valueNotifier;
  MyIconDialogContent(this.valueNotifier);
  @override
  _MyIconDialogContentState createState() => _MyIconDialogContentState();
}

class _MyIconDialogContentState extends State<MyIconDialogContent> {
  List<Widget> iconList = [];
  List<String> avialableIconNameList = [];
  String searchText = '';
  TextEditingController searchController = TextEditingController();
  bool searching = false;
  @override
  void initState() {
    super.initState();
    _buildIcons();
    // add every icon's name in this list
    iconMap.forEach((String key, int val) {
      avialableIconNameList.add(key);
    });
  }

  _buildIcons() async {
    iconMap.forEach((String key, int val) async {
      iconList.add(InkResponse(
          onTap: () {
            print("Chose $key");
            setState(() {
              widget.valueNotifier.value = key;
            });
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          },
          child: Icon(
            MdiIcons.fromString(key),
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: 300,
      child: Column(
        children: <Widget>[
          // Search bar
          Container(
            height: 35,
            width: 300,
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                searchText = val;
                setState(() {
                  if (searchController.text.isEmpty) {
                    searching = false;
                  } else {
                    searching = true;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search icon...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    print("Pressed");
                  },
                ),
              ),
            ),
          ),
          searching == false
              ? Container(
                  child: SingleChildScrollView(
                      child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: 300,
                  child: GridView.count(
                    crossAxisCount: 5,
                    children: iconList,
                  ),
                )))
              : searchingContainer(),
        ],
      ),
    );
  }

  Widget searchingContainer() {
    List matchedList = [];
    List<Widget> matchedIconList = [];
    for (int i = 0; i < avialableIconNameList.length; i++) {
      if (avialableIconNameList[i]
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        matchedList.add(avialableIconNameList[i]);
      }
    }
    if (matchedList != []) {
      for (int i = 0; i < matchedList.length; i++) {
        iconMap.forEach((String key, int val) {
          if (matchedList[i] == key) {
            matchedIconList.add(InkResponse(
                onTap: () {
                  print("Chose $key");

                widget.valueNotifier.value = key;
                  Navigator.pop(context);
                },
                child: Icon(
                  MdiIcons.fromString(key),
                )));
          }
        });
      }
      return Container(
          child: SingleChildScrollView(
              child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: 300,
        child: GridView.count(
          crossAxisCount: 5,
          children: matchedIconList,
        ),
      )));
    } else {
      print("No match");
      return Text("There isn't match icon");
    }
  }
}

import 'package:counter_app/color.dart';
import 'package:counter_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final boxDB = Hive.box("counterData"); //Call Box

  List dataList = [];

  @override
  void initState() {
    super.initState();
    if (boxDB.get("counterData") != null) {
      dataList = boxDB.get("counterData"); //Read All Data in BoxDB
    } else {
      boxDB.put("counterData", []);
    }
    // print(dataList);
  }

  void deleteCounter(int index) async {
    dataList.removeAt(index);
    await boxDB.put("counterData", dataList);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => MenuPage()));
    setState(() {
      Navigator.of(context).pop();
    });
  }

  //Dialog Delete Confirmation
  void _dialogBoxSave(int index) {
    Dialog errorDialog = Dialog(
      // backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 150.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Are you sure want to delete this?',
                style: TextStyle(color: textIconColor),
              ),
            ),
            // Padding(padding: EdgeInsets.only(top: 50.0)),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No!',
                      style: TextStyle(color: textIconColor, fontSize: 18.0),
                    )),
                TextButton(
                    onPressed: () {
                      deleteCounter(index);
                    },
                    child: Text(
                      'Yes!',
                      style: TextStyle(color: textIconColor, fontSize: 18.0),
                    )),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => errorDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counting History",
          style: TextStyle(color: textIconColor),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SettingPage()))),
                child: Icon(
                  Icons.settings,
                  color: textIconColor,
                )),
          )
        ],
      ),
      body: dataList.isEmpty
          ? Center(
              child: Text(
                "Oops, no data to show here!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: textIconColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: SizedBox(
                    width: 75,
                    child: Center(
                      child: Text(
                        dataList[index][1].toString(),
                        style: TextStyle(
                          fontSize: 35,
                          color: textIconColor,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    dataList[index][0],
                    style: TextStyle(
                      color: textIconColor,
                    ),
                  ),
                  subtitle: Text(
                    dataList[index][2],
                    style: TextStyle(
                      color: textIconColor.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _dialogBoxSave(index),
                    child: Icon(
                      Icons.delete_rounded,
                      color: textIconColor,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

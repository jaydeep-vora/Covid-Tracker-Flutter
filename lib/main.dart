import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:india_covid19_data/StateWiseData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'India Covid-19',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<StateWiseData> stateWiseList = [];
  StateWiseData totalCase;

  int selectedStateIndex;

  Color secondaryColor = Color.fromRGBO(108, 117, 125, 1);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCompleted(context));
    super.initState();
  }

  loadCompleted(BuildContext context) async {
    stateWiseList = await _getCovidPatientsData();
    totalCase = stateWiseList.removeAt(0);
    print(stateWiseList.map((element) => element.state));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 20, 38, 1),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 12,
              ),
              Text(
                "India Covid-19 Case",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "verdana",
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              totalCase == null
                  ? Container()
                  : Text(
                      "Last Updated on " + totalCase.lastupdatedtime,
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: "verdana",
                          fontSize: 14),
                    ),
              SizedBox(
                height: 12,
              ),
              _totalSection(),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedStateIndex != null &&
                              selectedStateIndex == index) {
                            selectedStateIndex = null;
                          } else {
                            selectedStateIndex = index;
                          }
                        });
                      },
                      child: _stateItemWidget(stateWiseList[index], index));
                },
                itemCount: stateWiseList.length,
              ))
            ],
          ),
        ));
  }

  Widget _totalSection() {
    return totalCase != null
        ? Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            margin: EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
                color: Color.fromRGBO(108, 117, 125, 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(
                      color: secondaryColor,
                      fontFamily: "verdana",
                      fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _sectionType("Confirmed", totalCase.confirmed,
                        totalCase.deltaconfirmed, true),
                    _sectionType("Active", totalCase.active, "0", true),
                    _sectionType("Recoverd", totalCase.recovered,
                        totalCase.deltarecovered, false),
                    _sectionType(
                        "Death", totalCase.deaths, totalCase.deltadeaths, true),
                  ],
                )
              ],
            ),
          )
        : Container();
  }

  Widget _sectionType(String type, count, delta, bool isDanger) {
    return Column(
      children: <Widget>[
        Text(
          type,
          style: TextStyle(
              color: secondaryColor, fontSize: 16, fontFamily: "verdana"),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: <Widget>[
            delta == "0"
                ? Container()
                : Text(
                    "+" + delta,
                    style: TextStyle(
                        color: isDanger ? Colors.red : Colors.green,
                        fontSize: 12,
                        fontFamily: "verdana"),
                  ),
            SizedBox(
              width: 2,
            ),
            Text(
              count,
              style: TextStyle(
                  color: secondaryColor, fontSize: 14, fontFamily: "verdana"),
            ),
          ],
        )
      ],
    );
  }

  Widget _stateItemWidget(StateWiseData data, int index) {
    return Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index % 2 == 0
                ? Color.fromRGBO(108, 117, 125, 0.1)
                : Colors.transparent),
        padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Text(
                    data.state,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "verdana",
                        fontSize: 16,
                        color: secondaryColor),
                  ),
                ),
                Icon(
                    selectedStateIndex == index
                        ? Icons.arrow_drop_down
                        : Icons.arrow_right,
                    size: 30,
                    color: secondaryColor)
              ],
            ),
            selectedStateIndex == index
                ? Container(
                    padding: EdgeInsets.only(
                        top: 12, left: 16, bottom: 4, right: 12),
                    child: Column(
                      children: <Widget>[
                        _caseTypeView("Confirmed", data.confirmed,
                            data.deltaconfirmed, true),
                        _caseTypeView("Active", data.active, "0", true),
                        _caseTypeView("Recoverd", data.recovered,
                            data.deltarecovered, false),
                        _caseTypeView(
                            "Death", data.deaths, data.deltadeaths, true),
                      ],
                    ),
                  )
                : Container()
          ],
        ));
  }

  Widget _caseTypeView(String type, count, delta, bool isDanger) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.radio_button_checked,
            size: 14,
            color: isDanger ? Colors.red : Colors.green,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(type,
                  style: TextStyle(
                    color: secondaryColor,
                    fontFamily: "verdana",
                  ))),
          delta == "0"
              ? Container()
              : Text(
                  "+" + delta,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDanger ? Colors.red : Colors.green,
                    fontFamily: "verdana",
                  ),
                ),
          SizedBox(
            width: 6,
          ),
          Text(count,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "verdana",
                color: secondaryColor,
              )),
        ],
      ),
    );
  }

  Future<List<StateWiseData>> _getCovidPatientsData() async {
    var response = await http.get('http://localhost:8080/api/covid19');
    if (response.statusCode == 200) {
      return CovidPatientsResponse.fromJson(json.decode(response.body)).data;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

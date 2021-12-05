import 'package:flutter/material.dart';
import 'package:laundromats/register_page.dart';
import 'package:laundromats/widgets/custom_checkbox.dart';
import 'package:laundromats/widgets/primary_button.dart';
import '../theme.dart';
import 'package:laundromats/listview_result.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPage createState() => _ListPage();
}

class _ListPage extends State<ListPage> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Laundromats"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: '),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Use Current Location',
                            hintStyle: heading6.copyWith(color: textGrey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Radius (km): '),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: '3',
                            hintStyle: heading6.copyWith(color: textGrey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Price Range: '),
                  SizedBox(
                    height: 20,
                  ),
                  RangeSlider(
                    values: _currentRangeValues,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(14.0),
                    elevation: 0,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListViewResult()));
                          },
                          borderRadius: BorderRadius.circular(14.0),
                          child: Center(
                            child: Text(
                              'Results',
                              style: heading5.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

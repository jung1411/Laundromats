import 'package:flutter/material.dart';

class ListViewResult extends StatefulWidget {
  const ListViewResult({Key? key}) : super(key: key);

  @override
  _ListViewResultState createState() => _ListViewResultState();
}

class _ListViewResultState extends State<ListViewResult> {
  List<Result> results = Result.generateData();
  bool resultAscending = true;
  int upvoteIndex = 0;
  int dowvoteIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Results")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
              sortColumnIndex: 0,
              sortAscending: true,
              columns: [
                DataColumn(
                    label: const Text("Name"),
                    onSort: (i, b) {
                      setState(() {
                        if (resultAscending == true) {
                          resultAscending = false;
                          results.sort((b, a) => a.name.compareTo(b.name));
                        } else {
                          resultAscending = true;
                          results.sort((a, b) => a.name.compareTo(b.name));
                        }
                      });
                    }),
                DataColumn(
                    label: const Text('Price'),
                    onSort: (i, b) {
                      setState(() {
                        if (resultAscending == true) {
                          resultAscending = false;
                          results.sort((b, a) => a.name.compareTo(b.name));
                        } else {
                          resultAscending = true;
                          results.sort((a, b) => a.name.compareTo(b.name));
                        }
                      });
                    }),
                DataColumn(
                    label: const Text('Distance'),
                    onSort: (i, b) {
                      setState(() {
                        if (resultAscending == true) {
                          resultAscending = false;
                          results.sort((b, a) => a.name.compareTo(b.name));
                        } else {
                          resultAscending = true;
                          results.sort((a, b) => a.name.compareTo(b.name));
                        }
                      });
                    }),
              ],
              rows: results
                  .map((e) => DataRow(
                        cells: [
                          DataCell(Text(e.name)),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r"$" + e.price.toString()),
                            ],
                          )),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.distance.toString() + " km"),
                            ],
                          )),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Result {
  String name;
  double price;
  double distance;

  Result(this.name, this.price, this.distance);

  static List<Result> generateData() {
    return [
      Result("John Doe's Laundromat", 5.00, 2),
      Result("Bob Smith Laundromat", 6.00, 3.2),
      Result("Jane Doe's Laundromat", 5.00, 0.5),
      Result("Toronto Laundromat", 5.50, 1),
      Result("General Laundromat", 5.25, 2),
    ];
  }
}

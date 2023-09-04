import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';
import 'package:mainsenapatirajasthanadmin/utils/colorconstants.dart';

class AllDistrict extends StatefulWidget {
  const AllDistrict({super.key});

  @override
  State<AllDistrict> createState() => _AllDistrictState();
}

class _AllDistrictState extends State<AllDistrict> {
  List districtList = [];

  fetchDistrict() async {
    districtList.clear();
    districtRef.get().then((value) {
      if (value.docs.isEmpty) {
        districtList = value.docs;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'District',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: ColorConstants.backgroundColor,
        body: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              height: MediaQuery.of(context).size.height / 1,
              child: StreamBuilder(
                  stream: districtRef
                      .orderBy('districtCode', descending: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                        "Somthing went Wrong",
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                          child: Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white),
                      ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return !snapshot.hasData || snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Text(''),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: createDataTable(
                                  snapshot.data!.docs,
                                )),
                          );
                  }),
            ),
          ),
        ));
  }

  header() {
    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      width: MediaQuery.of(context).size.width / 2,
      child: Row(
        children: [
          customContainer('District Code'),
          customContainer('District English'),
          customContainer('District Hindi'),
        ],
      ),
    );
  }

  customContainer(String title) {
    return Flexible(
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(border: Border()),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  showData() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [],
          )
        ],
      ),
    );
  }

  DataTable createDataTable(
    list,
  ) {
    return DataTable(
        border: TableBorder.all(color: Colors.black),
        columns: _createColumns(),
        rows: _createRows(
          list,
        ));
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(
          label: Text(
        'District Code',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'District English',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'District Hindi',
        style: TextStyle(color: Colors.white),
      )),
    ];
  }

  List<DataRow> _createRows(
    List list,
  ) {
    return list.map((e) {
      return DataRow(
          color: MaterialStateColor.resolveWith((states) => Colors.white),
          cells: [
            dataCell(e['districtCode'].toString()),
            dataCell(e['nameEnglish'].toString()),
            dataCell(e['nameHindi'].toString()),
          ]);
    }).toList();
  }

  DataCell dataCell(
    String title,
  ) {
    return DataCell(Text(title));
  }

  heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: const Text('Name'),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: const Text('Phone-Number'),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: const Text('District Name'),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: const Text('Vidhansabha Name'),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: const Text('Age'),
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';

class ViewData extends StatefulWidget {
  const ViewData({super.key});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  //  DataTable _createDataTable(list,) {
  //   return DataTable(
  //       border: TableBorder.all(color: Colors.black),
  //       columns: _createColumns(),
  //       rows: _createRows(list,));
  // }

  // List<DataColumn> _createColumns() {
  //   return [
  //     const DataColumn(label: Text('District')),
  //  const   DataColumn(label: Text('Vidhansabha')),
  //   const  DataColumn(label: Text('Vidhan-code')),
  //   const  DataColumn(label: Text('Group-code')),
  //   const  DataColumn(label: Text('Group-link')),
  //   ];
  // }

  // List<DataRow> _createRows(List list,) {
  //   return list.map((e) {
  //     return DataRow(cells: [
  //       dataCell(
  //           e[volunteerProvider.keys.acNo].toString()),
  //      ]);
  //   }).toList();
  // }

  DataCell dataCell(
    String title,
  ) {
    return DataCell(Text(title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: whatsappRef.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Somthing went Wrong");
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(child: CircularProgressIndicator());
            }
            return !snapshot.hasData
                ? Container()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        heading(),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return snapshot.data!.docs.isEmpty
                                  ? Container()
                                  : StreamBuilder(
                                      stream: whatsappRef
                                          .doc(snapshot.data!.docs[index]['id'])
                                          .collection('whatsLink')
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot1) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot1.data!.docs.length,
                                            itemBuilder: (context, index2) {
                                              if (snapshot.hasError) {
                                                return const Text(
                                                    "Somthing went Wrong");
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.none) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              return !snapshot1.hasData
                                                  ? Container()
                                                  : showData(
                                                      snapshot.data!.docs[index]
                                                          ['disName'],
                                                      snapshot.data!.docs[index]
                                                          ['nameHindi'],
                                                      snapshot.data!.docs[index]
                                                          ['vidhanCode'],
                                                      snapshot1.data!
                                                              .docs[index2]
                                                          ['grpcode'],
                                                      snapshot1.data!
                                                              .docs[index2]
                                                          ['grplink'],
                                                    );
                                            });
                                      });
                            }),
                      ],
                    ),
                  );
          }),
    );
  }

  showData(String title1, String title2, String title3, String title4,
      String title5) {
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
            child: Text(
              title1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: Text(
              title2,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: Text(
              title3,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: Text(
              title4,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: Text(
              title5,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
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
            child: Text('District'),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            child: Text('Vidhansabha'),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text('Vidhan-Code'),
          ),
        ),
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            height: 30,
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text('Group-code'),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black38)),
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            child: Text('Group-link'),
          ),
        ),
      ],
    );
  }

}

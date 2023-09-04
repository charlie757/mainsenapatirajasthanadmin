import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mainsenapatirajasthanadmin/model/usermodel.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';
import 'package:mainsenapatirajasthanadmin/utils/colorconstants.dart';
import 'package:mainsenapatirajasthanadmin/utils/showcircleprogressdialog.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  List userList = [];
  fetchData() async {
    userList.clear();
    // showCircleProgressDialog(context);
    usersRef.get().then((value) {
      print(value.docs.length);
      // Navigator.pop(context);
      for (int i = 0; i < value.docs.length; i++) {
        usersRef
            .doc(value.docs[i]['id'])
            .collection('volunteer')
            .get()
            .then((value1) {
          print(value.docs[i]['name']);
          UserModel model = UserModel(
              value.docs[i]['name'],
              value.docs[i]['number'],
              value.docs[i]['district'],
              value.docs[i]['vidhan'],
              value.docs[i]['age'],
              value.docs[i]['gendor'],
              value.docs[i]['createdAt'],
              value.docs[i]['updateAt'] ?? '',
              value1.docs.isNotEmpty ? value1.docs[0]['education'] : '-',
              value1.docs.isNotEmpty ? value1.docs[0]['occupation'] : "-",
              value1.docs.isNotEmpty ? value1.docs[0]['vehicle_type'] : "-",
              value1.docs.isNotEmpty
                  ? value1.docs[0]['govt_statisfaction']
                  : "-",
              value1.docs.isNotEmpty ? value1.docs[0]['congress_worker'] : "-",
              value1.docs.isNotEmpty ? value1.docs[0]['onground_work'] : "-");
          userList.add(model);
          setState(() {});

          print(userList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Users',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: createDataTable(userList)),
        ));
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
        'Name',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'PhoneNumber',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'District Name',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Vidhansabha Name',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Age',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Gender',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'education',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'occupation',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'vehicle_type',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'govt_statisfaction',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'congress_worker',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'onground_work',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Create Time',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Update Time',
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
            dataCell(e.name.toString()),
            dataCell(e.number.toString()),
            dataCell(e.district.toString()),
            dataCell(e.vidhansabha.toString()),
            dataCell(e.age.toString()),
            dataCell(e.gendar.toString()),
            dataCell(e.education.toString()),
            dataCell(e.occupation.toString()),
            dataCell(e.vehicleType.toString()),
            dataCell(e.govtStatisfaction.toString()),
            dataCell(e.congressWorker.toString()),
            dataCell(e.ongroundWork.toString()),
            dataCell(DateFormat('MM-dd-yyyy, hh:mm a')
                .format(DateTime.fromMillisecondsSinceEpoch(
                    e.createdAt.seconds * 1000))
                .toString()),
            dataCell(e.updateAt.toString().isEmpty
                ? '-'
                : DateFormat('MM-dd-yyyy, hh:mm a')
                    .format(DateTime.fromMillisecondsSinceEpoch(
                        e.updateAt.seconds * 1000))
                    .toString()),
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

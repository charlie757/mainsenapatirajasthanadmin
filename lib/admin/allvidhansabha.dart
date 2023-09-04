import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/custombtn.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/customtextfield.dart';
import 'package:mainsenapatirajasthanadmin/model/vidhanmodel.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';
import 'package:mainsenapatirajasthanadmin/utils/colorconstants.dart';
import 'package:mainsenapatirajasthanadmin/utils/showcircleprogressdialog.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AllVidhan extends StatefulWidget {
  const AllVidhan({super.key});

  @override
  State<AllVidhan> createState() => _AllVidhanState();
}

class _AllVidhanState extends State<AllVidhan> {
  final vidhanList = [];
  final disCodeController = TextEditingController();
  final vidhanHController = TextEditingController();
  final vidhanEController = TextEditingController();
  final vidhanCodeController = TextEditingController();
  final grpCodeController = TextEditingController();
  final grpLinkController = TextEditingController();
  final whatsappLinkController = TextEditingController();
  final counterController = TextEditingController();

  bool isLoading = false;

  fetchData() async {
    isLoading = true;
    setState(() {});
    vidhanRef
        .orderBy('vidhanCode', descending: false)
        // .limit(10)
        .get()
        .then((value) {
      vidhanList.clear();
      for (int i = 0; i < value.docs.length; i++) {
        whatsappRef
            .where('vidhanCode', isEqualTo: value.docs[i]['vidhanCode'])
            .get()
            .then((value1) {
          whatsappRef
              .doc(value1.docs[0]['id'])
              .collection('whatsLink')
              .get()
              .then((value2) {
            VidhanModel model = VidhanModel(
              value.docs[i]['districtCode'],
              value.docs[i]['vidhanCode'],
              value.docs[i]['nameEnglish'],
              value.docs[i]['nameHindi'],
              value2.docs.isNotEmpty ? value2.docs[0]['grpcode'] : '-',
              value2.docs.isNotEmpty ? value2.docs[0]['grplink'] : '-',
              value2.docs.isNotEmpty ? value2.docs[0]['counter'] : '-',
              value.docs[i]['id'],
              value1.docs[0]['id'],
              value2.docs[0]['id'],
            );
            vidhanList.add(model);
            isLoading = false;
            setState(() {});
          });
        });
      }
    });
  }

  saveData(whatsId, whatsLinkId) {
    showCircleProgressDialog(context);
    whatsappRef.doc(whatsId).collection('whatsLink').doc(whatsLinkId).update({
      'updateAt': FieldValue.serverTimestamp(),
      'counter': counterController.text,
      'grpcode': grpCodeController.text,
      'grplink': grpLinkController.text,
    }).then((value) {
      Get.back();
      Get.back();
      fetchData();
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Vidhansabha',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: isLoading
            ? const Align(
                alignment: Alignment.center,
                child: Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      fetchData();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: createDataTable(vidhanList, isMobile)),
                        )),
                  ),
                ),
              ));
  }

  DataTable createDataTable(list, isMobile) {
    return DataTable(
        border: TableBorder.all(color: Colors.black),
        columns: _createColumns(),
        rows: _createRows(list, isMobile));
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
        'Vidhansabha Code',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Vidhansabha English',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Vidhansabha Hindi',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Group Code',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Group Link',
        style: TextStyle(color: Colors.white),
      )),
      const DataColumn(
          label: Text(
        'Counter',
        style: TextStyle(color: Colors.white),
      )),
    ];
  }

  List<DataRow> _createRows(List list, isMobile) {
    return list.map((e) {
      return DataRow(
          color: MaterialStateColor.resolveWith((states) => Colors.white),
          cells: [
            dataCell(e.districtCode.toString(), e, isMobile),
            dataCell(e.vidhanCode.toString(), e, isMobile),
            dataCell(e.nameEnglish.toString(), e, isMobile),
            dataCell(e.nameHindi.toString(), e, isMobile),
            dataCell(e.grpCode.toString(), e, isMobile),
            dataCell(e.grpLink.toString(), e, isMobile),
            dataCell(e.counter.toString(), e, isMobile),
          ]);
    }).toList();
  }

  DataCell dataCell(String title, e, isMobile) {
    return DataCell(onTap: () {
      disCodeController.text = e.districtCode.toString();
      vidhanCodeController.text = e.vidhanCode.toString();
      vidhanEController.text = e.nameEnglish.toString();
      vidhanHController.text = e.nameHindi.toString();
      grpCodeController.text = e.grpCode.toString();
      grpLinkController.text = e.grpLink.toString();
      counterController.text = e.counter.toString();
      editDialogBox(isMobile, e.vidhanId, e.whatsId, e.whatsLinkId);
    }, Text(title));
  }

  editDialogBox(isMobile, vidhanId, whatsid, whatsLinkId) {
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 400),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(builder: (context, state) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                  width: isMobile ? MediaQuery.of(context).size.width : 400,
                  margin:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xff213865),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  child: fields(isMobile, vidhanId, whatsid, whatsLinkId)),
            );
          });
        });
    transitionBuilder:
    (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    };
  }

  fields(isMobile, vidhanId, whatsid, whatsLinkId) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextfield(
          isReadOnly: true,
          hintText: 'Enter dis code',
          controller: disCodeController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: true,
          hintText: 'Enter vidhan code',
          controller: vidhanCodeController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: true,
          hintText: 'Enter vidhan hindi',
          controller: vidhanHController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: true,
          hintText: 'Enter vidhan english',
          controller: vidhanEController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter grpcode',
          controller: grpCodeController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter grplink',
          controller: grpLinkController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter counter',
          controller: counterController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomBtn(
            title: 'Submit',
            height: 50,
            width: double.infinity,
            onTap: () {
              alertDialog(whatsid, whatsLinkId);
            }),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  alertDialog(whatsId, whatsLinkId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure you want to edit?'),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Flexible(
                        child: CustomBtn(
                            title: 'No',
                            height: 35,
                            color: Colors.red,
                            width: double.infinity,
                            onTap: () {
                              Get.back();
                            })),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                        child: CustomBtn(
                            title: 'Yes',
                            height: 35,
                            width: double.infinity,
                            onTap: () {
                              Get.back();
                              saveData(whatsId, whatsLinkId);
                            }))
                  ],
                )
              ],
            ),
          );
        });
  }
}

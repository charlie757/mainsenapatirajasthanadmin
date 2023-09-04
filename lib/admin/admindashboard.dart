import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/custombtn.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/customtextfield.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';
import 'package:mainsenapatirajasthanadmin/utils/routes.dart';
import 'package:mainsenapatirajasthanadmin/utils/showcircleprogressdialog.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final formKey = GlobalKey<FormState>();
  int tabBarIndex = 0;
  int selectedDistrict = -1;
  int selectedVidhan = -1;
  String currentDisId = '';
  final disController = TextEditingController();
  final disEController = TextEditingController();
  final disHController = TextEditingController();
  final disCodeController = TextEditingController();

  final vidhanHController = TextEditingController();
  final vidhanEController = TextEditingController();
  final vidhanCodeController = TextEditingController();
  final grpCodeController = TextEditingController();
  final grpLinkController = TextEditingController();
  @override
  void initState() {
    // provider.fetchDistrctData();
    fetchData();
    super.initState();
  }

  List districtList = [];
  List vidhanList = [];
  fetchData() async {
    districtList.clear();
    districtRef.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        districtList = value.docs;
      }
      // districtList = value.docs;
      setState(() {});
    });
  }

  fetchVidhan(disCode) async {
    vidhanList.clear();
    vidhanRef.where('districtCode', isEqualTo: disCode).get().then((value) {
      vidhanList = value.docs;
      setState(() {});
    });
  }

  saveDistrictData() async {
    if (disCodeController.text.isNotEmpty &&
        disEController.text.isNotEmpty &&
        disHController.text.isNotEmpty) {
      final doc = districtRef.doc();
      showCircleProgressDialog(context);
      districtRef.doc(doc.id).set({
        'districtCode': disCodeController.text,
        'nameEnglish': disEController.text,
        'nameHindi': disHController.text,
        'id': doc.id,
        'createAt': FieldValue.serverTimestamp()
      }).then((value) {
        Get.back();
        disCodeController.text = '';
        disEController.text = '';
        disHController.text = '';
      });
    }
  }

  saveVidhanData() async {
    if (disCodeController.text.isNotEmpty &&
        vidhanEController.text.isNotEmpty &&
        vidhanHController.text.isNotEmpty &&
        vidhanCodeController.text.isNotEmpty) {
      final doc = vidhanRef.doc();
      showCircleProgressDialog(context);
      vidhanRef.doc(doc.id).set({
        'districtCode': disCodeController.text,
        'nameEnglish': vidhanEController.text,
        'nameHindi': vidhanHController.text,
        'vidhanCode': vidhanCodeController.text,
        'id': doc.id,
        'createAt': FieldValue.serverTimestamp()
      }).then((value) {
        Get.back();
        disCodeController.text = '';
        vidhanCodeController.text = '';
        vidhanEController.text = '';
        vidhanHController.text = '';
      });
    }
  }

  clearValues() {
    disCodeController.text = '';
    disEController.text = '';
    disHController.text = '';
    disController.text = '';
    vidhanCodeController.text = '';
    vidhanHController.text = '';
    vidhanEController.text = '';
    disEController.text = '';
    grpCodeController.text = '';
    grpLinkController.text = '';
    selectedDistrict = -1;
    selectedVidhan = -1;
  }

  submitData() {
    if (disController.text.isNotEmpty &&
        vidhanCodeController.text.isNotEmpty &&
        vidhanHController.text.isNotEmpty &&
        grpCodeController.text.isNotEmpty &&
        grpLinkController.text.isNotEmpty) {
      showCircleProgressDialog(context);
      final whatsId = whatsappRef.doc();
      final whatsSubCId =
          whatsappRef.doc(whatsId.id).collection('whatsLink').doc();
      whatsappRef
          .where('vidhanCode',
              isEqualTo: vidhanCodeController.text.removeAllWhitespace)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          whatsappRef.doc(whatsId.id).set({
            'id': whatsId.id,
            'disId': currentDisId,
            'disName': disController.text,
            'nameHindi': vidhanHController.text,
            'vidhanCode': vidhanCodeController.text.removeAllWhitespace,
          }).then((value1) {
            whatsappRef
                .doc(whatsId.id)
                .collection('whatsLink')
                .doc(whatsSubCId.id)
                .set({
              'counter': '0',
              'createdAt': FieldValue.serverTimestamp(),
              'grpcode': grpCodeController.text,
              'id': whatsSubCId.id,
              'isAdd': false,
              'grplink': grpLinkController.text,
              // 'discode': disCodeController.text.removeAllWhitespace,
              'vidhancode': vidhanCodeController.text.removeAllWhitespace
            }).then((value) {
              Get.back();
              clearValues();
            });
          });
        } else {
          whatsappRef
              .doc(value.docs[0]['id'])
              .collection('whatsLink')
              .doc(whatsSubCId.id)
              .set({
            'counter': '0',
            'createdAt': FieldValue.serverTimestamp(),
            'grpcode': grpCodeController.text,
            'id': whatsSubCId.id,
            'isAdd': false,
            'grplink': grpLinkController.text,
            // 'discode': disCodeController.text.removeAllWhitespace,
            'vidhancode': vidhanCodeController.text.removeAllWhitespace

            // 'discode': disCodeController.text.removeAllWhitespace,
            // 'vidhancode': vidhanCodeController.text.removeAllWhitespace
          }).then((value) {
            Get.back();
            clearValues();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff213865),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomBtn(
                title: 'User Data',
                height: 40,
                width: 200,
                onTap: () {
                  Get.toNamed(Routes.userDetails);
                }),
            const SizedBox(
              height: 20,
            ),
            CustomBtn(
                title: 'All District',
                height: 40,
                width: 200,
                onTap: () {
                  Get.toNamed(Routes.allDistrict);
                }),
            const SizedBox(
              height: 20,
            ),
            CustomBtn(
                title: 'All Vidhansabha',
                height: 40,
                width: 200,
                onTap: () {
                  Get.toNamed(Routes.allVidhan);
                }),
            const SizedBox(
              height: 20,
            ),
            CustomBtn(
                title: 'chart',
                height: 40,
                width: 200,
                onTap: () {
                  Get.toNamed(Routes.chart);
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Admin'),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 400,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tabBar(),
                const SizedBox(
                  height: 20,
                ),
                tabBarIndex == 0
                    ? districtView()
                    : tabBarIndex == 1
                        ? vidhanView()
                        : whtsappView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  vidhanView() {
    return Column(
      children: [
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter dis code',
          controller: disCodeController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter vidhan hindi',
          controller: vidhanHController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter vidhan english',
          controller: vidhanEController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter vidhan code',
          controller: vidhanCodeController,
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
              saveVidhanData();
            }),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  districtView() {
    return Column(
      children: [
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter dis hindi',
          controller: disHController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter dis english',
          controller: disEController,
          onTap: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter dis code',
          controller: disCodeController,
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
              saveDistrictData();
            }),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  whtsappView() {
    return Column(
      children: [
        CustomTextfield(
          isReadOnly: true,
          hintText: 'select District',
          controller: disController,
          onTap: () {
            alertDialog('dis');
          },
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: true,
          hintText: 'select vs',
          controller: vidhanHController,
          onTap: () {
            disController.text.isEmpty ? null : alertDialog('vidhan');
          },
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextfield(
          isReadOnly: false,
          hintText: 'Enter vs code',
          controller: vidhanCodeController,
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
          hintText: 'Enter whatsapp link',
          controller: grpLinkController,
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
              submitData();
            }),
        const SizedBox(
          height: 15,
        ),
        CustomBtn(
            title: 'Check data',
            height: 50,
            width: double.infinity,
            color: Colors.red,
            onTap: () {
              Get.toNamed(Routes.viewdata);
              // submitData();
            }),
      ],
    );
  }

  tabBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              tabBarIndex = 0;
            });
          },
          child: Row(
            children: [
              radioBtn(0, tabBarIndex, Colors.white),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'District',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              tabBarIndex = 1;
            });
          },
          child: Row(
            children: [
              radioBtn(1, tabBarIndex, Colors.white),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'vidhansabha',
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              tabBarIndex = 2;
            });
          },
          child: Row(
            children: [
              radioBtn(2, tabBarIndex, Colors.white),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'whatsapp',
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
        )
      ],
    );
  }

  alertDialog(route) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              padding: const EdgeInsets.only(top: 10),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 50,
                  minHeight: 300,
                  maxWidth: 300,
                  minWidth: 300),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                          separatorBuilder: (context, sp) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: route == 'dis'
                              ? districtList.length
                              : vidhanList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (route == 'dis') {
                                  selectedDistrict = index;
                                  disController.text =
                                      districtList[index]['nameHindi'];
                                  currentDisId = districtList[index]['id'];
                                  fetchVidhan(
                                      districtList[index]['districtCode']);
                                } else {
                                  selectedVidhan = index;
                                  vidhanHController.text =
                                      vidhanList[index]['nameHindi'];
                                  vidhanCodeController.text =
                                      vidhanList[index]['vidhanCode'];
                                }
                                Get.back();
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Text(
                                        route == 'dis'
                                            ? districtList[index]['nameHindi']
                                            : vidhanList[index]['nameHindi'],
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      const Spacer(),
                                      radioBtn(
                                          index,
                                          route == 'district'
                                              ? selectedDistrict
                                              : selectedVidhan,
                                          const Color(0xff213865))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  radioBtn(index, selected, Color unselectColor) {
    return Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        border: Border.all(
            color: selected == index ? const Color(0xffbd9766) : unselectColor),
        shape: BoxShape.circle,
        // color: Colors.black,
      ),
      padding: const EdgeInsets.all(2),
      child: selected == index
          ? Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xffbd9766)),
            )
          : Container(),
    );
  }
}

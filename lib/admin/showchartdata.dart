import 'package:flutter/material.dart';
import 'package:mainsenapatirajasthanadmin/helper.dart/custombtn.dart';
import 'package:mainsenapatirajasthanadmin/model/districtusermodel.dart';
import 'package:mainsenapatirajasthanadmin/utils/collectionreference.dart';
import 'package:mainsenapatirajasthanadmin/utils/colorconstants.dart';
import 'package:mainsenapatirajasthanadmin/utils/pichartmodel.dart';
import 'package:mainsenapatirajasthanadmin/widget/custompichart.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ShowChartData extends StatefulWidget {
  const ShowChartData({super.key});

  @override
  State<ShowChartData> createState() => _ShowChartDataState();
}

class _ShowChartDataState extends State<ShowChartData> {
  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  List verifiedUser = [];
  List nonVerifiedUser = [];
  List districtUser = [];

  List<PiChartModel>? userchart;
  List<PiChartModel> getUsersChart() {
    final List<PiChartModel> userChart = [
      PiChartModel(
          'Verified',
          verifiedUser.length,
          "${verifiedUser.length.toString()} (${verifiedUser.length / 100}%)",
          Colors.blue),
      PiChartModel(
          'Non-Verified',
          nonVerifiedUser.length,
          "${nonVerifiedUser.length.toString()} (${nonVerifiedUser.length / 100}%)",
          Colors.red),
    ];
    return userChart;
  }

  fetchUserData() async {
    nonVerifiedUser.clear();
    verifiedUser.clear();
    districtUser.clear();
    usersRef.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['isVerified'] == false) {
          nonVerifiedUser.add(value.docs[i]);
        } else {
          verifiedUser.add(value.docs);
        }
        // DistrictUserModel model = DistrictUserModel(
        //     value.docs[i]['district'] == 'भीलवाड़ा' ? value.docs[i] : 0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     value.docs[i]['district'] == 'जयपुर' ? value.docs : 0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0,
        //     0);
        // districtUser.add(model);

        setState(() {});
      }
      userchart = getUsersChart();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 7, top: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userVerificationData(isMobile),
            // CustomBtn(
            //     title: 'title',
            //     height: 40,
            //     width: 200,
            //     onTap: () {
            //       for (int i = 0; i < districtUser.length; i++) {
            //         if (districtUser[i].GANGANAGAR == '') {
            //           print(districtUser[i].GANGANAGAR.l);
            //         }
            //       }
            //     })
          ],
        ),
      ),
    );
  }

  userVerificationData(isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'User-Verification Data',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        Container(
          color: Colors.white,
          width: 400,
          child: Column(
            children: [
              customCircularChart(userchart, context, isMobile),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'verified',
                      style: TextStyle(),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'registered',
                      style: TextStyle(),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

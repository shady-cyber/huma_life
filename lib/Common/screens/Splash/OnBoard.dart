import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../Authentication/Select_Type.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/constant.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  String buttonText = 'Next';
  double percent = 0.34;

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'assets/images/onboard1.png',
      "title": "title1".tr(),
      "description": 'description1'.tr(),
    },
    {
      "icon": 'assets/images/onboard2.png',
      "title": 'title2'.tr(),
      "description": 'description2'.tr(),
    },
    {
      "icon": 'assets/images/onboard3.png',
      "title": 'title3'.tr(),
      "description": ''
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF0FDFF),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFFFCF1F0)),
        backgroundColor: const Color(0xFFF0FDFF),
        elevation: 0.0,
        actions: [
          const SizedBox(
            width: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () {
                const SelectType().launch(context);
              },
              child: Text(
                'Skip'.tr(),
                style: GoogleFonts.dmSans(
                  fontSize: 16.0,
                  color: kTitleColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 30.0,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      itemCount: sliderList.length,
                      controller: pageController,
                      onPageChanged: (int index) =>
                          setState(() => currentIndexPage = index),
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            Image.asset(
                              sliderList[index]['icon'],
                              fit: BoxFit.fill,
                              width: context.width(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),
                               //   color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 100.0,
                                          top: 15.0,
                                          bottom: 10.0),
                                      child: Text(
                                        sliderList[index]['title'].toString(),
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.jost(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 20.0),
                                      // ignore: sized_box_for_whitespace
                                      child: Container(
                                        width: context.width(),
                                        child: Text(
                                          sliderList[index]['description']
                                              .toString(),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                          style: GoogleFonts.jost(
                                            fontSize: 20.0,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 8, bottom: 8),
                          child: DotIndicator(
                            currentDotSize: 15,
                            dotSize: 6,
                            pageController: pageController,
                            pages: sliderList,
                            indicatorColor: kMainColor,
                            unselectedIndicatorColor: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 3.0,
                            progressColor: kMainColor,
                            percent: percent,
                            animation: true,
                            center: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndexPage < 2
                                      ? percent = percent + 0.33
                                      : percent = 1.0;
                                  currentIndexPage < 2
                                      ? pageController.nextPage(
                                          duration: const Duration(
                                              microseconds: 3000),
                                          curve: Curves.bounceInOut)
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectType()),
                                        );
                                });
                              },
                              child: const CircleAvatar(
                                radius: 35.0,
                                backgroundColor: kMainColor,
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

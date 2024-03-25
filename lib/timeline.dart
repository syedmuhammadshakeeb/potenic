import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:potenic/component/newvision_component.dart';
import 'package:potenic/screen_utils.dart';

import 'component/Day_time_component.dart';
import 'component/goal_practice_component.dart';
import 'component/hurdle_component.dart';
import 'component/inspiration_component.dart';
import 'component/practice_session_component.dart';
import 'component/recorded_component.dart';
import 'component/repoprt_component.dart';
import 'general/Api.dart';

class timeline extends StatefulWidget {
  const timeline({super.key});

  @override
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  late ScrollController _scrollController;
  late DateTime? setValue = DateTime.now();
  final searchController = TextEditingController();

  bool isSearch = false;
  Map<String, dynamic> TimeLineRes = {};

  final List<String> _statements = [
    'All ',
    'Sessions completed',
    'Sessions upcoming',
    'Sessions missed',
    'Evaluation & reports',
    'Hurdles',
  ];
  final List<String> _goals = [
    'All ',
    'Goal name 1',
    'Goal name 2 ',
    'Goal name 3 ',
    'Practice name 1 (goal name)',
  ];
  int _selectedTag = 0;
  int goalIndex = 0;
  String selectedActivity = 'All';
  String selectedGoal = 'All';

  clearData() {
    setState(() {
      setValue = DateTime.now();
      selectedGoal = 'All';
      selectedActivity = 'All';
    });
  }

  @override
  void initState() {
    callTimeLine();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
// show the back-to-top button
          } else {
// hide the back-to-top button
          }
        });
      });

    super.initState();
  }

  bool loader = true;
  DateTime date = DateTime.now();

  callTimeLine() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      loader = true;
      ApiServices().getTimeLine(329, formattedDate).then((value) {
        setState(() {
          TimeLineRes = value;
        });
      });
    } catch (e) {
      print(e);
    } finally {
      loader = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(820,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Center(
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/images/Back.webp',
                height: AppDimensions.height10(context) * 3.0,
                fit: BoxFit.contain,
              )),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _scrollToTop();
            },
            child: Container(
              child: Image.asset(
                'assets/images/Asset 10 2.webp',
                width: AppDimensions.width10(context) * 4.1,
                height: AppDimensions.height10(context) * 4.1,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: AssetImage('assets/images/Background.webp'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: AppDimensions.height10(context) * 8.0,
                    ),
                    Column(
                      children: [
                        ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index1) {
                            // Calculate the date for the current index
                            DateTime currentDate =
                                date.add(Duration(days: index1 + 1));
                            String currentDateKey =
                                DateFormat('yyyy-MM-dd').format(currentDate);

                            return Column(
                              children: [
                                DayTimeComponent(
                                  DayText:
                                      DateFormat('EEE').format(currentDate),
                                  TimeText:
                                      DateFormat('dd.MM').format(currentDate),
                                ),
                                // Check if the data exists for the current date in TimeLineRes
                                TimeLineRes.containsKey(currentDateKey)
                                    ? ListView.builder(
                                        itemCount: TimeLineRes[currentDateKey]
                                                ?.length ??
                                            0,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppDimensions.width10(context) *
                                                  1.5,
                                        ),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index2) {
                                          // Get the schedule list for the current index
                                          Map<String, dynamic>? scheduleList =
                                              TimeLineRes[currentDateKey]
                                                  ?[index2]?["schedule"];
                                          String practiceName =
                                              TimeLineRes[currentDateKey]
                                                  ?[index2]?["name"];
                                          Map<String, dynamic>? userGoal =
                                              TimeLineRes[currentDateKey]
                                                  ?[index2]?["userGoal"];

                                          if (scheduleList == null) {
                                            // Handle case when scheduleList is null
                                            return Container();
                                          }

                                          return Column(
                                            children: [
                                              ListView.builder(
                                                itemCount: scheduleList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index3) {
                                                  // Get the schedule time for the current index
                                                  String? scheduleTime =
                                                      scheduleList[
                                                          'time${index3 + 1}'];
                                                  String? goalName =
                                                      userGoal?["name"];
                                                  if (scheduleTime == null) {
                                                    return Container();
                                                  } else {
                                                    return PracticeSessionComponent(
                                                      status:
                                                          'active', // Assuming this should be constant
                                                      scheduleTime:
                                                          scheduleTime,
                                                      greenText:
                                                          practiceName, // Assuming these texts are constants
                                                      image1:
                                                          'assets/images/orange_moon.webp',
                                                      orangeText: goalName!,
                                                      image2:
                                                          'assets/images/Ellipse 158.webp',
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : Container(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    DayTimeComponent(
                      DayText: 'WED',
                      TimeText: '05.34',
                    ),
                    DayTimeComponent(
                      DayText: 'MOn',
                      TimeText: '05.34',
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: AppDimensions.height10(context) * 3.5),
                      child: Image.asset(
                        'assets/images/Arrow_up.webp',
                        color: const Color(0xFF437296),
                        width: AppDimensions.width10(context) * 2.5,
                        height: AppDimensions.height10(context) * 2.5,
                      ),
                    ),
                    Container(
                      width: AppDimensions.width10(context) * 7.2,
                      height: AppDimensions.height10(context) * 1.9,
                      margin: EdgeInsets.only(
                          top: AppDimensions.height10(context) * 0.4),
                      child: Center(
                        child: Text(
                          'Schedule',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppDimensions.font10(context) * 1.6,
                              fontWeight: FontWeight.w700,
                              height: AppDimensions.height10(context) * 0.12,
                              color: const Color(0xFF437296)),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: AppDimensions.height10(context) * 3.5),
                        child: Image.asset(
                          'assets/images/Asset_timeline.webp',
                          height: AppDimensions.height10(context) * 7.8,
                          width: AppDimensions.width10(context) * 7.8,
                        )),
                    Container(
                      width: AppDimensions.width10(context) * 34.8,
                      height: AppDimensions.height10(context) * 3.6,
                      margin: EdgeInsets.only(
                          top: AppDimensions.height10(context) * 2.0),
                      child: Center(
                        child: Text(
                          'Your Timeline Journey',
                          style: TextStyle(
                              fontSize: AppDimensions.font10(context) * 3.0,
                              letterSpacing:
                                  AppDimensions.height10(context) * 0.2,
                              fontWeight: FontWeight.w700,
                              height: AppDimensions.height10(context) * 0.12,
                              color: const Color(0xFF437296)),
                        ),
                      ),
                    ),
                    Container(
                      width: AppDimensions.width10(context) * 30.8,
                      height: AppDimensions.height10(context) * 5.4,
                      margin: EdgeInsets.only(
                          top: AppDimensions.height10(context) * 1.5,
                          left: AppDimensions.width10(context) * 4.8,
                          right: AppDimensions.width10(context) * 4.7),
                      child: Text(
                        'All your recorded events & schedule\nin one place',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppDimensions.font10(context) * 1.8,
                            fontWeight: FontWeight.w500,
                            height: AppDimensions.height10(context) * 0.12,
                            color: const Color(0xFF437296)),
                      ),
                    ),
                    Container(
                      width: AppDimensions.width10(context) * 11.20,
                      height: AppDimensions.height10(context) * 1.9,
                      margin: EdgeInsets.only(
                          top: AppDimensions.height10(context) * 1.3),
                      child: Center(
                        child: Text(
                          'Past activities',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppDimensions.font10(context) * 1.6,
                              fontWeight: FontWeight.w700,
                              height: AppDimensions.height10(context) * 0.12,
                              color: const Color(0xFF437296)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: AppDimensions.height10(context) * 0.8),
                      child: Image.asset(
                        'assets/images/Arrow.webp',
                        color: const Color(0xFF437296),
                        width: AppDimensions.width10(context) * 2.5,
                        height: AppDimensions.height10(context) * 2.5,
                      ),
                    ),
                    DayTimeComponent(
                      DayText: 'FRI',
                      TimeText: '05.34',
                    ),
                    Column(
                      children: [
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                left: AppDimensions.width10(context) * 1.5,
                                right: AppDimensions.width10(context) * 1.5,
                                top: AppDimensions.width10(context) * 1.5),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              const goal = 'active';
                              const stop_goal = 'inactive';
                              const del_goal = 'delactive';
                              return GoalPracticeComponent(
                                status: goal,
                                subText:
                                    'I am someone who is in\ncontrol of my anger',
                                image1: 'assets/images/orange_moon.webp',
                                image2: 'assets/images/Ellipse 158.webp',
                                mainText: 'Control my anger',
                                smallText: 'Meditation',
                              );
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                                left: AppDimensions.width10(context) * 1.5,
                                right: AppDimensions.width10(context) * 1.5,
                                top: AppDimensions.width10(context) * 8.5),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              const recorded = 'active';
                              const missed = 'inactive';

                              return RecordedComponent(
                                status: recorded,
                                orangeImage: 'assets/images/orange_moon.webp',
                                orangeText: 'Control\nmy anger',
                                beforeText: '"I felt low and irritable"',
                                afterText: '"I felt focused and good"',
                                recordedText: 'Practice session "Recorded"',
                                greenImage:
                                    'assets/images/Meditation Completed.webp',
                                missedGreenImage:
                                    'assets/images/Meditation_missed.webp',
                              );
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              const active = 'active';
                              const updated = 'inactive';
                              const deleted = 'delactive';
                              return HurdleComponent(
                                status: active,
                                mainText: 'Husband',
                                subText: 'Makes a\nmistake',
                              );
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              const active = 'active';
                              const updated = 'inactive';
                              const deleted = 'delactive';
                              return InspirationComponent(
                                status: active,
                                mainImage: 'assets/images/Rectangle 10.webp',
                                Text1: 'Feelings and thoughts',
                                Text2:
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit....',
                              );
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ReportComponent(
                                mainText: 'Congratulations!',
                                subText: 'Your 20 active\nday report is ready',
                                image: 'assets/images/Report card.webp',
                              );
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              int goalLevel = 1;
                              return NewVisionComponent(
                                mainText: 'Control my anger',
                                image1: 'assets/images/orange_moon.webp',
                                subText:
                                    '"i am someone who is in\ncontrol  of my anger"',
                                image2: goalLevel == 1
                                    ? 'assets/images/goal_level_1.webp'
                                    : goalLevel == 2
                                        ? 'assets/images/Nebula pie 2.webp'
                                        : goalLevel == 3
                                            ? 'assets/images/Nebula pie 3.webp'
                                            : goalLevel == 4
                                                ? 'assets/images/goal_level_4.webp'
                                                : 'assets/images/goal_level_5.webp',
                                quoteText:
                                    'I feel i am making small\nsteps forward',
                                levelText: goalLevel.toString(),
                              );
                            }),
                      ],
                    ),
                    DayTimeComponent(
                      DayText: 'TUE',
                      TimeText: '04.07',
                    ),
                    DayTimeComponent(
                      DayText: 'TUE',
                      TimeText: '04.09',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                    right: AppDimensions.width10(context) * 2.2),
                height: AppDimensions.height10(context) * 7.0,
                width: AppDimensions.width10(context) * 41.4,
                decoration: const BoxDecoration(
                  color: Color(0xffFBFBFB),
                ),
                child: isSearch
                    ? Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: AppDimensions.height10(context) *
                                          2.0),
                                  child: Container(
                                    height:
                                        AppDimensions.height10(context) * 3.6,
                                    width:
                                        AppDimensions.width10(context) * 29.3,
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF767680)
                                            .withOpacity(0.12),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppDimensions.height10(
                                                    context)))),
                                    child: TextFormField(
                                        textCapitalization: TextCapitalization
                                            .sentences,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        controller: searchController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(0.0),
                                            prefixIcon: Image.asset(
                                              'assets/images/Light.webp',
                                              width: AppDimensions.width10(
                                                      context) *
                                                  1.5,
                                              height: AppDimensions.height10(
                                                      context) *
                                                  1.5,
                                            ),
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  searchController.clear();
                                                },
                                                child: Icon(
                                                  Icons.cancel,
                                                  size: AppDimensions.height10(
                                                          context) *
                                                      1.8,
                                                  color: const Color(0xff252525)
                                                      .withOpacity(0.75),
                                                )),
                                            hintText: "Search",
                                            hintStyle: GoogleFonts.laila(
                                              textStyle: TextStyle(
                                                color: const Color(0xff3C3C43)
                                                    .withOpacity(0.6),
                                                height: AppDimensions.height10(
                                                        context) *
                                                    0.11,
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .transparent)))),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSearch = !isSearch;
                                });
                              },
                              child: Text(
                                "Cancel",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppDimensions.font10(context) * 1.7,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF007AFF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                //width: AppDimensions.width10(context) * 66.0,
                                // height: AppDimensions.height10(context)*5.0,
                                padding: EdgeInsets.only(
                                    left: AppDimensions.width10(context) * 2.2),
                                margin: EdgeInsets.only(
                                    right:
                                        AppDimensions.width10(context) * 5.0),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:
                                              AppDimensions.width10(context) *
                                                  2.4,
                                          height:
                                              AppDimensions.height10(context) *
                                                  2.4,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Image.asset(
                                              'assets/images/ic_filter_list.webp',
                                              width: AppDimensions.width10(
                                                      context) *
                                                  2.4,
                                              height: AppDimensions.height10(
                                                      context) *
                                                  2.4,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              AppDimensions.width10(context) *
                                                  0.5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Container(
                                                    height:
                                                        AppDimensions.height10(
                                                                context) *
                                                            30.3,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.001),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: AppDimensions
                                                                      .height10(
                                                                          context) *
                                                                  4.0,
                                                              width: AppDimensions
                                                                      .width10(
                                                                          context) *
                                                                  41.4,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width: AppDimensions.width10(context) *
                                                                              0.1,
                                                                          color:
                                                                              const Color(0xFF828282)))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            20.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: AppDimensions.width10(context) *
                                                                            5.0,
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                AppDimensions.height10(context) * 2.0),
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              fontSize: AppDimensions.font10(context) * 1.4,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0xFF2F80ED)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedGoal =
                                                                              _goals[goalIndex];
                                                                        });

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width: AppDimensions.width10(context) *
                                                                            3.7,
                                                                        child:
                                                                            Text(
                                                                          'Done',
                                                                          style: TextStyle(
                                                                              fontSize: AppDimensions.font10(context) * 1.4,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0xFF2F80ED)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ListWheelScrollView(
                                                                itemExtent: 40,
                                                                magnification:
                                                                    1.2,
                                                                useMagnifier:
                                                                    true, // Set the height of each statement
                                                                children: _goals
                                                                    .map((statement) => Text(
                                                                        statement,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              AppDimensions.height10(context) * 2.0,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        )))
                                                                    .toList(),
                                                                onSelectedItemChanged:
                                                                    (int
                                                                        index) {
                                                                  setState(() {
                                                                    goalIndex =
                                                                        index;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            // width: AppDimensions.width10(context) * 11.5,
                                            height: AppDimensions.height10(
                                                    context) *
                                                3.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimensions.height10(
                                                                context) *
                                                            1.0),
                                                border: Border.all(
                                                    width:
                                                        AppDimensions.width10(
                                                                context) *
                                                            0.1,
                                                    color: const Color(
                                                        0xFFE0E0E0))),
                                            margin: EdgeInsets.only(
                                                left: AppDimensions.height10(
                                                        context) *
                                                    1.3,
                                                right: AppDimensions.width10(
                                                        context) *
                                                    1.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          1.0),
                                                  child: Text(
                                                    'Goal:',
                                                    style: TextStyle(
                                                        fontSize: AppDimensions
                                                                .font10(
                                                                    context) *
                                                            1.4,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xffFA9934)),
                                                  ),
                                                ),
                                                Container(
                                                  //width: AppDimensions.width10(context) * 1.9,
                                                  height:
                                                      AppDimensions.height10(
                                                              context) *
                                                          2.4,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.8),
                                                  child: Center(
                                                    child: Text(
                                                      selectedGoal,
                                                      style: TextStyle(
                                                          fontSize: AppDimensions
                                                                  .font10(
                                                                      context) *
                                                              1.4,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xffFA9934)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: AppDimensions.width10(
                                                          context) *
                                                      2.4,
                                                  height:
                                                      AppDimensions.height10(
                                                              context) *
                                                          2.4,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.8,
                                                      right: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          1.0,
                                                      bottom: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.3),
                                                  child: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color(0xffFA9934),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Container(
                                                    height:
                                                        AppDimensions.height10(
                                                                context) *
                                                            30.3,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.001),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: AppDimensions
                                                                      .height10(
                                                                          context) *
                                                                  4.0,
                                                              width: AppDimensions
                                                                      .width10(
                                                                          context) *
                                                                  41.4,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width: AppDimensions.width10(context) *
                                                                              0.1,
                                                                          color:
                                                                              const Color(0xFF828282)))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            20.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: AppDimensions.width10(context) *
                                                                            5.0,
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                AppDimensions.height10(context) * 2.0),
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              fontSize: AppDimensions.font10(context) * 1.4,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0xFF2F80ED)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedActivity =
                                                                              _statements[_selectedTag];
                                                                        });

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width: AppDimensions.width10(context) *
                                                                            3.7,
                                                                        child:
                                                                            Text(
                                                                          'Done',
                                                                          style: TextStyle(
                                                                              fontSize: AppDimensions.font10(context) * 1.4,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0xFF2F80ED)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ListWheelScrollView(
                                                                itemExtent: 40,
                                                                magnification:
                                                                    1.2,
                                                                useMagnifier:
                                                                    true, // Set the height of each statement
                                                                children: _statements
                                                                    .map((statement) => Text(statement,
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              AppDimensions.height10(context) * 2.0,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        )))
                                                                    .toList(),
                                                                onSelectedItemChanged:
                                                                    (int
                                                                        index) {
                                                                  setState(() {
                                                                    _selectedTag =
                                                                        index;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            // width: AppDimensions.width10(context) * 11.6,
                                            height: AppDimensions.height10(
                                                    context) *
                                                3.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimensions.height10(
                                                                context) *
                                                            1.0),
                                                border: Border.all(
                                                    width:
                                                        AppDimensions.width10(
                                                                context) *
                                                            0.1,
                                                    color: const Color(
                                                        0xFFE0E0E0))),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          1.0),
                                                  child: Text(
                                                    'Action:',
                                                    style: TextStyle(
                                                        fontSize: AppDimensions
                                                                .font10(
                                                                    context) *
                                                            1.4,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xffFA9934)),
                                                  ),
                                                ),
                                                Container(
                                                  //width: AppDimensions.width10(context) * 1.9,
                                                  height:
                                                      AppDimensions.height10(
                                                              context) *
                                                          2.4,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.8),
                                                  child: Center(
                                                    child: Text(
                                                      selectedActivity,
                                                      style: TextStyle(
                                                          fontSize: AppDimensions
                                                                  .font10(
                                                                      context) *
                                                              1.4,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xffFA9934)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: AppDimensions.width10(
                                                          context) *
                                                      2.4,
                                                  height:
                                                      AppDimensions.height10(
                                                              context) *
                                                          2.4,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.8,
                                                      right: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          1.0,
                                                      bottom: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.3),
                                                  child: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color(0xffFA9934),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            DateTime? valueOne =
                                                await _TimeBottomSheet(context);
                                            setState(() {
                                              setValue = valueOne!;
                                            });
                                          },
                                          child: Container(
                                            //width: AppDimensions.width10(context) * 11.5,
                                            height: AppDimensions.height10(
                                                    context) *
                                                3.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimensions.height10(
                                                                context) *
                                                            1.0),
                                                border: Border.all(
                                                    width:
                                                        AppDimensions.width10(
                                                                context) *
                                                            0.1,
                                                    color: const Color(
                                                        0xFFE0E0E0))),
                                            margin: EdgeInsets.only(
                                                left: AppDimensions.height10(
                                                        context) *
                                                    1.3,
                                                right: AppDimensions.width10(
                                                        context) *
                                                    1.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          1.0),
                                                  child: Text(
                                                    'Date:',
                                                    style: TextStyle(
                                                        fontSize: AppDimensions
                                                                .font10(
                                                                    context) *
                                                            1.4,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xffFA9934)),
                                                  ),
                                                ),
                                                Container(
                                                  //width: AppDimensions.width10(context) * 1.9,
                                                  height:
                                                      AppDimensions.height10(
                                                              context) *
                                                          2.4,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.8),
                                                  child: Center(
                                                    child: Text(
                                                      setValue == null
                                                          ? ''
                                                          : '${setValue!.year}-${setValue!.month}-${setValue!.day}',
                                                      style: TextStyle(
                                                          fontSize: AppDimensions
                                                                  .font10(
                                                                      context) *
                                                              1.4,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xffFA9934)),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: AppDimensions.width10(
                                                          context) *
                                                      2.4,
                                                  height:
                                                      AppDimensions.height10(
                                                              context) *
                                                          2.4,
                                                  margin: EdgeInsets.only(
                                                      left: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.8,
                                                      right: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          1.0,
                                                      bottom: AppDimensions
                                                              .height10(
                                                                  context) *
                                                          0.3),
                                                  child: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Color(0xffFA9934),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            clearData();
                                          },
                                          child: Container(
                                            // width: AppDimensions.width10(context) * 6.0,
                                            height: AppDimensions.height10(
                                                    context) *
                                                2.1,
                                            margin: EdgeInsets.only(
                                                left: AppDimensions.width10(
                                                        context) *
                                                    1.0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Clear all',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.font10(
                                                              context) *
                                                          1.4,
                                                  fontWeight: FontWeight.w700,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color:
                                                      const Color(0xFFFA9934)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: AppDimensions.width10(context) * 4.9,
                              height: AppDimensions.height10(context) * 5.0,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFBFBFB),
                                  borderRadius: BorderRadius.circular(100)),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSearch = !isSearch;
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/Search.webp',
                                  width: AppDimensions.width10(context) * 5,
                                  height: AppDimensions.height10(context) * 5,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          //const Padding(padding: EdgeInsets.all(10))
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  final bool sheet_bottom;

  const MyBottomSheet({super.key, required this.sheet_bottom});
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  int _selectedIndex = 0;

  final List<String> goalsname = [
    'All',
    'Goal name 1',
    'Goal name 2',
    'Goal name 3',
    'Goal name 4'
  ];
  final List<String> _sessions = [
    'All',
    'Sessions completed',
    'Sessions upcoming',
    'Sessions missed',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.height10(context) *
          31.3, // Set the height of the bottom sheet
      child: Column(
        children: [
          Container(
            height: AppDimensions.height10(context) * 3.8,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: const Color(0xFF828282),
                        width: AppDimensions.width10(context) * 0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: AppDimensions.width10(context) * 5.0,
                    height: AppDimensions.height10(context) * 2.1,
                    margin: EdgeInsets.only(
                        right: AppDimensions.width10(context) * 2.0),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: AppDimensions.font10(context) * 1.4,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2F80ED)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      //activity_duration = selectedActivity;
                      //activity_duration = _statements[_selectedIndex];
                    });
                    Navigator.of(context).pop(_sessions[_selectedIndex]);
                  },
                  child: Container(
                    width: AppDimensions.width10(context) * 3.7,
                    height: AppDimensions.height10(context) * 2.1,
                    margin: EdgeInsets.only(
                        right: AppDimensions.width10(context) * 1.9),
                    child: Text(
                      'Done',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: AppDimensions.font10(context) * 1.4,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2F80ED)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 35,
              magnification: 1.2,
              useMagnifier: true, // Set the height of each statement
              children: widget.sheet_bottom
                  ? _sessions
                      .map((statement) => Text(statement,
                          style: TextStyle(
                            fontSize: AppDimensions.font10(context) * 2.0,
                            fontWeight: FontWeight.w400,
                          )))
                      .toList()
                  : goalsname
                      .map((statement) => Text(statement,
                          style: TextStyle(
                            fontSize: AppDimensions.font10(context) * 2.0,
                            fontWeight: FontWeight.w400,
                          )))
                      .toList(),
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                  //activity_duration = _statements[_selectedIndex];
                  //  selectedActivity = _statements[_selectedIndex];
                });
              },
            ),
          ),
          SizedBox(height: AppDimensions.height10(context) * 3.6),
        ],
      ),
    );
  }
}

_BottomSheet(BuildContext context) {
  const bool bottom_sheet = false;
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return const MyBottomSheet(
          sheet_bottom: bottom_sheet,
        );
      });
    },
  ).then((value) {
    if (value != null) {
      // Do something with the selected statement
    }
  });
}

class BottomSheet extends StatefulWidget {
  final bool sheet_bottom;

  const BottomSheet({super.key, required this.sheet_bottom});
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _BottomSheetState extends State<MyBottomSheet> {
  int _selectedIndex = 0;

  final List<String> goalsname = [
    'All',
    'Goal name 1',
    'Goal name 2',
    'Goal name 3',
    'Goal name 4'
  ];
  final List<String> _sessions = [
    'All',
    'Sessions completed',
    'Sessions upcoming',
    'Sessions missed',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.height10(context) *
          31.3, // Set the height of the bottom sheet
      child: Column(
        children: [
          Container(
            height: AppDimensions.height10(context) * 3.8,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: const Color(0xFF828282),
                        width: AppDimensions.width10(context) * 0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: AppDimensions.width10(context) * 5.0,
                    height: AppDimensions.height10(context) * 2.1,
                    margin: EdgeInsets.only(
                        right: AppDimensions.width10(context) * 2.0),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: AppDimensions.font10(context) * 1.4,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2F80ED)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    Navigator.of(context).pop(_sessions[_selectedIndex]);
                  },
                  child: Container(
                    width: AppDimensions.width10(context) * 3.7,
                    height: AppDimensions.height10(context) * 2.1,
                    margin: EdgeInsets.only(
                        right: AppDimensions.width10(context) * 1.9),
                    child: Text(
                      'Done',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: AppDimensions.font10(context) * 1.4,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2F80ED)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 35,
              magnification: 1.2,
              useMagnifier: true, // Set the height of each statement
              children: widget.sheet_bottom
                  ? _sessions
                      .map((statement) => Text(statement,
                          style: TextStyle(
                            fontSize: AppDimensions.font10(context) * 2.0,
                            fontWeight: FontWeight.w400,
                          )))
                      .toList()
                  : goalsname
                      .map((statement) => Text(statement,
                          style: TextStyle(
                            fontSize: AppDimensions.font10(context) * 2.0,
                            fontWeight: FontWeight.w400,
                          )))
                      .toList(),
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: AppDimensions.height10(context) * 3.6),
        ],
      ),
    );
  }
}

Future<DateTime?> _TimeBottomSheet(BuildContext context) async {
  DateTime iniValue = DateTime.now();

  final selectedDate = await showModalBottomSheet(
      shape: LinearBorder(),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: AppDimensions.height10(context) * 30.3,
          child: Column(
            children: [
              Container(
                height: AppDimensions.height10(context) * 3.8,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: const Color(0xFF828282),
                            width: AppDimensions.width10(context) * 0.1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: AppDimensions.width10(context) * 5.0,
                        height: AppDimensions.height10(context) * 2.1,
                        margin: EdgeInsets.only(
                            right: AppDimensions.width10(context) * 2.0),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppDimensions.font10(context) * 1.4,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF2F80ED)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Value is ---> $iniValue');
                        Navigator.of(context).pop(iniValue);
                      },
                      child: Container(
                        width: AppDimensions.width10(context) * 3.7,
                        height: AppDimensions.height10(context) * 2.1,
                        margin: EdgeInsets.only(
                            right: AppDimensions.width10(context) * 1.9),
                        child: Text(
                          'Done',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppDimensions.font10(context) * 1.4,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF2F80ED)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppDimensions.height10(context) * 26.0,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    iniValue = value;
                  },
                ),
              ),
            ],
          ),
        );
      });
  return selectedDate ?? iniValue;
}

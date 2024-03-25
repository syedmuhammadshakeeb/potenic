import 'package:flutter/material.dart';

import '../screen_utils.dart';

class GoalPracticeComponent extends StatefulWidget {
  final image1;
  final image2;
  String mainText;
  String subText;
  String smallText;
  final status;

  GoalPracticeComponent(
      {super.key,
      required this.image1,
      required this.image2,
      required this.mainText,
      required this.smallText,
      required this.subText,
      required this.status}) {}

  @override
  State<GoalPracticeComponent> createState() => _GoalPracticeComponentState();
}

class _GoalPracticeComponentState extends State<GoalPracticeComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.width10(context) * 38.4,
      height: AppDimensions.height10(context) * 49.1,
      margin: EdgeInsets.only(
        top: AppDimensions.height10(context) * 2.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius:
            BorderRadius.circular(AppDimensions.height10(context) * 2.0),
      ),
      child: Column(
        children: [
          Container(
            width: AppDimensions.width10(context) * 29.6,
            height: AppDimensions.height10(context) * 3.5,
            margin: EdgeInsets.only(
              right: AppDimensions.width10(context) * 5.5,
              top: AppDimensions.height10(context) * 1.5,
            ),
            child: Row(
              children: [
                Container(
                  width: AppDimensions.width10(context) * 3.55,
                  height: AppDimensions.height10(context) * 3.5,
                  margin: EdgeInsets.only(
                      right: AppDimensions.height10(context) * 0.8),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/menu_goals_b.webp'),
                  )),
                ),
                SizedBox(
                  width: AppDimensions.width10(context) * 22.5,
                  height: AppDimensions.height10(context) * 2.2,
                  child: Text(
                    widget.status == 'delactive'
                        ? 'Goal & Practice deleted'
                        : widget.status == 'inactive'
                            ? 'Goal & Practice scheduled'
                            : 'Goal & Practice scheduled',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.font10(context) * 1.8,
                        color: const Color(0xff437296)),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: AppDimensions.width10(context) * 35.3,
            height: AppDimensions.height10(context) * 39.6,
            margin: EdgeInsets.only(top: AppDimensions.height10(context) * 1.5),
            decoration: widget.status == 'delactive'
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        AppDimensions.height10(context) * 2.0),
                    color: const Color(0xff828282))
                : widget.status == 'inactive'
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.height10(context) * 2.0),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/timeline_1.webp'),
                            fit: BoxFit.cover))
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.height10(context) * 2.0),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/timeline_1.webp'),
                            fit: BoxFit.cover)),
            child: Column(
              children: [
                Container(
                  width: AppDimensions.width10(context) * 40.2,
                  height: AppDimensions.height10(context) * 3.4,
                  margin: EdgeInsets.only(
                      top: AppDimensions.height10(context) * 3.2),
                  child: Center(
                    child: Text(
                      widget.status == 'delactive'
                          ? 'Goal deleted!'
                          : widget.status == 'inactive'
                              ? 'Schedule stopped!'
                              : 'New schedule started',
                      style: TextStyle(
                          fontSize: AppDimensions.font10(context) * 2.8,
                          height: AppDimensions.height10(context) * 0.12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffFBFBFB)),
                    ),
                  ),
                ),
                Container(
                  width: AppDimensions.width10(context) * 26.8,
                  height: AppDimensions.height10(context) * 26.8,
                  margin: EdgeInsets.only(
                      top: AppDimensions.height10(context) * 1.9),
                  child: Stack(
                    children: [
                      Container(
                        width: AppDimensions.width10(context) * 26.8,
                        height: AppDimensions.height10(context) * 26.8,
                        padding: EdgeInsets.only(
                            bottom: AppDimensions.height10(context) * 6.0),
                        decoration: BoxDecoration(
                            image: widget.status == 'delactive'
                                ? DecorationImage(
                                    image: AssetImage(widget.image1),
                                    opacity: 0.45,
                                    fit: BoxFit.cover)
                                : widget.status == 'inactive'
                                    ? DecorationImage(
                                        image: AssetImage(widget.image1),
                                        opacity: 0.45,
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image: AssetImage(widget.image1),
                                        fit: BoxFit.cover)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: AppDimensions.width10(context) * 17.1,
                              height: AppDimensions.height10(context) * 2.4,
                              alignment: Alignment.center,
                              child: Text(
                                widget.mainText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:
                                        AppDimensions.font10(context) * 2.0,
                                    height:
                                        AppDimensions.height10(context) * 0.12,
                                    fontWeight: FontWeight.w600,
                                    color: widget.status == 'delactive'
                                        ? const Color(0xff5B74A6)
                                            .withOpacity(0.4)
                                        : widget.status == 'inactive'
                                            ? const Color(0xff5B74A6)
                                                .withOpacity(0.4)
                                            : const Color(0xff5B74A6)),
                              ),
                            ),
                            Container(
                              width: AppDimensions.width10(context) * 20.9,
                              height: AppDimensions.height10(context) * 3.63,
                              alignment: Alignment.center,
                              child: Text(
                                '“${widget.subText}”',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:
                                        AppDimensions.font10(context) * 1.6,
                                    height:
                                        AppDimensions.height10(context) * 0.15,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    color: widget.status == 'delactive'
                                        ? const Color(0xff5B74A6)
                                            .withOpacity(0.4)
                                        : widget.status == 'inactive'
                                            ? const Color(0xff5B74A6)
                                                .withOpacity(0.4)
                                            : const Color(0xff5B74A6)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const Alignment(-0.2, 1.3),
                        child: Container(
                          width: AppDimensions.width10(context) * 13.8,
                          height: AppDimensions.height10(context) * 13.8,
                          decoration: BoxDecoration(
                              image: widget.status == 'delactive'
                                  ? DecorationImage(
                                      image: AssetImage(widget.image2),
                                      opacity: 0.45,
                                      fit: BoxFit.cover)
                                  : widget.status == 'inactive'
                                      ? DecorationImage(
                                          image: AssetImage(widget.image2),
                                          opacity: 0.45,
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: AssetImage(widget.image2),
                                          fit: BoxFit.cover)),
                          child: Center(
                            child: Text(
                              widget.smallText,
                              style: TextStyle(
                                fontSize: AppDimensions.font10(context) * 1.8,
                                height: AppDimensions.height10(context) * 0.12,
                                fontWeight: FontWeight.w500,
                                color: widget.status == 'delactive'
                                    ? const Color(0xffFBFBFB).withOpacity(0.4)
                                    : widget.status == 'inactive'
                                        ? const Color(0xffFBFBFB)
                                            .withOpacity(0.4)
                                        : const Color(0xffFBFBFB),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

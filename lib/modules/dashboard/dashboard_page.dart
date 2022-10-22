import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_insta_story.dart';
import 'package:re_vision/base_widgets/base_rounded_elevated_button.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/utils/app_config.dart';

import '../../base_widgets/base_arc_painter.dart';

class DashBoardArguments {
  final User? user;

  DashBoardArguments(this.user);
}

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: const BaseText(StringConstants.dashboard),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: IconConstants.settings,
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: ListView.separated(
                      separatorBuilder: (context, state) {
                        return SizeConstants.spaceHorizontal5;
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return BaseInstaStory(
                          imageUrl:
                              "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png",
                          onTap: () {},
                        );
                      },
                    ),
                  ).paddingTop8(),
                ),
                _heading(StringConstants.overview),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, state) => Card(
                        child: SizedBox(
                          width: 220,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CustomPaint(
                                  painter: const BaseArcPainter(
                                    progress: 0.8,
                                    startColor: ColorConstants.primary,
                                    endColor: ColorConstants.secondary,
                                    width: 4.0,
                                  ),
                                  child: const BaseText('80%').center(),
                                ),
                              ),
                              SizeConstants.spaceHorizontal5,
                              const BaseText(StringConstants.completedRevision)
                            ],
                          ).paddingDefault(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingOnly(left: 8.0),
            Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: AppConfig.width(context),
                height: 80,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(AppConfig.height(context), 80),
                      painter: CustomNavigationPainter(),
                    ),
                    Center(
                      heightFactor: 0.6,
                      child: BaseElevatedRoundedButton(
                        backgroundColor: ColorConstants.loginButton,
                        child: IconConstants.mainLogo,
                        onPressed: () {
                          Navigator.of(context).pushNamed(RouteConstants.homePage);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: AppConfig.width(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: IconConstants.habits,
                            color: Colors.white,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: IconConstants.todo,
                            color: Colors.white,
                          ),
                          (AppConfig.width(context) * 0.20).separation(false),
                          IconButton(
                            onPressed: () {},
                            icon: IconConstants.lover,
                            color: Colors.white,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: IconConstants.rising,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------Functions-------------------------------------------
  SliverPadding _heading(String title) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 8.0),
      sliver: SliverToBoxAdapter(
        child: BaseText(title, fontSize: 20.0, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class CustomNavigationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double x = size.width;
    final double y = size.height;

    Paint paint = Paint()
      ..color = ColorConstants.primary
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, 20);

    path.quadraticBezierTo(x * 0.20, 0, x * 0.35, 0);
    path.quadraticBezierTo(x * 0.40, 0, x * 0.40, 20);
    path.arcToPoint(
      Offset(x * 0.60, 20),
      radius: const Radius.circular(20.0),
      clockwise: false,
    );
    path.quadraticBezierTo(x * 0.60, 0, x * 0.65, 0);
    path.quadraticBezierTo(x * 0.80, 0, x, 20);
    path.lineTo(x, y);
    path.lineTo(0, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

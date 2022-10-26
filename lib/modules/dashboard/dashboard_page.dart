import 'package:carousel_slider/carousel_slider.dart';
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

enum CurrentS { dashboard, todo, habits, notifications }

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));
}

class _DashBoardState extends State<DashBoard> {
  CurrentS _currentS = CurrentS.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _getS(),
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
                        backgroundColor: ColorC.loginButton,
                        child: IconC.mainLogo,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RouteConstants.homePage);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: AppConfig.width(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dashboard.
                          _bottomNavButton(
                            CurrentS.dashboard,
                            _currentS,
                            icon: IconC.dashboard,
                          ),
                          // To-do.
                          _bottomNavButton(
                            CurrentS.todo,
                            _currentS,
                            icon: IconC.todo,
                          ),
                          (AppConfig.width(context) * 0.20).separation(false),
                          // Habits.
                          _bottomNavButton(
                            CurrentS.habits,
                            _currentS,
                            icon: IconC.habits,
                          ),
                          // Notifications.
                          _bottomNavButton(
                            CurrentS.notifications,
                            _currentS,
                            icon: IconC.notification,
                          ),
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

  IconButton _bottomNavButton(CurrentS val, CurrentS grpVal,
      {required Icon icon}) {
    return IconButton(
      onPressed: () {
        _currentS = val;
        setState(() {});
      },
      icon: icon,
      color: val == grpVal ? ColorC.button : ColorC.white,
    );
  }

  // Dashboard.
  CustomScrollView _dashboard(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const BaseText(StringC.dashboard),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteConstants.profilePage);
              },
              icon: IconC.user,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.separated(
              separatorBuilder: (context, state) {
                return SizeC.spaceHorizontal5;
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
          ).paddingOnly(top: 8.0, left: 14.0),
        ),
        _heading(StringC.overview),
        SliverToBoxAdapter(
          child: CarouselSlider.builder(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.7,
              initialPage: 1,
            ),
            itemCount: 3,
            itemBuilder: (context, itemIndex, pageIndex) => Card(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: const [
                        DashBoard._divider,
                        BaseText(
                          StringC.revision,
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                        ),
                        DashBoard._divider
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomPaint(
                            painter: const BaseArcPainter(
                              progress: 0.8,
                              startColor: Colors.red,
                              endColor: ColorC.secondary,
                              width: 4.0,
                            ),
                            child: const BaseText('80%').center(),
                          ),
                        ),
                        SizeC.spaceHorizontal10,
                        const BaseText(
                          StringC.pending,
                          color: ColorC.subtitle,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconC.star,
                        ),
                        SizeC.spaceHorizontal10,
                        BaseText(
                          StringC.stars.padRight(20, ' '),
                          color: ColorC.subtitle,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    ),
                  ],
                ).paddingDefault(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // -----------------------Functions-------------------------------------------

  // To get the current screen.
  Widget _getS() {
    switch (_currentS) {
      case CurrentS.dashboard:
        return _dashboard(context);
      case CurrentS.todo:
        return Container();
      case CurrentS.habits:
        return Container();
      case CurrentS.notifications:
        return Container();
      default:
        return _dashboard(context);
    }
  }

  SliverPadding _heading(String title) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 8.0, left: 16.0),
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
      ..color = ColorC.primary
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:re_vision/models/user_dm.dart';
import 'package:re_vision/modules/search_page/search_page.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/utils/app_config.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';
import 'package:re_vision/utils/social_auth/base_auth.dart';

import '../../base_widgets/base_arc_painter.dart';

enum CurrentS { dashboard, search, notifications, profile }

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));
}

class _DashBoardState extends State<DashBoard> {
  CurrentS _currentS = CurrentS.search;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        backgroundColor: ColorC.elevatedButton,
                        child: IconC.mainLogo,
                        onPressed: () {
                          Navigator.of(context).pushNamed(RouteC.homePage);
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
                          // Search.
                          _bottomNavButton(
                            CurrentS.search,
                            _currentS,
                            icon: IconC.search,
                          ),
                          (AppConfig.width(context) * 0.20).separation(false),
                          // Notifications.
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _bottomNavButton(
                                CurrentS.notifications,
                                _currentS,
                                icon: IconC.notification,
                              ),
                              Positioned(
                                bottom: -10,
                                child: Container(
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorC.secondary),
                                  height: 5, width: 5,
                                ),
                              )
                            ],
                          ),
                          // Profile.
                          _bottomNavButton(
                            CurrentS.profile,
                            _currentS,
                            icon: IconC.profile,
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
              onPressed: () {},
              icon: IconC.settings,
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
                        ),
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

  /// To get the friend requests.
  void _getFRRequests() async {
    DocumentSnapshot? snap = await BaseCloud.readD(
      collection: CloudC.users,
      document: BaseAuth.currentUser()?.uid ?? '',
    );

    if (snap != null) {
      final Map<String, dynamic> snapD = snap.data() as Map<String, dynamic>;
      UserFBDm snapM = UserFBDm.fromJson(snapD);

      List <Requests> req = snapM.requests ?? [];

      if (req.isNotEmpty) {
        for (Requests e in req) {
          if (e.seen == 0) {
            // Show notification badge.
            break;
          }
        }
      }
    }
  }

  /// To get the current screen.
  Widget _getS() {
    switch (_currentS) {
      case CurrentS.dashboard:
        return _dashboard(context);
      case CurrentS.search:
        return const SearchPage();
      case CurrentS.profile:
        return Container();
      case CurrentS.notifications:
        return Container();
      default:
        return _dashboard(context);
    }
  }

  /// The heading of each section in the [DashboardPage].
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

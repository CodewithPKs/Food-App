import 'dart:async';
import 'dart:developer';

import 'package:bottom_navbar_with_indicator/bottom_navbar_with_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/bottom_nav_bar/widgets/app_exit_alert_dialog.dart';

import '../app_bar/custom_app_bar.dart';
import '../constants/colors.dart';
import '../home/HomeNewScreen.dart';
import 'controller/nav_bar_provider.dart';


class KrishiBottomNavBar extends StatefulWidget {

  final int screenIndex;

  const KrishiBottomNavBar({super.key, this.screenIndex = 0});

  @override
  State<KrishiBottomNavBar> createState() => _KrishiBottomNavBarState();
}

class _KrishiBottomNavBarState extends State<KrishiBottomNavBar> with WidgetsBindingObserver, SingleTickerProviderStateMixin {

  int _selectedIndex = 0;

  bool isKrishiNewsEnabled = true;

  late AnimationController _animationController;
  late NavBarProvider provider;

  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    initAnimationController();

    setState(() {
      _selectedIndex = widget.screenIndex;
    });

    provider = Provider.of<NavBarProvider>(context, listen: false);

    setState(() {
      isKrishiNewsEnabled = provider.isKrishiNewsEnabled;
    });

    fetchRequiredData();

    initDeeplinks();

    //PermissionController.onContactPermissionGranted();
  }

  fetchRequiredData() async {
    bool isEnabled = await provider.fetchKrishiNewsStatus();

    setState(() {
      isKrishiNewsEnabled = isEnabled;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.fetchNetcoreBotStatus();
    });
  }

  void initAnimationController() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> initDeeplinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String languageCode = prefs.getString('language_code') ?? '';

   // NetcoreService.initDeepLinks(context: context, languageCode: languageCode);

    // FirebaseDynamicLinkService.initDynamicLink(context);


  }

  Future<bool> _onWillPop() async {

    if (_selectedIndex == 0) {

      bool? exit = await showDialog(
        context: context,
        builder: (context) {
          return AppExitAlertDialog();
        }
      );

      return exit ?? false;
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KrishiBottomNavBar()),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(child: Scaffold(
          backgroundColor: Color.fromRGBO(245, 246, 250, 1),

          appBar: CustomAppBar(),

          // drawer: Hamburger(),

          body: getWidgetOptions().elementAt(_selectedIndex),

          floatingActionButton: Consumer<NavBarProvider>(
              builder: (context, NavBarProvider provider, child) {
                return provider.isNetCoreBotEnabled
                    ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    if (provider.isExpanded)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_selectedIndex == 2 && isKrishiNewsEnabled && provider.isAddPostEnabled) ...[

                            Hero(
                                tag: 'add_post_button',
                                child: SizedBox()
                            ),

                            const SizedBox(height: 10),

                          ],

                          // _customFloatingButtons(
                          //   icon: Icons.video_call,
                          //   iconColor: KrishiColors.primary,
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //       context,
                          //       Routes.navBar,
                          //       arguments: getWidgetOptions().length - 1,
                          //     );
                          //   },
                          // ),

                          const SizedBox(height: 10),

                          // _customFloatingButtons(
                          //   icon: Icons.call,
                          //   iconColor: Colors.orange,
                          //   onTap: () async {
                          //
                          //     final String number = contactModel?.number ?? '+917000528397' ;
                          //
                          //     final Uri callUri = Uri(scheme: 'tel', path: number);
                          //
                          //     if (await canLaunchUrl(callUri)) {
                          //       await launchUrl(callUri);
                          //     } else {
                          //       log('Could not launch $callUri');
                          //     }
                          //   },
                          // ),

                          const SizedBox(height: 10),

                          // _customFloatingButtons(
                          //   icon: Iconsax.message,
                          //   imageIcon: 'assets/icons/Chat Bot.png',
                          //   iconColor: Colors.blueAccent,
                          //   onTap: () async {
                          //
                          //     final String number = contactModel?.chatBot ?? '+919201972066' ;
                          //
                          //     final Uri whatsappUri = Uri(
                          //       scheme: 'https',
                          //       host: 'wa.me',
                          //       path: number,
                          //     );
                          //
                          //     if (await canLaunchUrl(whatsappUri)) {
                          //       await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                          //     } else {
                          //       throw 'Could not launch $whatsappUri';
                          //     }
                          //   },
                          // ),

                          const SizedBox(height: 15),
                        ],
                      ),

                    if (_selectedIndex == 2 && isKrishiNewsEnabled && !provider.isExpanded && provider.isAddPostEnabled) ...[
                      Hero(
                          tag: 'add_post_button',
                          child: SizedBox()
                      ),

                      const SizedBox(height: 10),
                    ],

                    GestureDetector(
                      onTap: () {
                        provider.toggleExpanded();
                        if (provider.isExpanded) {
                          _animationController.forward();
                        } else {
                          _animationController.reverse();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: KrishiColors.primaryLight2_5,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: KrishiColors.primary,
                              width: 1.5
                          ),
                        ),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          color: KrishiColors.primary,
                          size: 24,
                          progress: _animationController,
                        ),
                      ),
                    ),
                  ],
                )
                    :
                _selectedIndex == 2 && isKrishiNewsEnabled && provider.isAddPostEnabled
                    ?
                SizedBox()
                    :
                SizedBox();
              }
          ),

          bottomNavigationBar: Material(
            color: const Color(0xff1A1410),
            elevation: 8,
            child: CustomLineIndicatorBottomNavbar(
              unselectedIconSize: 20,
              selectedIconSize: 26,
              selectedColor:  Colors.orange,
              unSelectedColor: Colors.white,
              backgroundColor:  Color(0xff1A1410),
              currentIndex: _selectedIndex,
              unselectedFontSize: 12,
              selectedFontSize: 13,
              onTap: onItemTapped,
              enableLineIndicator: true,
              lineIndicatorWidth: 4,
              indicatorType: IndicatorType.top,
              customBottomBarItems: getBottomBarItems(context),
            ),
          )
      ))
    );
  }


  Widget _customFloatingButtons({
    required IconData icon,
    String? imageIcon,
    required Color iconColor,
    required VoidCallback onTap,
    Color backgroundColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: iconColor,
            width: 1.5
          ),
        ),
        child: imageIcon != null
            ?
        Image.asset(
          imageIcon,
          height: 24,
          width: 24,
          color: iconColor,
          fit: BoxFit.fill,
        )
            :
        Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    String screenName;

    switch (index) {
      case 0:
        screenName = "";
        break;

      case 1:
        screenName = "";
        break;

      case 2:
        screenName = "";
        break;

      case 3:
        screenName = "";
        break;

      case 4:
        screenName = "";
        break;

      case 5:
        screenName = "";
        break;

      default:
        screenName = 'Unknown Screen';
        break;
    }

    _selectedIndex = index;

    setState(() {});

    // if (screenName != Routes.home && screenName != Routes.agriAdvisor) {
    //   Timer(
    //     Duration(seconds: 5),
    //     () => NetcoreService.screenLoadEvent(screenName),
    //   );
    // }
  }

  List<Widget> getWidgetOptions() {

    List<Widget> widgetOptions = [
      const Homenewscreen(),
      SizedBox(),
      SizedBox(),
      SizedBox()
      // const CropScreen(isHome: true),
      // const CategeryProductPage(isHome: true),
      // const AgriAdvisoryScreen(isHome: true),
    ];


    return widgetOptions;
  }

  List<CustomBottomBarItems> getBottomBarItems(BuildContext context) {

    List<CustomBottomBarItems> bottomBarItems = [

      CustomBottomBarItems(
        label: '',
        icon: Icons.menu_book_outlined,
        isAssetsImage: false,
      ),

      CustomBottomBarItems(
          label: '',
          icon: FontAwesomeIcons.bagShopping,
        isAssetsImage: false,
      ),

      CustomBottomBarItems(
          label:  '',
          icon: FontAwesomeIcons.arrowDownUpLock,
        isAssetsImage: false,
      ),

      CustomBottomBarItems(
        label: '',
        icon: Icons.support_agent_rounded,
        isAssetsImage: false,
      ),

      CustomBottomBarItems(
        label:  '',
        icon: Icons.menu,
        isAssetsImage: false,
      ),
    ];

    if (isKrishiNewsEnabled) {
      bottomBarItems.insert(
          2,
          CustomBottomBarItems(
              label:  '',
              icon: FontAwesomeIcons.newspaper,
            isAssetsImage: false,
          )
      );
    }

    return bottomBarItems;
  }
}

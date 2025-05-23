import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:animated_box_decoration/animated_box_decoration.dart';
import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/extensions/uriExtension.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/models/model_datasource.dart';
import 'package:portfolio/models/enum_screen_type.dart';
import 'package:portfolio/pages/app/tab_aboutme.dart';
import 'package:portfolio/pages/app/tab_blog.dart';
import 'package:portfolio/pages/app/tab_callscreen.dart';
import 'package:portfolio/pages/app/tab_timeline.dart';
import 'package:portfolio/pages/app/widgets/flag.dart';
import 'package:portfolio/widgets/ring_vibration.dart';
import 'package:portfolio/widgets/slide_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabControllerAppPage extends StatelessWidget {
  const TabControllerAppPage({
    super.key,
    this.bodyWidth,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final Duration animationDuration;
  final double? bodyWidth;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: AppPage(
        bodyWidth: bodyWidth,
        animationDuration: animationDuration,
      ),
    );
  }
}

class AppPage extends StatefulWidget {
  static const String routeName = '/';

  const AppPage({
    super.key,
    this.bodyWidth,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final Duration animationDuration;
  final double? bodyWidth;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final GlobalKey appKey = GlobalKey();
  final GlobalKey headerKey = GlobalKey();
  final GlobalKey<RingVibrationState> ringKey = GlobalKey();
  late final List<Tab> _tabs;

  var player = AudioPlayer();
  bool ringAudioPlayed = false;

  @override
  void initState() {
    _tabs = [
      const Tab(icon: Icon(FontAwesomeIcons.solidUser)),
      const Tab(icon: Icon(FontAwesomeIcons.medal)),
      const Tab(icon: Icon(FontAwesomeIcons.pencil)),
      Tab(
        icon: RingVibration(
          key: ringKey,
          automatic: false,
          child: const Icon(FontAwesomeIcons.phone),
        ),
      ),
    ];
    super.initState();
  }

  int selectedTabIndex = 0;
  double bodyWidth = 400;

  BoxConstraints? tabBoxConstraints;
  AppLocalizations? localizations;
  MediaQueryData? mediaQuery;
  ThemeData? theme;
  List<Widget>? _tabViews;

  Datasource? selectedDatasource;

  Future cache(String fontFamilyName, String fontUrl) async {
    DynamicCachedFonts.removeCachedFont(fontUrl);
    if (await DynamicCachedFonts.canLoadFont(fontUrl)) {
      await DynamicCachedFonts.loadCachedFont(
        fontUrl,
        fontFamily: fontFamilyName,
      );
    } else {
      final cacher = DynamicCachedFonts(
        fontFamily: fontFamilyName,
        url: fontUrl,
      );

      await cacher.load();
    }
  }

  late Future<List<Datasource>> datasourceFuture = generateDatasourceFuture();
  Future<List<Datasource>> generateDatasourceFuture() async {
    player.setVolume(0.2);
    player.setAsset('assets/ring.mp3', preload: true);

    var importantResourceFuturess = <Future<dynamic>>[
      // rootBundle.loadString('assets/resume.json'),
      http.get(Uri.parse('https://iamjamali.ir/assets/assets/resume.json'))
    ];

    if (kIsWeb) {
      importantResourceFuturess.add(
        cache('FontAwesomeSolid', 'assets/assets/font/fa/fa-solid-900.ttf'),
      );
      precacheImage(const AssetImage("assets/images/callbg.jpg"), context);
      cache('times', 'assets/assets/font/times/regular.ttf');
      cache('pnazanin', 'assets/assets/font/pnazanin/regular.ttf');
      cache('MaterialIcons', 'assets/assets/font/material_icons.otf');
      cache('FontAwesomeBrands', 'assets/assets/font/fa/fa-brands-400.ttf');
      cache('FontAwesomeRegular', 'assets/assets/font/fa/fa-regular-400.ttf');
    }

    try {
      final resources = await Future.wait(importantResourceFuturess);

      final portfolioData = utf8.decode(resources.first.bodyBytes);
      return List.from(json.decode(portfolioData))
          .map((e) => Datasource.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  void _decideBodySize() {
    setState(() {
      final windowHeight = max(
        300,
        min(MediaQuery.of(context).size.height, 700) -
            (headerKey.currentContext?.size?.height ?? 0),
      );
      tabBoxConstraints = BoxConstraints(
        minHeight: windowHeight - 100 - 48,
        maxHeight: windowHeight - 48,
      );
    });
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    mediaQuery = MediaQuery.of(context);
    theme = Theme.of(context);

    bodyWidth = widget.bodyWidth ??
        // mediaQuery?.getAppWidth().toDouble() ??
        WidgetsBinding.instance.window.getAppWidth();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneCall = selectedTabIndex == 3;

    return Scaffold(
      floatingActionButton: mediaQuery!.getScreenType() != ScreenType.small &&
              !isPhoneCall
          ? FloatingActionButton(
              onPressed: () {
                if (mounted) {
                  if (ringAudioPlayed) {
                    setState(() {
                      final tabController = DefaultTabController.of(context);
                      selectedTabIndex = _tabs.length - 1;
                      tabController.animateTo(selectedTabIndex);
                    });
                  } else {
                    ringKey.currentState?.ring();
                    player.play();
                    ringAudioPlayed = true;
                  }
                }
              },
              tooltip: localizations!.hi,
              child: const Icon(Icons.waving_hand_rounded),
            )
          : null,
      body: !isPhoneCall && (selectedDatasource?.supportDeveloper ?? false)
          ? Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () => "https://iamjamali.ir".tryLaunch(
                        "https://iamjamali.ir",
                        context,
                      ),
                      child: Text(
                        "Developed by Mohammad Jamali",
                        style: theme?.textTheme.bodySmall?.copyWith(
                          color: theme?.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                mainPage(isPhoneCall),
              ],
            )
          : mainPage(isPhoneCall),
    );
  }

  Widget mainPage(bool isPhoneCall) {
    return SafeArea(
      left: !kIsWeb,
      right: !kIsWeb,
      top: !kIsWeb,
      bottom: !kIsWeb,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Card(
              key: appKey,
              elevation: 1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: SmoothAnimatedContainer(
                duration: const Duration(milliseconds: 300),
                clipBehavior: Clip.hardEdge,
                width: bodyWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: selectedTabIndex == 3
                      ? const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/callbg.jpg",
                          ),
                        )
                      : null,
                ),
                child: AnimatedSize(
                  duration: widget.animationDuration,
                  curve: Curves.easeOutQuad,
                  child: FutureBuilder(
                    future: datasourceFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox(
                          height: 400,
                          child: Center(
                            child: SizedBox(
                              height: 64,
                              width: 64,
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return SizedBox(
                          height: 400,
                          child: Center(
                            child: Text(snapshot.error?.toString() ?? "Error"),
                          ),
                        );
                      }

                      if (tabBoxConstraints == null) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _decideBodySize(),
                        );
                      }

                      final languages =
                          snapshot.data!.map((e) => e.language).toList();
                      if (selectedDatasource?.language !=
                          localizations!.localeName) {
                        selectedDatasource = snapshot.data!.firstWhere(
                          (element) =>
                              element.language == localizations!.localeName,
                          orElse: () => snapshot.data!.firstWhere(
                            (element) => element.language == 'en',
                            orElse: () => snapshot.data!.first,
                          ),
                        );

                        _tabViews = [
                          AboutMe(selectedDatasource!.aboutMe),
                          ScrollableTimeline(selectedDatasource!.timeline),
                          Blog(selectedDatasource!.blog),
                          Center(
                            child: CallScreen(selectedDatasource!.contacts),
                          )
                        ];

                        if (languages.length == 1) {
                          context.read<AppSettingCubit>().setLocale(
                                languages.first,
                              );
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child:
                                  _header(200, theme!, isPhoneCall, languages)),
                          const Padding(padding: EdgeInsets.only(top: 24)),
                          TabBar(
                            labelColor: isPhoneCall ? Colors.white : null,
                            unselectedLabelColor: isPhoneCall
                                ? Colors.white.withValues(alpha: 0.1)
                                : null,
                            indicator: isPhoneCall
                                ? const UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  )
                                : null,
                            indicatorColor: theme!.colorScheme.secondary,
                            onTap: (value) => setState(
                              () => selectedTabIndex = value,
                            ),
                            tabs: _tabs,
                          ),
                          AnimatedSize(
                            duration: widget.animationDuration,
                            curve: Curves.easeOutQuad,
                            child: AnimatedSwitcher(
                              duration: widget.animationDuration,
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) =>
                                  SlideTransitionX(
                                direction: AxisDirection.right,
                                position: animation,
                                child: child,
                              ),
                              child: Container(
                                constraints: tabBoxConstraints,
                                child: SingleChildScrollView(
                                  child: _tabViews![selectedTabIndex],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(
    double height,
    ThemeData theme,
    bool isPhoneCall,
    List<String> languages,
  ) {
    return Column(
      key: headerKey,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => context.read<AppSettingCubit>().toggleTheme(),
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: BlocBuilder<AppSettingCubit, AppSetting>(
                    builder: (context, state) => Icon(
                      state.themeMode == ThemeMode.dark
                          ? Icons.sunny
                          : FontAwesomeIcons.moon,
                      color: isPhoneCall
                          ? Colors.white.withValues(alpha: 0.1)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<AppSettingCubit, AppSetting>(
              builder: (context, state) {
                // Get the image URL based on the theme
                String imageUrl = state.themeMode == ThemeMode.light
                    ? selectedDatasource!.aboutMe.lightProfilePic
                    : selectedDatasource!.aboutMe.darkProfilePic;

                return Container(
                  width: height * 0.6,
                  height: height * 0.6,
                  margin: const EdgeInsets.only(
                    top: 24,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      height,
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(height),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image is loaded
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ); // Show error icon if the image fails to load
                      },
                    ),
                  ),
                );
              },
            ),
            FlagButton(languages: languages),
          ],
        ),
        Text(
          selectedDatasource!.aboutMe.fullname,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPhoneCall ? Colors.white : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
          child: Text(
            selectedDatasource!.aboutMe.slogan,
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPhoneCall ? Colors.white : null,
            ),
          ),
        ),
      ],
    );
  }
}

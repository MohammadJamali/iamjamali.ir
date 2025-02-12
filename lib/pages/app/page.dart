import 'dart:convert';
import 'dart:math';

import 'package:animated_box_decoration/animated_box_decoration.dart';
import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    var importantResources = Future.wait([
      rootBundle.loadString('assets/resume.json'),
      cache('FontAwesomeSolid', 'assets/assets/font/fa/fa-solid-900.ttf')
    ]);

    precacheImage(const AssetImage("assets/images/callbg.jpg"), context);
    player.setVolume(0.2);
    player.setAsset('assets/ring.mp3', preload: true);
    cache('times', 'assets/assets/font/times/regular.ttf');
    cache('pnazanin', 'assets/assets/font/pnazanin/regular.ttf');
    cache('MaterialIcons', 'assets/assets/font/material_icons.otf');
    cache('FontAwesomeBrands', 'assets/assets/font/fa/fa-brands-400.ttf');
    cache('FontAwesomeRegular', 'assets/assets/font/fa/fa-regular-400.ttf');

    try {
      return List.from(json.decode((await importantResources).first))
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
                          color:
                              theme?.textTheme.bodySmall?.color?.withValues(alpha:0.2),
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

  Center mainPage(bool isPhoneCall) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          // margin: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Card(
            key: appKey,
            elevation: 4,
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
                            child: RefreshProgressIndicator(),
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
                      color: isPhoneCall ? Colors.white.withValues(alpha: 0.1) : null,
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<AppSettingCubit, AppSetting>(
              builder: (context, state) => Container(
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
                  image: DecorationImage(
                    image: NetworkImage(
                      state.themeMode == ThemeMode.light
                          ? selectedDatasource!.aboutMe.lightProfilePic
                          : selectedDatasource!.aboutMe.darkProfilePic,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
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
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            selectedDatasource!.aboutMe.slogan,
            maxLines: 2,
            softWrap: true,
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

class FlagButton extends StatelessWidget {
  const FlagButton({super.key, required this.languages});

  final List<String> languages;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingCubit, AppSetting>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: languages.length > 1
                ? () {
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: '',
                      barrierColor: Colors.black38,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (ctx, anim1, anim2) => Directionality(
                        textDirection: TextDirection.ltr,
                        child: AlertDialog(
                          title: const Text(
                            'Language',
                            style: TextStyle(
                              fontFamily: 'times',
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Which language do you speek ?',
                                style: TextStyle(
                                  fontFamily: 'times',
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(top: 16.0)),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<AppSettingCubit>()
                                            .setLocale('en');

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            elevation: 6.0,
                                            content: Text(
                                              lookupAppLocalizations(Locale('en')).languageChanged,
                                              style: TextStyle(
                                                color: state.themeMode ==
                                                        ThemeMode.light
                                                    ? const Color(0xDDFFFFFF)
                                                    : const Color(0xDD000000),
                                                fontFamily: 'times',
                                              ),
                                            ),
                                          ),
                                        );

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'English',
                                        style: TextStyle(
                                          fontFamily: 'times',
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<AppSettingCubit>()
                                            .setLocale('fa');

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            elevation: 6.0,
                                            content: Text(
                                              lookupAppLocalizations(Locale('fa')).languageChanged,
                                              style: TextStyle(
                                                  color: state.themeMode ==
                                                          ThemeMode.light
                                                      ? const Color(0xDDFFFFFF)
                                                      : const Color(0xDD000000),
                                                  fontFamily: 'pnazanin'),
                                            ),
                                          ),
                                        );

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Persian',
                                        style: TextStyle(
                                          fontFamily: 'times',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          elevation: 2,
                        ),
                      ),
                      // transitionBuilder: (ctx, anim1, anim2, Widget tbChild) =>
                      //     FadeTransition(
                      //   opacity: anim1,
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(
                      //       sigmaX: 4,
                      //       sigmaY: 4,
                      //     ),
                      //     child: tbChild,
                      //   ),
                      // ),
                      context: context,
                    );
                  }
                : null,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: countryIcons[state.locale ?? 'en'] as ImageProvider<Object>,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

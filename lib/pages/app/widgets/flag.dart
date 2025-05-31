import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/l10n/app_localizations.dart';

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
                                    _languageBtn(context, state, 'en'),
                                    _languageBtn(context, state, 'fa'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          elevation: 2,
                        ),
                      ),
                      transitionBuilder: _transitionBuilder(),
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
                    image: countryIcons[state.locale ?? 'en']
                        as ImageProvider<Object>,
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

  _transitionBuilder() {
    if (kIsWeb) return null;

    return (ctx, anim1, anim2, Widget tbChild) => FadeTransition(
          opacity: anim1,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4,
              sigmaY: 4,
            ),
            child: tbChild,
          ),
        );
  }

  _languageBtn(
    BuildContext context,
    AppSetting state,
    String languageCode,
  ) =>
      TextButton(
        onPressed: () => _changeLocal(
          context,
          state,
          languageCode,
        ),
        child: Text(
          lookupAppLocalizations(Locale(languageCode)).language,
          style: TextStyle(
            fontFamily: _fontFamily(languageCode),
          ),
        ),
      );

  _changeLocal(
    BuildContext context,
    AppSetting state,
    String languageCode,
  ) {
    context.read<AppSettingCubit>().setLocale(languageCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6.0,
        content: Text(
          lookupAppLocalizations(Locale(languageCode)).languageChanged,
          style: TextStyle(
            color: state.themeMode == ThemeMode.light
                ? const Color(0xDDFFFFFF)
                : const Color(0xDD000000),
            fontFamily: _fontFamily(languageCode),
          ),
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  _fontFamily(String local) => switch (local) {
        'en' => 'times',
        'fa' => 'pnazanin',
        _ => null,
      };
}

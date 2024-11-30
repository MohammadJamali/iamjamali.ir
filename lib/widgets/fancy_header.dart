import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/models/enum_screen_type.dart';

class FancyHeader extends StatelessWidget {
  const FancyHeader({
    super.key,
    required this.bodyWidth,
  });

  final double bodyWidth;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    double headerHeight = min(300.0, mediaQuery.size.height * 0.3);
    double headerWidth = bodyWidth * 1.3;
    BorderRadius headerBorderRadius;

    if (mediaQuery.getScreenType() == ScreenType.small) {
      headerWidth = bodyWidth;
      headerBorderRadius = const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      );
    } else {
      headerBorderRadius = const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      );
    }

    return Stack(
      children: [
        Center(
          child: Container(
            width: headerWidth,
            height: headerHeight,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: headerBorderRadius,
              image: const DecorationImage(
                image: AssetImage('assets/images/bg.jpeg'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0,
                ),
                child: Container(
                  width: bodyWidth,
                  height: headerHeight * 0.6,
                  alignment: AlignmentDirectional.centerStart,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(60, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                    end: 24,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: headerHeight * 0.4,
                        height: headerHeight * 0.4,
                        margin: const EdgeInsetsDirectional.only(end: 16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            headerHeight,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "localizations.author",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "localizations.slogan",
                                maxLines: 2,
                                softWrap: true,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

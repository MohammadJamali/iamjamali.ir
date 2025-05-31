import 'package:flutter/material.dart';
import 'package:portfolio/models/model_timeline.dart';
import 'package:portfolio/widgets/fancy_header.dart';
import 'package:portfolio/widgets/timeline_point.dart';

import 'package:portfolio/l10n/app_localizations.dart';

class FancyTimelinePage extends StatelessWidget {
  const FancyTimelinePage({
    super.key,
    required this.model,
  });

  final bodyWidth = 350.0;
  final List<TimelineModel> model;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 36,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FancyHeader(bodyWidth: bodyWidth),
          Flexible(
            fit: FlexFit.loose,
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: 600,
                  minWidth: bodyWidth,
                  maxWidth: bodyWidth,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      const SizedBox.square(
                        dimension: 8,
                      ),
                      ...model
                          .asMap()
                          .map(
                            (index, timeline) => MapEntry(
                              key,
                              TimelinePoint(
                                model: timeline,
                                tail: index < model.length - 1,
                              ),
                            ),
                          )
                          .values,
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 16, bottom: 32),
                        child: OutlinedButton(
                          onPressed: () => {},
                          child: Text(localizations.showMore),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

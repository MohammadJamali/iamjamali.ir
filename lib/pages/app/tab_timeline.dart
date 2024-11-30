import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/models/model_timeline.dart';
import 'package:portfolio/widgets/timeline_point.dart';

class ScrollableTimeline extends StatefulWidget {
  const ScrollableTimeline(this.model, {super.key});

  final List<TimelineModel> model;

  @override
  State<ScrollableTimeline> createState() => _ScrollableTimelineState();
}

class _ScrollableTimelineState extends State<ScrollableTimeline> {
  late int lastItemShowed = min(widget.model.length, 3);

  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.model.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                const SizedBox.square(
                  dimension: 8,
                ),
                ...widget.model
                    .sublist(0, lastItemShowed)
                    .asMap()
                    .map(
                      (index, timeline) => MapEntry(
                        index,
                        TimelinePoint(
                          key: ValueKey(index),
                          model: timeline,
                          tail: index < lastItemShowed - 1,
                        ),
                      ),
                    )
                    .values
                    ,
                if (lastItemShowed < widget.model.length)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        lastItemShowed += min(
                          3,
                          widget.model.length - lastItemShowed,
                        );
                      }),
                      child: Text(localizations!.showMore),
                    ),
                  )
              ],
            ),
          )
        : _emptyResult(localizations!);
  }

  Widget _emptyResult(AppLocalizations localizations) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 24),
      child: Wrap(
        spacing: 16.0,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.clockRotateLeft),
          Text(localizations.emptyTimeline)
        ],
      ),
    );
  }
}

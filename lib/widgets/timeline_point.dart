import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/extensions/uriExtension.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/models/enum_icon_class.dart';
import 'package:portfolio/models/model_timeline.dart';
import 'package:portfolio/pages/detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shamsi_date/shamsi_date.dart';

class TimelinePoint extends StatefulWidget {
  final bool tail;
  final TimelineModel model;

  const TimelinePoint({
    super.key,
    required this.tail,
    required this.model,
  });

  @override
  State<TimelinePoint> createState() => _TimelinePointState();
}

class _TimelinePointState extends State<TimelinePoint> {
  final UniqueKey heroKey = UniqueKey();

  AppLocalizations? localizations;
  ThemeData? theme;

  bool hover = false;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  String daysBetweenToString(int days) {
    final years = days ~/ 360;
    final months = ((days - (years * 360)) / 30).round();

    if (years > 0) {
      if (months > 0) {
        return localizations!.yearMonth
            .replaceFirst('{0}', '$years')
            .replaceFirst('{1}', '$months');
      }
      return localizations!.years.replaceFirst('{0}', '$years');
    }

    return localizations!.months.replaceFirst('{0}', '$months');
  }

  String dateRange() {
    String startAtStr;
    String? finishedAtStr;
    if (localizations!.localeName == "fa") {
      final startAt = Jalali.fromDateTime(widget.model.startedAt!).formatter;
      if (widget.model.startedAt!.day > 1) {
        startAtStr = '${startAt.d} ${startAt.mN} ${startAt.yyyy}';
      } else {
        startAtStr = '${startAt.mN} ${startAt.yyyy}';
      }

      if (widget.model.finishedAt != null) {
        final finishedAt = Jalali.fromDateTime(
          widget.model.finishedAt!,
        ).formatter;

        if (widget.model.finishedAt!.day > 1) {
          finishedAtStr = '${finishedAt.d} ${finishedAt.mN} ${finishedAt.yyyy}';
        } else {
          finishedAtStr = '${finishedAt.mN} ${finishedAt.yyyy}';
        }
      }
    } else {
      if (widget.model.startedAt!.day > 1) {
        startAtStr = DateFormat.yMMMMd().format(widget.model.startedAt!);
      } else {
        startAtStr = DateFormat.yMMMM().format(widget.model.startedAt!);
      }

      if (widget.model.finishedAt != null) {
        if (widget.model.finishedAt!.day > 1) {
          finishedAtStr = DateFormat.yMMMMd().format(widget.model.finishedAt!);
        } else {
          finishedAtStr = DateFormat.yMMMM().format(widget.model.finishedAt!);
        }
      }
    }
    return localizations!.dateUntilDate
        .replaceFirst('{0}', startAtStr)
        .replaceFirst('{1}', finishedAtStr ?? localizations!.now);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.model.detail != null ? null : theme!.disabledColor;

    var caption = widget.model.caption;
    if (widget.model.startedAt != null) {
      final diff = daysBetweenToString(
        daysBetween(
          widget.model.startedAt!,
          widget.model.finishedAt ?? DateTime.now(),
        ),
      );
      final range = dateRange();

      caption = [caption, range, diff]
          .where(
            (e) => (e?.length ?? 0) > 0,
          )
          .join(", ");
    }

    return InkWell(
      onTap: widget.model.detail != null
          ? () => Navigator.of(
                context,
              ).pushNamed(
                DetailPage.routeName,
                arguments: DetailPageArguments(
                  widget.model.detail!,
                  heroKey,
                ),
              )
          : widget.model.externalLink != null
              ? () => Uri.parse(widget.model.externalLink!).tryLaunch()
              : null,
      hoverColor: widget.model.color != null
          ? Color(widget.model.color!).withOpacity(0.05)
          : null,
      onHover: (value) => setState(() => hover = value),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
          bottom: 8,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 4,
                    width: 64,
                  ),
                  BlocBuilder<AppSettingCubit, AppSetting>(
                    builder: (context, state) => widget.model.image != null
                        ? _imageTimelinePoint(widget.model.image!, color)
                        : widget.model.iconCode == null
                            ? _circleAnimatedContainer(state.themeMode, color)
                            : _iconTimelinePoint(color),
                  ),
                  if (widget.tail)
                    Expanded(
                      child: AnimatedContainer(
                        margin: const EdgeInsets.only(top: 8),
                        duration: const Duration(milliseconds: 500),
                        width: 1.5,
                        color: theme!.disabledColor,
                      ),
                    ),
                ],
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: heroKey,
                        child: Text(
                          widget.model.title,
                          style: theme!.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.model.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.model.subtitle!,
                            style: theme!.textTheme.titleMedium,
                          ),
                        ),
                      if (caption != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: widget.model.subtitle != null ? 8 : 4,
                          ),
                          child: Text(
                            caption,
                            style: theme!.textTheme.bodySmall,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.model.description,
                          maxLines: 4,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: theme!.textTheme.bodyLarge,
                        ),
                      ),
                      if (widget.model.externalLink != null)
                        GestureDetector(
                          onTap:
                              Uri.parse(widget.model.externalLink!).tryLaunch,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                widget.model.externalLink!,
                                maxLines: 4,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: theme!.textTheme.labelMedium?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Icon _iconTimelinePoint(Color? color) {
    return Icon(
      (widget.model.iconClass!).iconData(
        widget.model.iconCode!,
      ),
      color: widget.model.color != null
          ? Color(widget.model.color!)
          : color ?? theme!.colorScheme.secondary,
      size: 20,
    );
  }

  Widget _circleAnimatedContainer(ThemeMode themeMode, Color? color) =>
      AnimatedContainer(
        width: 20,
        height: 20,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: themeMode == ThemeMode.dark ? Colors.white12 : Colors.white,
          border: Border.all(
            color: color ?? theme!.colorScheme.secondary,
            width: 5.8,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          boxShadow: hover
              ? [
                  BoxShadow(
                    color: (color ?? theme!.colorScheme.secondary)
                        .withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 3,
                  ),
                ]
              : null,
        ),
      );

  Widget _imageTimelinePoint(String image, Color? color) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: widget.model.color != null
        //       ? Color(widget.model.color!)
        //       : color ?? theme!.colorScheme.secondary,
        // ),
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(
            image,
          ),
        ),
      ),
    );
  }
}

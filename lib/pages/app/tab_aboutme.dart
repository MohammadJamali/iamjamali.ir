import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/models/model_aboutme.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/models/model_hobby.dart';
import 'package:portfolio/models/model_tag.dart';
import 'package:portfolio/pages/detail_page.dart';

class AboutMe extends StatelessWidget {
  const AboutMe(this.model, {super.key});

  final AboutMeModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.aboutMe,
            style: theme.textTheme.bodySmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              model.biography,
              textAlign: TextAlign.justify,
            ),
          ),
          if (model.skills?.isNotEmpty == true) ...[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                localizations.skills,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Skills(model.skills!),
            ),
          ],
          if (model.hobbies?.isNotEmpty == true) ...[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                localizations.hobbies,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 16,
                children: model.hobbies!
                    .map(
                      (hobby) => HobbyWidget(model: hobby, theme: theme),
                    )
                    .toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class HobbyWidget extends StatelessWidget {
  final heroKey = UniqueKey();

  HobbyWidget({
    super.key,
    required this.model,
    required this.theme,
  });

  final HobbyModel model;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(42),
      color: Colors.transparent,
      child: InkWell(
        onTap: model.detail != null
            ? () {
                Navigator.of(
                  context,
                ).pushNamed(
                  DetailPage.routeName,
                  arguments: DetailPageArguments(
                    model.detail!,
                    heroKey,
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(42),
        child: Container(
          alignment: Alignment.center,
          width: 72,
          height: 72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                model.iconClass.iconData(model.iconCode),
                size: 42,
                color:
                    model.detail != null ? theme.colorScheme.secondary : null,
              ),
              if (model.title != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Hero(
                    tag: heroKey,
                    child: Text(
                      model.title!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class Skills extends StatefulWidget {
  const Skills(this.skills, {super.key, this.topSkills = 3});

  final List<TagModel> skills;
  final int topSkills;

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  AppLocalizations? localizations;
  int? showedSkills;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);

    showedSkills ??= min(widget.topSkills, widget.skills.length);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = widget.skills
        .sublist(0, showedSkills)
        .map(
          (skill) => SkillsChip(skill: skill) as Widget,
        )
        .toList();

    if (widgets.length < widget.skills.length) {
      widgets.add(
        TextButton(
          child: Text(localizations!.showMore),
          onPressed: () {
            setState(() {
              showedSkills = min(showedSkills! + 5, widget.skills.length);
            });
          },
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }
}

class SkillsChip extends StatefulWidget {
  final TagModel skill;

  const SkillsChip({
    super.key,
    required this.skill,
  });

  @override
  State<SkillsChip> createState() => _SkillsChipState();
}

class _SkillsChipState extends State<SkillsChip> {
  bool isHovered = false;

  ThemeData? theme;
  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = context.select(
      (AppSettingCubit value) => value.state.themeMode,
    );
    final disabled = widget.skill.detail == null;

    return InkWell(
      onTap: disabled
          ? null
          : () async => await Navigator.of(
                context,
              ).pushNamed(
                DetailPage.routeName,
                arguments: DetailPageArguments(
                  widget.skill.detail!,
                  widget.skill.tag,
                ),
              ),
      borderRadius: BorderRadius.circular(128),
      onHighlightChanged: (value) => setState(() => isHovered = value),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: themeMode == ThemeMode.light
                ? disabled
                    ? Colors.grey.shade400
                    : theme?.colorScheme.secondary ?? const Color(0xFFE3F2FD)
                : disabled
                    ? Colors.grey.shade500
                    : theme?.colorScheme.secondary ?? const Color(0xff64ffda),
          ),
          borderRadius: BorderRadius.circular(128),
        ),
        padding: const EdgeInsetsDirectional.only(
          start: 4.0,
          end: 8.0,
          top: 4.0,
          bottom: 4.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 32,
              child: CircleAvatar(
                backgroundColor: themeMode == ThemeMode.light
                    ? disabled
                        ? Colors.grey.shade300
                        : Colors.blue.shade100
                    : disabled
                        ? Colors.grey.shade700
                        : const Color(0xFF1CBB96),
                child: Text(
                  widget.skill.tag[0].toUpperCase(),
                  style: theme!.textTheme.bodyLarge,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 8.0,
                ),
                child: Hero(
                  tag: widget.skill.tag,
                  child: Text(
                    widget.skill.tag,
                    maxLines: 1,
                    style: theme!.textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

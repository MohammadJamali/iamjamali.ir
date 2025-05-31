import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/extensions/uriExtension.dart';
import 'package:portfolio/models/model_blog.dart';
import 'package:portfolio/models/model_bog_post.dart';
import 'package:portfolio/models/enum_icon_class.dart';
import 'package:portfolio/pages/detail_page.dart';
import 'package:xml/xml.dart';

class Blog extends StatefulWidget {
  const Blog(this.model, {super.key});

  final BlogModel? model;

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  AppLocalizations? localizations;
  ThemeData? theme;

  int? showedSkills;

  Future<List<BlogPostModel>>? _fetchBlogPosts;
  Future<List<BlogPostModel>> _fetchBlogPostsFutureGenerator(
    BlogModel model,
  ) async {
    List<BlogPostModel> posts = [];
    if (widget.model!.blogPosts?.isNotEmpty == true) {
      posts.addAll(widget.model!.blogPosts!);
    }

    if (model.mediumRssLink != null) {
      posts.addAll(await _parseMedium(model.mediumRssLink!) ?? []);
    }

    return posts;
  }

  Future<List<BlogPostModel>?> _parseMedium(String rssLink) async {
    String rss;
    try {
      final response = await http.get(Uri.parse(rssLink));
      if (response.statusCode < 200 && response.statusCode >= 300) return null;
      rss = response.body;
    } catch (_) {
      return null;
    }

    final document = XmlDocument.parse(rss);
    final items = document.findAllElements('item');
    if (items.isEmpty) return null;

    return items.map(
      (item) {
        final html = html_parser.parse(
          item.findElements('content:encoded').first.children.first.text,
        );

        final figure = html.getElementsByTagName('figure').first;
        var description = figure.nextElementSibling?.text;
        description = description?.substring(0, min(description.length, 500));

        final dateFormat = DateFormat("E, d MMM yyyy hh:mm:ss");
        var dateStr = item.findElements('pubDate').first.innerText;
        dateStr = dateStr.replaceAll(RegExp(r' GMT'), '');

        return BlogPostModel(
          iconCode: FontAwesomeIcons.medium.codePoint,
          iconClass: IconClass.iconDataBrands,
          title: item.findElements('title').first.innerText,
          externalLink: item.findElements('link').first.innerText,
          publishedDate: dateFormat.parse(dateStr).toLocal(),
          description: description,
          imgUrl: figure.getElementsByTagName('img').first.attributes['src'],
        );
      },
    ).toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      _fetchBlogPosts = _fetchBlogPostsFutureGenerator(widget.model!);
    }
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: widget.model != null
          ? FutureBuilder<List<BlogPostModel>>(
              future: _fetchBlogPosts,
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    (snapshot.connectionState == ConnectionState.done &&
                        !snapshot.hasData)) {
                  return _errorResult(localizations!, theme!);
                }

                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 24.0),
                    alignment: Alignment.center,
                    child: const RefreshProgressIndicator(),
                  );
                }

                if (snapshot.data?.isNotEmpty != true) {
                  return _emptyResult(localizations!);
                }

                return Blogs(snapshot.data!);
              },
            )
          : _emptyResult(localizations!),
    );
  }

  Widget _errorResult(
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 24),
      child: Wrap(
        spacing: 16.0,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.circleXmark,
            color: theme.colorScheme.error,
          ),
          Text(
            localizations.error,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
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
          const Icon(FontAwesomeIcons.rss),
          Text(localizations.emptyBlog)
        ],
      ),
    );
  }
}

class Blogs extends StatefulWidget {
  const Blogs(this.skills, {super.key, this.topSkills = 3});

  final List<BlogPostModel> skills;
  final int topSkills;

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  AppLocalizations? localizations;
  int? showedBlogs;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);

    showedBlogs ??= min(widget.topSkills, widget.skills.length);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = widget.skills
        .sublist(0, showedBlogs)
        .asMap()
        .map(
          (index, post) => MapEntry(
            index,
            BlogPostItem(
              key: ValueKey(index),
              context: context,
              model: post,
            ) as Widget,
          ),
        )
        .values
        .toList();

    if (widgets.length < widget.skills.length) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(
            child: Text(localizations!.showMore),
            onPressed: () {
              setState(() {
                showedBlogs = min(showedBlogs! + 5, widget.skills.length);
              });
            },
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}

class BlogPostItem extends StatelessWidget {
  final heroKey = UniqueKey();
  final BuildContext context;
  final BlogPostModel model;

  BlogPostItem({
    super.key,
    required this.context,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: model.externalLink != null
          ? () => model.externalLink!.tryLaunch(model.externalLink!, context)
          : model.detail != null
              ? () => Navigator.of(
                    context,
                  ).pushNamed(
                    DetailPage.routeName,
                    arguments: DetailPageArguments(
                      model.detail!,
                      heroKey,
                    ),
                  )
              : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              alignment: Alignment.center,
              margin: const EdgeInsetsDirectional.only(end: 16.0),
              child: model.iconCode != null || model.imgUrl != null
                  ? Column(
                      children: [
                        if (model.iconCode != null)
                          Center(
                            child: Icon(
                              (model.iconClass!).iconData(model.iconCode!),
                            ),
                          ),
                        if (model.imgUrl != null)
                          Image.network(
                            model.imgUrl!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                      ],
                    )
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: heroKey,
                    child: Text(
                      model.title,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      DateFormat("yyyy-MM-dd hh:mm").format(
                        model.publishedDate,
                      ),
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  if (model.description != null)
                    Text(
                      model.description!,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

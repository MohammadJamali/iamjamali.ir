import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show Document, QuillController, QuillEditor, QuillEditorConfig;
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/main.dart' show AppSetting, AppSettingCubit;
import 'package:portfolio/models/model_detail.dart' show DetailModel;

class DetailPageArguments {
  final DetailModel model;
  final Object titleHeroKey;

  const DetailPageArguments(this.model, this.titleHeroKey);
}

class DetailPage extends StatefulWidget {
  static const String routeName = '/detail';

  const DetailPage({
    super.key,
    required this.bodyWidth,
  });

  final double bodyWidth;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  bool shadowSet = false;

  TextDirection? directionality;
  DetailPageArguments? model;
  ThemeData? theme;

  void onScroll() {
    if (scrollController.offset > 0 && !shadowSet) {
      shadowSet = true;
    } else if (scrollController.offset == 0 && shadowSet) {
      shadowSet = false;
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void didChangeDependencies() {
    directionality = Directionality.of(context);
    theme = Theme.of(context);
    model = ModalRoute.of(
      context,
    )!
        .settings
        .arguments as DetailPageArguments;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(
              minHeight: 300,
              maxHeight: 700,
              minWidth: widget.bodyWidth,
              maxWidth: widget.bodyWidth,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BackButton(),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                      ),
                      Expanded(
                        child: Hero(
                          tag: model!.titleHeroKey,
                          child: Text(
                            model!.model.title,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: theme!.textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<AppSettingCubit, AppSetting>(
                    builder: (context, state) => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: state.themeMode == ThemeMode.light
                            ? const Color(0xFFF9F9FB)
                            : const Color(0xFF828282),
                        border: Border.all(
                          color: state.themeMode == ThemeMode.light
                              ? const Color(0xFFEEEEF0)
                              : const Color(0xFFA7A7A7),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: model!.model.tags
                            .map((tag) => _buildHeaderTags(
                                tag.iconClass.iconData(tag.iconCode),
                                tag.title,
                                tag.value,
                                theme!))
                            .toList(),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: QuillEditor(
                        controller: QuillController(
                          document: Document.fromJson(model!.model.document),
                          selection: const TextSelection.collapsed(offset: 0),
                          readOnly: true,
                        ),
                        config: QuillEditorConfig(
                          scrollable: false,
                          autoFocus: true,
                          expands: false,
                          padding: EdgeInsets.zero,
                          showCursor: false,
                        ),
                        scrollController: scrollController,
                        focusNode: focusNode,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTags(
    IconData icon,
    String header,
    String value,
    ThemeData theme,
  ) =>
      Wrap(
        direction: Axis.vertical,
        spacing: 8,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Icon(
                icon,
                size: 16,
              ),
              Text(
                header.toUpperCase(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(value),
        ],
      );

  @override
  void dispose() {
    try {
      scrollController.removeListener(onScroll);
      focusNode.dispose();
    } catch (_) {}
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/extensions/enumExtension.dart';
import 'package:portfolio/models/model_contact.dart';
import 'package:portfolio/models/enum_contact_host.dart';
import 'package:portfolio/widgets/slide_to_call.dart';

class CallScreen extends StatelessWidget {
  const CallScreen(this.model, {super.key});

  final List<ContactModel> model;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final slideToActionContact = model.firstWhere(
      (e) => e.host == ContactHost.phone,
      orElse: () => model.first,
    );
    final buttons = model.where(
      (e) => !(e.host == slideToActionContact.host &&
          e.identifier == slideToActionContact.identifier),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (buttons.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: GridView.builder(
              itemCount: buttons.length,
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              reverse: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemBuilder: (BuildContext context, int index) => _iconBox(
                context,
                buttons.elementAt(index),
                localizations,
                theme,
              ),
            ),
          ),
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 64),
          child: SlideToAction(
            action: () async => slideToActionContact.host.intraction(
              slideToActionContact.identifier,
            )(context, localizations),
            callToAction: localizations.slide,
            icon: Icon(
              slideToActionContact.host.icon,
              color: Colors.green,
              size: 22,
            ),
            callToActionStyle: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }

  Widget _iconBox(
    BuildContext context,
    ContactModel model,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => model.host.intraction(model.identifier)(
          context,
          localizations,
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(
                  model.host.icon,
                  color: Colors.white,
                ),
              ),
              Text(
                model.host.localize(localizations),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

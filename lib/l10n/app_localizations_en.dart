// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Portfolio';

  @override
  String get language => 'English';

  @override
  String get languageChanged => 'Now we are talking the same language!';

  @override
  String get hi => 'Hi!';

  @override
  String get showMore => 'Show More';

  @override
  String get aboutMe => 'About Me';

  @override
  String get skills => 'My Skills';

  @override
  String get phone => 'Phone';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Email';

  @override
  String get facebook => 'Facebook';

  @override
  String get instagram => 'Instagram';

  @override
  String get youTube => 'YouTube';

  @override
  String get twitch => 'Twitch';

  @override
  String get skype => 'Skype';

  @override
  String get twitter => 'Twitter';

  @override
  String get viber => 'Viber';

  @override
  String get telegram => 'Telegram';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get pinterest => 'Pinterest';

  @override
  String get linkedIn => 'LinkedIn';

  @override
  String get medium => 'Medium';

  @override
  String get github => 'Github';

  @override
  String get gitlab => 'Gitlab';

  @override
  String get bitbucket => 'Bitbucket';

  @override
  String get slide => 'Slide';

  @override
  String get emptyBlog => 'My publications are\'nt listed here right now';

  @override
  String get emptyTimeline => 'My activities and experiences are kinda secret';

  @override
  String get error => 'Sadly, an error occured';

  @override
  String get hobbies => 'Hobbies';

  @override
  String yearMonth(int year, int month) {
    String _temp0 = intl.Intl.pluralLogic(
      year,
      locale: localeName,
      other: '',
      many: '$year years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      month,
      locale: localeName,
      other: '',
      many: '$month months',
      one: '1 month',
    );
    return '$_temp0 and $_temp1';
  }

  @override
  String years(int year) {
    String _temp0 = intl.Intl.pluralLogic(
      year,
      locale: localeName,
      other: '',
      many: '$year years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String months(int month) {
    String _temp0 = intl.Intl.pluralLogic(
      month,
      locale: localeName,
      other: '',
      many: '$month months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String dateUntilDate(String from, String to) {
    return '$from until $to';
  }

  @override
  String get now => 'now';
}

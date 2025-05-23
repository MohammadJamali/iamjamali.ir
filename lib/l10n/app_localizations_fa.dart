// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get title => 'پورتفولیو';

  @override
  String get language => 'فارسی';

  @override
  String get languageChanged => 'حالا به یک زبان صحبت می کنیم !';

  @override
  String get hi => 'سلام!';

  @override
  String get showMore => 'نمایش بیشتر';

  @override
  String get aboutMe => 'درباره من';

  @override
  String get skills => 'مهارت ها';

  @override
  String get phone => 'تلفن';

  @override
  String get sms => 'پیام کوتاه';

  @override
  String get email => 'ایمیل';

  @override
  String get facebook => 'فیسبوک';

  @override
  String get instagram => 'اینستاگرام';

  @override
  String get youTube => 'یوتیوب';

  @override
  String get twitch => 'توییچ';

  @override
  String get skype => 'اسکایپ';

  @override
  String get twitter => 'توییتر';

  @override
  String get viber => 'وایبر';

  @override
  String get telegram => 'تلگرام';

  @override
  String get whatsapp => 'واتساپ';

  @override
  String get pinterest => 'پینترست';

  @override
  String get linkedIn => 'لینکدین';

  @override
  String get medium => 'مدیوم';

  @override
  String get github => 'گیت هاب';

  @override
  String get gitlab => 'گیت لب';

  @override
  String get bitbucket => 'بیت باکت';

  @override
  String get slide => 'بکشید';

  @override
  String get emptyBlog => 'نگارشات من هنوز در این بخش فهرست نشده اند';

  @override
  String get emptyTimeline => 'فعالیت و تجربیات من به نوعی محرمانه است';

  @override
  String get error => 'متأسفانه خطایی رخ داده است';

  @override
  String get hobbies => 'سرگرمی ها';

  @override
  String yearMonth(int year, int month) {
    return '$year سال و $month ماه';
  }

  @override
  String years(int year) {
    return '$year سال';
  }

  @override
  String months(int month) {
    return '$month ماه';
  }

  @override
  String dateUntilDate(String from, String to) {
    return '$from تا $to';
  }

  @override
  String get now => 'حالا';
}

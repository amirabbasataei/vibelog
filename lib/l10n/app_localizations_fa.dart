// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'وایب‌لاگ';

  @override
  String get tabNotes => 'یادداشت‌ها';

  @override
  String get tabGraph => 'نمودار';

  @override
  String get tabSettings => 'تنظیمات';

  @override
  String get addEntry => 'افزودن یادداشت';

  @override
  String get editEntry => 'ویرایش یادداشت';

  @override
  String get save => 'ذخیره';

  @override
  String get cancel => 'لغو';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'بازگردانی';

  @override
  String get mood => 'حال';

  @override
  String get energy => 'انرژی';

  @override
  String get boredom => 'بی‌حوصلگی';

  @override
  String get descriptionHint => 'الان چه احساسی داری؟';

  @override
  String get dateLabel => 'تاریخ';

  @override
  String get timeLabel => 'ساعت';

  @override
  String get emptyNotes =>
      'هنوز یادداشتی وجود ندارد.\nروی + ضربه بزنید تا اولین یادداشت را اضافه کنید.';

  @override
  String get emptyGraph => 'حداقل ۲ یادداشت ثبت کنید تا نمودار نمایش داده شود.';

  @override
  String get errorRetry => 'مشکلی پیش آمد. برای تلاش دوباره ضربه بزنید.';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get settingsScaleTitle => 'محدوده امتیاز';

  @override
  String get settingsThemeTitle => 'پوسته';

  @override
  String get settingsThemeLight => 'روشن';

  @override
  String get settingsThemeDark => 'تاریک';

  @override
  String get settingsThemeSystem => 'سیستم';

  @override
  String get settingsDangerZone => 'منطقه خطر';

  @override
  String get deleteAllData => 'حذف همه داده‌ها';

  @override
  String get deleteAllConfirmTitle => 'حذف همه داده‌ها؟';

  @override
  String get deleteAllConfirmBody =>
      'این عمل تمام یادداشت‌ها را به‌طور دائمی حذف می‌کند و قابل بازگشت نیست.';

  @override
  String get deleteAllConfirm => 'حذف';

  @override
  String get entryDeleted => 'یادداشت حذف شد';

  @override
  String get moodOverTime => 'تغییرات حال';

  @override
  String get energyOverTime => 'تغییرات انرژی';

  @override
  String get boredomOverTime => 'تغییرات بی‌حوصلگی';
}

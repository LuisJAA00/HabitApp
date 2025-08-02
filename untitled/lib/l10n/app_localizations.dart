import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new habit'**
  String get addTitle;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Name of the habit'**
  String get habitName;

  /// No description provided for @needTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer?'**
  String get needTimer;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @duracion.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duracion;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @aDay.
  ///
  /// In en, this message translates to:
  /// **'a day'**
  String get aDay;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Select days'**
  String get selectDays;

  /// No description provided for @enableReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable reminder'**
  String get enableReminder;

  /// No description provided for @noSpecificTime.
  ///
  /// In en, this message translates to:
  /// **'No specific time'**
  String get noSpecificTime;

  /// No description provided for @selectHour.
  ///
  /// In en, this message translates to:
  /// **'Select hour'**
  String get selectHour;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @forToday.
  ///
  /// In en, this message translates to:
  /// **'For today'**
  String get forToday;

  /// No description provided for @lunes.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get lunes;

  /// No description provided for @martes.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get martes;

  /// No description provided for @miercoles.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get miercoles;

  /// No description provided for @jueves.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get jueves;

  /// No description provided for @viernes.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get viernes;

  /// No description provided for @sabado.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sabado;

  /// No description provided for @domingo.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get domingo;

  /// No description provided for @proximo.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get proximo;

  /// No description provided for @hecho.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get hecho;

  /// No description provided for @habitMustName.
  ///
  /// In en, this message translates to:
  /// **'The habit must have a name'**
  String get habitMustName;

  /// No description provided for @vez.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get vez;

  /// No description provided for @veces.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get veces;

  /// No description provided for @valorValido.
  ///
  /// In en, this message translates to:
  /// **'Must be a valid value'**
  String get valorValido;

  /// No description provided for @numeroValido.
  ///
  /// In en, this message translates to:
  /// **'Must be a valid number'**
  String get numeroValido;

  /// No description provided for @between17.
  ///
  /// In en, this message translates to:
  /// **'Must be between 1 to 7 days...'**
  String get between17;

  /// No description provided for @select1Day.
  ///
  /// In en, this message translates to:
  /// **'Select at least a day'**
  String get select1Day;

  /// No description provided for @l.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get l;

  /// No description provided for @m.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get m;

  /// No description provided for @mi.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get mi;

  /// No description provided for @j.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get j;

  /// No description provided for @v.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get v;

  /// No description provided for @s.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get s;

  /// No description provided for @d.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get d;

  /// No description provided for @nameAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The name is already in use'**
  String get nameAlreadyInUse;

  /// No description provided for @habitCreated.
  ///
  /// In en, this message translates to:
  /// **'habit created'**
  String get habitCreated;

  /// No description provided for @noHabitsYet.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get noHabitsYet;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

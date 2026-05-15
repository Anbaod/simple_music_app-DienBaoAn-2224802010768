import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhạc của tôi'**
  String get appTitle;

  /// No description provided for @songs.
  ///
  /// In vi, this message translates to:
  /// **'Bài hát'**
  String get songs;

  /// No description provided for @playlist.
  ///
  /// In vi, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @nowPlaying.
  ///
  /// In vi, this message translates to:
  /// **'Đang phát'**
  String get nowPlaying;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới'**
  String get refresh;

  /// No description provided for @noSongs.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài hát'**
  String get noSongs;

  /// No description provided for @permissionRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần cấp quyền'**
  String get permissionRequired;

  /// No description provided for @openSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở cài đặt'**
  String get openSettings;

  /// No description provided for @addToPlaylist.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào playlist'**
  String get addToPlaylist;

  /// No description provided for @share.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get share;

  /// No description provided for @songInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin bài hát'**
  String get songInfo;

  /// No description provided for @deleteSong.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bài hát'**
  String get deleteSong;

  /// No description provided for @playback.
  ///
  /// In vi, this message translates to:
  /// **'Phát nhạc'**
  String get playback;

  /// No description provided for @shuffle.
  ///
  /// In vi, this message translates to:
  /// **'Phát ngẫu nhiên'**
  String get shuffle;

  /// No description provided for @repeat.
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại'**
  String get repeat;

  /// No description provided for @repeatAll.
  ///
  /// In vi, this message translates to:
  /// **'Lặp tất cả'**
  String get repeatAll;

  /// No description provided for @repeatOne.
  ///
  /// In vi, this message translates to:
  /// **'Lặp một bài'**
  String get repeatOne;

  /// No description provided for @on.
  ///
  /// In vi, this message translates to:
  /// **'Bật'**
  String get on;

  /// No description provided for @off.
  ///
  /// In vi, this message translates to:
  /// **'Tắt'**
  String get off;

  /// No description provided for @unknown.
  ///
  /// In vi, this message translates to:
  /// **'Không rõ'**
  String get unknown;

  /// No description provided for @volume.
  ///
  /// In vi, this message translates to:
  /// **'Âm lượng'**
  String get volume;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ngôn ngữ'**
  String get changeLanguage;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get english;

  /// No description provided for @app.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng'**
  String get app;

  /// No description provided for @appInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin ứng dụng'**
  String get appInfo;

  /// No description provided for @about.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin ứng dụng'**
  String get about;

  /// No description provided for @recent.
  ///
  /// In vi, this message translates to:
  /// **'Nghe gần đây'**
  String get recent;

  /// No description provided for @noRecentSongs.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài hát gần đây'**
  String get noRecentSongs;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

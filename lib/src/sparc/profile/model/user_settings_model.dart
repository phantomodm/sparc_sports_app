import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
class UserSettings with _$UserSettings {
  factory UserSettings({
    @Default(false) bool darkMode,
    @Default([]) List<String> favoriteSports,
    @Default([]) List<Notification> notifications,
    @Default({}) Map<String, bool> onboarding,
    @Default(false) bool showNsfwContent,
    @Default(false) bool receiveEmailNotifications,
    @Default(false) bool receivePushNotifications,
    String? preferredLanguage,
    String? preferredCurrency,
    String? timeZone,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
}
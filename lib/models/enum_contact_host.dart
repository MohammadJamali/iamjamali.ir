import 'package:json_annotation/json_annotation.dart';

enum ContactHost {
  @JsonValue("phone")
  phone,

  @JsonValue("sms")
  sms,

  @JsonValue("email")
  email,

  @JsonValue("facebook")
  facebook,

  @JsonValue("instagram")
  instagram,

  @JsonValue("telegram")
  telegram,

  @JsonValue("whatsapp")
  whatsapp,

  @JsonValue("Skype")
  skype,

  @JsonValue("pinterest")
  pinterest,

  @JsonValue("twitter")
  twitter,

  @JsonValue("twitch")
  twitch,

  @JsonValue("viber")
  viber,

  @JsonValue("youtube")
  youtube,

  @JsonValue("linkedIn")
  linkedIn,

  @JsonValue("medium")
  medium,

  @JsonValue("github")
  github,

  @JsonValue("gitlab")
  gitlab,

  @JsonValue("bitbucket")
  bitbucket,
}

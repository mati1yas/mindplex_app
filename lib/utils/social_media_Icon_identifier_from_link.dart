import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/social_media_link_identifier.dart';

FaIcon getSocialLinkIcon(String link) {
  var linkType = detectSocialMediaPlatform(link);

  switch (linkType) {
    case 'Facebook':
      return FaIcon(
        FontAwesomeIcons.facebook,
        size: 25.0,
        color: profileGolden,
      );
    case 'Twitter':
      return FaIcon(
        FontAwesomeIcons.twitter,
        size: 25.0,
        color: profileGolden,
      );
    case 'Youtube':
      return FaIcon(
        FontAwesomeIcons.youtube,
        size: 25.0,
        color: profileGolden,
      );
    case 'LinkedIn':
      return FaIcon(
        FontAwesomeIcons.linkedin,
        size: 25.0,
        color: profileGolden,
      );
    case 'Instagram':
      return FaIcon(
        FontAwesomeIcons.instagram,
        size: 25.0,
        color: profileGolden,
      );

    case 'Telegram':
      return FaIcon(
        FontAwesomeIcons.telegram,
        size: 25.0,
        color: profileGolden,
      );

    case 'Snapchat':
      return FaIcon(
        FontAwesomeIcons.snapchat,
        size: 25.0,
        color: profileGolden,
      );
    case 'Pinterest':
      return FaIcon(
        FontAwesomeIcons.pinterest,
        size: 25.0,
        color: profileGolden,
      );
    case 'Reddit':
      return FaIcon(
        FontAwesomeIcons.reddit,
        size: 25.0,
        color: profileGolden,
      );

    case 'TikTok':
      return FaIcon(
        FontAwesomeIcons.tiktok,
        size: 25.0,
        color: profileGolden,
      );
    case 'WhatsApp':
      return FaIcon(
        FontAwesomeIcons.whatsapp,
        size: 25.0,
        color: profileGolden,
      );

    case 'Discord':
      return FaIcon(
        FontAwesomeIcons.discord,
        size: 25.0,
        color: profileGolden,
      );
    case 'Medium':
      return FaIcon(
        FontAwesomeIcons.medium,
        size: 25.0,
        color: profileGolden,
      );
    case 'Quora':
      return FaIcon(
        FontAwesomeIcons.quora,
        size: 25.0,
        color: profileGolden,
      );

    case 'Periscope':
      return FaIcon(
        FontAwesomeIcons.periscope,
        size: 25.0,
        color: profileGolden,
      );
    default:
      return FaIcon(
        FontAwesomeIcons.link,
        size: 25.0,
        color: profileGolden,
      );
  }
}

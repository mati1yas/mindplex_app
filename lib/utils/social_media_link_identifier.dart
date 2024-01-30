// Helper Methdos
String detectSocialMediaPlatform(String url) {
  if (RegExp(r'^https?:\/\/(?:www\.)?facebook\.com\/.*').hasMatch(url)) {
    return "Facebook";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?twitter\.com\/.*').hasMatch(url) ||
      RegExp(r'^https?:\/\/(?:www\.)?x\.com\/.*').hasMatch(url)) {
    return "Twitter";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?linkedin\.com\/.*').hasMatch(url)) {
    return "LinkedIn";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?youtube\.com\/.*').hasMatch(url)) {
    return "Youtube";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?instagram\.com\/.*')
      .hasMatch(url)) {
    return "Instagram";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?t\.me\/.*').hasMatch(url)) {
    return "Telegram";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?snapchat\.com\/.*').hasMatch(url)) {
    return "Snapchat";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?pinterest\.com\/.*')
      .hasMatch(url)) {
    return "Pinterest";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?reddit\.com\/.*').hasMatch(url)) {
    return "Reddit";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?tumblr\.com\/.*').hasMatch(url)) {
    return "Tumblr";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?tiktok\.com\/.*').hasMatch(url)) {
    return "TikTok";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?whatsapp\.com\/.*').hasMatch(url)) {
    return "WhatsApp";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?wechat\.com\/.*').hasMatch(url)) {
    return "WeChat";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?discord\.com\/.*').hasMatch(url)) {
    return "Discord";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?medium\.com\/.*').hasMatch(url)) {
    return "Medium";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?quora\.com\/.*').hasMatch(url)) {
    return "Quora";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?clubhouse\.com\/.*')
      .hasMatch(url)) {
    return "Clubhouse";
  } else if (RegExp(r'^https?:\/\/(?:www\.)?periscope\.tv\/.*').hasMatch(url)) {
    return "Periscope";
  } else {
    // Add more platforms as needed
    return "";
  }
}

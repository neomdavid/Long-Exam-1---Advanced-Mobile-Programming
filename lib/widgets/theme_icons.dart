import 'package:flutter/material.dart';

class ThemeIcons {
  // Brand Icons
  static IconData get brand => Icons.article_outlined;
  static IconData get brandFilled => Icons.article;

  // Navigation Icons
  static IconData get home => Icons.home_outlined;
  static IconData get homeFilled => Icons.home;
  static IconData get settings => Icons.settings_outlined;
  static IconData get settingsFilled => Icons.settings;
  static IconData get profile => Icons.person_outline;
  static IconData get profileFilled => Icons.person;

  // Action Icons
  static IconData get login => Icons.login;
  static IconData get logout => Icons.logout;
  static IconData get add => Icons.add;
  static IconData get edit => Icons.edit_outlined;
  static IconData get delete => Icons.delete_outline;
  static IconData get save => Icons.save_outlined;
  static IconData get cancel => Icons.cancel_outlined;

  // Form Icons
  static IconData get email => Icons.email_outlined;
  static IconData get password => Icons.lock_outline;
  static IconData get visibility => Icons.visibility_outlined;
  static IconData get visibilityOff => Icons.visibility_off_outlined;
  static IconData get search => Icons.search;
  static IconData get filter => Icons.filter_list;

  // Status Icons
  static IconData get success => Icons.check_circle_outline;
  static IconData get error => Icons.error_outline;
  static IconData get warning => Icons.warning_outlined;
  static IconData get info => Icons.info_outline;

  // Theme Icons
  static IconData get lightMode => Icons.light_mode;
  static IconData get darkMode => Icons.dark_mode;

  // Media Icons
  static IconData get image => Icons.image_outlined;
  static IconData get video => Icons.videocam_outlined;
  static IconData get attachment => Icons.attach_file;

  // Navigation Icons
  static IconData get back => Icons.arrow_back;
  static IconData get forward => Icons.arrow_forward;
  static IconData get up => Icons.keyboard_arrow_up;
  static IconData get down => Icons.keyboard_arrow_down;
  static IconData get menu => Icons.menu;
  static IconData get close => Icons.close;

  // Social Icons
  static IconData get like => Icons.favorite_outline;
  static IconData get likeFilled => Icons.favorite;
  static IconData get share => Icons.share_outlined;
  static IconData get comment => Icons.comment_outlined;

  // Utility Icons
  static IconData get refresh => Icons.refresh;
  static IconData get loading => Icons.hourglass_empty;
  static IconData get more => Icons.more_horiz;
  static IconData get moreVertical => Icons.more_vert;
}

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final bool useThemeColor;

  const ThemedIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.useThemeColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: useThemeColor
          ? (color ?? Theme.of(context).colorScheme.primary)
          : color,
    );
  }
}

import 'package:expense_tracker/utils/app_color.dart';
import 'package:flutter/material.dart';

class ProfileUserModel {
  final String title;
  final String? subTitle;
  final IconData icon;
  final Color? iconColor;
  final bool isLogOut;

  ProfileUserModel({
    this.isLogOut = false,
    this.iconColor,
    required this.title,
    this.subTitle,
    required this.icon
  });
}

List<ProfileUserModel> profileMenuList =[
  ProfileUserModel(
      title: 'Personal Information',
      subTitle: 'Update your personal details',
      icon: Icons.person,),

  ProfileUserModel(
      title: 'Security',
      subTitle: 'Change password and security settings',
      icon: Icons.lock_outline),
  ProfileUserModel(
      title: 'Categories',
      subTitle: 'manage your income and expense categories',
      icon: Icons.category_rounded),
  ProfileUserModel(
      title: 'Payment Methods ',
      subTitle: 'Manage your payment methods',
      icon: Icons.payment) ,
  ProfileUserModel(
      title: 'Export Data',
      subTitle: 'Export your transaction data',
      icon: Icons.import_export),
  ProfileUserModel(
      title: 'Notifications ',
      subTitle: 'Manage notification preferences',
      icon: Icons.notifications),
  ProfileUserModel(
      title: ' Help &  Support',
      subTitle: 'FAQs and contact support',
      icon: Icons.help_sharp),
  ProfileUserModel(
      title: 'About App ',
      subTitle: 'App version and information',
      icon: Icons.info_outline) ,
  ProfileUserModel(
      title: 'LogOut ',
      icon: Icons.logout,
      iconColor: AppColors.error,
      isLogOut: true,
  )
];

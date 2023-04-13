import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  const TabItemData({required this.title, required this.icon});
  final String title;
  final IconData icon;
  static Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: const TabItemData(title: 'Jobs', icon: Icons.work),
    TabItem.entries:
        const TabItemData(title: 'Entries', icon: Icons.view_headline),
    TabItem.account: const TabItemData(title: 'Account', icon: Icons.person),
  };
}

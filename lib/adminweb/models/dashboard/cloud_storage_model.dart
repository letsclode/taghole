import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;
  final Icon? icon;

  CloudStorageInfo({
    this.icon,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

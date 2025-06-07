import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimeConverter {
  static bool _initialized = false;
  /// Khởi tạo timezone database (chỉ cần gọi 1 lần khi app khởi động)
  static Future<void> initialize() async {    
    if (!_initialized) {       
      await Future(() => tz.initializeTimeZones());
      _initialized = true;
    }    
  }

  /// Chuyển đổi DateTime UTC sang Local Time
  static DateTime convertToUserTime(DateTime utcTime) {
    return utcTime.toLocal();
  }

  /// Chuyển đổi chuỗi ISO 8601 UTC sang Local Time
  static DateTime utcStringToLocal(String utcString) {
    return DateTime.parse(utcString).toLocal();
  }

  /// Chuyển đổi UTC sang Local Time với timezone cụ thể (sử dụng package timezone)
  static Future<DateTime> utcToLocalTimezone(DateTime utcTime, String timeZoneName) async {
    try {
      await initialize();
      final location = tz.getLocation(timeZoneName);
      return tz.TZDateTime.from(utcTime, location);
    } catch (e) {      
      return convertToUserTime(utcTime); // Fallback to device local time
    }
  }

  /// Định dạng DateTime thành chuỗi theo pattern
  static String formatDateTime(DateTime dateTime, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Chuyển đổi và định dạng UTC sang Local Time string
  static String formatUtcToLocal(DateTime utcTime, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return formatDateTime(convertToUserTime(utcTime), pattern: pattern);
  }

  /// Chuyển đổi và định dạng chuỗi ISO UTC sang Local Time string
  static String formatUtcStringToLocal(String utcString, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return formatDateTime(utcStringToLocal(utcString), pattern: pattern);
  }

  /// Lấy timezone hiện tại của thiết bị
  static String getCurrentTimezone() {
    return tz.local.name;
  }

  /// Kiểm tra xem chuỗi có phải là UTC time không (có ký tự 'Z' ở cuối)
  static bool isUtcString(String timeString) {
    return timeString.toUpperCase().endsWith('Z');
  }

  /// Tính thời gian đã trôi qua từ UTC string (ví dụ: "2 giờ trước")
  static String timeAgoFromUtc(String utcString, {bool short = false}) {
    final date = utcStringToLocal(utcString);
    return _timeAgo(date, short: short);
  }

  /// Tính thời gian đã trôi qua từ DateTime (ví dụ: "2 giờ trước")
  static String timeAgo(DateTime date, {bool short = false}) {
    return _timeAgo(date, short: short);
  }

  /// Kiểm tra xem thời gian UTC string đã qua hay chưa
  static bool isPast(String utcString) {
    return utcStringToLocal(utcString).isBefore(DateTime.now());
  }

  /// Kiểm tra xem DateTime đã qua hay chưa
  static bool isPastDateTime(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Helper method for timeAgo calculations
  static String _timeAgo(DateTime date, {bool short = false}) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return short ? '$years y' : '$years năm trước';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return short ? '$months m' : '$months tháng trước';
    } else if (difference.inDays > 0) {
      return short ? '${difference.inDays}d' : '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return short ? '${difference.inHours}h' : '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return short ? '${difference.inMinutes}m' : '${difference.inMinutes} phút trước';
    } else {
      return short ? 'now' : 'vừa xong';
    }
  }
}

/// Extension methods cho String để hỗ trợ cú pháp '...'.utcToLocal()
extension DateTimeStringExtension on String {
  /// Chuyển đổi chuỗi UTC sang DateTime local
  DateTime utcToLocal() {
    return TimeConverter.utcStringToLocal(this);
  }

  /// Chuyển đổi chuỗi UTC sang DateTime với timezone cụ thể
  Future<DateTime> utcToTimezone(String timezone) {
    return TimeConverter.utcToLocalTimezone(DateTime.parse(this), timezone);
  }

  /// Chuyển đổi chuỗi UTC và định dạng thành chuỗi local
  String toLocalFormatted({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return TimeConverter.formatUtcStringToLocal(this, pattern: pattern);
  }

  /// Kiểm tra xem chuỗi có phải là định dạng UTC không (có 'Z' ở cuối)
  bool isUtc() {
    return TimeConverter.isUtcString(this);
  }

  /// Tính thời gian đã trôi qua (ví dụ: "2 giờ trước")
  String timeAgo({bool short = false}) {
    return TimeConverter.timeAgoFromUtc(this, short: short);
  }

  /// Kiểm tra xem thời gian đã qua hay chưa
  bool isPast() {
    return TimeConverter.isPast(this);
  }
}

/// Extension methods cho DateTime
extension DateTimeExtension on DateTime {
  DateTime convertToUserTime() {
    return TimeConverter.convertToUserTime(this);
  }
  /// Định dạng DateTime thành chuỗi
  String convertToUserTimeString({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return TimeConverter.formatDateTime(this, pattern: pattern);
  }

  /// Chuyển đổi sang timezone cụ thể
  Future<DateTime> convertToUserTimezone(String timezone) {
    return TimeConverter.utcToLocalTimezone(this, timezone);
  }

  /// Tính thời gian đã trôi qua (ví dụ: "2 giờ trước")
  String timeAgo({bool short = false}) {
    return TimeConverter.timeAgo(this, short: short);
  }

  /// Kiểm tra xem thời gian đã qua hay chưa
  bool isPast() {
    return TimeConverter.isPastDateTime(this);
  }
}
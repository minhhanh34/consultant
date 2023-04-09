mixin WeekDayMixin {
  String convertWeekDay(int day) {
    switch (day) {
      case 0:
        return 'Thứ hai';
      case 1:
        return 'Thứ ba';
      case 2:
        return 'Thứ tư';
      case 3:
        return 'Thứ năm';
      case 4:
        return 'Thứ sáu';
      case 5:
        return 'Thứ bảy';
      case 6:
        return 'Chủ nhật';
      default:
        throw Exception('day not found!');
    }
  }
}

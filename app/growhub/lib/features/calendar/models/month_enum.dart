enum Month {
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December,
}

//TODO: iinternationalization: required later or maybe intl?
extension MonthExtension on Month {
  String get name {
    switch (this) {
      case Month.January:
        return "January";
      case Month.February:
        return "February";
      case Month.March:
        return "March";
      case Month.April:
        return "April";
      case Month.May:
        return "May";
      case Month.June:
        return "June";
      case Month.July:
        return "July";
      case Month.August:
        return "August";
      case Month.September:
        return "September";
      case Month.October:
        return "October";
      case Month.November:
        return "November";
      case Month.December:
        return "December";
    }
  }

  static Month fromIndex(int index) {
    return Month.values[index];
  }
}

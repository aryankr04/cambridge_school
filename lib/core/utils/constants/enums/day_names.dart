enum Day {
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday'),
  sunday('Sunday');

  final String label;

  const Day(this.label);

  static final List<String> _dayLabels = Day.values.map((day) => day.label).toList();
  static final List<Day> _days = Day.values.toList();

  static Day fromString(String dayString) {
    return switch (dayString.toLowerCase()) {
      'monday' => Day.monday,
      'tuesday' => Day.tuesday,
      'wednesday' => Day.wednesday,
      'thursday' => Day.thursday,
      'friday' => Day.friday,
      'saturday' => Day.saturday,
      'sunday' => Day.sunday,
      _ => throw ArgumentError('Invalid day string: $dayString'), // Or return a default value
    };
  }

  @override
  String toString() {
    return label;
  }

  // Method to get a list of all Day labels
  static List<String> getDayLabels() => _dayLabels;

  //Method to get a list of all Day enums
  static List<Day> getDays() => _days;
}
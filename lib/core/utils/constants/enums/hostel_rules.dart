enum HostelRule {
  noLateEntry,
  attendanceMandatory,
  visitorsRestricted,
  noOutsideFood,
  silenceHours,
  curfewTime,
  noSmokingAlcohol,
  cleanlinessRequired,
  mealTimingsFixed,
  restrictedElectricalAppliances,
  studyHoursMandatory,
  dressCode,
  hostelLeavePermission,
  noRagging,
  noLoudMusic,
  lightsOutTime,
  genderRestrictedAreas,
  personalResponsibility,
  internetUsageLimit,
  emergencyProtocol,
  other,
}

extension HostelRuleExtension on HostelRule {
  /// Returns a user-friendly label for the hostel rule.
  String get label => _labels[this] ?? "Other";

  /// Returns a description explaining the hostel rule.
  String get description => _descriptions[this] ?? "No description available.";

  /// Mapping of `HostelRule` to readable labels.
  static const Map<HostelRule, String> _labels = {
    HostelRule.noLateEntry: "No Late Entry",
    HostelRule.attendanceMandatory: "Mandatory Attendance",
    HostelRule.visitorsRestricted: "Visitor Restrictions",
    HostelRule.noOutsideFood: "No Outside Food Allowed",
    HostelRule.silenceHours: "Silence Hours",
    HostelRule.curfewTime: "Curfew Time",
    HostelRule.noSmokingAlcohol: "No Smoking or Alcohol",
    HostelRule.cleanlinessRequired: "Cleanliness Required",
    HostelRule.mealTimingsFixed: "Fixed Meal Timings",
    HostelRule.restrictedElectricalAppliances: "Restricted Electrical Appliances",
    HostelRule.studyHoursMandatory: "Mandatory Study Hours",
    HostelRule.dressCode: "Dress Code Enforcement",
    HostelRule.hostelLeavePermission: "Hostel Leave Permission Required",
    HostelRule.noRagging: "Anti-Ragging Rule",
    HostelRule.noLoudMusic: "No Loud Music Allowed",
    HostelRule.lightsOutTime: "Lights Out Time",
    HostelRule.genderRestrictedAreas: "Restricted Areas for Opposite Gender",
    HostelRule.personalResponsibility: "Responsibility for Personal Belongings",
    HostelRule.internetUsageLimit: "Limited Internet Usage",
    HostelRule.emergencyProtocol: "Emergency Protocol Compliance",
    HostelRule.other: "Other",
  };

  /// Reverse mapping of labels to `HostelRule` enum for efficient lookup.
  static final Map<String, HostelRule> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Mapping of `HostelRule` to detailed descriptions.
  static const Map<HostelRule, String> _descriptions = {
    HostelRule.noLateEntry: "Students must return to the hostel before the specified time.",
    HostelRule.attendanceMandatory: "Daily attendance is required for all hostel residents.",
    HostelRule.visitorsRestricted: "Visitors are only allowed during designated hours and with permission.",
    HostelRule.noOutsideFood: "Bringing outside food is not allowed to maintain hygiene.",
    HostelRule.silenceHours: "Quiet hours must be observed for study and sleep.",
    HostelRule.curfewTime: "Curfew timings must be strictly followed.",
    HostelRule.noSmokingAlcohol: "Consumption of alcohol, smoking, or drugs is strictly prohibited.",
    HostelRule.cleanlinessRequired: "Residents must keep their rooms and common areas clean.",
    HostelRule.mealTimingsFixed: "Meals are served only during designated meal hours.",
    HostelRule.restrictedElectricalAppliances: "Use of high-power electrical appliances is not allowed.",
    HostelRule.studyHoursMandatory: "Students must follow designated study hours.",
    HostelRule.dressCode: "Residents must adhere to the prescribed dress code.",
    HostelRule.hostelLeavePermission: "Students must get prior approval to leave the hostel.",
    HostelRule.noRagging: "Any form of ragging or bullying is strictly prohibited.",
    HostelRule.noLoudMusic: "Playing loud music that disturbs others is not allowed.",
    HostelRule.lightsOutTime: "Lights must be turned off after the designated time.",
    HostelRule.genderRestrictedAreas: "Certain areas are restricted for the opposite gender.",
    HostelRule.personalResponsibility: "Students are responsible for their belongings.",
    HostelRule.internetUsageLimit: "Internet usage may be restricted or monitored.",
    HostelRule.emergencyProtocol: "Residents must follow safety protocols during emergencies.",
    HostelRule.other: "Any other rule not specified.",
  };

  /// Converts a string to the corresponding `HostelRule` enum.
  static HostelRule fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? HostelRule.other;
  }

  /// Returns a list of all hostel rule labels.
  static List<String> get labelsList => _labels.values.toList();
}

enum HostelRule {
  noLateEntry(
    label: "No Late Entry",
    description: "Students must return to the hostel before the specified time.",
  ),
  attendanceMandatory(
    label: "Mandatory Attendance",
    description: "Daily attendance is required for all hostel residents.",
  ),
  visitorsRestricted(
    label: "Visitor Restrictions",
    description: "Visitors are only allowed during designated hours and with permission.",
  ),
  noOutsideFood(
    label: "No Outside Food Allowed",
    description: "Bringing outside food is not allowed to maintain hygiene.",
  ),
  silenceHours(
    label: "Silence Hours",
    description: "Quiet hours must be observed for study and sleep.",
  ),
  curfewTime(
    label: "Curfew Time",
    description: "Curfew timings must be strictly followed.",
  ),
  noSmokingAlcohol(
    label: "No Smoking or Alcohol",
    description: "Consumption of alcohol, smoking, or drugs is strictly prohibited.",
  ),
  cleanlinessRequired(
    label: "Cleanliness Required",
    description: "Residents must keep their rooms and common areas clean.",
  ),
  mealTimingsFixed(
    label: "Fixed Meal Timings",
    description: "Meals are served only during designated meal hours.",
  ),
  restrictedElectricalAppliances(
    label: "Restricted Electrical Appliances",
    description: "Use of high-power electrical appliances is not allowed.",
  ),
  studyHoursMandatory(
    label: "Mandatory Study Hours",
    description: "Students must follow designated study hours.",
  ),
  dressCode(
    label: "Dress Code Enforcement",
    description: "Residents must adhere to the prescribed dress code.",
  ),
  hostelLeavePermission(
    label: "Hostel Leave Permission Required",
    description: "Students must get prior approval to leave the hostel.",
  ),
  noRagging(
    label: "Anti-Ragging Rule",
    description: "Any form of ragging or bullying is strictly prohibited.",
  ),
  noLoudMusic(
    label: "No Loud Music Allowed",
    description: "Playing loud music that disturbs others is not allowed.",
  ),
  lightsOutTime(
    label: "Lights Out Time",
    description: "Lights must be turned off after the designated time.",
  ),
  genderRestrictedAreas(
    label: "Restricted Areas for Opposite Gender",
    description: "Certain areas are restricted for the opposite gender.",
  ),
  personalResponsibility(
    label: "Responsibility for Personal Belongings",
    description: "Students are responsible for their belongings.",
  ),
  internetUsageLimit(
    label: "Limited Internet Usage",
    description: "Internet usage may be restricted or monitored.",
  ),
  emergencyProtocol(
    label: "Emergency Protocol Compliance",
    description: "Residents must follow safety protocols during emergencies.",
  ),
  other(
    label: "Other",
    description: "Any other rule not specified.",
  );

  const HostelRule({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static HostelRule fromString(String value) {
    return HostelRule.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => HostelRule.other,
    );
  }

  static List<String> get labelsList =>
      HostelRule.values.map((e) => e.label).toList();
}
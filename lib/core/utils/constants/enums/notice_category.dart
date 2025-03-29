enum NoticeCategory {
  // Academic
  examSchedules(label: 'Exam Schedules', emoji: '📅'),
  classTimetables(label: 'Class Timetables', emoji: '🕰️'),
  assignmentDeadlines(label: 'Assignment Deadlines', emoji: '⏰'),
  resultsAndGrades(label: 'Results and Grades', emoji: '🎓'),
  syllabusUpdates(label: 'Syllabus Updates', emoji: '📝'),

  // Administrative
  feePaymentReminders(label: 'Fee Payment Reminders', emoji: '💰'),
  admissionAnnouncements(label: 'Admission Announcements', emoji: '📢'),
  schoolPolicyUpdates(label: 'School Policy Updates', emoji: '📋'),
  parentTeacherMeetings(label: 'Parent-Teacher Meetings', emoji: '👨‍👩‍👧'),
  administrativeHolidays(label: 'Administrative Holidays', emoji: '🏖️'),

  // Events & Activities
  sportsEvents(label: 'Sports Events', emoji: '⚽'),
  culturalPrograms(label: 'Cultural Programs', emoji: '🎉'),
  workshopsAndSeminars(label: 'Workshops & Seminars', emoji: '🎓'),
  fieldTrips(label: 'Field Trips', emoji: '🚌'),
  annualDayCelebrations(label: 'Annual Day / Celebrations', emoji: '🎂'),

  // Health & Safety
  healthCheckupCamps(label: 'Health Checkup Camps', emoji: '🩺'),
  emergencyAnnouncements(label: 'Emergency Announcements', emoji: '🚨'),
  covid19Protocols(label: 'COVID-19 Protocols', emoji: '😷'),
  safetyDrills(label: 'Safety Drills', emoji: '🛡️'),
  medicalAlerts(label: 'Medical Alerts', emoji: '🚑'),

  // Extracurricular
  clubActivities(label: 'Club Activities', emoji: '🎤'),
  competitionsAndContests(label: 'Competitions & Contests', emoji: '🏆'),
  talentShows(label: 'Talent Shows', emoji: '🎬'),
  artAndCraftEvents(label: 'Art & Craft Events', emoji: '🎨'),

  // Transport
  busScheduleChanges(label: 'Bus Schedule Changes', emoji: '🚌'),
  routeUpdates(label: 'Route Updates', emoji: '🗺️'),
  safetyGuidelines(label: 'Safety Guidelines', emoji: '🚦'),
  pickupDropOffChanges(label: 'Pickup/Drop-off Changes', emoji: '🚏'),

  // General
  publicHolidays(label: 'Public Holidays', emoji: '🛌 🎉 🕶️ 🏖️ 📅'),
  weatherRelatedClosures(label: 'Weather-Related Closures', emoji: '🌧️'),
  lostAndFound(label: 'Lost and Found', emoji: '🔍'),
  generalAnnouncements(label: 'General Announcements', emoji: '📢'),

  // Disciplinary
  codeOfConductReminders(label: 'Code of Conduct Reminders', emoji: '📋'),
  disciplinaryActions(label: 'Disciplinary Actions', emoji: '⚖️'),
  behavioralGuidelines(label: 'Behavioral Guidelines', emoji: '📋'),

  // Special Programs
  scholarshipAnnouncements(label: 'Scholarship Announcements', emoji: '🎓'),
  specialCoachingClasses(label: 'Special Coaching Classes', emoji: '✍️'),
  internshipPlacementInformation(
      label: 'Internship/Placement Information', emoji: '💼'),

  // Maintenance & Infrastructure
  facilityRepairs(label: 'Facility Repairs', emoji: '🔧'),
  labLibraryClosures(label: 'Lab/Library Closures', emoji: '🧪'),
  newFacilityAnnouncements(label: 'New Facility Announcements', emoji: '📢');

  const NoticeCategory({required this.label, required this.emoji});

  final String label;
  final String emoji;

  static NoticeCategory fromString(String value) {
    return NoticeCategory.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => NoticeCategory.generalAnnouncements, // A reasonable default
    );
  }

  static List<String> get labelsList =>
      NoticeCategory.values.map((e) => e.label).toList();

  static String? getEmojiByLabel(String label) {
    try {
      return NoticeCategory.values
          .firstWhere((element) => element.label == label)
          .emoji;
    } catch (e) {
      return null; // Or a default emoji if preferred
    }
  }
}
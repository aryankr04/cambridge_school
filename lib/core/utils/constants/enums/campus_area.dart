import 'package:collection/collection.dart';

enum CampusArea {
  classroom, staffRoom, principalOffice, library, laboratory,
  computerLab, auditorium, sportsGround, canteen, parking,
  hostel, washroom, reception, adminOffice, infirmary,
  playground, corridor, examinationHall, activityRoom,
  prayerRoom, conferenceHall, musicRoom, artRoom, danceRoom,
  multipurposeHall, counselingRoom, teacherLounge, waitingArea,
  securityRoom, transportOffice, storeRoom, feeCounter,
  chemistryLab, physicsLab, biologyLab, roboticsLab,
  languageLab, daycare, cafeteria, studentCommonRoom,
  indoorSportsRoom, swimmingPool, terraceGarden, meditationRoom
}

extension CampusAreaExtension on CampusArea {
  static const Map<CampusArea, String> _labels = {
    CampusArea.classroom: "Classroom",
    CampusArea.staffRoom: "Staff Room",
    CampusArea.principalOffice: "Principal's Office",
    CampusArea.library: "Library",
    CampusArea.laboratory: "Science Laboratory",
    CampusArea.computerLab: "Computer Lab",
    CampusArea.auditorium: "Auditorium",
    CampusArea.sportsGround: "Sports Ground",
    CampusArea.canteen: "Canteen",
    CampusArea.parking: "Parking Area",
    CampusArea.hostel: "Hostel",
    CampusArea.washroom: "Washroom",
    CampusArea.reception: "Reception",
    CampusArea.adminOffice: "Admin Office",
    CampusArea.infirmary: "Infirmary (Medical Room)",
    CampusArea.playground: "Playground",
    CampusArea.corridor: "Corridor",
    CampusArea.examinationHall: "Examination Hall",
    CampusArea.activityRoom: "Activity Room",
    CampusArea.prayerRoom: "Prayer Room",
    CampusArea.conferenceHall: "Conference Hall",
    CampusArea.musicRoom: "Music Room",
    CampusArea.artRoom: "Art Room",
    CampusArea.danceRoom: "Dance Room",
    CampusArea.multipurposeHall: "Multipurpose Hall",
    CampusArea.counselingRoom: "Counseling Room",
    CampusArea.teacherLounge: "Teacher Lounge",
    CampusArea.waitingArea: "Waiting Area",
    CampusArea.securityRoom: "Security Room",
    CampusArea.transportOffice: "Transport Office",
    CampusArea.storeRoom: "Store Room",
    CampusArea.feeCounter: "Fee Counter",
    CampusArea.chemistryLab: "Chemistry Lab",
    CampusArea.physicsLab: "Physics Lab",
    CampusArea.biologyLab: "Biology Lab",
    CampusArea.roboticsLab: "Robotics Lab",
    CampusArea.languageLab: "Language Lab",
    CampusArea.daycare: "Daycare",
    CampusArea.cafeteria: "Cafeteria",
    CampusArea.studentCommonRoom: "Student Common Room",
    CampusArea.indoorSportsRoom: "Indoor Sports Room",
    CampusArea.swimmingPool: "Swimming Pool",
    CampusArea.terraceGarden: "Terrace Garden",
    CampusArea.meditationRoom: "Meditation Room",
  };

  static const Map<CampusArea, String> _descriptions = {
    CampusArea.classroom: "A room where students attend lessons.",
    CampusArea.staffRoom: "A place where teachers rest and work.",
    CampusArea.principalOffice: "The office of the school's principal.",
    CampusArea.library: "A room containing books and study resources.",
    CampusArea.laboratory: "A place for conducting science experiments.",
    CampusArea.computerLab: "A room with computers for IT learning.",
    CampusArea.auditorium: "A large hall for school events and meetings.",
    CampusArea.sportsGround: "An outdoor area for sports and games.",
    CampusArea.canteen: "A place where students buy and eat food.",
    CampusArea.parking: "Parking space for staff and students' vehicles.",
    CampusArea.hostel: "Accommodation for students staying at school.",
    CampusArea.washroom: "Restroom facilities for students and staff.",
    CampusArea.reception: "Front desk for visitors and inquiries.",
    CampusArea.adminOffice: "Office where school administration works.",
    CampusArea.infirmary: "A medical room for first aid and health checkups.",
    CampusArea.playground: "An outdoor play area for children.",
    CampusArea.corridor: "Passageways connecting different school sections.",
    CampusArea.examinationHall: "A hall for conducting exams and tests.",
    CampusArea.activityRoom: "A space for extracurricular activities and clubs.",
    CampusArea.prayerRoom: "A quiet place for religious prayers.",
    CampusArea.conferenceHall: "A hall for meetings and discussions.",
    CampusArea.musicRoom: "A room for learning and practicing music.",
    CampusArea.artRoom: "A space for drawing, painting, and creativity.",
    CampusArea.danceRoom: "A room for dance and movement activities.",
    CampusArea.multipurposeHall: "A hall for various school activities.",
    CampusArea.counselingRoom: "A room for student counseling and guidance.",
    CampusArea.teacherLounge: "A space for teachers to relax and work.",
    CampusArea.waitingArea: "A designated area for visitors and parents.",
    CampusArea.securityRoom: "A place where security personnel are stationed.",
    CampusArea.transportOffice: "An office managing school transport services.",
    CampusArea.storeRoom: "Storage for school supplies and materials.",
    CampusArea.feeCounter: "A counter for school fee payments.",
    CampusArea.chemistryLab: "A lab for conducting chemistry experiments.",
    CampusArea.physicsLab: "A lab for physics practical work.",
    CampusArea.biologyLab: "A lab for biology experiments and research.",
    CampusArea.roboticsLab: "A lab for robotics and engineering projects.",
    CampusArea.languageLab: "A room for language learning and practice.",
    CampusArea.daycare: "A daycare center for younger children.",
    CampusArea.cafeteria: "A space for dining with food options.",
    CampusArea.studentCommonRoom: "A shared space for students to relax.",
    CampusArea.indoorSportsRoom: "An indoor area for sports activities.",
    CampusArea.swimmingPool: "A pool for swimming practice.",
    CampusArea.terraceGarden: "A rooftop garden for learning and relaxation.",
    CampusArea.meditationRoom: "A quiet space for meditation and mindfulness.",
  };

  /// Returns the label of the campus area.
  String get label => _labels[this] ?? "Unknown Area";

  /// Returns the description of the campus area.
  String get description => _descriptions[this] ?? "No description available.";

  /// Cached map for fast string-to-enum conversion.
  static final Map<String, CampusArea> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key
  };

  /// Converts a string label to the corresponding `CampusArea` enum.
  static CampusArea? fromString(String value) {
    return _labelToEnum[value.toLowerCase()];
  }

  /// Returns a list of all campus area labels.
  static List<String> get labelsList => _labels.values.toList();
}


enum CampusArea {
  classroom(
    label: "Classroom",
    description: "A room where students attend lessons.",
  ),
  staffRoom(
    label: "Staff Room",
    description: "A place where teachers rest and work.",
  ),
  principalOffice(
    label: "Principal's Office",
    description: "The office of the school's principal.",
  ),
  library(
    label: "Library",
    description: "A room containing books and study resources.",
  ),
  laboratory(
    label: "Science Laboratory",
    description: "A place for conducting science experiments.",
  ),
  computerLab(
    label: "Computer Lab",
    description: "A room with computers for IT learning.",
  ),
  auditorium(
    label: "Auditorium",
    description: "A large hall for school events and meetings.",
  ),
  sportsGround(
    label: "Sports Ground",
    description: "An outdoor area for sports and games.",
  ),
  canteen(
    label: "Canteen",
    description: "A place where students buy and eat food.",
  ),
  parking(
    label: "Parking Area",
    description: "Parking space for staff and students' vehicles.",
  ),
  hostel(
    label: "Hostel",
    description: "Accommodation for students staying at school.",
  ),
  washroom(
    label: "Washroom",
    description: "Restroom facilities for students and staff.",
  ),
  reception(
    label: "Reception",
    description: "Front desk for visitors and inquiries.",
  ),
  adminOffice(
    label: "Admin Office",
    description: "Office where school administration works.",
  ),
  infirmary(
    label: "Infirmary (Medical Room)",
    description: "A medical room for first aid and health checkups.",
  ),
  playground(
    label: "Playground",
    description: "An outdoor play area for children.",
  ),
  corridor(
    label: "Corridor",
    description: "Passageways connecting different school sections.",
  ),
  examinationHall(
    label: "Examination Hall",
    description: "A hall for conducting exams and tests.",
  ),
  activityRoom(
    label: "Activity Room",
    description: "A space for extracurricular activities and clubs.",
  ),
  prayerRoom(
    label: "Prayer Room",
    description: "A quiet place for religious prayers.",
  ),
  conferenceHall(
    label: "Conference Hall",
    description: "A hall for meetings and discussions.",
  ),
  musicRoom(
    label: "Music Room",
    description: "A room for learning and practicing music.",
  ),
  artRoom(
    label: "Art Room",
    description: "A space for drawing, painting, and creativity.",
  ),
  danceRoom(
    label: "Dance Room",
    description: "A room for dance and movement activities.",
  ),
  multipurposeHall(
    label: "Multipurpose Hall",
    description: "A hall for various school activities.",
  ),
  counselingRoom(
    label: "Counseling Room",
    description: "A room for student counseling and guidance.",
  ),
  teacherLounge(
    label: "Teacher Lounge",
    description: "A space for teachers to relax and work.",
  ),
  waitingArea(
    label: "Waiting Area",
    description: "A designated area for visitors and parents.",
  ),
  securityRoom(
    label: "Security Room",
    description: "A place where security personnel are stationed.",
  ),
  transportOffice(
    label: "Transport Office",
    description: "An office managing school transport services.",
  ),
  storeRoom(
    label: "Store Room",
    description: "Storage for school supplies and materials.",
  ),
  feeCounter(
    label: "Fee Counter",
    description: "A counter for school fee payments.",
  ),
  chemistryLab(
    label: "Chemistry Lab",
    description: "A lab for conducting chemistry experiments.",
  ),
  physicsLab(
    label: "Physics Lab",
    description: "A lab for physics practical work.",
  ),
  biologyLab(
    label: "Biology Lab",
    description: "A lab for biology experiments and research.",
  ),
  roboticsLab(
    label: "Robotics Lab",
    description: "A lab for robotics and engineering projects.",
  ),
  languageLab(
    label: "Language Lab",
    description: "A room for language learning and practice.",
  ),
  daycare(
    label: "Daycare",
    description: "A daycare center for younger children.",
  ),
  cafeteria(
    label: "Cafeteria",
    description: "A space for dining with food options.",
  ),
  studentCommonRoom(
    label: "Student Common Room",
    description: "A shared space for students to relax.",
  ),
  indoorSportsRoom(
    label: "Indoor Sports Room",
    description: "An indoor area for sports activities.",
  ),
  swimmingPool(
    label: "Swimming Pool",
    description: "A pool for swimming practice.",
  ),
  terraceGarden(
    label: "Terrace Garden",
    description: "A rooftop garden for learning and relaxation.",
  ),
  meditationRoom(
    label: "Meditation Room",
    description: "A quiet space for meditation and mindfulness.",
  );

  const CampusArea({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static CampusArea fromLabel(String label) {
    return CampusArea.values.firstWhere(
          (element) => element.label == label,
      orElse: () => CampusArea.classroom, // or another suitable default
    );
  }

  static List<String> getLabels() {
    return CampusArea.values.map((area) => area.label).toList();
  }

  static CampusArea fromString(String value) {
    return CampusArea.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => CampusArea.classroom, // or another suitable default
    );
  }
}
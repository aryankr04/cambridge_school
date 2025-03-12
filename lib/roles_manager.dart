enum AppPermission {
  manageUsers,
  manageTeachers,
  manageStudents,
  manageAttendance,
  manageExams,
  viewReports,
  manageFinance,
  manageTransport,
  manageLibrary,
  viewStudents,
  assignHomework,
  submitHomework,
  viewResults,
  viewSchedule,
  viewExams,
  payFees,
  viewChildReports,
  viewAttendance,
  viewRoutes,
  markTransportAttendance,
  createAnnouncements,
  viewAnnouncements,
  manageEvents,
  viewEvents,
  manageClassrooms,
  manageSubjects,
  viewSubjects,
  sendNotifications,
  manageTimetable,
  viewTimetable,
  manageAssignments,
  viewAssignments,
  manageStudyMaterials,
  viewStudyMaterials,
  communicateWithParents,
  manageStudentBehavior,
  viewStudentBehavior,
  manageFees,
}

extension AppPermissionExtension on AppPermission {
  String get value {
    switch (this) {
      case AppPermission.manageUsers:
        return "Manage Users";
      case AppPermission.manageTeachers:
        return "Manage Teachers";
      case AppPermission.manageStudents:
        return "Manage Students";
      case AppPermission.manageAttendance:
        return "Manage Attendance";
      case AppPermission.manageExams:
        return "Manage Exams";
      case AppPermission.viewReports:
        return "View Reports";
      case AppPermission.manageFinance:
        return "Manage Finance";
      case AppPermission.manageTransport:
        return "Manage Transport";
      case AppPermission.manageLibrary:
        return "Manage Library";
      case AppPermission.viewStudents:
        return "View Students";
      case AppPermission.assignHomework:
        return "Assign Homework";
      case AppPermission.submitHomework:
        return "Submit Homework";
      case AppPermission.viewResults:
        return "View Results";
      case AppPermission.viewSchedule:
        return "View Schedule";
      case AppPermission.viewExams:
        return "View Exams";
      case AppPermission.payFees:
        return "Pay Fees";
      case AppPermission.viewChildReports:
        return "View Child Reports";
      case AppPermission.viewAttendance:
        return "View Attendance";
      case AppPermission.viewRoutes:
        return "View Routes";
      case AppPermission.markTransportAttendance:
        return "Mark Transport Attendance";
      case AppPermission.createAnnouncements:
        return "Create Announcements";
      case AppPermission.viewAnnouncements:
        return "View Announcements";
      case AppPermission.manageEvents:
        return "Manage Events";
      case AppPermission.viewEvents:
        return "View Events";
      case AppPermission.manageClassrooms:
        return "Manage Classrooms";
      case AppPermission.manageSubjects:
        return "Manage Subjects";
      case AppPermission.viewSubjects:
        return "View Subjects";
      case AppPermission.sendNotifications:
        return "Send Notifications";
      case AppPermission.manageTimetable:
        return "Manage Timetable";
      case AppPermission.viewTimetable:
        return "View Timetable";
      case AppPermission.manageAssignments:
        return "Manage Assignments";
      case AppPermission.viewAssignments:
        return "View Assignments";
      case AppPermission.manageStudyMaterials:
        return "Manage Study Materials";
      case AppPermission.viewStudyMaterials:
        return "View Study Materials";
      case AppPermission.communicateWithParents:
        return "Communicate With Parents";
      case AppPermission.manageStudentBehavior:
        return "Manage Student Behavior";
      case AppPermission.viewStudentBehavior:
        return "View Student Behavior";
      case AppPermission.manageFees:
        return "Manage Fees";

      default:
        return "Unknown Permission";
    }
  }
}

enum UserRole {
  superAdmin,
  admin,
  schoolAdmin,
  chairperson,
  boardMember,
  deanOfAcademics,
  departmentHead,
  director,
  principal,
  vicePrincipal,
  academicCoordinator,
  teacher,
  specialEducator,
  physicalEducationTeacher,
  sportsCoach,
  musicTeacher,
  danceTeacher,
  officeAdministrator,
  receptionist,
  accountant,
  hrPersonnel,
  examinationCoordinator,
  librarian,
  labAssistant,
  itSupportStaff,
  socialMediaManager,
  counselor,
  nurse,
  busDriver,
  busConductor,
  securityGuard,
  janitor,
  electrician,
  gardener,
  student,
  parent,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.superAdmin:
        return "Super Admin";
      case UserRole.admin:
        return "Admin";
      case UserRole.schoolAdmin:
        return "School Admin";
      case UserRole.chairperson:
        return "Chairperson";
      case UserRole.boardMember:
        return "Board Member";
      case UserRole.deanOfAcademics:
        return "Dean Of Academics";
      case UserRole.departmentHead:
        return "Department Head";
      case UserRole.director:
        return "Director";
      case UserRole.principal:
        return "Principal";
      case UserRole.vicePrincipal:
        return "Vice Principal";
      case UserRole.academicCoordinator:
        return "Academic Coordinator";
      case UserRole.teacher:
        return "Teacher";
      case UserRole.specialEducator:
        return "Special Educator";
      case UserRole.physicalEducationTeacher:
        return "Physical Education Teacher";
      case UserRole.sportsCoach:
        return "Sports Coach";
      case UserRole.musicTeacher:
        return "Music Teacher";
      case UserRole.danceTeacher:
        return "Dance Teacher";
      case UserRole.officeAdministrator:
        return "Office Administrator";
      case UserRole.receptionist:
        return "Receptionist";
      case UserRole.accountant:
        return "Accountant";
      case UserRole.hrPersonnel:
        return "HR Personnel";
      case UserRole.examinationCoordinator:
        return "Examination Coordinator";
      case UserRole.librarian:
        return "Librarian";
      case UserRole.labAssistant:
        return "Lab Assistant";
      case UserRole.itSupportStaff:
        return "IT Support Staff";
      case UserRole.socialMediaManager:
        return "Social Media Manager";
      case UserRole.counselor:
        return "Counselor";
      case UserRole.nurse:
        return "Nurse";
      case UserRole.busDriver:
        return "Bus Driver";
      case UserRole.busConductor:
        return "Bus Conductor";
      case UserRole.securityGuard:
        return "Security Guard";
      case UserRole.janitor:
        return "Janitor";
      case UserRole.electrician:
        return "Electrician";
      case UserRole.gardener:
        return "Gardener";
      case UserRole.student:
        return "Student";
      case UserRole.parent:
        return "Parent";
      default:
        return "Unknown User Role";
    }
  }

  String get category {
    switch (this) {
      case UserRole.superAdmin:
      case UserRole.admin:
        return 'Higher Administration';
      case UserRole.schoolAdmin:
      case UserRole.chairperson:
      case UserRole.boardMember:
      case UserRole.deanOfAcademics:
      case UserRole.departmentHead:
        return 'Administrative Staff';
      case UserRole.director:
      case UserRole.principal:
      case UserRole.vicePrincipal:
      case UserRole.academicCoordinator:
      case UserRole.teacher:
      case UserRole.specialEducator:
      case UserRole.physicalEducationTeacher:
      case UserRole.sportsCoach:
      case UserRole.musicTeacher:
      case UserRole.danceTeacher:
        return 'Teaching Staff';
      case UserRole.officeAdministrator:
      case UserRole.receptionist:
      case UserRole.accountant:
      case UserRole.hrPersonnel:
      case UserRole.examinationCoordinator:
        return 'Non-Teaching Administrative Staff';
      case UserRole.librarian:
      case UserRole.labAssistant:
      case UserRole.itSupportStaff:
      case UserRole.socialMediaManager:
      case UserRole.counselor:
      case UserRole.nurse:
        return 'Support Staff';
      case UserRole.busDriver:
      case UserRole.busConductor:
      case UserRole.securityGuard:
        return 'Transport and Security Staff';
      case UserRole.janitor:
      case UserRole.electrician:
      case UserRole.gardener:
        return 'Maintenance and Housekeeping Staff';
      case UserRole.student:
      case UserRole.parent:
        return 'Student and Parent';
      default:
        return 'Support Staff'; // Or a more appropriate default
    }
  }

  String get description {
    switch (this) {
      case UserRole.superAdmin:
        return "Manages multiple schools or an entire education system.";
      case UserRole.admin:
        return "Handles overall school administration and management.";
      case UserRole.schoolAdmin:
        return "Manages daily operations of a particular school.";
      case UserRole.chairperson:
        return "Oversees multiple schools under a trust or foundation.";
      case UserRole.boardMember:
        return "Part of the school's governing body, making key decisions.";
      case UserRole.deanOfAcademics:
        return "Manages academic policies, curriculum, and teaching standards.";
      case UserRole.departmentHead:
        return "Leads a specific department like Science, Math, etc.";
      case UserRole.director:
        return "Oversees the entire school's operations and administration.";
      case UserRole.principal:
        return "Oversees the entire school's operations and administration.";
      case UserRole.vicePrincipal:
        return "Assists the principal in managing school activities and staff.";
      case UserRole.academicCoordinator:
        return "Manages curriculum, teachers, and academic planning.";
      case UserRole.teacher:
        return "Delivers lessons and educates students in various subjects.";
      case UserRole.specialEducator:
        return "Works with students with special learning needs.";
      case UserRole.physicalEducationTeacher:
        return "Focuses on physical development and sports activities.";
      case UserRole.sportsCoach:
        return "Trains students in different sports and fitness activities.";
      case UserRole.musicTeacher:
        return "Teaches students music theory and instrument playing.";
      case UserRole.danceTeacher:
        return "Instructs students in dance and movement techniques.";
      case UserRole.officeAdministrator:
        return "Manages school records, operations, and documentation.";
      case UserRole.receptionist:
        return "Handles inquiries, communication, and visitor management.";
      case UserRole.accountant:
        return "Manages school finances, budgets, and salary distribution.";
      case UserRole.hrPersonnel:
        return "Handles staff recruitment, salaries, and other HR tasks.";
      case UserRole.examinationCoordinator:
        return "Organizes exams, schedules, and result processing.";
      case UserRole.librarian:
        return "Maintains the school library and assists students with books.";
      case UserRole.labAssistant:
        return "Supports students and teachers in science and computer labs.";
      case UserRole.itSupportStaff:
        return "Manages digital infrastructure, software, and hardware.";
      case UserRole.socialMediaManager:
        return "Handles the school's online presence, posts updates, and engages with the audience.";
      case UserRole.counselor:
        return "Provides mental health and emotional support to students.";
      case UserRole.nurse:
        return "Handles medical emergencies and student health services.";
      case UserRole.busDriver:
        return "Drives school buses and ensures student transport safety.";
      case UserRole.busConductor:
        return "Assists in student transport and bus management.";
      case UserRole.securityGuard:
        return "Ensures school campus safety and security.";
      case UserRole.janitor:
        return "Maintains school cleanliness and sanitation.";
      case UserRole.electrician:
        return "Maintains electrical systems and technical equipment.";
      case UserRole.gardener:
        return "Takes care of school gardens and outdoor areas.";
      case UserRole.student:
        return "Learns in the school and participates in educational activities.";
      case UserRole.parent:
        return "Guardian responsible for a student's well-being and education.";
      default:
        return "No Description Available";
    }
  }
}


class RoleDefinition {
  final UserRole role;
  final List<AppPermission> permissions;

  RoleDefinition({required this.role, required this.permissions});
}


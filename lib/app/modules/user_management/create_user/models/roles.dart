enum UserRole {
  SuperAdmin,
  Admin,
  SchoolAdmin,
  Chairperson,
  BoardMember,
  DeanOfAcademics,
  DepartmentHead,
  Director,
  Principal,
  VicePrincipal,
  AcademicCoordinator,
  Teacher,
  SpecialEducator,
  PhysicalEducationTeacher,
  SportsCoach,
  MusicTeacher,
  DanceTeacher,
  OfficeAdministrator,
  Receptionist,
  Accountant,
  HRPersonnel,
  ExaminationCoordinator,
  Librarian,
  LabAssistant,
  ITSupportStaff,
  SocialMediaManager,
  Counselor,
  Nurse,
  BusDriver,
  BusConductor,
  SecurityGuard,
  Janitor,
  Electrician,
  Gardener,
  Student,
  Parent,
}

class Role {
  final String category;
  final UserRole role; // Change 'role' to type UserRole
  final String description;

  Role({required this.category, required this.role, required this.description});
}

class Roles {
  final List<Role> roles = [
    Role(category: "Higher Administration", role: UserRole.SuperAdmin, description: "Manages multiple schools or an entire education system."),
    Role(category: "Higher Administration", role: UserRole.Admin, description: "Handles overall school administration and management."),

    // Administrative Roles
    Role(category: "Administrative Staff", role: UserRole.SchoolAdmin, description: "Manages daily operations of a particular school."),
    Role(category: "Administrative Staff", role: UserRole.Chairperson, description: "Oversees multiple schools under a trust or foundation."),
    Role(category: "Administrative Staff", role: UserRole.BoardMember, description: "Part of the school's governing body, making key decisions."),
    Role(category: "Administrative Staff", role: UserRole.DeanOfAcademics, description: "Manages academic policies, curriculum, and teaching standards."),
    Role(category: "Administrative Staff", role: UserRole.DepartmentHead, description: "Leads a specific department like Science, Math, etc."),

    // Teaching Staff
    Role(category: "Teaching Staff", role: UserRole.Director, description: "Oversees the entire school's operations and administration."),
    Role(category: "Teaching Staff", role: UserRole.Principal, description: "Oversees the entire school's operations and administration."),
    Role(category: "Teaching Staff", role: UserRole.VicePrincipal, description: "Assists the principal in managing school activities and staff."),
    Role(category: "Teaching Staff", role: UserRole.AcademicCoordinator, description: "Manages curriculum, teachers, and academic planning."),
    Role(category: "Teaching Staff", role: UserRole.Teacher, description: "Delivers lessons and educates students in various subjects."),
    Role(category: "Teaching Staff", role: UserRole.SpecialEducator, description: "Works with students with special learning needs."),
    Role(category: "Teaching Staff", role: UserRole.PhysicalEducationTeacher, description: "Focuses on physical development and sports activities."),
    Role(category: "Teaching Staff", role: UserRole.SportsCoach, description: "Trains students in different sports and fitness activities."),
    Role(category: "Teaching Staff", role: UserRole.MusicTeacher, description: "Teaches students music theory and instrument playing."),
    Role(category: "Teaching Staff", role: UserRole.DanceTeacher, description: "Instructs students in dance and movement techniques."),

    // Non-Teaching Administrative Staff
    Role(category: "Non-Teaching Administrative Staff", role: UserRole.OfficeAdministrator, description: "Manages school records, operations, and documentation."),
    Role(category: "Non-Teaching Administrative Staff", role: UserRole.Receptionist, description: "Handles inquiries, communication, and visitor management."),
    Role(category: "Non-Teaching Administrative Staff", role: UserRole.Accountant, description: "Manages school finances, budgets, and salary distribution."),
    Role(category: "Non-Teaching Administrative Staff", role: UserRole.HRPersonnel, description: "Handles staff recruitment, salaries, and other HR tasks."),
    Role(category: "Non-Teaching Administrative Staff", role: UserRole.ExaminationCoordinator, description: "Organizes exams, schedules, and result processing."),

    // Support Staff
    Role(category: "Support Staff", role: UserRole.Librarian, description: "Maintains the school library and assists students with books."),
    Role(category: "Support Staff", role: UserRole.LabAssistant, description: "Supports students and teachers in science and computer labs."),
    Role(category: "Support Staff", role: UserRole.ITSupportStaff, description: "Manages digital infrastructure, software, and hardware."),
    Role(category: "Support Staff", role: UserRole.SocialMediaManager, description: "Handles the school's online presence, posts updates, and engages with the audience."),

    Role(category: "Support Staff", role: UserRole.Counselor, description: "Provides mental health and emotional support to students."),
    Role(category: "Support Staff", role: UserRole.Nurse, description: "Handles medical emergencies and student health services."),

    // Transport & Security Staff
    Role(category: "Transport & Security Staff", role: UserRole.BusDriver, description: "Drives school buses and ensures student transport safety."),
    Role(category: "Transport & Security Staff", role: UserRole.BusConductor, description: "Assists in student transport and bus management."),
    Role(category: "Transport & Security Staff", role: UserRole.SecurityGuard, description: "Ensures school campus safety and security."),

    // Maintenance & Housekeeping Staff
    Role(category: "Maintenance & Housekeeping Staff", role: UserRole.Janitor, description: "Maintains school cleanliness and sanitation."),
    Role(category: "Maintenance & Housekeeping Staff", role: UserRole.Electrician, description: "Maintains electrical systems and technical equipment."),
    Role(category: "Maintenance & Housekeeping Staff", role: UserRole.Gardener, description: "Takes care of school gardens and outdoor areas."),


    // Student/Parent
    Role(category: "Student/Parent", role: UserRole.Student, description: "Learns in the school and participates in educational activities."),
    Role(category: "Student/Parent", role: UserRole.Parent, description: "Guardian responsible for a student's well-being and education."),
  ];

  /// Returns a list of all unique categories
  List<String> getCategories() {
    return roles.map((e) => e.category).toSet().toList();
  }

  /// Returns a list of all roles in the school
  List<UserRole> getAllRoles() {
    return roles.map((e) => e.role).toList();
  }

  /// Returns all roles under a specific category
  List<UserRole> getRolesByCategory(String category) {
    return roles.where((e) => e.category == category).map((e) => e.role).toList();
  }

  /// Returns the description of a specific role
  String? getRoleDescription(UserRole role) { //Take an enum now
    try {
      return roles.firstWhere((e) => e.role == role).description;
    } catch (e) {
      return null;
    }
  }

  /// Checks if a role exists in the school
  bool roleExists(UserRole role) {
    return roles.any((e) => e.role == role);
  }

  String getRoleName(UserRole role) {
    return role.toString().split('.').last;
  }
}

/// Extension for fetching role descriptions without passing strings
extension RoleDescriptions on Roles {
  RoleDescriptionExtension get getRoleDescription => RoleDescriptionExtension(this);
}

class RoleDescriptionExtension {
  final Roles roles;
  RoleDescriptionExtension(this.roles);

  String? SuperAdmin() => roles.getRoleDescription(UserRole.SuperAdmin);
  String? Admin() => roles.getRoleDescription(UserRole.Admin);
  String? SchoolAdmin() => roles.getRoleDescription(UserRole.SchoolAdmin);
  String? Chairperson() => roles.getRoleDescription(UserRole.Chairperson);
  String? BoardMember() => roles.getRoleDescription(UserRole.BoardMember);
  String? DeanOfAcademics() => roles.getRoleDescription(UserRole.DeanOfAcademics);
  String? DepartmentHead() => roles.getRoleDescription(UserRole.DepartmentHead);
  String? Director() => roles.getRoleDescription(UserRole.Director);
  String? Principal() => roles.getRoleDescription(UserRole.Principal);
  String? VicePrincipal() => roles.getRoleDescription(UserRole.VicePrincipal);
  String? AcademicCoordinator() => roles.getRoleDescription(UserRole.AcademicCoordinator);
  String? Teacher() => roles.getRoleDescription(UserRole.Teacher);
  String? SpecialEducator() => roles.getRoleDescription(UserRole.SpecialEducator);
  String? PhysicalEducationTeacher() => roles.getRoleDescription(UserRole.PhysicalEducationTeacher);
  String? SportsCoach() => roles.getRoleDescription(UserRole.SportsCoach);
  String? MusicTeacher() => roles.getRoleDescription(UserRole.MusicTeacher);
  String? DanceTeacher() => roles.getRoleDescription(UserRole.DanceTeacher);
  String? OfficeAdministrator() => roles.getRoleDescription(UserRole.OfficeAdministrator);
  String? Receptionist() => roles.getRoleDescription(UserRole.Receptionist);
  String? Accountant() => roles.getRoleDescription(UserRole.Accountant);
  String? HRPersonnel() => roles.getRoleDescription(UserRole.HRPersonnel);
  String? ExaminationCoordinator() => roles.getRoleDescription(UserRole.ExaminationCoordinator);
  String? Librarian() => roles.getRoleDescription(UserRole.Librarian);
  String? LabAssistant() => roles.getRoleDescription(UserRole.LabAssistant);
  String? ITSupportStaff() => roles.getRoleDescription(UserRole.ITSupportStaff);
  String? Counselor() => roles.getRoleDescription(UserRole.Counselor);
  String? Nurse() => roles.getRoleDescription(UserRole.Nurse);
  String? BusDriver() => roles.getRoleDescription(UserRole.BusDriver);
  String? BusConductor() => roles.getRoleDescription(UserRole.BusConductor);
  String? SecurityGuard() => roles.getRoleDescription(UserRole.SecurityGuard);
  String? Janitor() => roles.getRoleDescription(UserRole.Janitor);
  String? Electrician() => roles.getRoleDescription(UserRole.Electrician);
  String? Gardener() => roles.getRoleDescription(UserRole.Gardener);
  String? SocialMediaManager() => roles.getRoleDescription(UserRole.SocialMediaManager);
  String? Student() => roles.getRoleDescription(UserRole.Student);
  String? Parent() => roles.getRoleDescription(UserRole.Parent);
}


/// Extension for category-based role retrieval
extension CategoryRoles on Roles {
  RoleCategoryExtension get getRolesByCategory => RoleCategoryExtension(this);
}

class RoleCategoryExtension {
  final Roles roles;
  RoleCategoryExtension(this.roles);

  List<UserRole> AdministrativeStaff() => roles.getRolesByCategory("Administrative Staff");
  List<UserRole> HigherAdministration() => roles.getRolesByCategory("Higher Administration");
  List<UserRole> TeachingStaff() => roles.getRolesByCategory("Teaching Staff");
  List<UserRole> SupportStaff() => roles.getRolesByCategory("Support Staff");
  List<UserRole> StudentParent() => roles.getRolesByCategory("Student/Parent");
  List<UserRole> NonTeachingAdministrativeStaff() => roles.getRolesByCategory("Non-Teaching Administrative Staff");
  List<UserRole> TransportAndSecurityStaff() => roles.getRolesByCategory("Transport & Security Staff");
  List<UserRole> MaintenanceAndHousekeepingStaff() => roles.getRolesByCategory("Maintenance & Housekeeping Staff");
}
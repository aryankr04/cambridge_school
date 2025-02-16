
// Main User Profile

import '../../../attendance/user_attendance_model.dart';

class UserModel {
  // 1️⃣ Basic Information
  final String userId;
  final String username;
  final String email;
  final String accountStatus;
  final String fullName;
  final String? profileImageUrl;
  final String? password;

  // 2️⃣ Performance & Activity
  final int points;
  final double performanceRating;
  final bool isActive;

  // 3️⃣ Personal Information
  final DateTime? dob;
  final String? gender;
  final String? religion;
  final String? category;
  final String? nationality;
  final String? maritalStatus;
  final String phoneNo;
  final String? profileDescription;
  final List<String>? languagesSpoken;
  final List<String>? hobbies;

  // 4️⃣ Physical & Health Information
  final double? height;
  final double? weight;
  final String? bloodGroup;
  final bool? isPhysicalDisability;

  // 5️⃣ Contact Information
  final Address? permanentAddress;
  final Address? currentAddress;

  // 6️⃣ Transportation Details
  final String? modeOfTransport;
  final TransportDetails? transportDetails;

  // 7️⃣ Role-Based Information
  final List<UserRole>? roles;
  final StudentDetails? studentDetails;
  final TeacherDetails? teacherDetails;
  final DirectorDetails? directorDetails;
  final AdminDetails? adminDetails;
  final SecurityGuardDetails? securityGuardDetails;
  final MaintenanceStaffDetails? maintenanceStaffDetails;
  final DriverDetails? driverDetails;
  final SchoolAdminDetails? schoolAdminDetails;
  final DepartmentHeadDetails? departmentHeadDetails;

  // 8️⃣ Emergency & Guardian Details
  final EmergencyContact? emergencyContact;
  final GuardianDetails? fatherDetails;
  final GuardianDetails? motherDetails;

  // 9️⃣ User Engagement
  final Favorite? favorites;
   UserAttendance? userAttendance;

  // 10 Metadata & System Fields
  final DateTime? createdAt;

  // 11 New Fields
  final List<Qualification>? qualifications;
  final DateTime? joiningDate;

  // 12 Added schoolId
  final String? schoolId; // Making this nullable

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.accountStatus,
    required this.fullName,
    this.profileImageUrl,
    this.password,
    required this.points,
    required this.performanceRating,
    this.isActive = true,
    this.dob,
    this.gender,
    this.religion,
    this.category,
    this.nationality,
    this.maritalStatus,
    required this.phoneNo,
    this.profileDescription,
    this.languagesSpoken,
    this.hobbies,
    this.height,
    this.weight,
    this.bloodGroup,
    this.isPhysicalDisability,
    this.permanentAddress,
    this.currentAddress,
    this.modeOfTransport,
    this.transportDetails,
    this.roles,
    this.studentDetails,
    this.teacherDetails,
    this.directorDetails,
    this.adminDetails,
    this.securityGuardDetails,
    this.maintenanceStaffDetails,
    this.driverDetails,
    this.schoolAdminDetails,
    this.departmentHeadDetails,
    this.emergencyContact,
    this.fatherDetails,
    this.motherDetails,
    this.favorites,
    this.userAttendance,
    this.createdAt,
    this.qualifications,
    this.joiningDate,
    this.schoolId, // Adding schoolId to constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'accountStatus': accountStatus,
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
      'password': password,
      'points': points,
      'performanceRating': performanceRating,
      'isActive': isActive,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'religion': religion,
      'category': category,
      'nationality': nationality,
      'maritalStatus': maritalStatus,
      'phoneNo': phoneNo,
      'profileDescription': profileDescription,
      'languagesSpoken': languagesSpoken,
      'hobbies': hobbies,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
      'isPhysicalDisability': isPhysicalDisability,
      'permanentAddress': permanentAddress?.toMap(),
      'currentAddress': currentAddress?.toMap(),
      'modeOfTransport': modeOfTransport,
      'transportDetails': transportDetails?.toMap(),
      'roles': roles?.map((role) => role.name).toList(),
      'studentDetails': studentDetails?.toMap(),
      'teacherDetails': teacherDetails?.toMap(),
      'directorDetails': directorDetails?.toMap(),
      'adminDetails': adminDetails?.toMap(),
      'securityGuardDetails': securityGuardDetails?.toMap(),
      'maintenanceStaffDetails': maintenanceStaffDetails?.toMap(),
      'driverDetails': driverDetails?.toMap(),
      'schoolAdminDetails': schoolAdminDetails?.toMap(),
      'departmentHeadDetails': departmentHeadDetails?.toMap(),
      'emergencyContact': emergencyContact?.toMap(),
      'fatherDetails': fatherDetails?.toMap(),
      'motherDetails': motherDetails?.toMap(),
      'favorites': favorites?.toMap(),
      'userAttendance': userAttendance?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'qualifications': qualifications
          ?.map((qualification) => qualification.toMap())
          .toList(),
      'joiningDate': joiningDate?.toIso8601String(),
      'schoolId': schoolId, //Adding schoolId to toMap
    };
  }

  static UserModel? fromMap(Map<String, dynamic> data) {
    try {
      return UserModel(
        userId: data['userId'] as String? ?? '',
        username: data['username'] as String,
        email: data['email'] as String,
        accountStatus: data['accountStatus'] as String,
        fullName: data['fullName'] as String,
        profileImageUrl: data['profileImageUrl'] as String?,
        password: data['password'] as String?,
        points: data['points'] as int? ?? 0,
        performanceRating:
            (data['performanceRating'] as num?)?.toDouble() ?? 0.0,
        isActive: data['isActive'] as bool? ?? true,
        dob: data['dob'] != null
            ? DateTime.tryParse(data['dob'] as String)
            : null,
        gender: data['gender'] as String?,
        religion: data['religion'] as String?,
        category: data['category'] as String?,
        nationality: data['nationality'] as String?,
        maritalStatus: data['maritalStatus'] as String?,
        phoneNo: data['phoneNo'] as String,
        profileDescription: data['profileDescription'] as String?,
        languagesSpoken: (data['languagesSpoken'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        hobbies: (data['hobbies'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        height:
            data['height'] is num ? (data['height'] as num).toDouble() : null,
        weight:
            data['weight'] is num ? (data['weight'] as num).toDouble() : null,
        bloodGroup: data['bloodGroup'] as String?,
        isPhysicalDisability: data['isPhysicalDisability'] as bool?,
        permanentAddress: data['permanentAddress'] != null
            ? Address.fromMap(data['permanentAddress'] as Map<String, dynamic>)
            : null,
        currentAddress: data['currentAddress'] != null
            ? Address.fromMap(data['currentAddress'] as Map<String, dynamic>)
            : null,
        modeOfTransport: data['modeOfTransport'] as String?,
        transportDetails: data['transportDetails'] != null
            ? TransportDetails.fromMap(
                data['transportDetails'] as Map<String, dynamic>)
            : null,
        roles: (data['roles'] as List<dynamic>?)
            ?.map((roleString) {
              try {
                return UserRole.values.firstWhere((element) =>
                    element.name == (roleString as String).toLowerCase());
              } catch (e) {
                print('Unknown role: $roleString');
                return null;
              }
            })
            .whereType<UserRole>()
            .toList(),
        studentDetails: data['studentDetails'] != null
            ? StudentDetails.fromMap(
                data['studentDetails'] as Map<String, dynamic>)
            : null,
        teacherDetails: data['teacherDetails'] != null
            ? TeacherDetails.fromMap(
                data['teacherDetails'] as Map<String, dynamic>)
            : null,
        directorDetails: data['directorDetails'] != null
            ? DirectorDetails.fromMap(
                data['directorDetails'] as Map<String, dynamic>)
            : null,
        adminDetails: data['adminDetails'] != null
            ? AdminDetails.fromMap(data['adminDetails'] as Map<String, dynamic>)
            : null,
        securityGuardDetails: data['securityGuardDetails'] != null
            ? SecurityGuardDetails.fromMap(
                data['securityGuardDetails'] as Map<String, dynamic>)
            : null,
        maintenanceStaffDetails: data['maintenanceStaffDetails'] != null
            ? MaintenanceStaffDetails.fromMap(
                data['maintenanceStaffDetails'] as Map<String, dynamic>)
            : null,
        driverDetails: data['driverDetails'] != null
            ? DriverDetails.fromMap(
                data['driverDetails'] as Map<String, dynamic>)
            : null,
        schoolAdminDetails: data['schoolAdminDetails'] != null
            ? SchoolAdminDetails.fromMap(
                data['schoolAdminDetails'] as Map<String, dynamic>)
            : null,
        departmentHeadDetails: data['departmentHeadDetails'] != null
            ? DepartmentHeadDetails.fromMap(
                data['departmentHeadDetails'] as Map<String, dynamic>)
            : null,
        emergencyContact: data['emergencyContact'] != null
            ? EmergencyContact.fromMap(
                data['emergencyContact'] as Map<String, dynamic>)
            : null,
        fatherDetails: data['fatherDetails'] != null
            ? GuardianDetails.fromMap(
                data['fatherDetails'] as Map<String, dynamic>)
            : null,
        motherDetails: data['motherDetails'] != null
            ? GuardianDetails.fromMap(
                data['motherDetails'] as Map<String, dynamic>)
            : null,
        favorites: data['favorites'] != null
            ? Favorite.fromMap(data['favorites'] as Map<String, dynamic>)
            : null,
        userAttendance: data['userAttendance'] != null
            ? UserAttendance.fromMap(
                data['userAttendance'] as Map<String, dynamic>)
            : null,
        qualifications: (data['qualifications'] as List<dynamic>?)
            ?.map((e) => Qualification.fromMap(e as Map<String, dynamic>))
            .whereType<Qualification>()
            .toList(),
        joiningDate: data['joiningDate'] != null
            ? DateTime.tryParse(data['joiningDate'] as String)
            : null,
        schoolId: data['schoolId'] as String?, //Adding schoolId fromMap
      );
    } catch (e) {
      print("Error creating User from map: $e");
      return null;
    }
  }

  UserModel copyWith({
    String? userId,
    String? username,
    String? email,
    String? accountStatus,
    String? fullName,
    String? profileImageUrl,
    String? password,
    int? points,
    double? performanceRating,
    bool? isActive,
    DateTime? dob,
    String? gender,
    String? religion,
    String? category,
    String? nationality,
    String? maritalStatus,
    String? phoneNo,
    String? profileDescription,
    List<String>? languagesSpoken,
    List<String>? hobbies,
    double? height,
    double? weight,
    String? bloodGroup,
    bool? isPhysicalDisability,
    Address? permanentAddress,
    Address? currentAddress,
    String? modeOfTransport,
    TransportDetails? transportDetails,
    List<UserRole>? roles,
    StudentDetails? studentDetails,
    TeacherDetails? teacherDetails,
    DirectorDetails? directorDetails,
    AdminDetails? adminDetails,
    SecurityGuardDetails? securityGuardDetails,
    MaintenanceStaffDetails? maintenanceStaffDetails,
    DriverDetails? driverDetails,
    SchoolAdminDetails? schoolAdminDetails,
    DepartmentHeadDetails? departmentHeadDetails,
    EmergencyContact? emergencyContact,
    GuardianDetails? fatherDetails,
    GuardianDetails? motherDetails,
    Favorite? favorites,
    UserAttendance? userAttendance,
    DateTime? createdAt,
    List<Qualification>? qualifications,
    DateTime? joiningDate,
    String? schoolId, //Adding schoolId in copyWith
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      accountStatus: accountStatus ?? this.accountStatus,
      fullName: fullName ?? this.fullName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      password: password ?? this.password,
      points: points ?? this.points,
      performanceRating: performanceRating ?? this.performanceRating,
      isActive: isActive ?? this.isActive,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      category: category ?? this.category,
      nationality: nationality ?? this.nationality,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      phoneNo: phoneNo ?? this.phoneNo,
      profileDescription: profileDescription ?? this.profileDescription,
      languagesSpoken: languagesSpoken ?? this.languagesSpoken,
      hobbies: hobbies ?? this.hobbies,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      isPhysicalDisability: isPhysicalDisability ?? this.isPhysicalDisability,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      currentAddress: currentAddress ?? this.currentAddress,
      modeOfTransport: modeOfTransport ?? this.modeOfTransport,
      transportDetails: transportDetails ?? this.transportDetails,
      roles: roles ?? this.roles,
      studentDetails: studentDetails ?? this.studentDetails,
      teacherDetails: teacherDetails ?? this.teacherDetails,
      directorDetails: directorDetails ?? this.directorDetails,
      adminDetails: adminDetails ?? this.adminDetails,
      securityGuardDetails: securityGuardDetails ?? this.securityGuardDetails,
      maintenanceStaffDetails:
          maintenanceStaffDetails ?? this.maintenanceStaffDetails,
      driverDetails: driverDetails ?? this.driverDetails,
      schoolAdminDetails: schoolAdminDetails ?? this.schoolAdminDetails,
      departmentHeadDetails:
          departmentHeadDetails ?? this.departmentHeadDetails,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      fatherDetails: fatherDetails ?? this.fatherDetails,
      motherDetails: motherDetails ?? this.motherDetails,
      favorites: favorites ?? this.favorites,
      userAttendance: userAttendance ?? this.userAttendance,
      createdAt: createdAt ?? this.createdAt,
      qualifications: qualifications ?? this.qualifications,
      joiningDate: joiningDate ?? this.joiningDate,
      schoolId: schoolId ?? this.schoolId, //Adding schoolId in copyWith
    );
  }

  String getHeightInFeetInches() {
    if (height == null) {
      return 'N/A';
    }

    double heightInInches = height! / 2.54;
    int feet = (heightInInches / 12).floor();
    double remainingInches = heightInInches % 12;

    return '$feet ft ${remainingInches.toStringAsFixed(1)} in';
  }

  int? getAge() {
    if (dob == null) {
      return null;
    }
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dob!.year;

    if (currentDate.month < dob!.month ||
        (currentDate.month == dob!.month && currentDate.day < dob!.day)) {
      age--;
    }

    return age;
  }
}

// Student Details
class StudentDetails {
  final String? studentId;
  final String? rollNumber;
  final String? admissionNo;
  final String? className;
  final String? section;
  final String? house;
  final DateTime? admissionDate; // Changed to DateTime
  final String? previousSchoolName;
  final double? averageMarks;
  final String? ambition;
  final String? guardian;
  final GuardianDetails? guardianDetails;
  final DocumentDetails? birthCertificate;
  final DocumentDetails? aadhaarCard;
  final DocumentDetails? transferCertificate;
  final DocumentDetails? passportSizedPhotograph;

  StudentDetails({
    this.studentId,
    this.rollNumber,
    this.className,
    this.section,
    this.house,
    this.admissionDate,
    this.previousSchoolName,
    this.guardian,
    this.guardianDetails,
    this.birthCertificate,
    this.aadhaarCard,
    this.transferCertificate,
    this.passportSizedPhotograph,
    this.admissionNo,
    this.averageMarks,
    this.ambition,
  });

  Map<String, dynamic> toMap() => {
        'studentId': studentId,
        'rollNumber': rollNumber,
        'admissionNo': admissionNo,
        'className': className,
        'section': section,
        'house': house,
        'admissionDate': admissionDate?.toIso8601String(), // Convert to String
        'previousSchoolName': previousSchoolName,
        'averageMarks': averageMarks,
        'ambition': ambition,
        'guardian': guardian,
        'guardianDetails': guardianDetails?.toMap(),
        'birthCertificate': birthCertificate?.toMap(),
        'aadhaarCard': aadhaarCard?.toMap(),
        'transferCertificate': transferCertificate?.toMap(),
        'passportSizedPhotograph': passportSizedPhotograph?.toMap(),
      };

  static StudentDetails? fromMap(Map<String, dynamic> data) {
    try {
      return StudentDetails(
        studentId: data['studentId'] as String?,
        rollNumber: data['rollNumber'] as String?,
        admissionNo: data['admissionNo'] as String?,
        className: data['className'] as String?,
        section: data['section'] as String?,
        house: data['house'] as String?,
        admissionDate: data['admissionDate'] != null
            ? DateTime.tryParse(
                data['admissionDate'] as String) // Convert to DateTime
            : null,
        previousSchoolName: data['previousSchoolName'] as String?,
        averageMarks: (data['averageMarks'] as num?)?.toDouble(),
        ambition: data['ambition'] as String?,
        guardian: data['guardian'] as String?,
        guardianDetails: data['guardianDetails'] != null
            ? GuardianDetails.fromMap(
                data['guardianDetails'] as Map<String, dynamic>)
            : null,
        birthCertificate: data['birthCertificate'] != null
            ? DocumentDetails.fromMap(
                data['birthCertificate'] as Map<String, dynamic>)
            : null,
        aadhaarCard: data['aadhaarCard'] != null
            ? DocumentDetails.fromMap(
                data['aadhaarCard'] as Map<String, dynamic>)
            : null,
        transferCertificate: data['transferCertificate'] != null
            ? DocumentDetails.fromMap(
                data['transferCertificate'] as Map<String, dynamic>)
            : null,
        passportSizedPhotograph: data['passportSizedPhotograph'] != null
            ? DocumentDetails.fromMap(
                data['passportSizedPhotograph'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      print('Error creating StudentDetails from map: $e');
      return null;
    }
  }
}

// Teacher Details
class TeacherDetails {
  final String? teacherId;
  final List<String>? subjectsTaught;
  final String? experience;

  TeacherDetails({
    this.teacherId,
    this.subjectsTaught,
    this.experience,
  });

  Map<String, dynamic> toMap() => {
        'teacherId': teacherId,
        'subjectsTaught': subjectsTaught,
        'experience': experience,
      };

  static TeacherDetails? fromMap(Map<String, dynamic> data) {
    try {
      return TeacherDetails(
        teacherId: data['teacherId'] as String?,
        subjectsTaught: (data['subjectsTaught'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        experience: data['experience'] as String?,
      );
    } catch (e) {
      print("Error creating TeacherDetails from map: $e");
      return null;
    }
  }
}

// Security Guard Details
class SecurityGuardDetails {
  final String? assignedArea;

  SecurityGuardDetails({
    this.assignedArea,
  });

  Map<String, dynamic> toMap() {
    return {
      'assignedArea': assignedArea,
    };
  }

  static SecurityGuardDetails? fromMap(Map<String, dynamic> map) {
    try {
      return SecurityGuardDetails(
        assignedArea: map['assignedArea'] as String?,
      );
    } catch (e) {
      print('Error creating SecurityGuardDetails from map: $e');
      return null;
    }
  }
}

// Maintenance Staff Details
class MaintenanceStaffDetails {
  final List<String>? responsibilities;

  MaintenanceStaffDetails({
    this.responsibilities,
  });

  Map<String, dynamic> toMap() {
    return {
      'responsibilities': responsibilities,
    };
  }

  static MaintenanceStaffDetails? fromMap(Map<String, dynamic> map) {
    try {
      return MaintenanceStaffDetails(
        responsibilities:
            (map['responsibilities'] as List<dynamic>?)?.cast<String>(),
      );
    } catch (e) {
      print('Error creating MaintenanceStaffDetails from map: $e');
      return null;
    }
  }
}

// Driver Details
class DriverDetails {
  final String? licenseNumber;
  final List<String>? routesAssigned;

  DriverDetails({
    this.licenseNumber,
    this.routesAssigned,
  });

  Map<String, dynamic> toMap() {
    return {
      'licenseNumber': licenseNumber,
      'routesAssigned': routesAssigned,
    };
  }

  static DriverDetails? fromMap(Map<String, dynamic> map) {
    try {
      return DriverDetails(
        licenseNumber: map['licenseNumber'] as String?,
        routesAssigned:
            (map['routesAssigned'] as List<dynamic>?)?.cast<String>(),
      );
    } catch (e) {
      print('Error creating DriverDetails from map: $e');
      return null;
    }
  }
}

// Admin Details
class AdminDetails {
  final List<String>? permissions;
  final List<String>? assignedModules;
  final List<String>? manageableSchools;

  AdminDetails({
    this.permissions,
    this.assignedModules,
    this.manageableSchools,
  });

  Map<String, dynamic> toMap() {
    return {
      'permissions': permissions,
      'assignedModules': assignedModules,
      'manageableSchools': manageableSchools,
    };
  }

  static AdminDetails? fromMap(Map<String, dynamic> map) {
    try {
      return AdminDetails(
        permissions: (map['permissions'] as List<dynamic>?)?.cast<String>(),
        assignedModules:
            (map['assignedModules'] as List<dynamic>?)?.cast<String>(),
        manageableSchools:
            (map['manageableSchools'] as List<dynamic>?)?.cast<String>(),
      );
    } catch (e) {
      print('Error creating AdminDetails from map: $e');
      return null;
    }
  }
}

// School Admin Details
class SchoolAdminDetails {
  final List<String>? permissions;
  final List<String>? assignedModules;

  SchoolAdminDetails({
    this.permissions,
    this.assignedModules,
  });

  Map<String, dynamic> toMap() {
    return {
      'permissions': permissions,
      'assignedModules': assignedModules,
    };
  }

  static SchoolAdminDetails? fromMap(Map<String, dynamic> map) {
    try {
      return SchoolAdminDetails(
        permissions: (map['permissions'] as List<dynamic>?)?.cast<String>(),
        assignedModules:
            (map['assignedModules'] as List<dynamic>?)?.cast<String>(),
      );
    } catch (e) {
      print('Error creating SchoolAdminDetails from map: $e');
      return null;
    }
  }
}

// Director Details
class DirectorDetails {
  final List<String>? schools;
  final int? yearsInManagement;
  final List<String>? permissions;

  DirectorDetails({
    this.schools,
    this.yearsInManagement,
    this.permissions,
  });

  Map<String, dynamic> toMap() {
    return {
      'schools': schools,
      'yearsInManagement': yearsInManagement,
      'permissions': permissions,
    };
  }

  static DirectorDetails? fromMap(Map<String, dynamic> map) {
    try {
      return DirectorDetails(
        schools: (map['schools'] as List<dynamic>?)?.cast<String>(),
        yearsInManagement: map['yearsInManagement'] as int?,
        permissions: (map['permissions'] as List<dynamic>?)?.cast<String>(),
      );
    } catch (e) {
      print('Error creating DirectorDetails from map: $e');
      return null;
    }
  }
}

// Department Head Details
class DepartmentHeadDetails {
  final String? department;
  final int? yearsAsHead;
  final List<String>? responsibilities;

  DepartmentHeadDetails({
    this.department,
    this.yearsAsHead,
    this.responsibilities,
  });

  Map<String, dynamic> toMap() {
    return {
      'department': department,
      'yearsAsHead': yearsAsHead,
      'responsibilities': responsibilities,
    };
  }

  static DepartmentHeadDetails? fromMap(Map<String, dynamic> map) {
    try {
      return DepartmentHeadDetails(
        department: map['department'] as String?,
        yearsAsHead: map['yearsAsHead'] as int?,
        responsibilities:
            (map['responsibilities'] as List<dynamic>?)?.cast<String>(),
      );
    } catch (e) {
      print('Error creating DepartmentHeadDetails from map: $e');
      return null;
    }
  }
}

enum UserRole {
  superAdmin,
  schoolAdmin,
  admin,
  principal,
  vicePrincipal,
  departmentHead,
  director,
  schoolSecretary,
  teacher,
  sportsCoach,
  musicInstructor,
  danceInstructor,
  specialEducationTeacher,
  guidanceCounselor,
  librarian,
  schoolNurse,
  itSupport,
  maintenanceStaff,
  driver,
  securityGuard,
  student,
  parentGuardian,
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.schoolAdmin:
        return 'School Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.principal:
        return 'Principal';
      case UserRole.vicePrincipal:
        return 'Vice Principal';
      case UserRole.departmentHead:
        return 'Department Head';
      case UserRole.director:
        return 'Director';
      case UserRole.schoolSecretary:
        return 'School Secretary';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.sportsCoach:
        return 'Sports Coach';
      case UserRole.musicInstructor:
        return 'Music Instructor';
      case UserRole.danceInstructor:
        return 'Dance Instructor';
      case UserRole.specialEducationTeacher:
        return 'Special Education Teacher';
      case UserRole.guidanceCounselor:
        return 'Guidance Counselor';
      case UserRole.librarian:
        return 'Librarian';
      case UserRole.schoolNurse:
        return 'School Nurse';
      case UserRole.itSupport:
        return 'IT Support';
      case UserRole.maintenanceStaff:
        return 'Maintenance Staff';
      case UserRole.driver:
        return 'Driver';
      case UserRole.securityGuard:
        return 'Security Guard';
      case UserRole.student:
        return 'Student';
      case UserRole.parentGuardian:
        return 'Parent Guardian';
      // Removed CleaningStaff and added maintenanceStaff instead
      default:
        return toString(); // Fallback for any unknown roles
    }
  }

  String get category {
    switch (this) {
      case UserRole.superAdmin:
      case UserRole.schoolAdmin:
      case UserRole.admin:
      case UserRole.principal:
      case UserRole.vicePrincipal:
      case UserRole.departmentHead:
      case UserRole.director:
      case UserRole.schoolSecretary:
        return 'Administrative';

      case UserRole.teacher:
      case UserRole.sportsCoach:
      case UserRole.musicInstructor:
      case UserRole.danceInstructor:
      case UserRole.specialEducationTeacher:
        return 'Teaching';

      case UserRole.guidanceCounselor:
      case UserRole.librarian:
      case UserRole.schoolNurse:
      case UserRole.itSupport:
      case UserRole.maintenanceStaff:
      case UserRole.driver:
      case UserRole.securityGuard:
        return 'Support';

      case UserRole.student:
      case UserRole.parentGuardian:
        return 'User';

      default:
        return 'Unknown';
    }
  }
}

// === Utility Classes ===

class Favorite {
  final String? dish;
  final String? subject;
  final String? teacher;
  final String? book;
  final String? sport;
  final String? athlete;
  final String? movie;
  final String? cuisine;
  final String? singer;
  final String? favoritePlaceToVisit;
  final String? festival;
  final String? personality;
  final String? season;
  final String? animal;
  final String? quote;

  Favorite({
    this.dish,
    this.subject,
    this.teacher,
    this.book,
    this.sport,
    this.athlete,
    this.movie,
    this.cuisine,
    this.singer,
    this.favoritePlaceToVisit,
    this.festival,
    this.personality,
    this.season,
    this.animal,
    this.quote,
  });

  Map<String, dynamic> toMap() {
    return {
      'dish': dish,
      'subject': subject,
      'teacher': teacher,
      'book': book,
      'sport': sport,
      'athlete': athlete,
      'movie': movie,
      'cuisine': cuisine,
      'singer': singer,
      'favoritePlaceToVisit': favoritePlaceToVisit,
      'festival': festival,
      'personality': personality,
      'season': season,
      'animal': animal,
      'quote': quote,
    };
  }

  static Favorite? fromMap(Map<String, dynamic> data) {
    try {
      return Favorite(
        dish: data['dish'] as String?,
        subject: data['subject'] as String?,
        teacher: data['teacher'] as String?,
        book: data['book'] as String?,
        sport: data['sport'] as String?,
        athlete: data['athlete'] as String?,
        movie: data['movie'] as String?,
        cuisine: data['cuisine'] as String?,
        singer: data['singer'] as String?,
        favoritePlaceToVisit: data['favoritePlaceToVisit'] as String?,
        festival: data['festival'] as String?,
        personality: data['personality'] as String?,
        season: data['season'] as String?,
        animal: data['animal'] as String?,
        quote: data['quote'] as String?,
      );
    } catch (e) {
      print("Error creating Favorite from map: $e");
      return null;
    }
  }
}

// Address Class
class Address {
  final String? houseAddress;
  final String? city;
  final String? district;
  final String? state;
  final String? village;
  final String? pinCode;
  final String? addressType;

  Address({
    this.houseAddress,
    this.city,
    this.district,
    this.state,
    this.village,
    this.pinCode,
    this.addressType = "other",
  });

  Map<String, dynamic> toMap() => {
        'houseAddress': houseAddress,
        'city': city,
        'district': district,
        'state': state,
        'village': village,
        'pinCode': pinCode,
        'addressType': addressType,
      };

  static Address fromMap(Map<String, dynamic> data) => Address(
        houseAddress: data['houseAddress'] as String?,
        city: data['city'] as String?,
        district: data['district'] as String?,
        state: data['state'] as String?,
        village: data['village'] as String?,
        pinCode: data['pinCode'] as String?,
        addressType: data['addressType'] as String? ?? "other",
      );
}

// Guardian Class
class GuardianDetails {
  final String? fullName;
  final String? relationshipToStudent;
  final String? occupation;
  final String? phoneNumber;
  final String? emailAddress;
  final String? highestEducationLevel;
  final String? annualIncome;

  GuardianDetails({
    this.fullName,
    this.relationshipToStudent,
    this.occupation,
    this.phoneNumber,
    this.emailAddress,
    this.highestEducationLevel,
    this.annualIncome,
  });

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'relationshipToStudent': relationshipToStudent,
        'occupation': occupation,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'highestEducationLevel': highestEducationLevel,
        'annualIncome': annualIncome,
      };

  static GuardianDetails fromMap(Map<String, dynamic> data) => GuardianDetails(
        fullName: data['fullName'] as String?,
        relationshipToStudent: data['relationshipToStudent'] as String?,
        occupation: data['occupation'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        emailAddress: data['emailAddress'] as String?,
        highestEducationLevel: data['highestEducationLevel'] as String?,
        annualIncome: data['annualIncome'] as String?,
      );
}

// Emergency Contact Class
class EmergencyContact {
  final String? fullName;
  final String? relationship;
  final String? phoneNumber;
  final String? emailAddress;

  EmergencyContact({
    this.fullName,
    this.relationship,
    this.phoneNumber,
    this.emailAddress,
  });

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'relationship': relationship,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
      };

  factory EmergencyContact.fromMap(Map<String, dynamic> data) =>
      EmergencyContact(
        fullName: data['fullName'] as String?,
        relationship: data['relationship'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        emailAddress: data['emailAddress'] as String?,
      );
}

// Transport Details Class
class TransportDetails {
  final String? routeNumber;
  final String? pickupPoint;
  final String? dropOffPoint;
  final String? vehicleNumber;
  final double? fare;

  TransportDetails({
    this.routeNumber,
    this.pickupPoint,
    this.dropOffPoint,
    this.vehicleNumber,
    this.fare,
  });

  Map<String, dynamic> toMap() => {
        'routeNumber': routeNumber,
        'pickupPoint': pickupPoint,
        'dropOffPoint': dropOffPoint,
        'vehicleNumber': vehicleNumber,
        'fare': fare,
      };

  static TransportDetails fromMap(Map<String, dynamic> data) =>
      TransportDetails(
        routeNumber: data['routeNumber'] as String?,
        pickupPoint: data['pickupPoint'] as String?,
        dropOffPoint: data['dropOffPoint'] as String?,
        vehicleNumber: data['vehicleNumber'] as String?,
        fare: (data['fare'] as num?)?.toDouble(),
      );
}

// Qualification Class
class Qualification {
  final String? degreeName;
  final String? institutionName;
  final String? passingYear;
  final String? majorSubject;
  final String? resultType;
  final String? result;

  Qualification({
    this.degreeName,
    this.institutionName,
    this.passingYear,
    this.majorSubject,
    this.resultType,
    this.result,
  }) : assert(isValidQualification(resultType: resultType, result: result),
            "If resultType is specified, then result must also be provided.");

  static bool isValidQualification({String? resultType, String? result}) {
    if (resultType == null && result == null) {
      return true;
    }

    if (resultType != null && result != null) {
      return true;
    }

    return false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'degreeName': degreeName,
      'institutionName': institutionName,
      'passingYear': passingYear,
      'majorSubject': majorSubject,
      'resultType': resultType,
      'result': result,
    };
  }

  static Qualification? fromMap(Map<String, dynamic> data) {
    final resultType = data['resultType'] as String?;
    final result = data['result'] as String?;

    if (!isValidQualification(resultType: resultType, result: result)) {
      print("Invalid Qualification data found.  Skipping.");
      return null;
    }

    return Qualification(
      degreeName: data['degreeName'] as String?,
      institutionName: data['institutionName'] as String?,
      passingYear: data['passingYear'] as String?,
      majorSubject: data['majorSubject'] as String?,
      resultType: resultType,
      result: result,
    );
  }

  bool get isValid =>
      isValidQualification(resultType: resultType, result: result);
}

// DocumentDetails Class
class DocumentDetails {
  final String? documentName;
  final String? documentUrl;
  final DateTime? uploadDate;

  DocumentDetails({this.documentName, this.documentUrl, this.uploadDate});

  Map<String, dynamic> toMap() => {
        'documentName': documentName,
        'documentUrl': documentUrl,
        'uploadDate': uploadDate?.toIso8601String(),
      };

  static DocumentDetails fromMap(Map<String, dynamic> data) => DocumentDetails(
        documentName: data['documentName'] as String?,
        documentUrl: data['documentUrl'] as String?,
        uploadDate: data['uploadDate'] != null
            ? DateTime.tryParse(data['uploadDate'] as String)
            : null,
      );
}

// Certificate Class
class Certificate {
  final String? name;
  final String? issuedBy;
  final DateTime? issueDate;
  final String? certificateUrl;
  final String? description;

  Certificate({
    this.name,
    this.issuedBy,
    this.issueDate,
    this.certificateUrl,
    this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'issuedBy': issuedBy,
        'issueDate': issueDate?.toIso8601String(),
        'certificateUrl': certificateUrl,
        'description': description,
      };

  static Certificate fromMap(Map<String, dynamic> data) => Certificate(
        name: data['name'] as String?,
        issuedBy: data['issuedBy'] as String?,
        issueDate: data['issueDate'] != null
            ? DateTime.tryParse(data['issueDate'] as String)
            : null,
        certificateUrl: data['certificateUrl'] as String?,
        description: data['description'] as String?,
      );
}

// Award Class
class Award {
  String? name;
  String? awardedBy;
  DateTime? date;
  String? description;

  Award({
    this.name,
    this.awardedBy,
    this.date,
    this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'awardedBy': awardedBy,
        'date': date?.toIso8601String(),
        'description': description,
      };

  factory Award.fromMap(Map<String, dynamic> data) => Award(
        name: data['name'] as String?,
        awardedBy: data['awardedBy'] as String?,
        date: data['date'] != null
            ? DateTime.tryParse(data['date'] as String)
            : null,
        description: data['description'] as String?,
      );
}

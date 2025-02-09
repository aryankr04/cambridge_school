import 'package:cambridge_school/modules/auth/register/models/salary_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../fees/models/fee_details.dart';
import '../../../fees/models/fee_payment_model.dart';

class UserModel {
// 1. Identification and Personal Information
  final String id;
  final String schoolId;
  final String name;
  final DateTime dob;
  final String gender;

// Demographics
  final String nationality;
  final String religion;
  final String category;
  final String aadhaarNo;
  final String aadhaarCardImageUrl;

// Physical Attributes
  final double height;
  final String weight;

// Health Details
  final String bloodGroup;
  final String visionCondition;
  final String medicalCondition;
  final bool isPhysicalDisability;

// Profile Information
  final String? maritalStatus;
  final String profileDescription;

// 2. Contact Information
  final String address;
  final String pinCode;
  final String email;
  final String phoneNumber;
  final String emergencyContact;

// 3. Employment Details
  final DateTime? dateOfJoining;
  final bool isActive;
  final String accountStatus;
  final String modeOfTransport;
  final String vehicleNo;

// 4. Educational and Professional Background
  final String? educationalQualification;
  final String? universityOrCollege;
  final int? experience;
  final List<String>? certifications;

// 5. Account and Authentication
  final String username;
  final String password;
  final DateTime lastLogin;
  final DateTime createdAt;

// 6. Social Metrics
  final List<String> following;
  final List<String> followers;
  final int posts;

// 7. Languages
  final List<String> languagesSpoken;

// 8. Profile Picture
  final String profilePictureUrl;

// 9. Attendance Tracking
  final int presentDays;
  final int absentDays;

// 10. Performance Metrics
  final double performanceRating;
  final int points;

// 11. Role(s) in the School
  final List<String> roles;

// 12. Role-specific details (Optional)
  final StudentDetails? studentDetails;
  final PrincipalDetails? principalDetails;
  final VicePrincipalDetails? vicePrincipalDetails;
  final TeacherDetails? teacherDetails;
  final DepartmentHeadDetails? departmentHeadDetails;
  final GuidanceCounselorDetails? guidanceCounselorDetails;
  final SchoolAdministratorDetails? schoolAdministratorDetails;
  final LibrarianDetails? librarianDetails;
  final SchoolNurseDetails? schoolNurseDetails;
  final SportsCoachDetails? sportsCoachDetails;
  final SpecialEducationTeacherDetails? specialEducationTeacherDetails;
  final ITSupportDetails? itSupportDetails;
  final SchoolSecretaryDetails? schoolSecretaryDetails;
  final DirectorDetails? directorDetails;
  final MaintenanceStaffDetails? maintenanceStaffDetails;
  final DriverDetails? driverDetails;
  final SecurityGuardDetails? securityGuardDetails;

// 13. Additional Details
  final String state;
  final String district;
  final String city;
  final String houseOrTeam;

// Favorites
  final String favSubject;
  final String favTeacher;
  final String favSports;
  final String favFood;

// Hobbies and Goals
  final List<String> hobbies;
  final String goal;

// 14. Settings
  final bool isDarkMode;
  final bool isNotificationsEnabled;
  final String languagePreference;
  final SalaryDetails? salaryDetails;

// Constructor
  UserModel(
      {required this.id,
      required this.schoolId,
      required this.name,
      required this.dob,
      required this.gender,
      required this.nationality,
      required this.religion,
      required this.category,
      required this.aadhaarNo,
      required this.aadhaarCardImageUrl,
      required this.height,
      required this.weight,
      required this.bloodGroup,
      required this.visionCondition,
      required this.medicalCondition,
      required this.isPhysicalDisability,
      this.maritalStatus,
      required this.profileDescription,
      required this.address,
      required this.pinCode,
      required this.email,
      required this.phoneNumber,
      required this.emergencyContact,
      this.dateOfJoining,
      required this.isActive,
      required this.accountStatus,
      required this.modeOfTransport,
      required this.vehicleNo,
      this.educationalQualification,
      this.universityOrCollege,
      this.experience,
      this.certifications,
      required this.username,
      required this.password,
      required this.lastLogin,
      required this.createdAt,
      required this.following,
      required this.followers,
      required this.posts,
      required this.languagesSpoken,
      required this.profilePictureUrl,
      required this.presentDays,
      required this.absentDays,
      required this.performanceRating,
      required this.points,
      required this.roles,
      this.studentDetails,
      this.principalDetails,
      this.vicePrincipalDetails,
      this.teacherDetails,
      this.departmentHeadDetails,
      this.guidanceCounselorDetails,
      this.schoolAdministratorDetails,
      this.librarianDetails,
      this.schoolNurseDetails,
      this.sportsCoachDetails,
      this.specialEducationTeacherDetails,
      this.itSupportDetails,
      this.schoolSecretaryDetails,
      this.directorDetails,
      this.maintenanceStaffDetails,
      this.driverDetails,
      this.securityGuardDetails,
      required this.state,
      required this.district,
      required this.city,
      required this.houseOrTeam,
      required this.favSubject,
      required this.favTeacher,
      required this.favSports,
      required this.favFood,
      required this.hobbies,
      required this.goal,
      required this.isDarkMode,
      required this.isNotificationsEnabled,
      required this.languagePreference,
      this.salaryDetails});

// Convert a User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'nationality': nationality,
      'religion': religion,
      'category': category,
      'aadhaarNo': aadhaarNo,
      'aadhaarCardImageUrl': aadhaarCardImageUrl,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
      'visionCondition': visionCondition,
      'medicalCondition': medicalCondition,
      'isPhysicalDisability': isPhysicalDisability,
      'maritalStatus': maritalStatus,
      'profileDescription': profileDescription,
      'address': address,
      'pinCode': pinCode,
      'email': email,
      'phoneNumber': phoneNumber,
      'emergencyContact': emergencyContact,
      'dateOfJoining': dateOfJoining?.toIso8601String(),
      'isActive': isActive,
      'accountStatus': accountStatus,
      'modeOfTransport': modeOfTransport,
      'vehicleNo': vehicleNo,
      'educationalQualification': educationalQualification,
      'universityOrCollege': universityOrCollege,
      'experience': experience,
      'certifications': certifications,
      'username': username,
      'password': password,
      'lastLogin': lastLogin.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'following': following,
      'followers': followers,
      'posts': posts,
      'languagesSpoken': languagesSpoken,
      'profilePictureUrl': profilePictureUrl,
      'presentDays': presentDays,
      'absentDays': absentDays,
      'performanceRating': performanceRating,
      'points': points,
      'roles': roles,
      'state': state,
      'district': district,
      'city': city,
      'houseOrTeam': houseOrTeam,
      'favSubject': favSubject,
      'favTeacher': favTeacher,
      'favSports': favSports,
      'favFood': favFood,
      'hobbies': hobbies,
      'goal': goal,
      'isDarkMode': isDarkMode,
      'isNotificationsEnabled': isNotificationsEnabled,
      'languagePreference': languagePreference,
      'studentDetails': studentDetails?.toMap(),
      'principalDetails': principalDetails?.toMap(),
      'vicePrincipalDetails': vicePrincipalDetails?.toMap(),
      'teacherDetails': teacherDetails?.toMap(),
      'departmentHeadDetails': departmentHeadDetails?.toMap(),
      'guidanceCounselorDetails': guidanceCounselorDetails?.toMap(),
      'schoolAdministratorDetails': schoolAdministratorDetails?.toMap(),
      'librarianDetails': librarianDetails?.toMap(),
      'schoolNurseDetails': schoolNurseDetails?.toMap(),
      'sportsCoachDetails': sportsCoachDetails?.toMap(),
      'specialEducationTeacherDetails': specialEducationTeacherDetails?.toMap(),
      'itSupportDetails': itSupportDetails?.toMap(),
      'schoolSecretaryDetails': schoolSecretaryDetails?.toMap(),
      'directorDetails': directorDetails?.toMap(),
      'maintenanceStaffDetails': maintenanceStaffDetails?.toMap(),
      'driverDetails': driverDetails?.toMap(),
      'securityGuardDetails': securityGuardDetails?.toMap(),
      'salaryDetails': salaryDetails?.toMap(),
    };
  }

// Factory method to create a User from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      schoolId: map['schoolId'],
      name: map['name'],
      dob: map['dob'] is Timestamp
          ? (map['dob'] as Timestamp).toDate()
          : DateTime.parse(map['dob']),
      gender: map['gender'],
      nationality: map['nationality'],
      religion: map['religion'],
      category: map['category'],
      aadhaarNo: map['aadhaarNo'],
      aadhaarCardImageUrl: map['aadhaarCardImageUrl'],
      height: map['height'],
      weight: map['weight'],
      bloodGroup: map['bloodGroup'],
      visionCondition: map['visionCondition'],
      medicalCondition: map['medicalCondition'],
      isPhysicalDisability: map['isPhysicalDisability'],
      maritalStatus: map['maritalStatus'],
      profileDescription: map['profileDescription'],
      address: map['address'],
      pinCode: map['pinCode'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      emergencyContact: map['emergencyContact'],
      dateOfJoining: map['dateOfJoining'] != null
          ? (map['dateOfJoining'] is Timestamp
              ? (map['dateOfJoining'] as Timestamp).toDate()
              : DateTime.tryParse(map['dateOfJoining']))
          : null,
      isActive: map['isActive'],
      accountStatus: map['accountStatus'],
      modeOfTransport: map['modeOfTransport'],
      vehicleNo: map['vehicleNo'],
      educationalQualification: map['educationalQualification'],
      universityOrCollege: map['universityOrCollege'],
      experience: map['experience'],
      certifications: List<String>.from(map['certifications'] ?? []),
      username: map['username'],
      password: map['password'],
      lastLogin: map['lastLogin'] is Timestamp
          ? (map['lastLogin'] as Timestamp).toDate()
          : DateTime.parse(map['lastLogin']),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      following: List<String>.from(map['following']),
      followers: List<String>.from(map['followers']),
      posts: map['posts'] ?? 0,
      languagesSpoken: List<String>.from(map['languagesSpoken'] ?? []),
      profilePictureUrl: map['profilePictureUrl'],
      presentDays: map['presentDays'],
      absentDays: map['absentDays'],
      performanceRating: map['performanceRating']?.toDouble() ?? 0.0,
      points: map['points'],
      roles: List<String>.from(map['roles']),
      state: map['state'],
      district: map['district'],
      city: map['city'],
      houseOrTeam: map['houseOrTeam'],
      favSubject: map['favSubject'],
      favTeacher: map['favTeacher'],
      favSports: map['favSports'],
      favFood: map['favFood'],
      hobbies: List<String>.from(map['hobbies']),
      goal: map['goal'],
      isDarkMode: map['isDarkMode'] ?? false,
      isNotificationsEnabled: map['isNotificationsEnabled'] ?? false,
      languagePreference: map['languagePreference'] ?? 'en',
      studentDetails: map['studentDetails'] != null
          ? StudentDetails.fromMap(map['studentDetails'])
          : null,
      principalDetails: map['principalDetails'] != null
          ? PrincipalDetails.fromMap(map['principalDetails'])
          : null,
      vicePrincipalDetails: map['vicePrincipalDetails'] != null
          ? VicePrincipalDetails.fromMap(map['vicePrincipalDetails'])
          : null,
      teacherDetails: map['teacherDetails'] != null
          ? TeacherDetails.fromMap(map['teacherDetails'])
          : null,
      departmentHeadDetails: map['departmentHeadDetails'] != null
          ? DepartmentHeadDetails.fromMap(map['departmentHeadDetails'])
          : null,
      guidanceCounselorDetails: map['guidanceCounselorDetails'] != null
          ? GuidanceCounselorDetails.fromMap(map['guidanceCounselorDetails'])
          : null,
      schoolAdministratorDetails: map['schoolAdministratorDetails'] != null
          ? SchoolAdministratorDetails.fromMap(
              map['schoolAdministratorDetails'])
          : null,
      librarianDetails: map['librarianDetails'] != null
          ? LibrarianDetails.fromMap(map['librarianDetails'])
          : null,
      schoolNurseDetails: map['schoolNurseDetails'] != null
          ? SchoolNurseDetails.fromMap(map['schoolNurseDetails'])
          : null,
      sportsCoachDetails: map['sportsCoachDetails'] != null
          ? SportsCoachDetails.fromMap(map['sportsCoachDetails'])
          : null,
      specialEducationTeacherDetails:
          map['specialEducationTeacherDetails'] != null
              ? SpecialEducationTeacherDetails.fromMap(
                  map['specialEducationTeacherDetails'])
              : null,
      itSupportDetails: map['itSupportDetails'] != null
          ? ITSupportDetails.fromMap(map['itSupportDetails'])
          : null,
      schoolSecretaryDetails: map['schoolSecretaryDetails'] != null
          ? SchoolSecretaryDetails.fromMap(map['schoolSecretaryDetails'])
          : null,
      directorDetails: map['directorDetails'] != null
          ? DirectorDetails.fromMap(map['directorDetails'])
          : null,
      maintenanceStaffDetails: map['maintenanceStaffDetails'] != null
          ? MaintenanceStaffDetails.fromMap(map['maintenanceStaffDetails'])
          : null,
      driverDetails: map['driverDetails'] != null
          ? DriverDetails.fromMap(map['driverDetails'])
          : null,
      securityGuardDetails: map['securityGuardDetails'] != null
          ? SecurityGuardDetails.fromMap(map['securityGuardDetails'])
          : null,
      salaryDetails: map['salaryDetails'] != null
          ? SalaryDetails.fromMap(map['salaryDetails'])
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? schoolId,
    String? name,
    DateTime? dob,
    String? gender,
    String? nationality,
    String? religion,
    String? category,
    String? aadhaarNo,
    String? aadhaarCardImageUrl,
    double? height,
    String? weight,
    String? bloodGroup,
    String? visionCondition,
    String? medicalCondition,
    bool? isPhysicalDisability,
    String? profileDescription,
    String? address,
    String? pinCode,
    String? email,
    String? phoneNumber,
    String? emergencyContact,
    DateTime? dateOfJoining,
    bool? isActive,
    String? accountStatus,
    String? modeOfTransport,
    String? vehicleNo,
    String? educationalQualification,
    String? universityOrCollege,
    int? experience,
    List<String>? certifications,
    String? username,
    String? password,
    DateTime? lastLogin,
    DateTime? createdAt,
    List<String>? following,
    List<String>? followers,
    int? posts,
    List<String>? languagesSpoken,
    String? profilePictureUrl,
    int? presentDays,
    int? absentDays,
    double? performanceRating,
    int? points,
    List<String>? roles,
    String? state,
    String? district,
    String? city,
    String? houseOrTeam,
    String? favSubject,
    String? favTeacher,
    String? favSports,
    String? favFood,
    List<String>? hobbies,
    String? goal,
    bool? isDarkMode,
    bool? isNotificationsEnabled,
    String? languagePreference,
    StudentDetails? studentDetails,
    PrincipalDetails? principalDetails,
    VicePrincipalDetails? vicePrincipalDetails,
    TeacherDetails? teacherDetails,
    DepartmentHeadDetails? departmentHeadDetails,
    GuidanceCounselorDetails? guidanceCounselorDetails,
    SchoolAdministratorDetails? schoolAdministratorDetails,
    LibrarianDetails? librarianDetails,
    SchoolNurseDetails? schoolNurseDetails,
    SportsCoachDetails? sportsCoachDetails,
    SpecialEducationTeacherDetails? specialEducationTeacherDetails,
    ITSupportDetails? itSupportDetails,
    SchoolSecretaryDetails? schoolSecretaryDetails,
    DirectorDetails? directorDetails,
    MaintenanceStaffDetails? maintenanceStaffDetails,
    DriverDetails? driverDetails,
    SecurityGuardDetails? securityGuardDetails,
    SalaryDetails? salaryDetails,
  }) {
    return UserModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      religion: religion ?? this.religion,
      category: category ?? this.category,
      aadhaarNo: aadhaarNo ?? this.aadhaarNo,
      aadhaarCardImageUrl: aadhaarCardImageUrl ?? this.aadhaarCardImageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      visionCondition: visionCondition ?? this.visionCondition,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      isPhysicalDisability: isPhysicalDisability ?? this.isPhysicalDisability,
      profileDescription: profileDescription ?? this.profileDescription,
      address: address ?? this.address,
      pinCode: pinCode ?? this.pinCode,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      isActive: isActive ?? this.isActive,
      accountStatus: accountStatus ?? this.accountStatus,
      modeOfTransport: modeOfTransport ?? this.modeOfTransport,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      educationalQualification:
          educationalQualification ?? this.educationalQualification,
      universityOrCollege: universityOrCollege ?? this.universityOrCollege,
      experience: experience ?? this.experience,
      certifications: certifications ?? this.certifications,
      username: username ?? this.username,
      password: password ?? this.password,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      posts: posts ?? this.posts,
      languagesSpoken: languagesSpoken ?? this.languagesSpoken,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      presentDays: presentDays ?? this.presentDays,
      absentDays: absentDays ?? this.absentDays,
      performanceRating: performanceRating ?? this.performanceRating,
      points: points ?? this.points,
      roles: roles ?? this.roles,
      state: state ?? this.state,
      district: district ?? this.district,
      city: city ?? this.city,
      houseOrTeam: houseOrTeam ?? this.houseOrTeam,
      favSubject: favSubject ?? this.favSubject,
      favTeacher: favTeacher ?? this.favTeacher,
      favSports: favSports ?? this.favSports,
      favFood: favFood ?? this.favFood,
      hobbies: hobbies ?? this.hobbies,
      goal: goal ?? this.goal,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      studentDetails: studentDetails ?? this.studentDetails,
      principalDetails: principalDetails ?? this.principalDetails,
      vicePrincipalDetails: vicePrincipalDetails ?? this.vicePrincipalDetails,
      teacherDetails: teacherDetails ?? this.teacherDetails,
      departmentHeadDetails:
          departmentHeadDetails ?? this.departmentHeadDetails,
      guidanceCounselorDetails:
          guidanceCounselorDetails ?? this.guidanceCounselorDetails,
      schoolAdministratorDetails:
          schoolAdministratorDetails ?? this.schoolAdministratorDetails,
      librarianDetails: librarianDetails ?? this.librarianDetails,
      schoolNurseDetails: schoolNurseDetails ?? this.schoolNurseDetails,
      sportsCoachDetails: sportsCoachDetails ?? this.sportsCoachDetails,
      specialEducationTeacherDetails:
          specialEducationTeacherDetails ?? this.specialEducationTeacherDetails,
      itSupportDetails: itSupportDetails ?? this.itSupportDetails,
      schoolSecretaryDetails:
          schoolSecretaryDetails ?? this.schoolSecretaryDetails,
      directorDetails: directorDetails ?? this.directorDetails,
      maintenanceStaffDetails:
          maintenanceStaffDetails ?? this.maintenanceStaffDetails,
      driverDetails: driverDetails ?? this.driverDetails,
      securityGuardDetails: securityGuardDetails ?? this.securityGuardDetails,
      salaryDetails: salaryDetails ?? this.salaryDetails,
      languagePreference: languagePreference??this.languagePreference,
    );
  }
}

class StudentDetails {
// Admission Information
  final DateTime admissionDate;
  final String admissionNo;
  final String className;
  final String sectionName;
  final String rollNo;

// Documents
  final String birthCertificateImageUrl;
  final String transferCertificateImageUrl;
  final String aadhaarCardImageUrl;

// Parent Information
  final String fatherName;
  final String fatherMobileNo;
  final String fatherOccupation;
  final String motherName;
  final String motherMobileNo;
  final String motherOccupation;

// Performance Metrics
  final List<FeeDetail> feeDetails;
  final List<FeePayment> feePayments;
  final int classRank;
  final int schoolRank;
  final int allIndiaRank;

// Constructor
  StudentDetails({
    required this.admissionDate,
    required this.admissionNo,
    required this.className,
    required this.sectionName,
    required this.rollNo,
    required this.birthCertificateImageUrl,
    required this.transferCertificateImageUrl,
    required this.aadhaarCardImageUrl,
    required this.fatherName,
    required this.fatherMobileNo,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherMobileNo,
    required this.motherOccupation,
    required this.feeDetails,
    required this.feePayments,
    required this.classRank,
    required this.schoolRank,
    required this.allIndiaRank,
  });

// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'admissionDate': admissionDate.toIso8601String(),
      'admissionNo': admissionNo,
      'className': className,
      'sectionName': sectionName,
      'rollNo': rollNo,
      'birthCertificateImageUrl': birthCertificateImageUrl,
      'transferCertificateImageUrl': transferCertificateImageUrl,
      'aadhaarCardImageUrl': aadhaarCardImageUrl,
      'fatherName': fatherName,
      'fatherMobileNo': fatherMobileNo,
      'fatherOccupation': fatherOccupation,
      'motherName': motherName,
      'motherMobileNo': motherMobileNo,
      'motherOccupation': motherOccupation,
      'feeDetails': feeDetails
          .map((e) => e.toMap())
          .toList(), // Assuming FeeDetail has a toMap method
      'feePayments': feePayments
          .map((e) => e.toMap())
          .toList(), // Assuming FeePayment has a toMap method
      'classRank': classRank,
      'schoolRank': schoolRank,
      'allIndiaRank': allIndiaRank,
    };
  }

// Create from Map
  factory StudentDetails.fromMap(Map<String, dynamic> map) {
    return StudentDetails(
      admissionDate: map['admissionDate'] is Timestamp
          ? (map['admissionDate'] as Timestamp).toDate()
          : DateTime.parse(map['admissionDate']),
      admissionNo: map['admissionNo'] ?? '',
      className: map['className'] ?? '',
      sectionName: map['sectionName'] ?? '',
      rollNo: map['rollNo'] ?? '',
      birthCertificateImageUrl: map['birthCertificateImageUrl'] ?? '',
      transferCertificateImageUrl: map['transferCertificateImageUrl'] ?? '',
      aadhaarCardImageUrl: map['aadhaarCardImageUrl'] ?? '',
      fatherName: map['fatherName'] ?? '',
      fatherMobileNo: map['fatherMobileNo'] ?? '',
      fatherOccupation: map['fatherOccupation'] ?? '',
      motherName: map['motherName'] ?? '',
      motherMobileNo: map['motherMobileNo'] ?? '',
      motherOccupation: map['motherOccupation'] ?? '',
      feeDetails: map['feeDetails'] != null
          ? List<FeeDetail>.from(
              map['feeDetails'].map((x) => FeeDetail.fromMap(x)))
          : [], // Safely parse feeDetails list
      feePayments: map['feePayments'] != null
          ? List<FeePayment>.from(
              map['feePayments'].map((x) => FeePayment.fromMap(x)))
          : [], // Safely parse feePayments list
      classRank: map['classRank'] ?? 0,
      schoolRank: map['schoolRank'] ?? 0,
      allIndiaRank: map['allIndiaRank'] ?? 0,
    );
  }
}

class PrincipalDetails {
  final String leadershipTraining; // Specific training related to leadership

  PrincipalDetails({required this.leadershipTraining});

  Map<String, dynamic> toMap() {
    return {
      'leadershipTraining': leadershipTraining,
    };
  }

  factory PrincipalDetails.fromMap(Map<String, dynamic> map) {
    return PrincipalDetails(
      leadershipTraining: map['leadershipTraining'] ?? '',
    );
  }
}

class VicePrincipalDetails {
  final String areaOfExpertise; // Vice principal's specialization area

  VicePrincipalDetails({required this.areaOfExpertise});

  Map<String, dynamic> toMap() {
    return {
      'areaOfExpertise': areaOfExpertise,
    };
  }

  factory VicePrincipalDetails.fromMap(Map<String, dynamic> map) {
    return VicePrincipalDetails(
      areaOfExpertise: map['areaOfExpertise'] ?? '',
    );
  }
}

class TeacherDetails {
  final List<String> subjects; // Subjects taught by the teacher
  final String department; // e.g., Science, Mathematics

  TeacherDetails({
    required this.subjects,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjects': subjects,
      'department': department,
    };
  }

  factory TeacherDetails.fromMap(Map<String, dynamic> map) {
    return TeacherDetails(
      subjects: List<String>.from(map['subjects'] ?? []),
      department: map['department'] ?? '',
    );
  }
}

class DepartmentHeadDetails {
  final String department;
  final int yearsAsHead; // Years as department head

  DepartmentHeadDetails({
    required this.department,
    required this.yearsAsHead,
  });

  Map<String, dynamic> toMap() {
    return {
      'department': department,
      'yearsAsHead': yearsAsHead,
    };
  }

  factory DepartmentHeadDetails.fromMap(Map<String, dynamic> map) {
    return DepartmentHeadDetails(
      department: map['department'] ?? '',
      yearsAsHead: map['yearsAsHead'] ?? 0,
    );
  }
}

class GuidanceCounselorDetails {
  final List<String> areasOfSpecialization; // Counseling expertise areas
  final int numberOfCasesHandled; // Total cases handled by counselor

  GuidanceCounselorDetails({
    required this.areasOfSpecialization,
    required this.numberOfCasesHandled,
  });

  Map<String, dynamic> toMap() {
    return {
      'areasOfSpecialization': areasOfSpecialization,
      'numberOfCasesHandled': numberOfCasesHandled,
    };
  }

  factory GuidanceCounselorDetails.fromMap(Map<String, dynamic> map) {
    return GuidanceCounselorDetails(
      areasOfSpecialization:
          List<String>.from(map['areasOfSpecialization'] ?? []),
      numberOfCasesHandled: map['numberOfCasesHandled'] ?? 0,
    );
  }
}

class SchoolAdministratorDetails {
  final String departmentManaged; // Department overseen by the administrator

  SchoolAdministratorDetails({required this.departmentManaged});

  Map<String, dynamic> toMap() {
    return {
      'departmentManaged': departmentManaged,
    };
  }

  factory SchoolAdministratorDetails.fromMap(Map<String, dynamic> map) {
    return SchoolAdministratorDetails(
      departmentManaged: map['departmentManaged'] ?? '',
    );
  }
}

class LibrarianDetails {
  final List<String> genresSpecialized; // Genres or areas specialized in

  LibrarianDetails({required this.genresSpecialized});

  Map<String, dynamic> toMap() {
    return {
      'genresSpecialized': genresSpecialized,
    };
  }

  factory LibrarianDetails.fromMap(Map<String, dynamic> map) {
    return LibrarianDetails(
      genresSpecialized: List<String>.from(map['genresSpecialized'] ?? []),
    );
  }
}

class SchoolNurseDetails {
  final String medicalQualification; // Nurse's specific qualification

  SchoolNurseDetails({required this.medicalQualification});

  Map<String, dynamic> toMap() {
    return {
      'medicalQualification': medicalQualification,
    };
  }

  factory SchoolNurseDetails.fromMap(Map<String, dynamic> map) {
    return SchoolNurseDetails(
      medicalQualification: map['medicalQualification'] ?? '',
    );
  }
}

class SportsCoachDetails {
  final List<String> sportsCoached; // Sports coached by the individual

  SportsCoachDetails({required this.sportsCoached});

  Map<String, dynamic> toMap() {
    return {
      'sportsCoached': sportsCoached,
    };
  }

  factory SportsCoachDetails.fromMap(Map<String, dynamic> map) {
    return SportsCoachDetails(
      sportsCoached: List<String>.from(map['sportsCoached'] ?? []),
    );
  }
}

class SpecialEducationTeacherDetails {
  final String areaOfSpecialEducation; // Area of special education expertise
  final List<String>
      disabilitiesSupported; // Disabilities the teacher is trained to support

  SpecialEducationTeacherDetails({
    required this.areaOfSpecialEducation,
    required this.disabilitiesSupported,
  });

  Map<String, dynamic> toMap() {
    return {
      'areaOfSpecialEducation': areaOfSpecialEducation,
      'disabilitiesSupported': disabilitiesSupported,
    };
  }

  factory SpecialEducationTeacherDetails.fromMap(Map<String, dynamic> map) {
    return SpecialEducationTeacherDetails(
      areaOfSpecialEducation: map['areaOfSpecialEducation'] ?? '',
      disabilitiesSupported:
          List<String>.from(map['disabilitiesSupported'] ?? []),
    );
  }
}

class ITSupportDetails {
  final List<String> technicalSkills; // Skills specific to IT support

  ITSupportDetails({required this.technicalSkills});

  Map<String, dynamic> toMap() {
    return {
      'technicalSkills': technicalSkills,
    };
  }

  factory ITSupportDetails.fromMap(Map<String, dynamic> map) {
    return ITSupportDetails(
      technicalSkills: List<String>.from(map['technicalSkills'] ?? []),
    );
  }
}

class SchoolSecretaryDetails {
  final List<String>
      departmentsAssisted; // Departments assisted by the secretary

  SchoolSecretaryDetails({required this.departmentsAssisted});

  Map<String, dynamic> toMap() {
    return {
      'departmentsAssisted': departmentsAssisted,
    };
  }

  factory SchoolSecretaryDetails.fromMap(Map<String, dynamic> map) {
    return SchoolSecretaryDetails(
      departmentsAssisted: List<String>.from(map['departmentsAssisted'] ?? []),
    );
  }
}

class DirectorDetails {
  final List<String> schoolsManaged; // List of schools managed by the director
  final int yearsInManagement; // Years in school management roles

  DirectorDetails({
    required this.schoolsManaged,
    required this.yearsInManagement,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolsManaged': schoolsManaged,
      'yearsInManagement': yearsInManagement,
    };
  }

  factory DirectorDetails.fromMap(Map<String, dynamic> map) {
    return DirectorDetails(
      schoolsManaged: List<String>.from(map['schoolsManaged'] ?? []),
      yearsInManagement: map['yearsInManagement'] ?? 0,
    );
  }
}

class MaintenanceStaffDetails {
  final List<String>
      responsibilities; // Specific tasks and areas handled by staff

  MaintenanceStaffDetails({required this.responsibilities});

  Map<String, dynamic> toMap() {
    return {
      'responsibilities': responsibilities,
    };
  }

  factory MaintenanceStaffDetails.fromMap(Map<String, dynamic> map) {
    return MaintenanceStaffDetails(
      responsibilities: List<String>.from(map['responsibilities'] ?? []),
    );
  }
}

class DriverDetails {
  final String licenseNumber; // Driver's license number
  final List<String> routesAssigned; // Routes assigned to the driver

  DriverDetails({
    required this.licenseNumber,
    required this.routesAssigned,
  });

  Map<String, dynamic> toMap() {
    return {
      'licenseNumber': licenseNumber,
      'routesAssigned': routesAssigned,
    };
  }

  factory DriverDetails.fromMap(Map<String, dynamic> map) {
    return DriverDetails(
      licenseNumber: map['licenseNumber'] ?? '',
      routesAssigned: List<String>.from(map['routesAssigned'] ?? []),
    );
  }
}

class SecurityGuardDetails {
  final String assignedArea; // Area of the school the guard is responsible for

  SecurityGuardDetails({required this.assignedArea});

  Map<String, dynamic> toMap() {
    return {
      'assignedArea': assignedArea,
    };
  }

  factory SecurityGuardDetails.fromMap(Map<String, dynamic> map) {
    return SecurityGuardDetails(
      assignedArea: map['assignedArea'] ?? '',
    );
  }
}

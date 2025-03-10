import 'dart:ui';

import '../../fees/models/fee_structure.dart';

class SchoolModel {
  // **Identification and Branding**
  final String schoolId;
  final String logoUrl;
  final String schoolName;
  final String schoolSlogan;
  final String aboutSchool;
  final String status;

  // **General Information**
  final DateTime establishedYear;
  final DateTime createdAt;
  final String schoolingSystem;
  final String schoolBoard;
  final String schoolCode;
  final String schoolType;
  final String affiliationNumber;
  final String schoolManagementAuthority;
  final String managingTrustName;
  final String registeredAddress;
  final String registeredContactNumber;

  // **Location Details**
  final SchoolAddress address;

  // **Contact Information**
  final String primaryPhoneNo;
  final String secondaryPhoneNo;
  final String email;
  final String website;
  final String faxNumber;

  // **Academic Information**
  final String gradingSystem;
  final String examPattern;
  final String academicLevel;
  final String mediumOfInstruction;
  final AcademicYear academicYear;
  final List<ClassData> classes;
  final List<SubjectData> subjects;
  final List<String> grades;
  final List<String> curriculumFrameworks;
  final List<String> languagesOffered;
  final List<String> specializedPrograms;
  final double studentTeacherRatio;
  final List<String> scholarshipPrograms;
  final String transportationDetails;


  // **Facilities and Infrastructure**
  final double campusSize;
  final List<String> facilitiesAvailable;
  final List<String> laboratoriesAvailable;
  final List<String> sportsFacilities;
  final int numberOfBuildings;
  final int numberOfFloors;
  final int numberOfClassrooms;
  final SchoolTimings schoolTimings;
  final bool hasCCTV;
  final bool hasFireSafetyEquipment;
  final bool isWheelchairAccessible;
  final bool hasSmartClassrooms;
  final int numberOfComputers;
  final bool hasInternetAccess;

  // **Activities and Engagement**
  final List<String> extracurricularActivities;
  final List<String> clubs;
  final List<String> societies;
  final List<String> sportsTeams;
  final List<AcademicEvent> academicEvents;

  // **Recognition and Achievements**
  final List<Accreditation> accreditations;
  final List<Ranking> rankings;
  final List<Award> awards;

  // **Student Demographics**
  final int totalBoys;
  final int totalGirls;

  // **Media and Resources**
  final List<String> schoolImagesUrl;
  final String? onlineLearningPlatform;
  final List<String> featuredNews;
  final List<String> importantNotices;

  // **Calendar and Scheduling**
  final List<String> holidays;
  final int noOfPeriodsPerDay;

  // **Fee**
  final List<FeeStructure> feeStructure;
  final String feePaymentMethods;
  final DateTime feeDueDate;
  final String lateFeePolicy;


  // **Staff and Management**
  final List<UserListDetails> principals;
  final List<UserListDetails> vicePrincipals;
  final List<UserListDetails> teachers;
  final List<UserListDetails> maintenanceStaff;
  final List<UserListDetails> drivers;
  final List<UserListDetails> securityGuards;
  final List<UserListDetails> directors;
  final List<UserListDetails> sportsCoaches;
  final List<UserListDetails> schoolNurses;
  final List<UserListDetails> schoolAdministrators;
  final List<UserListDetails> itSupportStaff;
  final List<UserListDetails> librarians;
  final List<UserListDetails> departmentHeads;
  final List<UserListDetails> guidanceCounselors;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String firstAidFacilities;

  // **Branding Customization**
  final Color primaryColor;
  final Color secondaryColor;

  // **Alumni Network**
  final List<Alumni> alumni;

  SchoolModel({
    required this.schoolId,
    required this.logoUrl,
    required this.schoolName,
    required this.schoolSlogan,
    required this.aboutSchool,
    required this.status,
    required this.establishedYear,
    required this.createdAt,
    required this.address,
    required this.primaryPhoneNo,
    required this.secondaryPhoneNo,
    required this.email,
    required this.website,
    required this.faxNumber,
    required this.schoolingSystem,
    required this.schoolBoard,
    required this.schoolCode,
    required this.schoolType,
    required this.affiliationNumber,
    required this.schoolManagementAuthority,
    required this.gradingSystem,
    required this.examPattern,
    required this.academicLevel,
    required this.mediumOfInstruction,
    required this.campusSize,
    required this.extracurricularActivities,
    required this.classes,
    required this.subjects,
    required this.grades,
    required this.clubs,
    required this.societies,
    required this.sportsTeams,
    required this.academicEvents,
    required this.facilitiesAvailable,
    required this.laboratoriesAvailable,
    required this.sportsFacilities,
    required this.schoolImagesUrl,
    required this.accreditations,
    required this.rankings,
    required this.awards,
    required this.holidays,
    required this.numberOfBuildings,
    required this.numberOfFloors,
    required this.numberOfClassrooms,
    required this.noOfPeriodsPerDay,
    required this.schoolTimings,
    required this.academicYear,
    required this.feeStructure,
    required this.principals,
    required this.vicePrincipals,
    required this.teachers,
    required this.maintenanceStaff,
    required this.drivers,
    required this.securityGuards,
    required this.directors,
    required this.sportsCoaches,
    required this.schoolNurses,
    required this.schoolAdministrators,
    required this.itSupportStaff,
    required this.librarians,
    required this.departmentHeads,
    required this.guidanceCounselors,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.firstAidFacilities,
    required this.primaryColor,
    required this.secondaryColor,
    required this.managingTrustName,
    required this.registeredAddress,
    required this.registeredContactNumber,
    required this.totalBoys,
    required this.totalGirls,
    required this.studentTeacherRatio,
    required this.scholarshipPrograms,
    required this.transportationDetails,
    required this.feePaymentMethods,
    required this.lateFeePolicy,
    required this.curriculumFrameworks,
    required this.languagesOffered,
    required this.specializedPrograms,
    required this.hasCCTV,
    required this.hasFireSafetyEquipment,
    required this.isWheelchairAccessible,
    required this.hasSmartClassrooms,
    required this.numberOfComputers,
    required this.hasInternetAccess,
    required this.onlineLearningPlatform,
    required this.featuredNews,
    required this.importantNotices,
    required this.alumni,
    required this.feeDueDate,
  });

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      schoolId: map['schoolId'],
      logoUrl: map['logoUrl'],
      schoolName: map['schoolName'],
      schoolSlogan: map['schoolSlogan'],
      aboutSchool: map['aboutSchool'],
      status: map['status'],
      establishedYear: DateTime.parse(map['establishedYear']),
      createdAt: DateTime.parse(map['createdAt']),
      address: SchoolAddress.fromMap(map['address']),
      primaryPhoneNo: map['primaryPhoneNo'],
      secondaryPhoneNo: map['secondaryPhoneNo'],
      email: map['email'],
      website: map['website'],
      faxNumber: map['faxNumber'],
      schoolingSystem: map['schoolingSystem'],
      schoolBoard: map['schoolBoard'],
      schoolCode: map['schoolCode'],
      schoolType: map['schoolType'],
      affiliationNumber: map['affiliationNumber'],
      schoolManagementAuthority: map['schoolManagementAuthority'],
      gradingSystem: map['gradingSystem'],
      examPattern: map['examPattern'],
      academicLevel: map['academicLevel'],
      mediumOfInstruction: map['mediumOfInstruction'],
      campusSize: map['campusSize'],
      extracurricularActivities:
      List<String>.from(map['extracurricularActivities']),
      classes: (map['classes'] as List)
          .map((e) => ClassData.fromMap(e))
          .toList(),
      subjects: (map['subjects'] as List)
          .map((e) => SubjectData.fromMap(e))
          .toList(),
      grades: List<String>.from(map['grades']),
      clubs: List<String>.from(map['clubs']),
      societies: List<String>.from(map['societies']),
      sportsTeams: List<String>.from(map['sportsTeams']),
      academicEvents: (map['academicEvents'] as List)
          .map((e) => AcademicEvent.fromMap(e))
          .toList(),
      facilitiesAvailable: List<String>.from(map['facilitiesAvailable']),
      laboratoriesAvailable: List<String>.from(map['laboratoriesAvailable']),
      sportsFacilities: List<String>.from(map['sportsFacilities']),
      schoolImagesUrl: List<String>.from(map['schoolImagesUrl']),
      accreditations: (map['accreditations'] as List)
          .map((e) => Accreditation.fromMap(e))
          .toList(),
      rankings: (map['rankings'] as List).map((e) => Ranking.fromMap(e)).toList(),
      awards: (map['awards'] as List).map((e) => Award.fromMap(e)).toList(),
      holidays: List<String>.from(map['holidays']),
      numberOfBuildings: map['numberOfBuildings'],
      numberOfFloors: map['numberOfFloors'],
      numberOfClassrooms: map['numberOfClassrooms'],
      noOfPeriodsPerDay: map['noOfPeriodsPerDay'],
      schoolTimings: SchoolTimings.fromMap(map['schoolTimings']),
      academicYear: AcademicYear.fromMap(map['academicYear']),
      feeStructure: (map['feeStructure'] as List)
          .map((e) => FeeStructure.fromMap(e))
          .toList(),
      principals: (map['principals'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      vicePrincipals: (map['vicePrincipals'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      teachers: (map['teachers'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      maintenanceStaff: (map['maintenanceStaff'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      drivers: (map['drivers'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      securityGuards: (map['securityGuards'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      directors: (map['directors'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      sportsCoaches: (map['sportsCoaches'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      schoolNurses: (map['schoolNurses'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      schoolAdministrators: (map['schoolAdministrators'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      itSupportStaff: (map['itSupportStaff'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      librarians: (map['librarians'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      departmentHeads: (map['departmentHeads'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      guidanceCounselors: (map['guidanceCounselors'] as List)
          .map((e) => UserListDetails.fromMap(e))
          .toList(),
      emergencyContactName: map['emergencyContactName'],
      emergencyContactPhone: map['emergencyContactPhone'],
      firstAidFacilities: map['firstAidFacilities'],
      primaryColor: Color(map['primaryColor']),
      secondaryColor:  Color(map['secondaryColor']),
      managingTrustName: map['managingTrustName'],
      registeredAddress: map['registeredAddress'],
      registeredContactNumber: map['registeredContactNumber'],
      totalBoys: map['totalBoys'],
      totalGirls:  map['totalGirls'],
      studentTeacherRatio: map['studentTeacherRatio'],
      scholarshipPrograms: List<String>.from(map['scholarshipPrograms']),
      transportationDetails: map['transportationDetails'],
      feePaymentMethods: map['feePaymentMethods'],
      lateFeePolicy: map['lateFeePolicy'],
      curriculumFrameworks: List<String>.from(map['curriculumFrameworks']),
      languagesOffered: List<String>.from(map['languagesOffered']),
      specializedPrograms: List<String>.from(map['specializedPrograms']),
      hasCCTV: map['hasCCTV'],
      hasFireSafetyEquipment: map['hasFireSafetyEquipment'],
      isWheelchairAccessible: map['isWheelchairAccessible'],
      hasSmartClassrooms: map['hasSmartClassrooms'],
      numberOfComputers: map['numberOfComputers'],
      hasInternetAccess: map['hasInternetAccess'],
      onlineLearningPlatform: map['onlineLearningPlatform'],
      featuredNews: List<String>.from(map['featuredNews']),
      importantNotices: List<String>.from(map['importantNotices']),
      alumni: (map['alumni'] as List).map((e) => Alumni.fromMap(e)).toList(),
      feeDueDate: DateTime.parse(map['feeDueDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'logoUrl': logoUrl,
      'schoolName': schoolName,
      'schoolSlogan': schoolSlogan,
      'aboutSchool': aboutSchool,
      'status': status,
      'establishedYear': establishedYear.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'address': address.toMap(),
      'primaryPhoneNo': primaryPhoneNo,
      'secondaryPhoneNo': secondaryPhoneNo,
      'email': email,
      'website': website,
      'faxNumber': faxNumber,
      'schoolingSystem': schoolingSystem,
      'schoolBoard': schoolBoard,
      'schoolCode': schoolCode,
      'schoolType': schoolType,
      'affiliationNumber': affiliationNumber,
      'schoolManagementAuthority': schoolManagementAuthority,
      'gradingSystem': gradingSystem,
      'examPattern': examPattern,
      'academicLevel': academicLevel,
      'mediumOfInstruction': mediumOfInstruction,
      'campusSize': campusSize,
      'extracurricularActivities': extracurricularActivities,
      'classes': classes.map((e) => e.toMap()).toList(),
      'subjects': subjects.map((e) => e.toMap()).toList(),
      'grades': grades,
      'clubs': clubs,
      'societies': societies,
      'sportsTeams': sportsTeams,
      'academicEvents': academicEvents.map((e) => e.toMap()).toList(),
      'facilitiesAvailable': facilitiesAvailable,
      'laboratoriesAvailable': laboratoriesAvailable,
      'sportsFacilities': sportsFacilities,
      'schoolImagesUrl': schoolImagesUrl,
      'accreditations': accreditations.map((e) => e.toMap()).toList(),
      'rankings': rankings.map((e) => e.toMap()).toList(),
      'awards': awards.map((e) => e.toMap()).toList(),
      'holidays': holidays,
      'numberOfBuildings': numberOfBuildings,
      'numberOfFloors': numberOfFloors,
      'numberOfClassrooms': numberOfClassrooms,
      'noOfPeriodsPerDay': noOfPeriodsPerDay,
      'schoolTimings': schoolTimings.toMap(),
      'academicYear': academicYear.toMap(),
      'feeStructure': feeStructure.map((e) => e.toMap()).toList(),
      'principals': principals.map((e) => e.toMap()).toList(),
      'vicePrincipals': vicePrincipals.map((e) => e.toMap()).toList(),
      'teachers': teachers.map((e) => e.toMap()).toList(),
      'maintenanceStaff': maintenanceStaff.map((e) => e.toMap()).toList(),
      'drivers': drivers.map((e) => e.toMap()).toList(),
      'securityGuards': securityGuards.map((e) => e.toMap()).toList(),
      'directors': directors.map((e) => e.toMap()).toList(),
      'sportsCoaches': sportsCoaches.map((e) => e.toMap()).toList(),
      'schoolNurses': schoolNurses.map((e) => e.toMap()).toList(),
      'schoolAdministrators':
      schoolAdministrators.map((e) => e.toMap()).toList(),
      'itSupportStaff': itSupportStaff.map((e) => e.toMap()).toList(),
      'librarians': librarians.map((e) => e.toMap()).toList(),
      'departmentHeads': departmentHeads.map((e) => e.toMap()).toList(),
      'guidanceCounselors': guidanceCounselors.map((e) => e.toMap()).toList(),
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'firstAidFacilities': firstAidFacilities,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'managingTrustName': managingTrustName,
      'registeredAddress': registeredAddress,
      'registeredContactNumber': registeredContactNumber,
      'totalBoys': totalBoys,
      'totalGirls': totalGirls,
      'studentTeacherRatio': studentTeacherRatio,
      'scholarshipPrograms': scholarshipPrograms,
      'transportationDetails': transportationDetails,
      'feePaymentMethods': feePaymentMethods,
      'lateFeePolicy': lateFeePolicy,
      'curriculumFrameworks': curriculumFrameworks,
      'languagesOffered': languagesOffered,
      'specializedPrograms': specializedPrograms,
      'hasCCTV': hasCCTV,
      'hasFireSafetyEquipment': hasFireSafetyEquipment,
      'isWheelchairAccessible': isWheelchairAccessible,
      'hasSmartClassrooms': hasSmartClassrooms,
      'numberOfComputers': numberOfComputers,
      'hasInternetAccess': hasInternetAccess,
      'onlineLearningPlatform': onlineLearningPlatform,
      'featuredNews': featuredNews,
      'importantNotices': importantNotices,
      'alumni': alumni.map((e) => e.toMap()).toList(),
      'feeDueDate': feeDueDate.toIso8601String(),
    };
  }
}

class AcademicEvent {
  final String eventName;
  final DateTime eventDate;
  final String? description;

  AcademicEvent({
    required this.eventName,
    required this.eventDate,
    this.description,
  });

  factory AcademicEvent.fromMap(Map<String, dynamic> map) {
    return AcademicEvent(
      eventName: map['eventName'] as String,
      eventDate: DateTime.parse(map['eventDate'] as String),
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'description': description,
    };
  }
}

class Alumni {
  final String alumniId;
  final String alumniName;
  final String? profilePictureUrl;
  final String? currentOccupation;
  final String? contactEmail;
  final String? contactPhone;
  final String? linkedInProfile;
  final String? passingYear;

  Alumni({
    required this.alumniId,
    required this.alumniName,
    this.profilePictureUrl,
    this.currentOccupation,
    this.contactEmail,
    this.contactPhone,
    this.linkedInProfile,
    this.passingYear,
  });

  factory Alumni.fromMap(Map<String, dynamic> map) {
    return Alumni(
      alumniId: map['alumniId'] ?? '',
      alumniName: map['alumniName'] ?? '',
      profilePictureUrl: map['profilePictureUrl'],
      currentOccupation: map['currentOccupation'],
      contactEmail: map['contactEmail'],
      contactPhone: map['contactPhone'],
      linkedInProfile: map['linkedInProfile'],
      passingYear: map['passingYear'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alumniId': alumniId,
      'alumniName': alumniName,
      'profilePictureUrl': profilePictureUrl,
      'currentOccupation': currentOccupation,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'linkedInProfile': linkedInProfile,
      'passingYear': passingYear,
    };
  }
}

class Accreditation {
  final String accreditingBody;
  final String description;
  final DateTime dateOfAccreditation;
  final String validityPeriod;
  final String standardsMet;

  Accreditation({
    required this.accreditingBody,
    required this.description,
    required this.dateOfAccreditation,
    required this.validityPeriod,
    required this.standardsMet,
  });

  factory Accreditation.fromMap(Map<String, dynamic> json) {
    return Accreditation(
      accreditingBody: json['accreditingBody'] ?? '',
      description: json['description'] ?? '',
      dateOfAccreditation: DateTime.parse(json['dateOfAccreditation'] ?? ''),
      validityPeriod: json['validityPeriod'] ?? '',
      standardsMet: json['standardsMet'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accreditingBody': accreditingBody,
      'description': description,
      'dateOfAccreditation': dateOfAccreditation.toIso8601String(),
      'validityPeriod': validityPeriod,
      'standardsMet': standardsMet,
    };
  }
}

class Ranking {
  final String title;
  final int rank;
  final String issuedBy;
  final int year;
  final String level;

  Ranking({
    required this.title,
    required this.rank,
    required this.issuedBy,
    required this.year,
    required this.level,
  });

  factory Ranking.fromMap(Map<String, dynamic> json) {
    return Ranking(
      title: json['title'] ?? '',
      rank: json['rank'] ?? 0,
      issuedBy: json['issuedBy'] ?? '',
      year: json['year'] ?? 0,
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'rank': rank,
      'issuedBy': issuedBy,
      'year': year,
      'level': level,
    };
  }
}

class Award {
  final String name;
  final String description;
  final String issuedBy;
  final DateTime receivedDate;
  final String level;

  Award({
    required this.name,
    required this.description,
    required this.issuedBy,
    required this.receivedDate,
    required this.level,
  });

  factory Award.fromMap(Map<String, dynamic> json) {
    return Award(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      issuedBy: json['issuedBy'] ?? '',
      receivedDate: DateTime.parse(json['receivedDate'] ?? ''),
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'issuedBy': issuedBy,
      'receivedDate': receivedDate.toIso8601String(),
      'level': level,
    };
  }
}

class SchoolTimings {
  final DateTime openingTime;
  final DateTime closingTime;
  final DateTime? assemblyStart;
  final DateTime? assemblyEnd;
  final DateTime? breakStart;
  final DateTime? breakEnd;

  SchoolTimings({
    required this.openingTime,
    required this.closingTime,
    this.assemblyStart,
    this.assemblyEnd,
    this.breakStart,
    this.breakEnd,
  });

  factory SchoolTimings.fromMap(Map<String, dynamic> json) {
    return SchoolTimings(
      openingTime: DateTime.parse(json['openingTime'] ?? ''),
      closingTime: DateTime.parse(json['closingTime'] ?? ''),
      assemblyStart: json['assemblyStart'] != null ? DateTime.parse(json['assemblyStart']) : null,
      assemblyEnd: json['assemblyEnd'] != null ? DateTime.parse(json['assemblyEnd']) : null,
      breakStart: json['breakStart'] != null ? DateTime.parse(json['breakStart']) : null,
      breakEnd:  json['breakEnd'] != null ? DateTime.parse(json['breakEnd']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'openingTime': openingTime.toIso8601String(),
      'closingTime': closingTime.toIso8601String(),
      'assemblyStart': assemblyStart?.toIso8601String(),
      'assemblyEnd': assemblyEnd?.toIso8601String(),
      'breakStart': breakStart?.toIso8601String(),
      'breakEnd': breakEnd?.toIso8601String(),
    };
  }
}

class AcademicYear {
  final DateTime start;
  final DateTime end;

  AcademicYear({
    required this.start,
    required this.end,
  });

  factory AcademicYear.fromMap(Map<String, dynamic> json) {
    return AcademicYear(
      start: DateTime.parse(json['start'] ?? ''),
      end: DateTime.parse(json['end'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}

class UserListDetails {
  final String userId;
  final String userName;
  final String profilePictureUrl;

  UserListDetails({
    required this.userId,
    required this.userName,
    required this.profilePictureUrl,
  });

  factory UserListDetails.fromMap(Map<String, dynamic> map) {
    return UserListDetails(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

class SchoolAddress {
  final String? streetAddress;
  final String? city;
  final String? district;
  final String? state;
  final String? country;
  final String? village;
  final String? pinCode;

  SchoolAddress({
    this.streetAddress,
    this.city,
    this.district,
    this.state,
    this.country,
    this.village,
    this.pinCode,
  });

  Map<String, dynamic> toMap() => {
    'streetAddress': streetAddress,
    'city': city,
    'district': district,
    'state': state,
    'country': country,
    'village': village,
    'pinCode': pinCode,
  };

  static SchoolAddress fromMap(Map<String, dynamic> data) => SchoolAddress(
    streetAddress: data['streetAddress'] as String?,
    city: data['city'] as String?,
    district: data['district'] as String?,
    state: data['state'] as String?,
    country: data['country'] as String?,
    village: data['village'] as String?,
    pinCode: data['pinCode'] as String?,
  );
}
class ClassData {
  final String classId;
  final String className;
  final List<String> sectionName;

  ClassData({
    required this.classId,
    required this.className,
    required this.sectionName,
  });

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
      'sectionName': sectionName,
    };
  }

  factory ClassData.fromMap(Map<String, dynamic> map) {
    return ClassData(
      classId: map['classId'] as String,
      className: map['className'] as String,
      sectionName: List<String>.from(map['sectionName'] ?? []),
    );
  }
}
class SectionData {
  final String classId;
  final String className;
  final String sectionName;

  SectionData({
    required this.classId,
    required this.className,
    required this.sectionName,
  });

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
      'sectionName': sectionName,
    };
  }

  factory SectionData.fromMap(Map<String, dynamic> map) {
    return SectionData(
      classId: map['classId'] as String,
      className: map['className'] as String,
      sectionName: map['sectionName'] ,
    );
  }
}


class SubjectData {
  final String subjectId;
  final String subjectName;
  final String? description;

  SubjectData({
    required this.subjectId,
    required this.subjectName,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'description': description,
    };
  }

  factory SubjectData.fromMap(Map<String, dynamic> map) {
    return SubjectData(
      subjectId: map['subjectId'] as String,
      subjectName: map['subjectName'] as String,
      description: map['description'] as String?,
    );
  }
}
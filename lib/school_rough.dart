import 'package:cambridge_school/roles_manager.dart';
import 'package:flutter/material.dart';

import 'app/modules/fees/models/fee_structure.dart';

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
  final int totalStudents;
  final int totalBoys;
  final int totalGirls;

  // **Media and Resources**
  final List<String> schoolImagesUrl;
  final String? onlineLearningPlatform;
  final List<FeaturedNews> featuredNews;

  // **Calendar and Scheduling**
  final List<Holiday> holidays;
  final int noOfPeriodsPerDay;

  // **Fee**
  final FeeStructure feeStructure;
  final List<String> feePaymentMethods;
  final DateTime feeDueDate;
  final String lateFeePolicy;

  // **Staff and Management**
  final List<UserListDetails> employees;

  final String emergencyContactName;
  final String emergencyContactPhone;
  final String firstAidFacilities;

  // **Branding Customization**
  final Color primaryColor;
  final Color secondaryColor;

  // **Alumni Network**
  final List<Alumni> alumni;

  // **Added Facilities**
  final List<Vehicle> vehicles;
  final List<Classroom> classroomsList;
  final List<Library> libraries;
  final List<ExamHall> examHalls;
  final List<Auditorium> auditoriums;
  final List<Hostel> hostels;
  final List<StaffRoom> staffRooms;
  final List<MedicalRoom> medicalRooms;
  final List<Cafeteria> cafeterias;
  final Parking parking;
  final SecuritySystem securitySystem;

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
    required this.employees,
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
    required this.alumni,
    required this.feeDueDate,
    required this.totalStudents,
    required this.vehicles,
    required this.classroomsList,
    required this.libraries,
    required this.examHalls,
    required this.auditoriums,
    required this.hostels,
    required this.staffRooms,
    required this.medicalRooms,
    required this.cafeterias,
    required this.parking,
    required this.securitySystem,
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
      rankings:
      (map['rankings'] as List).map((e) => Ranking.fromMap(e)).toList(),
      awards: (map['awards'] as List).map((e) => Award.fromMap(e)).toList(),
      holidays: (map['holidays'] as List)
          .map((e) => Holiday.fromMap(e))
          .toList(),
      numberOfBuildings: map['numberOfBuildings'],
      numberOfFloors: map['numberOfFloors'],
      numberOfClassrooms: map['numberOfClassrooms'],
      noOfPeriodsPerDay: map['noOfPeriodsPerDay'],
      schoolTimings: SchoolTimings.fromMap(map['schoolTimings']),
      academicYear: AcademicYear.fromMap(map['academicYear']),
      feeStructure: FeeStructure.fromMap(map['feeStructure']),
      emergencyContactName: map['emergencyContactName'],
      emergencyContactPhone: map['emergencyContactPhone'],
      firstAidFacilities: map['firstAidFacilities'],
      primaryColor: Color(map['primaryColor']),
      secondaryColor: Color(map['secondaryColor']),
      managingTrustName: map['managingTrustName'],
      registeredAddress: map['registeredAddress'],
      registeredContactNumber: map['registeredContactNumber'],
      totalBoys: map['totalBoys'],
      totalGirls: map['totalGirls'],
      studentTeacherRatio: map['studentTeacherRatio'],
      scholarshipPrograms: List<String>.from(map['scholarshipPrograms']),
      transportationDetails: map['transportationDetails'],
      feePaymentMethods: List<String>.from(map['feePaymentMethods']),
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
      featuredNews: (map['featuredNews'] as List)
          .map((e) => FeaturedNews.fromMap(e))
          .toList(),
      alumni: (map['alumni'] as List).map((e) => Alumni.fromMap(e)).toList(),
      feeDueDate: DateTime.parse(map['feeDueDate']),
      employees: List<UserListDetails>.from(map['employees']),
      totalStudents: map['totalStudents'],
      vehicles: (map['vehicles'] as List?)?.map((e) => Vehicle.fromMap(e)).toList() ?? [],
      classroomsList: (map['classroomsList'] as List?)?.map((e) => Classroom.fromMap(e)).toList() ?? [],
      libraries: (map['libraries'] as List?)?.map((e) => Library.fromMap(e)).toList() ?? [],
      examHalls: (map['examHalls'] as List?)?.map((e) => ExamHall.fromMap(e)).toList() ?? [],
      auditoriums: (map['auditoriums'] as List?)?.map((e) => Auditorium.fromMap(e)).toList() ?? [],
      hostels: (map['hostels'] as List?)?.map((e) => Hostel.fromMap(e)).toList() ?? [],
      staffRooms: (map['staffRooms'] as List?)?.map((e) => StaffRoom.fromMap(e)).toList() ?? [],
      medicalRooms: (map['medicalRooms'] as List?)?.map((e) => MedicalRoom.fromMap(e)).toList() ?? [],
      cafeterias: (map['cafeterias'] as List?)?.map((e) => Cafeteria.fromMap(e)).toList() ?? [],
      parking: Parking.fromMap(map['parking'] ?? {}),
      securitySystem: SecuritySystem.fromMap(map['securitySystem'] ?? {}),
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
      'holidays': holidays.map((e) => e.toMap()).toList(),
      'numberOfBuildings': numberOfBuildings,
      'numberOfFloors': numberOfFloors,
      'numberOfClassrooms': numberOfClassrooms,
      'noOfPeriodsPerDay': noOfPeriodsPerDay,
      'schoolTimings': schoolTimings.toMap(),
      'academicYear': academicYear.toMap(),
      'feeStructure': feeStructure.toMap(),
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
      'featuredNews': featuredNews.map((e) => e.toMap()).toList(),
      'alumni': alumni.map((e) => e.toMap()).toList(),
      'feeDueDate': feeDueDate.toIso8601String(),
      'employees': employees.map((e) => e.toMap()).toList(),
      'vehicles': vehicles.map((e) => e.toMap()).toList(),
      'classroomsList': classroomsList.map((e) => e.toMap()).toList(),
      'libraries': libraries.map((e) => e.toMap()).toList(),
      'examHalls': examHalls.map((e) => e.toMap()).toList(),
      'auditoriums': auditoriums.map((e) => e.toMap()).toList(),
      'hostels': hostels.map((e) => e.toMap()).toList(),
      'staffRooms': staffRooms.map((e) => e.toMap()).toList(),
      'medicalRooms': medicalRooms.map((e) => e.toMap()).toList(),
      'cafeterias': cafeterias.map((e) => e.toMap()).toList(),
      'parking': parking.toMap(),
      'securitySystem': securitySystem.toMap(),
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

class FeaturedNews {
  final String title;
  final String content;
  final String imageUrl;
  final DateTime datePublished;

  FeaturedNews({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.datePublished,
  });

  factory FeaturedNews.fromMap(Map<String, dynamic> map) {
    return FeaturedNews(
      title: map['title'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      datePublished: DateTime.parse(map['datePublished']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'datePublished': datePublished.toIso8601String(),
    };
  }
}

class Holiday {
  final String holidayName;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;

  Holiday({
    required this.holidayName,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  factory Holiday.fromMap(Map<String, dynamic> map) {
    return Holiday(
      holidayName: map['holidayName'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'holidayName': holidayName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
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
      assemblyStart:
      json['assemblyStart'] != null ? DateTime.parse(json['assemblyStart']) : null,
      assemblyEnd:
      json['assemblyEnd'] != null ? DateTime.parse(json['assemblyEnd']) : null,
      breakStart:
      json['breakStart'] != null ? DateTime.parse(json['breakStart']) : null,
      breakEnd: json['breakEnd'] != null ? DateTime.parse(json['breakEnd']) : null,
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
  final List<UserRole> roles;

  UserListDetails({
    required this.userId,
    required this.userName,
    required this.profilePictureUrl,
    required this.roles,
  });

  factory UserListDetails.fromMap(Map<String, dynamic> map) {
    return UserListDetails(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
      roles: (map['roles'] as List<dynamic>?)
          ?.map((roleName) {
        try {
          return UserRole.values
              .firstWhere((element) => element.value == roleName);
        } catch (e) {
          print('Unknown role: $roleName');
          return null;
        }
      })
          .whereType<UserRole>()
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'profilePictureUrl': profilePictureUrl,
      'roles': roles.map((e) => e.value).toList(), // Store role value
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
      sectionName: map['sectionName'],
    );
  }
}

class SubjectData {
  final String subjectId;
  final String subjectName;

  SubjectData({
    required this.subjectId,
    required this.subjectName,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
    };
  }

  factory SubjectData.fromMap(Map<String, dynamic> map) {
    return SubjectData(
      subjectId: map['subjectId'] as String,
      subjectName: map['subjectName'] as String,
    );
  }
}

class Vehicle {
  String vehicleType; // Bus, Van, Car, etc.
  String registrationNumber;
  int capacity;
  String driverName;
  String driverContact;
  String route;
  bool gpsEnabled;
  DateTime lastMaintenanceDate;
  String fuelType; // Petrol, Diesel, Electric
  double mileage; // in km/l
  String status; // Active, Under Maintenance, etc.

  Vehicle({
    required this.vehicleType,
    required this.registrationNumber,
    required this.capacity,
    required this.driverName,
    required this.driverContact,
    required this.route,
    required this.gpsEnabled,
    required this.lastMaintenanceDate,
    required this.fuelType,
    required this.mileage,
    required this.status,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      vehicleType: map['vehicleType'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      capacity: map['capacity'] ?? 0,
      driverName: map['driverName'] ?? '',
      driverContact: map['driverContact'] ?? '',
      route: map['route'] ?? '',
      gpsEnabled: map['gpsEnabled'] ?? false,
      lastMaintenanceDate: DateTime.parse(map['lastMaintenanceDate'] ?? DateTime.now().toIso8601String()),
      fuelType: map['fuelType'] ?? '',
      mileage: map['mileage'] ?? 0.0,
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicleType,
      'registrationNumber': registrationNumber,
      'capacity': capacity,
      'driverName': driverName,
      'driverContact': driverContact,
      'route': route,
      'gpsEnabled': gpsEnabled,
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
      'fuelType': fuelType,
      'mileage': mileage,
      'status': status,
    };
  }
}

class Classroom {
  String classroomName;
  int capacity;
  String assignedGrade;
  List<String> facilities; // Smartboard, Projector, AC, etc.
  String seatingArrangement; // Rows,Circular, U-Shape
  DateTime lastMaintenanceDate;

  Classroom({
    required this.classroomName,
    required this.capacity,
    required this.assignedGrade,
    required this.facilities,
    required this.seatingArrangement,
    required this.lastMaintenanceDate,
  });

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      classroomName: map['classroomName'] ?? '',
      capacity: map['capacity'] ?? 0,
      assignedGrade: map['assignedGrade'] ?? '',
      facilities: List<String>.from(map['facilities'] ?? []),
      seatingArrangement: map['seatingArrangement'] ?? '',
      lastMaintenanceDate: DateTime.parse(map['lastMaintenanceDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomName': classroomName,
      'capacity': capacity,
      'assignedGrade': assignedGrade,
      'facilities': facilities,
      'seatingArrangement': seatingArrangement,
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
    };
  }
}

class Library {
  String libraryName;
  int totalBooks;
  List<String> sections; // Science, Fiction, History, etc.
  int seatingCapacity;
  String librarianName;
  bool hasDigitalLibrary;

  Library({
    required this.libraryName,
    required this.totalBooks,
    required this.sections,
    required this.seatingCapacity,
    required this.librarianName,
    required this.hasDigitalLibrary,
  });

  factory Library.fromMap(Map<String, dynamic> map) {
    return Library(
      libraryName: map['libraryName'] ?? '',
      totalBooks: map['totalBooks'] ?? 0,
      sections: List<String>.from(map['sections'] ?? []),
      seatingCapacity: map['seatingCapacity'] ?? 0,
      librarianName: map['librarianName'] ?? '',
      hasDigitalLibrary: map['hasDigitalLibrary'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'libraryName': libraryName,
      'totalBooks': totalBooks,
      'sections': sections,
      'seatingCapacity': seatingCapacity,
      'librarianName': librarianName,
      'hasDigitalLibrary': hasDigitalLibrary,
    };
  }
}

class ExamHall {
  String examHallName;
  int capacity;
  List<String> assignedExams;
  bool cctvInstalled;
  String supervisorName;
  DateTime lastUsageDate;

  ExamHall({
    required this.examHallName,
    required this.capacity,
    required this.assignedExams,
    required this.cctvInstalled,
    required this.supervisorName,
    required this.lastUsageDate,
  });

  factory ExamHall.fromMap(Map<String, dynamic> map) {
    return ExamHall(
      examHallName: map['examHallName'] ?? '',
      capacity: map['capacity'] ?? 0,
      assignedExams: List<String>.from(map['assignedExams'] ?? []),
      cctvInstalled: map['cctvInstalled'] ?? false,
      supervisorName: map['supervisorName'] ?? '',
      lastUsageDate: DateTime.parse(map['lastUsageDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examHallName': examHallName,
      'capacity': capacity,
      'assignedExams': assignedExams,
      'cctvInstalled': cctvInstalled,
      'supervisorName': supervisorName,
      'lastUsageDate': lastUsageDate.toIso8601String(),
    };
  }
}

class Auditorium {
  String auditoriumName;
  int seatingCapacity;
  List<String> availableEquipment; // Mic, Projector, Speaker, etc.
  bool bookingAvailable;
  DateTime lastEventDate;

  Auditorium({
    required this.auditoriumName,
    required this.seatingCapacity,
    required this.availableEquipment,
    required this.bookingAvailable,
    required this.lastEventDate,
  });

  factory Auditorium.fromMap(Map<String, dynamic> map) {
    return Auditorium(
      auditoriumName: map['auditoriumName'] ?? '',
      seatingCapacity: map['seatingCapacity'] ?? 0,
      availableEquipment: List<String>.from(map['availableEquipment'] ?? []),
      bookingAvailable: map['bookingAvailable'] ?? false,
      lastEventDate: DateTime.parse(map['lastEventDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'auditoriumName': auditoriumName,
      'seatingCapacity': seatingCapacity,
      'availableEquipment': availableEquipment,
      'bookingAvailable': bookingAvailable,
      'lastEventDate': lastEventDate.toIso8601String(),
    };
  }
}

class Hostel {
  String hostelName;
  int totalRooms;
  Map<String, int> roomCapacity; // {"Room101": 2, "Room102": 3}
  String wardenName;
  bool messAvailable;
  List<String> rules;

  Hostel({
    required this.hostelName,
    required this.totalRooms,
    required this.roomCapacity,
    required this.wardenName,
    required this.messAvailable,
    required this.rules,
  });

  factory Hostel.fromMap(Map<String, dynamic> map) {
    // Handle nested map for roomCapacity
    Map<String, int> parsedRoomCapacity = {};
    if (map['roomCapacity'] != null && map['roomCapacity'] is Map) {
      map['roomCapacity'].forEach((key, value) {
        if (value is int) {
          parsedRoomCapacity[key] = value;
        }
      });
    }

    return Hostel(
      hostelName: map['hostelName'] ?? '',
      totalRooms: map['totalRooms'] ?? 0,
      roomCapacity: parsedRoomCapacity,
      wardenName: map['wardenName'] ?? '',
      messAvailable: map['messAvailable'] ?? false,
      rules: List<String>.from(map['rules'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostelName': hostelName,
      'totalRooms': totalRooms,
      'roomCapacity': roomCapacity,
      'wardenName': wardenName,
      'messAvailable': messAvailable,
      'rules': rules,
    };
  }
}

class StaffRoom {
  String staffRoomName;
  List<String> assignedStaff;
  List<String> facilities; // Coffee Machine, Computers, etc.
  DateTime lastMaintenanceDate;

  StaffRoom({
    required this.staffRoomName,
    required this.assignedStaff,
    required this.facilities,
    required this.lastMaintenanceDate,
  });

  factory StaffRoom.fromMap(Map<String, dynamic> map) {
    return StaffRoom(
      staffRoomName: map['staffRoomName'] ?? '',
      assignedStaff: List<String>.from(map['assignedStaff'] ?? []),
      facilities: List<String>.from(map['facilities'] ?? []),
      lastMaintenanceDate: DateTime.parse(map['lastMaintenanceDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staffRoomName': staffRoomName,
      'assignedStaff': assignedStaff,
      'facilities': facilities,
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
    };
  }
}

class MedicalRoom {
  String medicalRoomName;
  String doctorName;
  String nurseName;
  List<String> emergencyContacts;
  List<String> availableMedicines;
  bool firstAidAvailable;
  DateTime lastInspectionDate;

  MedicalRoom({
    required this.medicalRoomName,
    required this.doctorName,
    required this.nurseName,
    required this.emergencyContacts,
    required this.availableMedicines,
    required this.firstAidAvailable,
    required this.lastInspectionDate,
  });

  factory MedicalRoom.fromMap(Map<String, dynamic> map) {
    return MedicalRoom(
      medicalRoomName: map['medicalRoomName'] ?? '',
      doctorName: map['doctorName'] ?? '',
      nurseName: map['nurseName'] ?? '',
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
      availableMedicines: List<String>.from(map['availableMedicines'] ?? []),
      firstAidAvailable: map['firstAidAvailable'] ?? false,
      lastInspectionDate: DateTime.parse(map['lastInspectionDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicalRoomName': medicalRoomName,
      'doctorName': doctorName,
      'nurseName': nurseName,
      'emergencyContacts': emergencyContacts,
      'availableMedicines': availableMedicines,
      'firstAidAvailable': firstAidAvailable,
      'lastInspectionDate': lastInspectionDate.toIso8601String(),
    };
  }
}

class Cafeteria {
  String cafeteriaName;
  List<CafeteriaMenuItem> menu;  // List of menu items
  int seatingCapacity;
  bool hygieneCertified;
  DateTime lastInspectionDate;

  Cafeteria({
    required this.cafeteriaName,
    required this.menu,
    required this.seatingCapacity,
    required this.hygieneCertified,
    required this.lastInspectionDate,
  });

  factory Cafeteria.fromMap(Map<String, dynamic> map) {
    return Cafeteria(
      cafeteriaName: map['cafeteriaName'] ?? '',
      menu: (map['menu'] as List?)?.map((e) => CafeteriaMenuItem.fromMap(e)).toList() ?? [],
      seatingCapacity: map['seatingCapacity'] ?? 0,
      hygieneCertified: map['hygieneCertified'] ?? false,
      lastInspectionDate: DateTime.parse(map['lastInspectionDate'] ?? DateTime.now().toIso8601String()),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'cafeteriaName': cafeteriaName,
      'menu': menu.map((e) => e.toMap()).toList(),
      'seatingCapacity': seatingCapacity,
      'hygieneCertified': hygieneCertified,
      'lastInspectionDate': lastInspectionDate.toIso8601String(),
    };
  }
}
class CafeteriaMenuItem {
  String itemName;
  double price;
  String? description; // Optional
  bool isVegetarian;
  String? imageUrl;  // Optional image of the food

  CafeteriaMenuItem({
    required this.itemName,
    required this.price,
    this.description,
    required this.isVegetarian,
    this.imageUrl,
  });

  factory CafeteriaMenuItem.fromMap(Map<String, dynamic> map) {
    return CafeteriaMenuItem(
      itemName: map['itemName'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(), // Double
      description: map['description'],
      isVegetarian: map['isVegetarian'] ?? false,
      imageUrl: map['imageUrl'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'price': price,
      'description': description,
      'isVegetarian': isVegetarian,
      'imageUrl': imageUrl,
    };
  }
}

class SecuritySystem {
  List<String> cctvLocations;
  List<String> securityGuards;
  String monitoringCenter;
  bool realTimeMonitoring;

  SecuritySystem({
    required this.cctvLocations,
    required this.securityGuards,
    required this.monitoringCenter,
    required this.realTimeMonitoring,
  });

  factory SecuritySystem.fromMap(Map<String, dynamic> map) {
    return SecuritySystem(
      cctvLocations: List<String>.from(map['cctvLocations'] ?? []),
      securityGuards: List<String>.from(map['securityGuards'] ?? []),
      monitoringCenter: map['monitoringCenter'] ?? '',
      realTimeMonitoring: map['realTimeMonitoring'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cctvLocations': cctvLocations,
      'securityGuards': securityGuards,
      'monitoringCenter': monitoringCenter,
      'realTimeMonitoring': realTimeMonitoring,
    };
  }
}

class Parking {
  String parkingName;
  int totalSlots;
  int reservedSlots; // For Staff, Visitors, etc.
  bool cctvInstalled;
  double parkingChargesPerHour;

  Parking({
    required this.parkingName,
    required this.totalSlots,
    required this.reservedSlots,
    required this.cctvInstalled,
    required this.parkingChargesPerHour,
  });

  factory Parking.fromMap(Map<String, dynamic> map) {
    return Parking(
      parkingName: map['parkingName'] ?? '',
      totalSlots: map['totalSlots'] ?? 0,
      reservedSlots: map['reservedSlots'] ?? 0,
      cctvInstalled: map['cctvInstalled'] ?? false,
      parkingChargesPerHour: (map['parkingChargesPerHour'] ?? 0.0).toDouble(), // Ensure it's a double
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parkingName': parkingName,
      'totalSlots': totalSlots,
      'reservedSlots': reservedSlots,
      'cctvInstalled': cctvInstalled,
      'parkingChargesPerHour': parkingChargesPerHour,
    };
  }
}
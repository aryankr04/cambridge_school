
import '../../fees/models/fee_structure.dart';

class School {
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

// **Location Details**
  final String address;
  final String country;
  final String state;
  final String city;
  final String district;
  final String pinCode;
  final String street;
  final String landmark;

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
  final List<String> classes;

// **Facilities and Infrastructure**
  final double campusSize;
  final List<String> facilitiesAvailable;
  final List<String> laboratoriesAvailable;
  final List<String> sportsFacilities;
  final int numberOfBuildings;
  final int numberOfFloors;
  final int numberOfClassrooms;
  final SchoolTimings schoolTimings;

// **Activities and Engagement**
  final List<String> extracurricularActivities;
  final List<String> clubs;
  final List<String> societies;
  final List<String> sportsTeams;
  final List<String> annualEvents;

// **Recognition and Achievements**
  final List<String> rankings;
  final List<String> awards;
  final List<Accreditation> accreditations;

// **Media and Resources**
  final List<String> schoolImagesUrl;

// **Calendar and Scheduling**
  final List<String> holidays;
  final int noOfPeriodsPerDay;

//**Fee
  final List<FeeStructure> feeStructure;

  // New properties for staff and management
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

  School({
    // All required parameters
    required this.schoolId,
    required this.logoUrl,
    required this.schoolName,
    required this.schoolSlogan,
    required this.aboutSchool,
    required this.status,
    required this.establishedYear,
    required this.createdAt,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.district,
    required this.pinCode,
    required this.street,
    required this.landmark,
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
    required this.clubs,
    required this.societies,
    required this.sportsTeams,
    required this.annualEvents,
    required this.facilitiesAvailable,
    required this.laboratoriesAvailable,
    required this.sportsFacilities,
    required this.schoolImagesUrl,
    required this.rankings,
    required this.awards,
    required this.holidays,
    required this.numberOfBuildings,
    required this.numberOfFloors,
    required this.numberOfClassrooms,
    required this.noOfPeriodsPerDay,
    required this.schoolTimings,
    required this.academicYear,
    required this.accreditations,
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
  });

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      schoolId: map['schoolId'],
      logoUrl: map['logoUrl'],
      schoolName: map['schoolName'],
      schoolSlogan: map['schoolSlogan'],
      aboutSchool: map['aboutSchool'],
      status: map['status'],
      establishedYear: DateTime.parse(map['establishedYear']),
      createdAt: DateTime.parse(map['createdAt']),
      address: map['address'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      district: map['district'],
      pinCode: map['pinCode'],
      street: map['street'],
      landmark: map['landmark'],
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
      classes: List<String>.from(map['classes']),
      clubs: List<String>.from(map['clubs']),
      societies: List<String>.from(map['societies']),
      sportsTeams: List<String>.from(map['sportsTeams']),
      annualEvents: List<String>.from(map['annualEvents']),
      facilitiesAvailable: List<String>.from(map['facilitiesAvailable']),
      laboratoriesAvailable: List<String>.from(map['laboratoriesAvailable']),
      sportsFacilities: List<String>.from(map['sportsFacilities']),
      schoolImagesUrl: List<String>.from(map['schoolImagesUrl']),
      rankings: List<String>.from(map['rankings']),
      awards: List<String>.from(map['awards']),
      holidays: List<String>.from(map['holidays']),
      numberOfBuildings: map['numberOfBuildings'],
      numberOfFloors: map['numberOfFloors'],
      numberOfClassrooms: map['numberOfClassrooms'],
      noOfPeriodsPerDay: map['noOfPeriodsPerDay'],
      schoolTimings: SchoolTimings.fromMap(map['schoolTimings']),
      academicYear: AcademicYear.fromMap(map['academicYear']),
      accreditations: (map['accreditations'] as List)
          .map((e) => Accreditation.fromMap(e))
          .toList(),
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
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'district': district,
      'pinCode': pinCode,
      'street': street,
      'landmark': landmark,
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
      'classes': classes,
      'clubs': clubs,
      'societies': societies,
      'sportsTeams': sportsTeams,
      'annualEvents': annualEvents,
      'facilitiesAvailable': facilitiesAvailable,
      'laboratoriesAvailable': laboratoriesAvailable,
      'sportsFacilities': sportsFacilities,
      'schoolImagesUrl': schoolImagesUrl,
      'rankings': rankings,
      'awards': awards,
      'holidays': holidays,
      'numberOfBuildings': numberOfBuildings,
      'numberOfFloors': numberOfFloors,
      'numberOfClassrooms': numberOfClassrooms,
      'noOfPeriodsPerDay': noOfPeriodsPerDay,
      'schoolTimings': schoolTimings.toMap(),
      'academicYear': academicYear.toMap(),
      'accreditations': accreditations.map((e) => e.toMap()).toList(),
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
      openingTime: DateTime.parse(json['start'] ?? ''),
      closingTime: DateTime.parse(json['end'] ?? ''),
      assemblyStart: DateTime.parse(json['assemblyStart'] ?? ''),
      assemblyEnd: DateTime.parse(json['assemblyEnd'] ?? ''),
      breakStart: DateTime.parse(json['breakStart'] ?? ''),
      breakEnd: DateTime.parse(json['breakEnd'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': openingTime.toIso8601String(),
      'end': closingTime.toIso8601String(),
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
      userId: map['id'] ?? '',
      userName: map['name'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'name': userName,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

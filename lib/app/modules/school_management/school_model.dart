import 'package:cambridge_school/core/utils/constants/enums/academic_level.dart';
import 'package:cambridge_school/core/utils/constants/enums/campus_area.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/enums/classroom_facilities.dart';
import 'package:cambridge_school/core/utils/constants/enums/classroom_seating_arrangement.dart';
import 'package:cambridge_school/core/utils/constants/enums/exam_pattern.dart';
import 'package:cambridge_school/core/utils/constants/enums/fee_payment_methods.dart';
import 'package:cambridge_school/core/utils/constants/enums/grading_system.dart';
import 'package:cambridge_school/core/utils/constants/enums/medium_of_instruction.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_board.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_ownership.dart';
import 'package:cambridge_school/core/utils/constants/enums/school_specialization.dart';
import 'package:cambridge_school/roles_manager.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/constants/enums/account_status.dart';
import '../../../core/utils/constants/enums/hostel_rules.dart';
import '../../../core/utils/constants/enums/school_gender_policy.dart';
import '../../../core/utils/constants/enums/vehicle_type.dart';
import '../fees/models/fee_structure.dart';

class SchoolModel {
  // ************************ Core School Information ************************
  final String schoolId;
  final String schoolName;
  final String schoolSlogan;
  final String aboutSchool;
  final String schoolCode;
  final String affiliationNumber;

  // ************************ Status and Meta Information ************************
  final AccountStatus status;
  final String establishedYear;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;

  // ************************ Categorical/Policy Information ************************
  final SchoolBoard schoolBoard;
  final SchoolOwnership schoolOwnership;
  final SchoolSpecialization schoolSpecialization;
  final SchoolGenderPolicy schoolGenderPolicy;
  final GradingSystem gradingSystem;
  final ExaminationPattern examPattern;
  final AcademicLevel academicLevel;
  final MediumOfInstruction mediumOfInstruction;

  // ************************ Contact Information ************************
  final SchoolAddress address;
  final String primaryPhoneNo;
  final String secondaryPhoneNo;
  final String email;
  final String website;
  final String faxNumber;

  // ************************ Facilities and Infrastructure ************************
  final double campusSize;
  final int numberOfBuildings;
  final List<String> generalFacilities;
  final List<String> transportFacilities;
  final List<String> sportsInfrastructure;
  final List<String> healthAndSafetyFacilities;
  final List<String> additionalFacilities;
  final List<String> sportsFacilities;
  final List<String> musicAndArtFacilities;
  final List<String> labsAvailable;

  // ************************ Academic Information ************************
  final String academicYear;
  final List<ClassData> classes;
  final double studentTeacherRatio;
  final List<AcademicEvent> academicEvents;
  final int noOfPeriodsPerDay;
  final SchoolTimings schoolTimings;

  // ************************ Student and Staff Demographics ************************
  final int totalStudents;
  final int totalBoys;
  final int totalGirls;
  final List<UserListDetails> employees;
  final List<Alumni> alumni;

  // ************************ Fee Information ************************
  final FeeStructure feeStructure;
  final List<FeePaymentMethod> feePaymentMethods;
  final String lateFeePolicy;
  final DateTime feeDueDate;

  // ************************ Extracurriculars ************************
  final List<String> studentClubs;
  final List<String> specialTrainingPrograms;

  // ************************ Achievements & Recognition ************************
  final List<Accreditation> accreditations;
  final List<Ranking> rankings;
  final List<Award> awards;

  // ************************ School Calendar ************************
  final List<Holiday> holidays;

  // ************************ Infrastructure Details (Specific) ************************
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
  final List<Vehicle> vehicles;

  // ************************ Media and Branding ************************
  final String schoolLogoUrl;
  final String schoolCoverImageUrl;
  final List<SchoolImage> schoolImages;
  final List<FeaturedNews> featuredNews;

  SchoolModel({
    required this.schoolId,
    required this.schoolName,
    required this.schoolSlogan,
    required this.aboutSchool,
    required this.status,
    required this.establishedYear,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.schoolCode,
    required this.affiliationNumber,
    required this.schoolBoard,
    required this.schoolOwnership,
    required this.schoolSpecialization,
    required this.schoolGenderPolicy,
    required this.address,
    required this.primaryPhoneNo,
    required this.secondaryPhoneNo,
    required this.email,
    required this.website,
    required this.faxNumber,
    required this.campusSize,
    required this.numberOfBuildings,
    required this.generalFacilities,
    required this.transportFacilities,
    required this.sportsInfrastructure,
    required this.healthAndSafetyFacilities,
    required this.additionalFacilities,
    required this.gradingSystem,
    required this.examPattern,
    required this.academicLevel,
    required this.mediumOfInstruction,
    required this.academicYear,
    required this.classes,
    required this.studentTeacherRatio,
    required this.academicEvents,
    required this.noOfPeriodsPerDay,
    required this.schoolTimings,
    required this.totalStudents,
    required this.totalBoys,
    required this.totalGirls,
    required this.employees,
    required this.alumni,
    required this.feeStructure,
    required this.feePaymentMethods,
    required this.lateFeePolicy,
    required this.feeDueDate,
    required this.sportsFacilities,
    required this.musicAndArtFacilities,
    required this.studentClubs,
    required this.specialTrainingPrograms,
    required this.accreditations,
    required this.rankings,
    required this.awards,
    required this.holidays,
    required this.labsAvailable,
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
    required this.vehicles,
    required this.schoolLogoUrl,
    required this.schoolCoverImageUrl,
    required this.schoolImages,
    required this.featuredNews,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolId': schoolId,
      'schoolName': schoolName,
      'schoolSlogan': schoolSlogan,
      'aboutSchool': aboutSchool,
      'status': status.name,
      'establishedYear': establishedYear,
      'createdAt': createdAt.toIso8601String(),
      'createdById': createdById,
      'createdByName': createdByName,
      'schoolCode': schoolCode,
      'affiliationNumber': affiliationNumber,
      'schoolBoard': schoolBoard.name,
      'schoolOwnership': schoolOwnership.name,
      'schoolSpecialization': schoolSpecialization.name,
      'schoolGenderPolicy': schoolGenderPolicy.name,
      'address': address.toMap(),
      'primaryPhoneNo': primaryPhoneNo,
      'secondaryPhoneNo': secondaryPhoneNo,
      'email': email,
      'website': website,
      'faxNumber': faxNumber,
      'campusSize': campusSize,
      'numberOfBuildings': numberOfBuildings,
      'generalFacilities': generalFacilities,
      'transportFacilities': transportFacilities,
      'sportsInfrastructure': sportsInfrastructure,
      'healthAndSafetyFacilities': healthAndSafetyFacilities,
      'additionalFacilities': additionalFacilities,
      'gradingSystem': gradingSystem.name,
      'examPattern': examPattern.name,
      'academicLevel': academicLevel.name,
      'mediumOfInstruction': mediumOfInstruction.name,
      'academicYear': academicYear,
      'classes': classes.map((e) => e.toMap()).toList(),
      'studentTeacherRatio': studentTeacherRatio,
      'academicEvents': academicEvents.map((e) => e.toMap()).toList(),
      'noOfPeriodsPerDay': noOfPeriodsPerDay,
      'schoolTimings': schoolTimings.toMap(),
      'totalStudents': totalStudents,
      'totalBoys': totalBoys,
      'totalGirls': totalGirls,
      'employees': employees.map((e) => e.toMap()).toList(),
      'alumni': alumni.map((e) => e.toMap()).toList(),
      'feeStructure': feeStructure.toMap(),
      'feePaymentMethods': feePaymentMethods.map((e) => e.name).toList(),
      'lateFeePolicy': lateFeePolicy,
      'feeDueDate': feeDueDate.toIso8601String(),
      'sportsFacilities': sportsFacilities,
      'musicAndArtFacilities': musicAndArtFacilities,
      'studentClubs': studentClubs,
      'specialTrainingPrograms': specialTrainingPrograms,
      'accreditations': accreditations.map((e) => e.toMap()).toList(),
      'rankings': rankings.map((e) => e.toMap()).toList(),
      'awards': awards.map((e) => e.toMap()).toList(),
      'holidays': holidays.map((e) => e.toMap()).toList(),
      'labsAvailable': labsAvailable,
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
      'vehicles': vehicles.map((e) => e.toMap()).toList(),
      'schoolLogoUrl': schoolLogoUrl,
      'schoolCoverImageUrl': schoolCoverImageUrl,
      'schoolImages': schoolImages.map((e) => e.toMap()).toList(),
      'featuredNews': featuredNews.map((e) => e.toMap()).toList(),
    };
  }

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      schoolId: map['schoolId'] ?? '',
      schoolName: map['schoolName'] ?? '',
      schoolSlogan: map['schoolSlogan'] ?? '',
      aboutSchool: map['aboutSchool'] ?? '',
      status: AccountStatusExtension.fromString(map['status'] ?? 'active'),
      establishedYear: map['establishedYear'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      createdById: map['createdById'] ?? '',
      createdByName: map['createdByName'] ?? '',
      schoolCode: map['schoolCode'] ?? '',
      affiliationNumber: map['affiliationNumber'] ?? '',
      schoolBoard:
          SchoolBoardExtension.fromString(map['schoolBoard'] ?? 'state'),
      schoolOwnership: SchoolOwnershipExtension.fromString(
          map['schoolOwnership'] ?? 'private'),
      schoolSpecialization: SchoolSpecializationExtension.fromString(
          map['schoolSpecialization'] ?? 'coEd'),
      schoolGenderPolicy: SchoolGenderPolicyExtension.fromString(
          map['schoolGenderPolicy'] ?? 'coEd'),
      address: SchoolAddress.fromMap(map['address'] ?? const {}),
      primaryPhoneNo: map['primaryPhoneNo'] ?? '',
      secondaryPhoneNo: map['secondaryPhoneNo'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      faxNumber: map['faxNumber'] ?? '',
      campusSize: (map['campusSize'] is int
          ? (map['campusSize'] as int).toDouble()
          : map['campusSize'] as double),
      numberOfBuildings: map['numberOfBuildings'] ?? 0,
      generalFacilities: (map['generalFacilities'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [],
      transportFacilities: (map['transportFacilities'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [],
      sportsInfrastructure: (map['sportsInfrastructure'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [],
      healthAndSafetyFacilities:
          (map['healthAndSafetyFacilities'] as List<dynamic>?)
                  ?.cast<String>()
                  .toList() ??
              [],
      additionalFacilities: (map['additionalFacilities'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [],
      gradingSystem: GradingSystemExtension.fromString(
          map['gradingSystem'] ?? 'percentage'),
      examPattern: ExaminationPatternExtension.fromString(
          map['examPattern'] ?? 'semester'),
      academicLevel: AcademicLevelExtension.fromString(
          map['academicLevel'] ?? 'higherSecondary'),
      mediumOfInstruction: MediumOfInstructionExtension.fromString(
          map['mediumOfInstruction'] ?? 'english'),
      academicYear: map['academicYear'] ?? '',
      classes: (map['classes'] as List?)
              ?.map((e) => ClassData.fromMap(e))
              .toList() ??
          [],
      studentTeacherRatio: (map['studentTeacherRatio'] is int
          ? (map['studentTeacherRatio'] as int).toDouble()
          : map['studentTeacherRatio'] as double),
      academicEvents: (map['academicEvents'] as List?)
              ?.map((e) => AcademicEvent.fromMap(e))
              .toList() ??
          [],
      noOfPeriodsPerDay: map['noOfPeriodsPerDay'] ?? 0,
      schoolTimings: SchoolTimings.fromMap(map['schoolTimings'] ?? const {}),
      totalStudents: map['totalStudents'] ?? 0,
      totalBoys: map['totalBoys'] ?? 0,
      totalGirls: map['totalGirls'] ?? 0,
      employees: (map['employees'] as List?)
              ?.map((e) => UserListDetails.fromMap(e))
              .toList() ??
          [],
      alumni:
          (map['alumni'] as List?)?.map((e) => Alumni.fromMap(e)).toList() ??
              [],
      feeStructure: FeeStructure.fromMap(map['feeStructure'] ?? const {}),
      feePaymentMethods: (map['feePaymentMethods'] as List?)
              ?.map((e) => FeePaymentMethodExtension.fromString(e))
              .toList() ??
          [],
      lateFeePolicy: map['lateFeePolicy'] ?? '',
      feeDueDate: DateTime.tryParse(map['feeDueDate'] ?? '') ?? DateTime.now(),
      sportsFacilities: (map['sportsFacilities'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [],
      musicAndArtFacilities: (map['musicAndArtFacilities'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [],
      studentClubs:
          (map['studentClubs'] as List<dynamic>?)?.cast<String>().toList() ??
              [],
      specialTrainingPrograms:
          (map['specialTrainingPrograms'] as List<dynamic>?)
                  ?.cast<String>()
                  .toList() ??
              [],
      accreditations: (map['accreditations'] as List?)
              ?.map((e) => Accreditation.fromMap(e))
              .toList() ??
          [],
      rankings:
          (map['rankings'] as List?)?.map((e) => Ranking.fromMap(e)).toList() ??
              [],
      awards:
          (map['awards'] as List?)?.map((e) => Award.fromMap(e)).toList() ?? [],
      holidays:
          (map['holidays'] as List?)?.map((e) => Holiday.fromMap(e)).toList() ??
              [],
      labsAvailable:
          (map['labsAvailable'] as List<dynamic>?)?.cast<String>().toList() ??
              [],
      classroomsList: (map['classroomsList'] as List?)
              ?.map((e) => Classroom.fromMap(e))
              .toList() ??
          [],
      libraries: (map['libraries'] as List?)
              ?.map((e) => Library.fromMap(e))
              .toList() ??
          [],
      examHalls: (map['examHalls'] as List?)
              ?.map((e) => ExamHall.fromMap(e))
              .toList() ??
          [],
      auditoriums: (map['auditoriums'] as List?)
              ?.map((e) => Auditorium.fromMap(e))
              .toList() ??
          [],
      hostels:
          (map['hostels'] as List?)?.map((e) => Hostel.fromMap(e)).toList() ??
              [],
      staffRooms: (map['staffRooms'] as List?)
              ?.map((e) => StaffRoom.fromMap(e))
              .toList() ??
          [],
      medicalRooms: (map['medicalRooms'] as List?)
              ?.map((e) => MedicalRoom.fromMap(e))
              .toList() ??
          [],
      cafeterias: (map['cafeterias'] as List?)
              ?.map((e) => Cafeteria.fromMap(e))
              .toList() ??
          [],
      parking: Parking.fromMap(map['parking'] ?? const {}),
      securitySystem: SecuritySystem.fromMap(map['securitySystem'] ?? const {}),
      vehicles:
          (map['vehicles'] as List?)?.map((e) => Vehicle.fromMap(e)).toList() ??
              [],
      schoolLogoUrl: map['schoolLogoUrl'] ?? '',
      schoolCoverImageUrl: map['schoolCoverImageUrl'] ?? '',
      schoolImages: (map['schoolImages'] as List?)
              ?.map((e) => SchoolImage.fromMap(e))
              .toList() ??
          [],
      featuredNews: (map['featuredNews'] as List?)
              ?.map((e) => FeaturedNews.fromMap(e))
              .toList() ??
          [],
    );
  }

  SchoolModel copyWith({
    String? schoolId,
    String? schoolName,
    String? schoolSlogan,
    String? aboutSchool,
    AccountStatus? status,
    String? establishedYear,
    DateTime? createdAt,
    String? createdById,
    String? createdByName,
    String? schoolCode,
    String? affiliationNumber,
    SchoolBoard? schoolBoard,
    SchoolOwnership? schoolOwnership,
    SchoolSpecialization? schoolSpecialization,
    SchoolGenderPolicy? schoolGenderPolicy,
    SchoolAddress? address,
    String? primaryPhoneNo,
    String? secondaryPhoneNo,
    String? email,
    String? website,
    String? faxNumber,
    double? campusSize,
    int? numberOfBuildings,
    List<String>? generalFacilities,
    List<String>? transportFacilities,
    List<String>? sportsInfrastructure,
    List<String>? healthAndSafetyFacilities,
    List<String>? additionalFacilities,
    GradingSystem? gradingSystem,
    ExaminationPattern? examPattern,
    AcademicLevel? academicLevel,
    MediumOfInstruction? mediumOfInstruction,
    String? academicYear,
    List<ClassData>? classes,
    double? studentTeacherRatio,
    List<AcademicEvent>? academicEvents,
    int? noOfPeriodsPerDay,
    SchoolTimings? schoolTimings,
    int? totalStudents,
    int? totalBoys,
    int? totalGirls,
    List<UserListDetails>? employees,
    List<Alumni>? alumni,
    FeeStructure? feeStructure,
    List<FeePaymentMethod>? feePaymentMethods,
    String? lateFeePolicy,
    DateTime? feeDueDate,
    List<String>? sportsFacilities,
    List<String>? musicAndArtFacilities,
    List<String>? studentClubs,
    List<String>? specialTrainingPrograms,
    List<Accreditation>? accreditations,
    List<Ranking>? rankings,
    List<Award>? awards,
    List<Holiday>? holidays,
    List<String>? labsAvailable,
    List<Classroom>? classroomsList,
    List<Library>? libraries,
    List<ExamHall>? examHalls,
    List<Auditorium>? auditoriums,
    List<Hostel>? hostels,
    List<StaffRoom>? staffRooms,
    List<MedicalRoom>? medicalRooms,
    List<Cafeteria>? cafeterias,
    Parking? parking,
    SecuritySystem? securitySystem,
    List<Vehicle>? vehicles,
    String? schoolLogoUrl,
    String? schoolCoverImageUrl,
    List<SchoolImage>? schoolImages,
    List<FeaturedNews>? featuredNews,
  }) {
    return SchoolModel(
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      schoolSlogan: schoolSlogan ?? this.schoolSlogan,
      aboutSchool: aboutSchool ?? this.aboutSchool,
      status: status ?? this.status,
      establishedYear: establishedYear ?? this.establishedYear,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      schoolCode: schoolCode ?? this.schoolCode,
      affiliationNumber: affiliationNumber ?? this.affiliationNumber,
      schoolBoard: schoolBoard ?? this.schoolBoard,
      schoolOwnership: schoolOwnership ?? this.schoolOwnership,
      schoolSpecialization: schoolSpecialization ?? this.schoolSpecialization,
      schoolGenderPolicy: schoolGenderPolicy ?? this.schoolGenderPolicy,
      address: address ?? this.address,
      primaryPhoneNo: primaryPhoneNo ?? this.primaryPhoneNo,
      secondaryPhoneNo: secondaryPhoneNo ?? this.secondaryPhoneNo,
      email: email ?? this.email,
      website: website ?? this.website,
      faxNumber: faxNumber ?? this.faxNumber,
      campusSize: campusSize ?? this.campusSize,
      numberOfBuildings: numberOfBuildings ?? this.numberOfBuildings,
      generalFacilities: generalFacilities ?? this.generalFacilities,
      transportFacilities: transportFacilities ?? this.transportFacilities,
      sportsInfrastructure: sportsInfrastructure ?? this.sportsInfrastructure,
      healthAndSafetyFacilities:
          healthAndSafetyFacilities ?? this.healthAndSafetyFacilities,
      additionalFacilities: additionalFacilities ?? this.additionalFacilities,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      examPattern: examPattern ?? this.examPattern,
      academicLevel: academicLevel ?? this.academicLevel,
      mediumOfInstruction: mediumOfInstruction ?? this.mediumOfInstruction,
      academicYear: academicYear ?? this.academicYear,
      classes: classes ?? this.classes,
      studentTeacherRatio: studentTeacherRatio ?? this.studentTeacherRatio,
      academicEvents: academicEvents ?? this.academicEvents,
      noOfPeriodsPerDay: noOfPeriodsPerDay ?? this.noOfPeriodsPerDay,
      schoolTimings: schoolTimings ?? this.schoolTimings,
      totalStudents: totalStudents ?? this.totalStudents,
      totalBoys: totalBoys ?? this.totalBoys,
      totalGirls: totalGirls ?? this.totalGirls,
      employees: employees ?? this.employees,
      alumni: alumni ?? this.alumni,
      feeStructure: feeStructure ?? this.feeStructure,
      feePaymentMethods: feePaymentMethods ?? this.feePaymentMethods,
      lateFeePolicy: lateFeePolicy ?? this.lateFeePolicy,
      feeDueDate: feeDueDate ?? this.feeDueDate,
      sportsFacilities: sportsFacilities ?? this.sportsFacilities,
      musicAndArtFacilities:
          musicAndArtFacilities ?? this.musicAndArtFacilities,
      studentClubs: studentClubs ?? this.studentClubs,
      specialTrainingPrograms:
          specialTrainingPrograms ?? this.specialTrainingPrograms,
      accreditations: accreditations ?? this.accreditations,
      rankings: rankings ?? this.rankings,
      awards: awards ?? this.awards,
      holidays: holidays ?? this.holidays,
      labsAvailable: labsAvailable ?? this.labsAvailable,
      classroomsList: classroomsList ?? this.classroomsList,
      libraries: libraries ?? this.libraries,
      examHalls: examHalls ?? this.examHalls,
      auditoriums: auditoriums ?? this.auditoriums,
      hostels: hostels ?? this.hostels,
      staffRooms: staffRooms ?? this.staffRooms,
      medicalRooms: medicalRooms ?? this.medicalRooms,
      cafeterias: cafeterias ?? this.cafeterias,
      parking: parking ?? this.parking,
      securitySystem: securitySystem ?? this.securitySystem,
      vehicles: vehicles ?? this.vehicles,
      schoolLogoUrl: schoolLogoUrl ?? this.schoolLogoUrl,
      schoolCoverImageUrl: schoolCoverImageUrl ?? this.schoolCoverImageUrl,
      schoolImages: schoolImages ?? this.schoolImages,
      featuredNews: featuredNews ?? this.featuredNews,
    );
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

  factory AcademicEvent.fromMap(Map<String, dynamic>? map) {
    return AcademicEvent(
      eventName: map?['eventName'] ?? '',
      eventDate:
          DateTime.parse(map?['eventDate'] ?? DateTime.now().toIso8601String()),
      description: map?['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'description': description,
    };
  }

  AcademicEvent copyWith({
    String? eventName,
    DateTime? eventDate,
    String? description,
  }) {
    return AcademicEvent(
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      description: description ?? this.description,
    );
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

  factory FeaturedNews.fromMap(Map<String, dynamic>? map) {
    return FeaturedNews(
      title: map?['title'] ?? '',
      content: map?['content'] ?? '',
      imageUrl: map?['imageUrl'] ?? '',
      datePublished: DateTime.parse(
          map?['datePublished'] ?? DateTime.now().toIso8601String()),
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

  FeaturedNews copyWith({
    String? title,
    String? content,
    String? imageUrl,
    DateTime? datePublished,
  }) {
    return FeaturedNews(
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      datePublished: datePublished ?? this.datePublished,
    );
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

  factory Holiday.fromMap(Map<String, dynamic>? map) {
    return Holiday(
      holidayName: map?['holidayName'] ?? '',
      startDate:
          DateTime.parse(map?['startDate'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(map?['endDate'] ?? DateTime.now().toIso8601String()),
      description: map?['description'],
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

  Holiday copyWith({
    String? holidayName,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
  }) {
    return Holiday(
      holidayName: holidayName ?? this.holidayName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
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

  factory Alumni.fromMap(Map<String, dynamic>? map) {
    return Alumni(
      alumniId: map?['alumniId'] ?? '',
      alumniName: map?['alumniName'] ?? '',
      profilePictureUrl: map?['profilePictureUrl'],
      currentOccupation: map?['currentOccupation'],
      contactEmail: map?['contactEmail'],
      contactPhone: map?['contactPhone'],
      linkedInProfile: map?['linkedInProfile'],
      passingYear: map?['passingYear'],
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

  Alumni copyWith({
    String? alumniId,
    String? alumniName,
    String? profilePictureUrl,
    String? currentOccupation,
    String? contactEmail,
    String? contactPhone,
    String? linkedInProfile,
    String? passingYear,
  }) {
    return Alumni(
      alumniId: alumniId ?? this.alumniId,
      alumniName: alumniName ?? this.alumniName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      currentOccupation: currentOccupation ?? this.currentOccupation,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      linkedInProfile: linkedInProfile ?? this.linkedInProfile,
      passingYear: passingYear ?? this.passingYear,
    );
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

  factory Accreditation.fromMap(Map<String, dynamic>? json) {
    return Accreditation(
      accreditingBody: json?['accreditingBody'] ?? '',
      description: json?['description'] ?? '',
      dateOfAccreditation: DateTime.parse(
          json?['dateOfAccreditation'] ?? DateTime.now().toIso8601String()),
      validityPeriod: json?['validityPeriod'] ?? '',
      standardsMet: json?['standardsMet'] ?? '',
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

  Accreditation copyWith({
    String? accreditingBody,
    String? description,
    DateTime? dateOfAccreditation,
    String? validityPeriod,
    String? standardsMet,
  }) {
    return Accreditation(
      accreditingBody: accreditingBody ?? this.accreditingBody,
      description: description ?? this.description,
      dateOfAccreditation: dateOfAccreditation ?? this.dateOfAccreditation,
      validityPeriod: validityPeriod ?? this.validityPeriod,
      standardsMet: standardsMet ?? this.standardsMet,
    );
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

  factory Ranking.fromMap(Map<String, dynamic>? json) {
    return Ranking(
      title: json?['title'] ?? '',
      rank: json?['rank'] ?? 0,
      issuedBy: json?['issuedBy'] ?? '',
      year: json?['year'] ?? 0,
      level: json?['level'] ?? '',
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

  Ranking copyWith({
    String? title,
    int? rank,
    String? issuedBy,
    int? year,
    String? level,
  }) {
    return Ranking(
      title: title ?? this.title,
      rank: rank ?? this.rank,
      issuedBy: issuedBy ?? this.issuedBy,
      year: year ?? this.year,
      level: level ?? this.level,
    );
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

  factory Award.fromMap(Map<String, dynamic>? json) {
    return Award(
      name: json?['name'] ?? '',
      description: json?['description'] ?? '',
      issuedBy: json?['issuedBy'] ?? '',
      receivedDate: DateTime.parse(
          json?['receivedDate'] ?? DateTime.now().toIso8601String()),
      level: json?['level'] ?? '',
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

  Award copyWith({
    String? name,
    String? description,
    String? issuedBy,
    DateTime? receivedDate,
    String? level,
  }) {
    return Award(
      name: name ?? this.name,
      description: description ?? this.description,
      issuedBy: issuedBy ?? this.issuedBy,
      receivedDate: receivedDate ?? this.receivedDate,
      level: level ?? this.level,
    );
  }
}

class SchoolTimings {
  final TimeOfDay arrivalTime;
  final TimeOfDay departureTime;
  final TimeOfDay? assemblyStart;
  final TimeOfDay? assemblyEnd;
  final TimeOfDay? breakStart;
  final TimeOfDay? breakEnd;

  SchoolTimings({
    required this.arrivalTime,
    required this.departureTime,
    this.assemblyStart,
    this.assemblyEnd,
    this.breakStart,
    this.breakEnd,
  });

  factory SchoolTimings.fromMap(Map<String, dynamic>? json) {
    TimeOfDay? parseTimeOfDay(String? timeString) {
      if (timeString == null || timeString.isEmpty) {
        return null;
      }

      try {
        final parts = timeString.split(':');
        if (parts.length != 2) {
          return null;
        }
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);

        if (hour == null || minute == null) {
          return null;
        }
        return TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        print("Error parsing TimeOfDay: $e");
        return null;
      }
    }

    return SchoolTimings(
      arrivalTime: parseTimeOfDay(json?['arrivalTime']) ??
          const TimeOfDay(hour: 0, minute: 0),
      departureTime: parseTimeOfDay(json?['departureTime']) ??
          const TimeOfDay(hour: 0, minute: 0),
      assemblyStart: parseTimeOfDay(json?['assemblyStart']),
      assemblyEnd: parseTimeOfDay(json?['assemblyEnd']),
      breakStart: parseTimeOfDay(json?['breakStart']),
      breakEnd: parseTimeOfDay(json?['breakEnd']),
    );
  }

  Map<String, dynamic> toMap() {
    String? timeOfDayToString(TimeOfDay? timeOfDay) {
      if (timeOfDay == null) {
        return null;
      }
      return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    }

    return {
      'arrivalTime': timeOfDayToString(arrivalTime),
      'departureTime': timeOfDayToString(departureTime),
      'assemblyStart': timeOfDayToString(assemblyStart),
      'assemblyEnd': timeOfDayToString(assemblyEnd),
      'breakStart': timeOfDayToString(breakStart),
      'breakEnd': timeOfDayToString(breakEnd),
    };
  }

  SchoolTimings copyWith({
    TimeOfDay? arrivalTime,
    TimeOfDay? departureTime,
    TimeOfDay? assemblyStart,
    TimeOfDay? assemblyEnd,
    TimeOfDay? breakStart,
    TimeOfDay? breakEnd,
  }) {
    return SchoolTimings(
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      assemblyStart: assemblyStart ?? this.assemblyStart,
      assemblyEnd: assemblyEnd ?? this.assemblyEnd,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
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

  factory UserListDetails.fromMap(Map<String, dynamic>? map) {
    return UserListDetails(
      userId: map?['userId'] ?? '',
      userName: map?['userName'] ?? '',
      profilePictureUrl: map?['profilePictureUrl'] ?? '',
      roles: (map?['roles'] as List<dynamic>?)
              ?.map((roleName) {
                if (roleName is! String) {
                  print('Invalid role type: $roleName. Skipping.');
                  return null;
                }

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
      'roles': roles.map((e) => e.value).toList(),
    };
  }

  UserListDetails copyWith({
    String? userId,
    String? userName,
    String? profilePictureUrl,
    List<UserRole>? roles,
  }) {
    return UserListDetails(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      roles: roles ?? this.roles,
    );
  }
}

class SchoolAddress {
  final String? streetAddress;
  final String? city;
  final String? district;
  final String? state;
  final String? country;
  final String? village;
  final String? landmark;
  final String? pinCode;

  SchoolAddress({
    this.streetAddress,
    this.city,
    this.district,
    this.state,
    this.country,
    this.village,
    this.landmark,
    this.pinCode,
  });

  Map<String, dynamic> toMap() => {
        'streetAddress': streetAddress,
        'city': city,
        'district': district,
        'state': state,
        'country': country,
        'village': village,
        'landmark': landmark,
        'pinCode': pinCode,
      };

  static SchoolAddress fromMap(Map<String, dynamic>? data) {
    return SchoolAddress(
      streetAddress: data?['streetAddress'],
      city: data?['city'],
      district: data?['district'],
      state: data?['state'],
      country: data?['country'],
      village: data?['village'],
      landmark: data?['landmark'],
      pinCode: data?['pinCode'],
    );
  }

  SchoolAddress copyWith({
    String? streetAddress,
    String? city,
    String? district,
    String? state,
    String? country,
    String? village,
    String? landmark,
    String? pinCode,
  }) {
    return SchoolAddress(
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      country: country ?? this.country,
      village: village ?? this.village,
      landmark: landmark ?? this.landmark,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}

class ClassData {
  final String classId;
  final ClassName className;
  final List<String> sectionName;

  ClassData({
    required this.classId,
    required this.className,
    required this.sectionName,
  });

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className.name, // Store enum name as string
      'sectionName': sectionName,
    };
  }

  factory ClassData.fromMap(Map<String, dynamic>? map) {
    return ClassData(
      classId: map?['classId'] ?? '',
      className: ClassNameExtension.fromString(
          map?['className'] ?? ''), // Retrieve enum from stored name
      sectionName: List<String>.from(map?['sectionName'] ?? const []),
    );
  }

  ClassData copyWith({
    String? classId,
    ClassName? className,
    List<String>? sectionName,
  }) {
    return ClassData(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      sectionName: sectionName ?? this.sectionName,
    );
  }
}

class SectionData {
  final String classId;
  final ClassName className;
  final String sectionName;

  SectionData({
    required this.classId,
    required this.className,
    required this.sectionName,
  });

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className.name, // Store enum name as string
      'sectionName': sectionName,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionData &&
          runtimeType == other.runtimeType &&
          classId == other.classId &&
          className == other.className &&
          sectionName == other.sectionName;

  @override
  int get hashCode =>
      classId.hashCode ^ className.hashCode ^ sectionName.hashCode;
}

class Vehicle {
  VehicleType vehicleType;
  String registrationNumber;
  int capacity;
  String driverName;
  String driverContact;
  String route;
  bool gpsEnabled;
  String fuelType;
  String status;

  Vehicle({
    required this.vehicleType,
    required this.registrationNumber,
    required this.capacity,
    required this.driverName,
    required this.driverContact,
    required this.route,
    required this.gpsEnabled,
    required this.fuelType,
    required this.status,
  });

  factory Vehicle.fromMap(Map<String, dynamic>? map) {
    return Vehicle(
      vehicleType:
          VehicleTypeExtension.fromString(map?['vehicleType'] ?? 'bus'),
      registrationNumber: map?['registrationNumber'] ?? '',
      capacity: map?['capacity'] ?? 0,
      driverName: map?['driverName'] ?? '',
      driverContact: map?['driverContact'] ?? '',
      route: map?['route'] ?? '',
      gpsEnabled: map?['gpsEnabled'] ?? false,
      fuelType: map?['fuelType'] ?? '',
      status: map?['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicleType.label,
      'registrationNumber': registrationNumber,
      'capacity': capacity,
      'driverName': driverName,
      'driverContact': driverContact,
      'route': route,
      'gpsEnabled': gpsEnabled,
      'fuelType': fuelType,
      'status': status,
    };
  }

  Vehicle copyWith({
    VehicleType? vehicleType,
    String? registrationNumber,
    int? capacity,
    String? driverName,
    String? driverContact,
    String? route,
    bool? gpsEnabled,
    String? fuelType,
    String? status,
  }) {
    return Vehicle(
      vehicleType: vehicleType ?? this.vehicleType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      capacity: capacity ?? this.capacity,
      driverName: driverName ?? this.driverName,
      driverContact: driverContact ?? this.driverContact,
      route: route ?? this.route,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      fuelType: fuelType ?? this.fuelType,
      status: status ?? this.status,
    );
  }
}

class Classroom {
  String classroomName;
  int capacity;
  List<ClassroomFacility> facilities;
  ClassroomSeatingArrangement seatingArrangement;

  Classroom({
    required this.classroomName,
    required this.capacity,
    required this.facilities,
    required this.seatingArrangement,
  });

  factory Classroom.fromMap(Map<String, dynamic>? map) {
    return Classroom(
      classroomName: map?['classroomName'] ?? '',
      capacity: map?['capacity'] ?? 0,
      facilities: (map?['facilities'] as List<dynamic>? ?? [])
          .map((e) => ClassroomFacilityExtension.fromString(e as String))
          .whereType<ClassroomFacility>()
          .toList(),
      seatingArrangement: ClassroomSeatingArrangementExtension.fromString(
          map?['seatingArrangement'] ?? 'rows'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomName': classroomName,
      'capacity': capacity,
      'facilities': facilities.map((e) => e.label).toList(),
      'seatingArrangement': seatingArrangement.label,
    };
  }

  Classroom copyWith({
    String? classroomName,
    int? capacity,
    List<ClassroomFacility>? facilities,
    ClassroomSeatingArrangement? seatingArrangement,
  }) {
    return Classroom(
      classroomName: classroomName ?? this.classroomName,
      capacity: capacity ?? this.capacity,
      facilities: facilities ?? this.facilities,
      seatingArrangement: seatingArrangement ?? this.seatingArrangement,
    );
  }
}

class Library {
  String libraryName;
  int totalBooks;
  List<String> sections;
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

  factory Library.fromMap(Map<String, dynamic>? map) {
    return Library(
      libraryName: map?['libraryName'] ?? '',
      totalBooks: map?['totalBooks'] ?? 0,
      sections: List<String>.from(map?['sections'] ?? const []),
      seatingCapacity: map?['seatingCapacity'] ?? 0,
      librarianName: map?['librarianName'] ?? '',
      hasDigitalLibrary: map?['hasDigitalLibrary'] ?? false,
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

  Library copyWith({
    String? libraryName,
    int? totalBooks,
    List<String>? sections,
    int? seatingCapacity,
    String? librarianName,
    bool? hasDigitalLibrary,
  }) {
    return Library(
      libraryName: libraryName ?? this.libraryName,
      totalBooks: totalBooks ?? this.totalBooks,
      sections: sections ?? this.sections,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      librarianName: librarianName ?? this.librarianName,
      hasDigitalLibrary: hasDigitalLibrary ?? this.hasDigitalLibrary,
    );
  }
}

class ExamHall {
  String examHallName;
  int capacity;
  List<String> assignedExams;
  bool cctvInstalled;

  ExamHall({
    required this.examHallName,
    required this.capacity,
    required this.assignedExams,
    required this.cctvInstalled,
  });

  factory ExamHall.fromMap(Map<String, dynamic>? map) {
    return ExamHall(
      examHallName: map?['examHallName'] ?? '',
      capacity: map?['capacity'] ?? 0,
      assignedExams: List<String>.from(map?['assignedExams'] ?? const []),
      cctvInstalled: map?['cctvInstalled'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examHallName': examHallName,
      'capacity': capacity,
      'assignedExams': assignedExams,
      'cctvInstalled': cctvInstalled,
    };
  }

  ExamHall copyWith({
    String? examHallName,
    int? capacity,
    List<String>? assignedExams,
    bool? cctvInstalled,
  }) {
    return ExamHall(
      examHallName: examHallName ?? this.examHallName,
      capacity: capacity ?? this.capacity,
      assignedExams: assignedExams ?? this.assignedExams,
      cctvInstalled: cctvInstalled ?? this.cctvInstalled,
    );
  }
}

class Auditorium {
  String auditoriumName;
  int seatingCapacity;
  List<ClassroomFacility> availableEquipment;

  Auditorium({
    required this.auditoriumName,
    required this.seatingCapacity,
    required this.availableEquipment,
  });

  factory Auditorium.fromMap(Map<String, dynamic>? map) {
    return Auditorium(
      auditoriumName: map?['auditoriumName'] ?? '',
      seatingCapacity: map?['seatingCapacity'] ?? 0,
      availableEquipment: (map?['availableEquipment'] as List<dynamic>? ?? [])
          .map((e) => ClassroomFacilityExtension.fromString(e as String))
          .whereType<ClassroomFacility>()
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'auditoriumName': auditoriumName,
      'seatingCapacity': seatingCapacity,
      'availableEquipment': availableEquipment.map((e) => e.label).toList(),
    };
  }

  Auditorium copyWith({
    String? auditoriumName,
    int? seatingCapacity,
    List<ClassroomFacility>? availableEquipment,
  }) {
    return Auditorium(
      auditoriumName: auditoriumName ?? this.auditoriumName,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      availableEquipment: availableEquipment ?? this.availableEquipment,
    );
  }
}

class Hostel {
  String hostelName;
  int totalRooms;
  Map<String, int> roomCapacity;
  String wardenName;
  bool messAvailable;
  List<HostelRule> rules;

  Hostel({
    required this.hostelName,
    required this.totalRooms,
    required this.roomCapacity,
    required this.wardenName,
    required this.messAvailable,
    required this.rules,
  });

  factory Hostel.fromMap(Map<String, dynamic>? map) {
    Map<String, int> parsedRoomCapacity = {};
    if (map?['roomCapacity'] != null && map?['roomCapacity'] is Map) {
      map?['roomCapacity'].forEach((key, value) {
        if (value is int) {
          parsedRoomCapacity[key] = value;
        }
      });
    }

    return Hostel(
      hostelName: map?['hostelName'] ?? '',
      totalRooms: map?['totalRooms'] ?? 0,
      roomCapacity: parsedRoomCapacity,
      wardenName: map?['wardenName'] ?? '',
      messAvailable: map?['messAvailable'] ?? false,
      rules: (map?['rules'] as List<dynamic>? ?? [])
          .map((e) => HostelRuleExtension.fromString(e as String))
          .whereType<HostelRule>()
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostelName': hostelName,
      'totalRooms': totalRooms,
      'roomCapacity': roomCapacity,
      'wardenName': wardenName,
      'messAvailable': messAvailable,
      'rules': rules.map((e) => e.label).toList(),
    };
  }

  Hostel copyWith({
    String? hostelName,
    int? totalRooms,
    Map<String, int>? roomCapacity,
    String? wardenName,
    bool? messAvailable,
    List<HostelRule>? rules,
  }) {
    return Hostel(
      hostelName: hostelName ?? this.hostelName,
      totalRooms: totalRooms ?? this.totalRooms,
      roomCapacity: roomCapacity ?? this.roomCapacity,
      wardenName: wardenName ?? this.wardenName,
      messAvailable: messAvailable ?? this.messAvailable,
      rules: rules ?? this.rules,
    );
  }
}

class StaffRoom {
  String staffRoomName;
  List<String> assignedStaff;
  List<String> facilities;
  DateTime lastMaintenanceDate;

  StaffRoom({
    required this.staffRoomName,
    required this.assignedStaff,
    required this.facilities,
    required this.lastMaintenanceDate,
  });

  factory StaffRoom.fromMap(Map<String, dynamic>? map) {
    return StaffRoom(
      staffRoomName: map?['staffRoomName'] ?? '',
      assignedStaff: List<String>.from(map?['assignedStaff'] ?? const []),
      facilities: List<String>.from(map?['facilities'] ?? const []),
      lastMaintenanceDate: DateTime.parse(
          map?['lastMaintenanceDate'] ?? DateTime.now().toIso8601String()),
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

  StaffRoom copyWith({
    String? staffRoomName,
    List<String>? assignedStaff,
    List<String>? facilities,
    DateTime? lastMaintenanceDate,
  }) {
    return StaffRoom(
      staffRoomName: staffRoomName ?? this.staffRoomName,
      assignedStaff: assignedStaff ?? this.assignedStaff,
      facilities: facilities ?? this.facilities,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
    );
  }
}

class MedicalRoom {
  String medicalRoomName;
  String doctorName;
  String nurseName;
  List<String> emergencyContacts;
  List<String> availableMedicines;
  bool firstAidAvailable;

  MedicalRoom({
    required this.medicalRoomName,
    required this.doctorName,
    required this.nurseName,
    required this.emergencyContacts,
    required this.availableMedicines,
    required this.firstAidAvailable,
  });

  factory MedicalRoom.fromMap(Map<String, dynamic>? map) {
    return MedicalRoom(
      medicalRoomName: map?['medicalRoomName'] ?? '',
      doctorName: map?['doctorName'] ?? '',
      nurseName: map?['nurseName'] ?? '',
      emergencyContacts:
          List<String>.from(map?['emergencyContacts'] ?? const []),
      availableMedicines:
          List<String>.from(map?['availableMedicines'] ?? const []),
      firstAidAvailable: map?['firstAidAvailable'] ?? false,
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
    };
  }

  MedicalRoom copyWith({
    String? medicalRoomName,
    String? doctorName,
    String? nurseName,
    List<String>? emergencyContacts,
    List<String>? availableMedicines,
    bool? firstAidAvailable,
  }) {
    return MedicalRoom(
      medicalRoomName: medicalRoomName ?? this.medicalRoomName,
      doctorName: doctorName ?? this.doctorName,
      nurseName: nurseName ?? this.nurseName,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      availableMedicines: availableMedicines ?? this.availableMedicines,
      firstAidAvailable: firstAidAvailable ?? this.firstAidAvailable,
    );
  }
}

class Cafeteria {
  String cafeteriaName;
  List<CafeteriaMenuItem> menu;
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

  factory Cafeteria.fromMap(Map<String, dynamic>? map) {
    return Cafeteria(
      cafeteriaName: map?['cafeteriaName'] ?? '',
      menu: (map?['menu'] as List?)
              ?.map((e) => CafeteriaMenuItem.fromMap(e))
              .toList() ??
          [],
      seatingCapacity: map?['seatingCapacity'] ?? 0,
      hygieneCertified: map?['hygieneCertified'] ?? false,
      lastInspectionDate: DateTime.parse(
          map?['lastInspectionDate'] ?? DateTime.now().toIso8601String()),
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

  Cafeteria copyWith({
    String? cafeteriaName,
    List<CafeteriaMenuItem>? menu,
    int? seatingCapacity,
    bool? hygieneCertified,
    DateTime? lastInspectionDate,
  }) {
    return Cafeteria(
      cafeteriaName: cafeteriaName ?? this.cafeteriaName,
      menu: menu ?? this.menu,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      hygieneCertified: hygieneCertified ?? this.hygieneCertified,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
    );
  }
}

class CafeteriaMenuItem {
  String itemName;
  double price;
  String? description;
  bool isVegetarian;
  String? imageUrl;

  CafeteriaMenuItem({
    required this.itemName,
    required this.price,
    this.description,
    required this.isVegetarian,
    this.imageUrl,
  });

  factory CafeteriaMenuItem.fromMap(Map<String, dynamic>? map) {
    return CafeteriaMenuItem(
      itemName: map?['itemName'] ?? '',
      price: (map?['price'] as num? ?? 0.0).toDouble(),
      description: map?['description'],
      isVegetarian: map?['isVegetarian'] ?? false,
      imageUrl: map?['imageUrl'],
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

  CafeteriaMenuItem copyWith({
    String? itemName,
    double? price,
    String? description,
    bool? isVegetarian,
    String? imageUrl,
  }) {
    return CafeteriaMenuItem(
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      description: description ?? this.description,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      imageUrl: imageUrl ?? this.imageUrl,
    );
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

  factory SecuritySystem.fromMap(Map<String, dynamic>? map) {
    return SecuritySystem(
      cctvLocations: List<String>.from(map?['cctvLocations'] ?? const []),
      securityGuards: List<String>.from(map?['securityGuards'] ?? const []),
      monitoringCenter: map?['monitoringCenter'] ?? '',
      realTimeMonitoring: map?['realTimeMonitoring'] ?? false,
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

  SecuritySystem copyWith({
    List<String>? cctvLocations,
    List<String>? securityGuards,
    String? monitoringCenter,
    bool? realTimeMonitoring,
  }) {
    return SecuritySystem(
      cctvLocations: cctvLocations ?? this.cctvLocations,
      securityGuards: securityGuards ?? this.securityGuards,
      monitoringCenter: monitoringCenter ?? this.monitoringCenter,
      realTimeMonitoring: realTimeMonitoring ?? this.realTimeMonitoring,
    );
  }
}

class Parking {
  String parkingName;
  int totalSlots;
  int reservedSlots;
  bool cctvInstalled;
  double parkingChargesPerHour;

  Parking({
    required this.parkingName,
    required this.totalSlots,
    required this.reservedSlots,
    required this.cctvInstalled,
    required this.parkingChargesPerHour,
  });

  factory Parking.fromMap(Map<String, dynamic>? map) {
    return Parking(
      parkingName: map?['parkingName'] ?? '',
      totalSlots: map?['totalSlots'] ?? 0,
      reservedSlots: map?['reservedSlots'] ?? 0,
      cctvInstalled: map?['cctvInstalled'] ?? false,
      parkingChargesPerHour:
          (map?['parkingChargesPerHour'] as num? ?? 0.0).toDouble(),
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

  Parking copyWith({
    String? parkingName,
    int? totalSlots,
    int? reservedSlots,
    bool? cctvInstalled,
    double? parkingChargesPerHour,
  }) {
    return Parking(
      parkingName: parkingName ?? this.parkingName,
      totalSlots: totalSlots ?? this.totalSlots,
      reservedSlots: reservedSlots ?? this.reservedSlots,
      cctvInstalled: cctvInstalled ?? this.cctvInstalled,
      parkingChargesPerHour:
          parkingChargesPerHour ?? this.parkingChargesPerHour,
    );
  }
}

class SchoolImage {
  CampusArea campusArea;
  List<String> imageUrls;

  SchoolImage({required this.campusArea, required this.imageUrls});

  Map<String, dynamic> toMap() {
    return {
      'campusArea': campusArea.label,
      'imageUrls': imageUrls,
    };
  }

  factory SchoolImage.fromMap(Map<String, dynamic>? map) {
    return SchoolImage(
      campusArea:
          CampusAreaExtension.fromString(map?['campusArea'] as String) ??
              CampusArea.classroom,
      imageUrls: List<String>.from(map?['imageUrls'] ?? const []),
    );
  }

  SchoolImage copyWith({
    CampusArea? campusArea,
    List<String>? imageUrls,
  }) {
    return SchoolImage(
      campusArea: campusArea ?? this.campusArea,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

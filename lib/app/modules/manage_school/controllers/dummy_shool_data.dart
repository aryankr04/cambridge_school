import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

import '../models/school_model.dart';

import 'package:flutter/material.dart';

class SchoolDummyData {
  // Function to generate a random DateTime within a range
  DateTime randomDateBetween(DateTime start, DateTime end) {
    final random = Random();
    final range = end.difference(start).inDays;
    return start.add(Duration(days: random.nextInt(range)));
  }

  Future<void> generateAndSendSchoolDataToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final schoolCollection = firestore.collection('schools'); // Collection name

    // Generate dummy data for SchoolModel
    final school = generateDummySchoolData();

    // Convert SchoolModel to a Map
    final schoolData = school.toMap();

    try {
      // Add the school data to Firestore
      await schoolCollection.doc(school.schoolId).set(schoolData);
      print('School data added to Firestore successfully!');
    } catch (e) {
      print('Error adding school data to Firestore: $e');
    }
  }

  SchoolModel generateDummySchoolData() {
    const uuid = Uuid();
    const schoolId = 'SCH00001';
    final random = Random();
    final faker = Faker();

    // ***  Reusable Dummy Data Generators ***

    // Address
    SchoolAddress generateAddress()  {
      return SchoolAddress(
        streetAddress: faker.address.streetAddress(),
        city: faker.address.city(),
        district: faker.address.state(), //Using state as district is not available
        state: faker.address.state(),
        country: faker.address.country(),
        village: faker.address.city(), //Using city as village is not available
        pinCode: faker.address.zipCode(),
      );
    }

    // SchoolTimings
    SchoolTimings generateSchoolTimings() {
      final now = DateTime.now();
      return SchoolTimings(
        openingTime: DateTime(now.year, now.month, now.day, 8, 0),
        closingTime: DateTime(now.year, now.month, now.day, 15, 0),
        assemblyStart: DateTime(now.year, now.month, now.day, 7, 45),
        assemblyEnd: DateTime(now.year, now.month, now.day, 8, 0),
        breakStart: DateTime(now.year, now.month, now.day, 10, 30),
        breakEnd: DateTime(now.year, now.month, now.day, 11, 0),
      );
    }

    // AcademicYear
    AcademicYear generateAcademicYear() {
      final now = DateTime.now();
      return AcademicYear(
        start: DateTime(now.year, 6, 1), // June 1st
        end: DateTime(now.year + 1, 5, 31), // May 31st next year
      );
    }

    // UserListDetails
    UserListDetails generateUserListDetails() {
      return UserListDetails(
        userId: uuid.v4(),
        userName: faker.person.firstName(),
        profilePictureUrl: 'https://example.com/profile.jpg', // Replace with dummy URL
      );
    }

    // FeeStructure (Simplified)
    // FeeStructure generateFeeStructure() {
    //   return FeeStructure(
    //     feeId: uuid.v4(),
    //     feeName: 'Tuition Fee',
    //     amount: (1000 + random.nextInt(5000)).toDouble(), // Random amount between 1000 and 6000
    //     description: 'Annual tuition fee',
    //     dueDate: randomDateBetween(DateTime.now(), DateTime.now().add(Duration(days: 365))),
    //     paymentSchedule: "Yearly",
    //   );
    // }

    // AcademicEvent
    AcademicEvent generateAcademicEvent() {
      return AcademicEvent(
        eventName: 'Science Fair',
        eventDate: randomDateBetween(DateTime.now(), DateTime.now().add(const Duration(days: 365))),
        description: 'Annual science exhibition',
      );
    }

    // Accreditation
    Accreditation generateAccreditation() {
      return Accreditation(
        accreditingBody: 'Example Accreditation Body',
        description: 'Accredited for quality education',
        dateOfAccreditation: randomDateBetween(DateTime(2010), DateTime.now()),
        validityPeriod: '5 years',
        standardsMet: 'All standards met',
      );
    }

    // Ranking
    Ranking generateRanking() {
      return Ranking(
        title: 'Best School',
        rank: random.nextInt(10) + 1, // Rank between 1 and 10
        issuedBy: 'Example Ranking Agency',
        year: DateTime.now().year - random.nextInt(5), // Within the last 5 years
        level: 'National',
      );
    }

    // Award
    Award generateAward() {
      return Award(
        name: 'Excellence in Education',
        description: 'Awarded for outstanding performance',
        issuedBy: 'Example Award Committee',
        receivedDate: randomDateBetween(DateTime(2015), DateTime.now()),
        level: 'State',
      );
    }

    // Alumni
    Alumni generateAlumni() {
      return Alumni(
        alumniId: uuid.v4(),
        alumniName: faker.person.firstName(),
        profilePictureUrl: 'https://example.com/alumni.jpg', // Replace with dummy URL
        currentOccupation: 'Software Engineer',
        contactEmail: faker.internet.email(),
        contactPhone: faker.phoneNumber.toString(),
        linkedInProfile: 'https://linkedin.com/in/example', // Replace with dummy URL
        passingYear: (2010 + random.nextInt(14)).toString(), //Passing year
      );
    }

    //Class Data
    ClassData generateClassData() {
      return ClassData(
        classId: uuid.v4(),
        className: (random.nextInt(12) + 1).toString(),
      );
    }

    //Section Data
    SectionData generateSectionData() {
      return SectionData(
        sectionId: uuid.v4(),
        sectionName: String.fromCharCode(65 + random.nextInt(26)),
        classId: uuid.v4(),
        className: (random.nextInt(12) + 1).toString(),
      );
    }

    //Subject Data
    SubjectData generateSubjectData() {
      return SubjectData(
        subjectId: uuid.v4(),
        subjectName: faker.job.title(),
        description: faker.lorem.sentence(),
      );
    }
    // ******* Now Generate The School Model *******

    return SchoolModel(
      schoolId: schoolId,
      logoUrl: 'https://example.com/school_logo.png', // Replace with a dummy URL
      schoolName: '${faker.company.name()} School',
      schoolSlogan: 'Inspiring Minds, Shaping Futures',
      aboutSchool: faker.lorem.sentences(5).join(" "),
      status: 'Active',
      establishedYear: DateTime(1950 + random.nextInt(74)), // Between 1950 and 2024
      createdAt: DateTime.now(),
      address: generateAddress(),
      primaryPhoneNo: faker.phoneNumber.toString(),
      secondaryPhoneNo: faker.phoneNumber.toString(),
      email: faker.internet.email(),
      website: faker.internet.domainName(),
      faxNumber: faker.phoneNumber.toString(),
      schoolingSystem: 'CBSE',
      schoolBoard: 'Central Board of Secondary Education',
      schoolCode: '12345',
      schoolType: 'Co-educational',
      affiliationNumber: '98765',
      schoolManagementAuthority: 'Private Trust',
      gradingSystem: 'A, B, C, D, E',
      examPattern: 'Semester',
      academicLevel: 'Secondary',
      mediumOfInstruction: 'English',
      campusSize: 5.0 + random.nextDouble() * 10,
      extracurricularActivities: List.generate(
          3, (index) => faker.sport.name()),
      classes: List.generate(10, (index) => generateClassData()),
      sections: List.generate(5, (index) => generateSectionData()),
      subjects: List.generate(8, (index) => generateSubjectData()),
      grades: ['A+', 'A', 'B+', 'B', 'C', 'D'],
      clubs: List.generate(3, (index) => 'Club ${index + 1}'),
      societies: List.generate(2, (index) => 'Society ${index + 1}'),
      sportsTeams: List.generate(3, (index) => 'Team ${index + 1}'),
      academicEvents: List.generate(3, (index) => generateAcademicEvent()),
      facilitiesAvailable: List.generate(
          5, (index) => faker.lorem.word()),
      laboratoriesAvailable: List.generate(
          2, (index) => faker.lorem.word()),
      sportsFacilities: List.generate(
          4, (index) => faker.sport.name()),
      schoolImagesUrl: List.generate(
          3, (index) => 'https://example.com/image${index + 1}.jpg'), // Replace with dummy URLs
      accreditations: List.generate(2, (index) => generateAccreditation()),
      rankings: List.generate(2, (index) => generateRanking()),
      awards: List.generate(2, (index) => generateAward()),
      holidays: List.generate(5, (index) => 'Holiday ${index + 1}'),
      numberOfBuildings: 3,
      numberOfFloors: 4,
      numberOfClassrooms: 30,
      noOfPeriodsPerDay: 8,
      schoolTimings: generateSchoolTimings(),
      academicYear: generateAcademicYear(),
      // feeStructure: List.generate(3, (index) => generateFeeStructure()),
      feeStructure: [],
      principals: List.generate(1, (index) => generateUserListDetails()),
      vicePrincipals: List.generate(1, (index) => generateUserListDetails()),
      teachers: List.generate(5, (index) => generateUserListDetails()),
      maintenanceStaff: List.generate(2, (index) => generateUserListDetails()),
      drivers: List.generate(1, (index) => generateUserListDetails()),
      securityGuards: List.generate(2, (index) => generateUserListDetails()),
      directors: List.generate(1, (index) => generateUserListDetails()),
      sportsCoaches: List.generate(1, (index) => generateUserListDetails()),
      schoolNurses: List.generate(1, (index) => generateUserListDetails()),
      schoolAdministrators: List.generate(
          1, (index) => generateUserListDetails()),
      itSupportStaff: List.generate(1, (index) => generateUserListDetails()),
      librarians: List.generate(1, (index) => generateUserListDetails()),
      departmentHeads: List.generate(
          2, (index) => generateUserListDetails()),
      guidanceCounselors: List.generate(
          1, (index) => generateUserListDetails()),
      emergencyContactName: faker.person.firstName(),
      emergencyContactPhone: faker.phoneNumber.toString(),
      firstAidFacilities: 'Available',
      primaryColor: Colors.blue,
      secondaryColor: Colors.green,
      managingTrustName: 'Example Trust',
      registeredAddress: faker.address.streetAddress(),
      registeredContactNumber: faker.phoneNumber.toString(),
      totalBoys: 200,
      totalGirls: 180,
      studentTeacherRatio: 20.0,
      scholarshipPrograms: ['Merit-based', 'Need-based'],
      transportationDetails: 'School bus available',
      feePaymentMethods: 'Online, Cash, Check',
      lateFeePolicy: 'Rs. 100 per day',
      curriculumFrameworks: ['National Curriculum', 'International Baccalaureate'],
      languagesOffered: ['English', 'Hindi', 'French'],
      specializedPrograms: ['STEM', 'Arts'],
      hasCCTV: true,
      hasFireSafetyEquipment: true,
      isWheelchairAccessible: true,
      hasSmartClassrooms: true,
      numberOfComputers: 50,
      hasInternetAccess: true,
      onlineLearningPlatform: 'Google Classroom',
      featuredNews: ['Annual Day Celebrations', 'Science Exhibition'],
      importantNotices: ['PTM on 2024-03-15', 'Holiday on 2024-03-25'],
      alumni: List.generate(5, (index) => generateAlumni()),
      feeDueDate: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
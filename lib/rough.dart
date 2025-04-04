

// final faker = Faker();
//
// Future<void> createAndUploadDummyClassRosters(
//     {int numberOfRosters = 5}) async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final List<ClassName> classNames = ClassName.values
//       .where((className) => className != ClassName.other)
//       .toList(); // Exclude 'other' class
//
//   final WriteBatch batch = firestore.batch();
//
//   for (int i = 0; i < numberOfRosters; i++) {
//     final className =
//     classNames[i % classNames.length]; // Cycle through class names
//     for (int sectionIndex = 0; sectionIndex < 3; sectionIndex++) {
//       // Create three sections per class
//       final sectionName =
//       String.fromCharCode('A'.codeUnitAt(0) + sectionIndex);
//       final classRoster =
//       _generateClassRoster(className.label, sectionName, schoolId);
//
//       try {
//         final classRosterDocRef = firestore
//             .collection('rosters')
//             .doc('class_roster')
//             .collection('classes')
//             .doc(classRoster.id);
//         batch.set(classRosterDocRef, classRoster.toMap());
//         print(
//             'Prepared Class Roster: ${classRoster.className} - Section ${classRoster.sectionName}');
//       } catch (e) {
//         print('Error preparing class roster: $e');
//       }
//     }
//   }
//
//   // Commit the batch write
//   try {
//     await batch.commit();
//     print('Finished generating and uploading dummy class rosters.');
//   } catch (e) {
//     print('Error committing batch write: $e');
//   }
// }
//
// ClassRoster _generateClassRoster(
//     String className, String sectionName, String schoolId) {
//   const academicYear = '2024-2025'; // Fixed academic year format
//   final classId = faker.guid.guid();
//
//   return ClassRoster(
//     id: classId,
//     classId: classId,
//     className: className,
//     sectionName: sectionName,
//     academicYear: academicYear,
//     schoolId: schoolId,
//     studentList: List.generate(
//         10, (index) => _generateStudent(className, sectionName, schoolId)),
//   );
// }
//
// UserModel _generateStudent(
//     String className, String sectionName, String schoolId) {
//   final firstName = faker.person.firstName();
//   final lastName = faker.person.lastName();
//   final rollNumber = faker.randomGenerator.integer(50, min: 1).toString();
//   final admissionNo =
//   faker.randomGenerator.integer(5000, min: 1000).toString();
//
//   final height = faker.randomGenerator.decimal(scale: 50, min: 120) + 120;
//   final genderOptions = ['Male', 'Female', 'Other'];
//   final gender = faker.randomGenerator.element(genderOptions);
//
//   final maritalStatusOptions = ['Single', 'Married', 'Divorced', 'Widowed'];
//   final maritalStatus = faker.randomGenerator.element(maritalStatusOptions);
//
//   final dob = faker.date
//       .dateTimeBetween(DateTime(2005, 1, 1), DateTime(2010, 12, 31));
//
//   return UserModel(
//     userId: faker.guid.guid(),
//     username: faker.internet.userName(),
//     fullName: '$firstName $lastName',
//     email: faker.internet.email(),
//     schoolId: schoolId,
//     accountStatus: 'active',
//     profileImageUrl: faker.image.image(),
//     password: faker.internet.password(),
//     points: faker.randomGenerator.integer(100),
//     performanceRating: faker.randomGenerator.decimal(scale: 5),
//     isActive: faker.randomGenerator.boolean(),
//     dob: dob,
//     gender: gender,
//     religion: faker.randomGenerator.element(
//         ['Christianity', 'Islam', 'Hinduism', 'Buddhism', 'Judaism']),
//     category: faker.randomGenerator.element(['General', 'OBC', 'SC', 'ST']),
//     nationality: faker.address.country(),
//     maritalStatus: maritalStatus,
//     phoneNo: faker.phoneNumber.us(), // Ensured valid phone number
//     profileDescription: faker.lorem.sentence(),
//     languagesSpoken: List.generate(
//         faker.randomGenerator.integer(3) + 1, (_) => faker.lorem.word()),
//     hobbies: List.generate(
//         faker.randomGenerator.integer(3) + 1, (_) => faker.lorem.word()),
//     height: height,
//     weight: faker.randomGenerator.decimal(scale: 30, min: 40),
//     bloodGroup: faker.randomGenerator
//         .element(['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']),
//     isPhysicalDisability: faker.randomGenerator.boolean(),
//     permanentAddress: HouseAddress(
//       houseAddress: faker.address.streetAddress(),
//       city: faker.address.city(),
//       district: MyDistrictLists.biharDistricts.isNotEmpty
//           ? MyDistrictLists.biharDistricts[faker.randomGenerator
//           .integer(MyDistrictLists.biharDistricts.length)]
//           : 'Unknown',
//       state: faker.address.state(),
//       pinCode: faker.address.zipCode(),
//     ),
//     currentAddress: HouseAddress(
//       houseAddress: faker.address.streetAddress(),
//       city: faker.address.city(),
//       district: MyDistrictLists.biharDistricts.isNotEmpty
//           ? MyDistrictLists.biharDistricts[faker.randomGenerator
//           .integer(MyDistrictLists.biharDistricts.length)]
//           : 'Unknown',
//       state: faker.address.state(),
//       pinCode: faker.address.zipCode(),
//     ),
//     modeOfTransport:
//     faker.randomGenerator.element(['Bus', 'Car', 'Bike', 'Walk']),
//     transportDetails: TransportDetails(
//       routeNumber: faker.randomGenerator.integer(50).toString(),
//       pickupPoint: faker.address.streetName(),
//       dropOffPoint: faker.address.streetName(),
//       vehicleNumber: faker.vehicle.vin(),
//       fare: faker.randomGenerator.decimal(scale: 10),
//     ),
//     roles: [UserRole.student],
//     studentDetails: StudentDetails(
//       rollNumber: rollNumber,
//       admissionNo: admissionNo,
//       className: className,
//       section: sectionName,
//       admissionDate:
//       faker.date.dateTimeBetween(DateTime(2022), DateTime(2023)),
//       guardian: faker.person.name(),
//     ),
//     emergencyContact: EmergencyContact(
//       fullName: faker.person.name(),
//       relationship: faker.randomGenerator
//           .element(['Father', 'Mother', 'Sibling', 'Friend']),
//       phoneNumber: faker.phoneNumber.us(),
//       emailAddress: faker.internet.email(),
//     ),
//     fatherDetails: GuardianDetails(
//       fullName: faker.person.name(),
//       relationshipToStudent: 'Father',
//       occupation: faker.job.title(),
//       phoneNumber: faker.phoneNumber.us(),
//       emailAddress: faker.internet.email(),
//     ),
//     motherDetails: GuardianDetails(
//       fullName: faker.person.name(),
//       relationshipToStudent: 'Mother',
//       occupation: faker.job.title(),
//       phoneNumber: faker.phoneNumber.us(),
//       emailAddress: faker.internet.email(),
//     ),
//     favorites: Favorite(
//       dish: faker.food.dish(),
//       subject: faker.lorem.word(),
//       teacher: faker.person.name(),
//       book: faker.lorem.word(),
//     ),
//     userAttendance: UserAttendance.empty(
//       academicPeriodStart: DateTime(DateTime.now().year, 1, 1),
//       numberOfDays: 365,
//     ),
//     createdAt: DateTime.now(),
//     qualifications: [
//       Qualification(
//         degreeName: faker.lorem.word(),
//         institutionName: faker.company.name(),
//         passingYear: (DateTime.now().year - faker.randomGenerator.integer(5))
//             .toString(),
//         majorSubject: faker.lorem.word(),
//         resultType: 'Percentage',
//         result: faker.randomGenerator.decimal(scale: 100).toString(),
//       ),
//     ],
//     joiningDate: DateTime.now(),
//     permissions: [],
//   );
// }
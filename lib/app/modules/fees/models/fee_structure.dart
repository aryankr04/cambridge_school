import '../fee_structure/models/admission_fee_structure_model.dart';
import '../fee_structure/models/books_and_stationary_fee_structure_model.dart';
import '../fee_structure/models/hostel_fee_structure_model.dart';
import '../fee_structure/models/late_fee_structure_model.dart';
import '../fee_structure/models/other_fee_structure_model.dart';
import '../fee_structure/models/re_admission_fee_structure_model.dart';
import '../fee_structure/models/registration_fee_structure_model.dart';
import '../fee_structure/models/transport_fee_structure_model.dart';
import '../fee_structure/models/tuition_fee_structure_model.dart';
import '../fee_structure/models/uniform_fee_structure_model.dart';

class FeeStructure {
  String year;
  TuitionFeeStructure? tuitionFeeStructure;
  TransportFeeStructure? transportFeeStructure;
  AdmissionFeeStructure? admissionFeeStructure;
  ReAdmissionFeeStructure? reAdmissionFeeStructure;
  RegistrationFeeStructure? registrationFeeStructure;
  LateFeeStructure? lateFeeStructure;
  BooksAndStationeryFeeStructure? booksAndStationeryFeeStructure;
  HostelFeeStructure? hostelFeeStructure;
  UniformFeeStructure? uniformFeeStructure;
  OtherFeeStructure? otherFeeStructure;

  FeeStructure({
    required this.year,
    this.tuitionFeeStructure,
    this.transportFeeStructure,
    this.admissionFeeStructure,
    this.reAdmissionFeeStructure,
    this.registrationFeeStructure,
    this.lateFeeStructure,
    this.booksAndStationeryFeeStructure,
    this.hostelFeeStructure,
    this.uniformFeeStructure,
    this.otherFeeStructure,
  });

  // Method to convert FeeStructure to a Map
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'tuitionFeeStructure': tuitionFeeStructure?.toMap(),
      'transportFeeStructure': transportFeeStructure?.toMap(),
      'admissionFeeStructure': admissionFeeStructure?.toMap(),
      'reAdmissionFeeStructure': reAdmissionFeeStructure?.toMap(),
      'registrationFeeStructure': registrationFeeStructure?.toMap(),
      'lateFeeStructure': lateFeeStructure?.toMap(),
      'booksAndStationeryFeeStructure': booksAndStationeryFeeStructure?.toMap(),
      'hostelFeeStructure': hostelFeeStructure?.toMap(),
      'uniformFeeStructure': uniformFeeStructure?.toMap(),
      'otherFeeStructure': otherFeeStructure?.toMap(),
    };
  }

  // Method to create FeeStructure from a Map
  factory FeeStructure.fromMap(Map<String, dynamic>? map) {
    if(map == null){
      return FeeStructure(year: ''); // Or throw an exception, depending on your needs
    }
    return FeeStructure(
      year: map['year'] as String? ?? '',
      tuitionFeeStructure:
      TuitionFeeStructure.fromMap(map['tuitionFeeStructure'] as Map<String, dynamic>? ?? {}),
      transportFeeStructure: map['transportFeeStructure'] != null
          ? TransportFeeStructure.fromMap(map['transportFeeStructure'] as Map<String, dynamic>? ?? {})
          : null,
      admissionFeeStructure: map['admissionFeeStructure'] != null
          ? AdmissionFeeStructure.fromMap(map['admissionFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      reAdmissionFeeStructure: map['reAdmissionFeeStructure'] != null
          ? ReAdmissionFeeStructure.fromMap(map['reAdmissionFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      registrationFeeStructure: map['registrationFeeStructure'] != null
          ? RegistrationFeeStructure.fromMap(map['registrationFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      lateFeeStructure: map['lateFeeStructure'] != null
          ? LateFeeStructure.fromMap(map['lateFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      booksAndStationeryFeeStructure:
      map['booksAndStationeryFeeStructure'] != null
          ? BooksAndStationeryFeeStructure.fromMap(
          map['booksAndStationeryFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      hostelFeeStructure: map['hostelFeeStructure'] != null
          ? HostelFeeStructure.fromMap(map['hostelFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      uniformFeeStructure: map['uniformFeeStructure'] != null
          ? UniformFeeStructure.fromMap(map['uniformFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
      otherFeeStructure: map['otherFeeStructure'] != null
          ? OtherFeeStructure.fromMap(map['otherFeeStructure']as Map<String, dynamic>? ?? {})
          : null,
    );
  }
}
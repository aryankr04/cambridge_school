import 'package:flutter/material.dart';

// lib/app_enums.dart

// Yes/No Options
enum YesNoOptions { yes, no }

// Marital Status Options
enum MaritalStatusOptions { single, married, divorced, widowed }

// Subject Options (Examples)

// Exam Pattern Options
enum ExamPatternOptions { semester, annual, trimester }

// Grading System Options
enum GradingSystemOptions { percentage, letterGrade, cgpa, points }

// Day Options
enum DayOptions { monday, tuesday, wednesday, thursday, friday, saturday, sunday }



// School Activity Options (Examples)
enum SchoolActivityOptions { sports, drama, musicClub, debateClub, scienceFair, artClub }

// School Board Options (Examples)
enum SchoolBoardOptions { cbse, icse, stateBoard, ib, cambridge }

// School Type Options
enum SchoolTypeOptions { public, private, boarding, international }

// Schooling System Options (Examples)
enum SchoolingSystemOptions { montessori, traditional, waldorf }

// Height (Simple Example)
enum Height { short, average, tall }

// Blood Group Options
enum BloodGroupOptions { aPositive, aNegative, bPositive, bNegative, abPositive, abNegative, oPositive, oNegative }

// Language Options (Examples)
enum LanguageOptions { english, spanish, french, german, hindi, chinese }

// Mode of Transport Options
enum ModeOfTransportOptions { bus, car, train, bike, walking, scooter }

// Holiday Type Options
enum HolidayTypeOptions { national, religious, school, public }

// Religion Options
enum ReligionOptions {
  christianity,
  islam,
  hinduism,
  buddhism,
  judaism,
  sikhism,
  atheism,
  agnosticism,
  other
}

// Medical Condition Options (Examples)
enum MedicalConditionOptions { allergy, asthma, diabetes, epilepsy, heartCondition }

// Grade Options (Examples)
enum GradeOptions { aPlus, a, bPlus, b, cPlus, c, d, f }

// Disciplinary Actions Options (Examples)
enum DisciplinaryActionsOptions { warning, detention, suspension, expulsion }

// Family Income Ranges Options (Examples)
enum FamilyIncomeRangesOptions { belowPovertyLine, lowIncome, middleIncome, upperMiddleIncome, highIncome }

extension EnumExtension on Enum {
  // Helper function to get string values for enums
  String get value {
    switch (runtimeType) {
      case YesNoOptions:
        return _yesNoOptionsValues[this] ?? name;
      case MaritalStatusOptions:
        return _maritalStatusValues[this] ?? name;
      case ExamPatternOptions:
        return _examPatternValues[this] ?? name;
      case GradingSystemOptions:
        return _gradingSystemValues[this] ?? name;
      case DayOptions:
        return _dayValues[this] ?? name;
      case SchoolActivityOptions:
        return _schoolActivityValues[this] ?? name;
      case SchoolBoardOptions:
        return _schoolBoardValues[this] ?? name;
      case SchoolTypeOptions:
        return _schoolTypeValues[this] ?? name;
      case SchoolingSystemOptions:
        return _schoolingSystemValues[this] ?? name;
      case Height:
        return _heightValues[this] ?? name;
      case BloodGroupOptions:
        return _bloodGroupValues[this] ?? name;
      case LanguageOptions:
        return _languageValues[this] ?? name;
      case ModeOfTransportOptions:
        return _modeOfTransportValues[this] ?? name;
      case HolidayTypeOptions:
        return _holidayTypeValues[this] ?? name;
      case ReligionOptions:
        return _religionValues[this] ?? name;
      case MedicalConditionOptions:
        return _medicalConditionValues[this] ?? name;
      case GradeOptions:
        return _gradeValues[this] ?? name;
      case DisciplinaryActionsOptions:
        return _disciplinaryActionsValues[this] ?? name;
      case FamilyIncomeRangesOptions:
        return _familyIncomeRangesValues[this] ?? name;
      default:
        return name; // Default to enum name
    }
  }

  String get iconString {
    switch (runtimeType) {
      case YesNoOptions:
        return _yesNoOptionsIcons[this] ?? '❓';
      case MaritalStatusOptions:
        return _maritalStatusIcons[this] ?? '❓';

      case ExamPatternOptions:
        return _examPatternIcons[this] ?? '❓';
      case GradingSystemOptions:
        return _gradingSystemIcons[this] ?? '❓';
      case DayOptions:
        return _dayIcons[this] ?? '❓';
      case SchoolActivityOptions:
        return _schoolActivityIcons[this] ?? '❓';
      case SchoolBoardOptions:
        return _schoolBoardIcons[this] ?? '❓';
      case SchoolTypeOptions:
        return _schoolTypeIcons[this] ?? '❓';
      case SchoolingSystemOptions:
        return _schoolingSystemIcons[this] ?? '❓';
      case Height:
        return _heightIcons[this] ?? '❓';
      case BloodGroupOptions:
        return _bloodGroupIcons[this] ?? '❓';
      case LanguageOptions:
        return _languageIcons[this] ?? '❓';
      case ModeOfTransportOptions:
        return _modeOfTransportIcons[this] ?? '❓';
      case HolidayTypeOptions:
        return _holidayTypeIcons[this] ?? '❓';
      case ReligionOptions:
        return _religionIcons[this] ?? '❓';
      case MedicalConditionOptions:
        return _medicalConditionIcons[this] ?? '❓';
      case GradeOptions:
        return _gradeIcons[this] ?? '❓';
      case DisciplinaryActionsOptions:
        return _disciplinaryActionsIcons[this] ?? '❓';
      case FamilyIncomeRangesOptions:
        return _familyIncomeRangesIcons[this] ?? '❓';
      default:
        return '❓'; // Default to question mark
    }
  }

  IconData get icon {
    switch (runtimeType) {
      case YesNoOptions:
        return _yesNoOptionsIconData[this] ?? Icons.error_outline;
      case MaritalStatusOptions _:
        return _maritalStatusIconData[this] ?? Icons.error_outline;

      case ExamPatternOptions:
        return _examPatternIconData[this] ?? Icons.error_outline;
      case GradingSystemOptions:
        return _gradingSystemIconData[this] ?? Icons.error_outline;
      case DayOptions:
        return _dayIconData[this] ?? Icons.error_outline;
      case SchoolActivityOptions:
        return _schoolActivityIconData[this] ?? Icons.error_outline;
      case SchoolBoardOptions:
        return _schoolBoardIconData[this] ?? Icons.error_outline;
      case SchoolTypeOptions:
        return _schoolTypeIconData[this] ?? Icons.error_outline;
      case SchoolingSystemOptions:
        return _schoolingSystemIconData[this] ?? Icons.error_outline;
      case Height:
        return _heightIconData[this] ?? Icons.error_outline;
      case BloodGroupOptions:
        return _bloodGroupIconData[this] ?? Icons.error_outline;
      case LanguageOptions:
        return _languageIconData[this] ?? Icons.error_outline;
      case ModeOfTransportOptions:
        return _modeOfTransportIconData[this] ?? Icons.error_outline;
      case HolidayTypeOptions:
        return _holidayTypeIconData[this] ?? Icons.error_outline;
      case ReligionOptions:
        return _religionIconData[this] ?? Icons.error_outline;
      case MedicalConditionOptions:
        return _medicalConditionIconData[this] ?? Icons.error_outline;
      case GradeOptions:
        return _gradeIconData[this] ?? Icons.error_outline;
      case DisciplinaryActionsOptions:
        return _disciplinaryActionsIconData[this] ?? Icons.error_outline;
      case FamilyIncomeRangesOptions:
        return _familyIncomeRangesIconData[this] ?? Icons.error_outline;
      default:
        return Icons.error_outline; // Default error icon
    }
  }

  // --- Value Maps ---
  static const Map<YesNoOptions, String> _yesNoOptionsValues = {
    YesNoOptions.yes: 'Yes',
    YesNoOptions.no: 'No',
  };

  static const Map<MaritalStatusOptions, String> _maritalStatusValues = {
    MaritalStatusOptions.single: 'Single',
    MaritalStatusOptions.married: 'Married',
    MaritalStatusOptions.divorced: 'Divorced',
    MaritalStatusOptions.widowed: 'Widowed',
  };


  static const Map<ExamPatternOptions, String> _examPatternValues = {
    ExamPatternOptions.semester: 'Semester',
    ExamPatternOptions.annual: 'Annual',
    ExamPatternOptions.trimester: 'Trimester',
  };

  static const Map<GradingSystemOptions, String> _gradingSystemValues = {
    GradingSystemOptions.percentage: 'Percentage',
    GradingSystemOptions.letterGrade: 'Letter Grade',
    GradingSystemOptions.cgpa: 'CGPA',
    GradingSystemOptions.points: 'Points',
  };

  static const Map<DayOptions, String> _dayValues = {
    DayOptions.monday: 'Monday',
    DayOptions.tuesday: 'Tuesday',
    DayOptions.wednesday: 'Wednesday',
    DayOptions.thursday: 'Thursday',
    DayOptions.friday: 'Friday',
    DayOptions.saturday: 'Saturday',
    DayOptions.sunday: 'Sunday',
  };


  static const Map<SchoolActivityOptions, String> _schoolActivityValues = {
    SchoolActivityOptions.sports: 'Sports',
    SchoolActivityOptions.drama: 'Drama',
    SchoolActivityOptions.musicClub: 'Music Club',
    SchoolActivityOptions.debateClub: 'Debate Club',
    SchoolActivityOptions.scienceFair: 'Science Fair',
    SchoolActivityOptions.artClub: 'Art Club',
  };

  static const Map<SchoolBoardOptions, String> _schoolBoardValues = {
    SchoolBoardOptions.cbse: 'CBSE',
    SchoolBoardOptions.icse: 'ICSE',
    SchoolBoardOptions.stateBoard: 'State Board',
    SchoolBoardOptions.ib: 'IB',
    SchoolBoardOptions.cambridge: 'Cambridge',
  };

  static const Map<SchoolTypeOptions, String> _schoolTypeValues = {
    SchoolTypeOptions.public: 'Public',
    SchoolTypeOptions.private: 'Private',
    SchoolTypeOptions.boarding: 'Boarding',
    SchoolTypeOptions.international: 'International',
  };

  static const Map<SchoolingSystemOptions, String> _schoolingSystemValues = {
    SchoolingSystemOptions.montessori: 'Montessori',
    SchoolingSystemOptions.traditional: 'Traditional',
    SchoolingSystemOptions.waldorf: 'Waldorf',
  };

  static const Map<Height, String> _heightValues = {
    Height.short: 'Short',
    Height.average: 'Average',
    Height.tall: 'Tall',
  };

  static const Map<BloodGroupOptions, String> _bloodGroupValues = {
    BloodGroupOptions.aPositive: 'A+',
    BloodGroupOptions.aNegative: 'A-',
    BloodGroupOptions.bPositive: 'B+',
    BloodGroupOptions.bNegative: 'B-',
    BloodGroupOptions.abPositive: 'AB+',
    BloodGroupOptions.abNegative: 'AB-',
    BloodGroupOptions.oPositive: 'O+',
    BloodGroupOptions.oNegative: 'O-',
  };

  static const Map<LanguageOptions, String> _languageValues = {
    LanguageOptions.english: 'English',
    LanguageOptions.spanish: 'Spanish',
    LanguageOptions.french: 'French',
    LanguageOptions.german: 'German',
    LanguageOptions.hindi: 'Hindi',
    LanguageOptions.chinese: 'Chinese',
  };

  static const Map<ModeOfTransportOptions, String> _modeOfTransportValues = {
    ModeOfTransportOptions.bus: 'Bus',
    ModeOfTransportOptions.car: 'Car',
    ModeOfTransportOptions.train: 'Train',
    ModeOfTransportOptions.bike: 'Bike',
    ModeOfTransportOptions.walking: 'Walking',
    ModeOfTransportOptions.scooter: 'Scooter',
  };

  static const Map<HolidayTypeOptions, String> _holidayTypeValues = {
    HolidayTypeOptions.national: 'National',
    HolidayTypeOptions.religious: 'Religious',
    HolidayTypeOptions.school: 'School',
    HolidayTypeOptions.public: 'Public',
  };

  static const Map<ReligionOptions, String> _religionValues = {
    ReligionOptions.christianity: 'Christianity',
    ReligionOptions.islam: 'Islam',
    ReligionOptions.hinduism: 'Hinduism',
    ReligionOptions.buddhism: 'Buddhism',
    ReligionOptions.judaism: 'Judaism',
    ReligionOptions.sikhism: 'Sikhism',
    ReligionOptions.atheism: 'Atheism',
    ReligionOptions.agnosticism: 'Agnosticism',
    ReligionOptions.other: 'Other',
  };

  static const Map<MedicalConditionOptions, String> _medicalConditionValues = {
    MedicalConditionOptions.allergy: 'Allergy',
    MedicalConditionOptions.asthma: 'Asthma',
    MedicalConditionOptions.diabetes: 'Diabetes',
    MedicalConditionOptions.epilepsy: 'Epilepsy',
    MedicalConditionOptions.heartCondition: 'Heart Condition',
  };

  static const Map<GradeOptions, String> _gradeValues = {
    GradeOptions.aPlus: 'A+',
    GradeOptions.a: 'A',
    GradeOptions.bPlus: 'B+',
    GradeOptions.b: 'B',
    GradeOptions.cPlus: 'C+',
    GradeOptions.c: 'C',
    GradeOptions.d: 'D',
    GradeOptions.f: 'F',
  };

  static const Map<DisciplinaryActionsOptions, String> _disciplinaryActionsValues = {
    DisciplinaryActionsOptions.warning: 'Warning',
    DisciplinaryActionsOptions.detention: 'Detention',
    DisciplinaryActionsOptions.suspension: 'Suspension',
    DisciplinaryActionsOptions.expulsion: 'Expulsion',
  };

  static const Map<FamilyIncomeRangesOptions, String> _familyIncomeRangesValues = {
    FamilyIncomeRangesOptions.belowPovertyLine: 'Below Poverty Line',
    FamilyIncomeRangesOptions.lowIncome: 'Low Income',
    FamilyIncomeRangesOptions.middleIncome: 'Middle Income',
    FamilyIncomeRangesOptions.upperMiddleIncome: 'Upper Middle Income',
    FamilyIncomeRangesOptions.highIncome: 'High Income',
  };

  // --- Icon Maps ---
  static const Map<YesNoOptions, String> _yesNoOptionsIcons = {
    YesNoOptions.yes: '✅',
    YesNoOptions.no: '❌',
  };

  static const Map<MaritalStatusOptions, String> _maritalStatusIcons = {
    MaritalStatusOptions.single: '🧍',
    MaritalStatusOptions.married: '👩‍❤️‍👨',
    MaritalStatusOptions.divorced: '💔',
    MaritalStatusOptions.widowed: '🕊️',
  };


  static const Map<ExamPatternOptions, String> _examPatternIcons = {
    ExamPatternOptions.semester: '📅',
    ExamPatternOptions.annual: '🗓️',
    ExamPatternOptions.trimester: '🕒',
  };

  static const Map<GradingSystemOptions, String> _gradingSystemIcons = {
    GradingSystemOptions.percentage: '💯',
    GradingSystemOptions.letterGrade: '🅰️',
    GradingSystemOptions.cgpa: '🔢',
    GradingSystemOptions.points: '📍',
  };

  static const Map<DayOptions, String> _dayIcons = {
    DayOptions.monday: '1️⃣',
    DayOptions.tuesday: '2️⃣',
    DayOptions.wednesday: '3️⃣',
    DayOptions.thursday: '4️⃣',
    DayOptions.friday: '5️⃣',
    DayOptions.saturday: '6️⃣',
    DayOptions.sunday: '7️⃣',
  };

  static const Map<SchoolActivityOptions, String> _schoolActivityIcons = {
    SchoolActivityOptions.sports: '⚽',
    SchoolActivityOptions.drama: '🎭',
    SchoolActivityOptions.musicClub: '🎼',
    SchoolActivityOptions.debateClub: '🗣️',
    SchoolActivityOptions.scienceFair: '🔬',
    SchoolActivityOptions.artClub: '🖼️',
  };

  static const Map<SchoolBoardOptions, String> _schoolBoardIcons = {
    SchoolBoardOptions.cbse: '🏫',
    SchoolBoardOptions.icse: '🏫',
    SchoolBoardOptions.stateBoard: '🏫',
    SchoolBoardOptions.ib: '🏫',
    SchoolBoardOptions.cambridge: '🏫',
  };

  static const Map<SchoolTypeOptions, String> _schoolTypeIcons = {
    SchoolTypeOptions.public: '🏛️',
    SchoolTypeOptions.private: '🏢',
    SchoolTypeOptions.boarding: '🛌',
    SchoolTypeOptions.international: '🌐',
  };

  static const Map<SchoolingSystemOptions, String> _schoolingSystemIcons = {
    SchoolingSystemOptions.montessori: '🧑‍🏫',
    SchoolingSystemOptions.traditional: '🧑‍🏫',
    SchoolingSystemOptions.waldorf: '🧑‍🏫',
  };

  static const Map<Height, String> _heightIcons = {
    Height.short: '🧍',
    Height.average: '🧍‍♀️',
    Height.tall: '🧍‍♂️',
  };

  static const Map<BloodGroupOptions, String> _bloodGroupIcons = {
    BloodGroupOptions.aPositive: '🩸',
    BloodGroupOptions.aNegative: '🩸',
    BloodGroupOptions.bPositive: '🩸',
    BloodGroupOptions.bNegative: '🩸',
    BloodGroupOptions.abPositive: '🩸',
    BloodGroupOptions.abNegative: '🩸',
    BloodGroupOptions.oPositive: '🩸',
    BloodGroupOptions.oNegative: '🩸',
  };

  static const Map<LanguageOptions, String> _languageIcons = {
    LanguageOptions.english: '💬',
    LanguageOptions.spanish: '💬',
    LanguageOptions.french: '💬',
    LanguageOptions.german: '💬',
    LanguageOptions.hindi: '💬',
    LanguageOptions.chinese: '💬',
  };

  static const Map<ModeOfTransportOptions, String> _modeOfTransportIcons = {
    ModeOfTransportOptions.bus: '🚌',
    ModeOfTransportOptions.car: '🚗',
    ModeOfTransportOptions.train: '🚆',
    ModeOfTransportOptions.bike: '🚲',
    ModeOfTransportOptions.walking: '🚶',
    ModeOfTransportOptions.scooter: '🛴',
  };

  static const Map<HolidayTypeOptions, String> _holidayTypeIcons = {
    HolidayTypeOptions.national: '🎉',
    HolidayTypeOptions.religious: '🎉',
    HolidayTypeOptions.school: '🎉',
    HolidayTypeOptions.public: '🎉',
  };

  static const Map<ReligionOptions, String> _religionIcons = {
    ReligionOptions.christianity: '🙏',
    ReligionOptions.islam: '🙏',
    ReligionOptions.hinduism: '🙏',
    ReligionOptions.buddhism: '🙏',
    ReligionOptions.judaism: '🙏',
    ReligionOptions.sikhism: '🙏',
    ReligionOptions.atheism: '🙏',
    ReligionOptions.agnosticism: '🙏',
    ReligionOptions.other: '🙏',
  };

  static const Map<MedicalConditionOptions, String> _medicalConditionIcons = {
    MedicalConditionOptions.allergy: '🩺',
    MedicalConditionOptions.asthma: '🩺',
    MedicalConditionOptions.diabetes: '🩺',
    MedicalConditionOptions.epilepsy: '🩺',
    MedicalConditionOptions.heartCondition: '🩺',
  };

  static const Map<GradeOptions, String> _gradeIcons = {
    GradeOptions.aPlus: '💯',
    GradeOptions.a: '💯',
    GradeOptions.bPlus: '💯',
    GradeOptions.b: '💯',
    GradeOptions.cPlus: '💯',
    GradeOptions.c: '💯',
    GradeOptions.d: '💯',
    GradeOptions.f: '💯',
  };

  static const Map<DisciplinaryActionsOptions, String> _disciplinaryActionsIcons = {
    DisciplinaryActionsOptions.warning: '⚠️',
    DisciplinaryActionsOptions.detention: '⏳',
    DisciplinaryActionsOptions.suspension: '🚫',
    DisciplinaryActionsOptions.expulsion: '🚪',
  };

  static const Map<FamilyIncomeRangesOptions, String> _familyIncomeRangesIcons = {
    FamilyIncomeRangesOptions.belowPovertyLine: '🏚️',
    FamilyIncomeRangesOptions.lowIncome: '🏠',
    FamilyIncomeRangesOptions.middleIncome: '🏘️',
    FamilyIncomeRangesOptions.upperMiddleIncome: '🏡',
    FamilyIncomeRangesOptions.highIncome: '🏰',
  };

  // --- IconData Maps ---
  static const Map<YesNoOptions, IconData> _yesNoOptionsIconData = {
    YesNoOptions.yes: Icons.check,
    YesNoOptions.no: Icons.close,
  };

  static const Map<MaritalStatusOptions, IconData> _maritalStatusIconData = {
    MaritalStatusOptions.single: Icons.person,
    MaritalStatusOptions.married: Icons.wc,
    MaritalStatusOptions.divorced: Icons.remove_circle_outline,
    MaritalStatusOptions.widowed: Icons.sentiment_dissatisfied,
  };

  static const Map<ExamPatternOptions, IconData> _examPatternIconData = {
    ExamPatternOptions.semester: Icons.calendar_view_month,
    ExamPatternOptions.annual: Icons.calendar_today,
    ExamPatternOptions.trimester: Icons.timelapse,
  };

  static const Map<GradingSystemOptions, IconData> _gradingSystemIconData = {
    GradingSystemOptions.percentage: Icons.percent,
    GradingSystemOptions.letterGrade: Icons.sort_by_alpha,
    GradingSystemOptions.cgpa: Icons.format_list_numbered,
    GradingSystemOptions.points: Icons.stars,
  };

  static const Map<DayOptions, IconData> _dayIconData = {
    DayOptions.monday: Icons.looks_one,
    DayOptions.tuesday: Icons.looks_two,
    DayOptions.wednesday: Icons.looks_3,
    DayOptions.thursday: Icons.looks_4,
    DayOptions.friday: Icons.looks_5,
    DayOptions.saturday: Icons.looks_6,
    DayOptions.sunday: Icons.wb_sunny,
  };


  static const Map<SchoolActivityOptions, IconData> _schoolActivityIconData = {
    SchoolActivityOptions.sports: Icons.fitness_center,
    SchoolActivityOptions.drama: Icons.theaters,
    SchoolActivityOptions.musicClub: Icons.library_music,
    SchoolActivityOptions.debateClub: Icons.record_voice_over,
    SchoolActivityOptions.scienceFair: Icons.biotech,
    SchoolActivityOptions.artClub: Icons.palette,
  };

  static const Map<SchoolBoardOptions, IconData> _schoolBoardIconData = {
    SchoolBoardOptions.cbse: Icons.school,
    SchoolBoardOptions.icse: Icons.school,
    SchoolBoardOptions.stateBoard: Icons.school,
    SchoolBoardOptions.ib: Icons.school,
    SchoolBoardOptions.cambridge: Icons.school,
  };

  static const Map<SchoolTypeOptions, IconData> _schoolTypeIconData = {
    SchoolTypeOptions.public: Icons.public,
    SchoolTypeOptions.private: Icons.home,
    SchoolTypeOptions.boarding: Icons.hotel,
    SchoolTypeOptions.international: Icons.language,
  };

  static const Map<SchoolingSystemOptions, IconData> _schoolingSystemIconData = {
    SchoolingSystemOptions.montessori: Icons.menu_book,
    SchoolingSystemOptions.traditional: Icons.menu_book,
    SchoolingSystemOptions.waldorf: Icons.menu_book,
  };

  static const Map<Height, IconData> _heightIconData = {
    Height.short: Icons.height,
    Height.average: Icons.accessibility,
    Height.tall: Icons.trending_up,
  };

  static const Map<BloodGroupOptions, IconData> _bloodGroupIconData = {
    BloodGroupOptions.aPositive: Icons.local_hospital,
    BloodGroupOptions.aNegative: Icons.local_hospital,
    BloodGroupOptions.bPositive: Icons.local_hospital,
    BloodGroupOptions.bNegative: Icons.local_hospital,
    BloodGroupOptions.abPositive: Icons.local_hospital,
    BloodGroupOptions.abNegative: Icons.local_hospital,
    BloodGroupOptions.oPositive: Icons.local_hospital,
    BloodGroupOptions.oNegative: Icons.local_hospital,
  };

  static const Map<LanguageOptions, IconData> _languageIconData = {
    LanguageOptions.english: Icons.translate,
    LanguageOptions.spanish: Icons.translate,
    LanguageOptions.french: Icons.translate,
    LanguageOptions.german: Icons.translate,
    LanguageOptions.hindi: Icons.translate,
    LanguageOptions.chinese: Icons.translate,
  };

  static const Map<ModeOfTransportOptions, IconData> _modeOfTransportIconData = {
    ModeOfTransportOptions.bus: Icons.directions_bus,
    ModeOfTransportOptions.car: Icons.directions_car,
    ModeOfTransportOptions.train: Icons.directions_railway,
    ModeOfTransportOptions.bike: Icons.directions_bike,
    ModeOfTransportOptions.walking: Icons.directions_walk,
    ModeOfTransportOptions.scooter: Icons.electric_scooter,
  };

  static const Map<HolidayTypeOptions, IconData> _holidayTypeIconData = {
    HolidayTypeOptions.national: Icons.celebration,
    HolidayTypeOptions.religious: Icons.celebration,
    HolidayTypeOptions.school: Icons.celebration,
    HolidayTypeOptions.public: Icons.celebration,
  };

  static const Map<ReligionOptions, IconData> _religionIconData = {
    ReligionOptions.christianity: Icons.flag,
    ReligionOptions.islam: Icons.flag,
    ReligionOptions.hinduism: Icons.flag,
    ReligionOptions.buddhism: Icons.flag,
    ReligionOptions.judaism: Icons.flag,
    ReligionOptions.sikhism: Icons.flag,
    ReligionOptions.atheism: Icons.flag,
    ReligionOptions.agnosticism: Icons.flag,
    ReligionOptions.other: Icons.flag,
  };

  static const Map<MedicalConditionOptions, IconData> _medicalConditionIconData = {
    MedicalConditionOptions.allergy: Icons.medical_services,
    MedicalConditionOptions.asthma: Icons.medical_services,
    MedicalConditionOptions.diabetes: Icons.medical_services,
    MedicalConditionOptions.epilepsy: Icons.medical_services,
    MedicalConditionOptions.heartCondition: Icons.medical_services,
  };

  static const Map<GradeOptions, IconData> _gradeIconData = {
    GradeOptions.aPlus: Icons.grade,
    GradeOptions.a: Icons.grade,
    GradeOptions.bPlus: Icons.grade,
    GradeOptions.b: Icons.grade,
    GradeOptions.cPlus: Icons.grade,
    GradeOptions.c: Icons.grade,
    GradeOptions.d: Icons.grade,
    GradeOptions.f: Icons.grade,
  };

  static const Map<DisciplinaryActionsOptions, IconData> _disciplinaryActionsIconData = {
    DisciplinaryActionsOptions.warning: Icons.warning,
    DisciplinaryActionsOptions.detention: Icons.timer,
    DisciplinaryActionsOptions.suspension: Icons.cancel,
    DisciplinaryActionsOptions.expulsion: Icons.exit_to_app,
  };

  static const Map<FamilyIncomeRangesOptions, IconData> _familyIncomeRangesIconData = {
    FamilyIncomeRangesOptions.belowPovertyLine: Icons.monetization_on,
    FamilyIncomeRangesOptions.lowIncome: Icons.monetization_on,
    FamilyIncomeRangesOptions.middleIncome: Icons.monetization_on,
    FamilyIncomeRangesOptions.upperMiddleIncome: Icons.monetization_on,
    FamilyIncomeRangesOptions.highIncome: Icons.monetization_on,
  };
}
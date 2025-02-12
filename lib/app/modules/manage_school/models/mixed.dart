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
}

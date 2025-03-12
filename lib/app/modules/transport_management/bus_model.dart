class Bus {
  final String busId;
  final String busNumber;
  final String driverName;
  final String driverPhone;
  final String routeId;
  final double currentLatitude;
  final double currentLongitude;
  final int lastUpdated; // Timestamp of the last location update

  Bus({
    required this.busId,
    required this.busNumber,
    required this.driverName,
    required this.driverPhone,
    required this.routeId,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.lastUpdated,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'busNumber': busNumber,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'routeId': routeId,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'lastUpdated': lastUpdated,
    };
  }

  // Convert from Firestore JSON
  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['busId'],
      busNumber: json['busNumber'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      routeId: json['routeId'],
      currentLatitude: json['currentLatitude'],
      currentLongitude: json['currentLongitude'],
      lastUpdated: json['lastUpdated'],
    );
  }
}

class Route {
  final String routeId;
  final String routeName;
  final List<BusStop> stops; // List of bus stops along the route

  Route({
    required this.routeId,
    required this.routeName,
    required this.stops,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'routeName': routeName,
      'stops': stops.map((stop) => stop.toJson()).toList(),
    };
  }

  // Convert from Firestore JSON
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeId: json['routeId'],
      routeName: json['routeName'],
      stops: (json['stops'] as List)
          .map((stop) => BusStop.fromJson(stop))
          .toList(),
    );
  }
}

class BusStop {
  final String stopId;
  final String stopName;
  final double latitude;
  final double longitude;
  final int estimatedArrivalTime; // Time in minutes from the start of the route

  BusStop({
    required this.stopId,
    required this.stopName,
    required this.latitude,
    required this.longitude,
    required this.estimatedArrivalTime,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'stopId': stopId,
      'stopName': stopName,
      'latitude': latitude,
      'longitude': longitude,
      'estimatedArrivalTime': estimatedArrivalTime,
    };
  }

  // Convert from JSON
  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      stopId: json['stopId'],
      stopName: json['stopName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      estimatedArrivalTime: json['estimatedArrivalTime'],
    );
  }
}

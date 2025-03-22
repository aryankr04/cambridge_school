class SchoolSubjects {
  static final Map<String, String> _subjects = {
    // Foundational Subjects
    "Mathematics": "🔢",
    "Science": "🔬",
    "English": "📖",
    "Social Studies": "🌍",
    "Foreign Language": "🗣️",

    // Sciences
    "Physics": "⚛️",
    "Chemistry": "🧪",
    "Biology": "🦠",
    "Environmental Science": "🌱",
    "Geology": "⛰️",
    "Astronomy": "🔭",
    "Marine Biology": "🐠",
    "Botany": "🌿",
    "Zoology": "🦓",
    "Biochemistry": "🧬",
    "Genetics": "🧪",
    "Neuroscience": "🧠",

    // History & Social Sciences
    "History": "🏰",
    "Geography": "🗺️",
    "Political Science": "⚖️",
    "Sociology": "👥",
    "Psychology": "🧠",
    "Anthropology": "🦴",
    "Archaeology": "🏺",
    "Economics": "💰",
    "Law": "⚖️",
    "Philosophy": "🤔",
    "Theology": "⛪",
    "Linguistics": "📝",

    // Arts & Humanities
    "Arts": "🎨",
    "Music": "🎵",
    "Drama": "🎭",
    "Creative Writing": "✍️",
    "Journalism": "📰",
    "Communications": "📡",
    "Film Production": "🎬",
    "Photography": "📸",
    "Graphic Design": "🖌️",
    "Interior Design": "🏠",
    "Fashion Design": "👗",
    "Architecture": "🏗️",

    // Business & Management
    "Accounting": "📊",
    "Finance": "💵",
    "Marketing": "📢",
    "Business Administration": "🏢",
    "Management": "📈",
    "Human Resources": "👥",
    "Project Management": "📋",
    "Supply Chain Management": "🚛",
    "Logistics": "📦",
    "Business Intelligence": "📊",

    // Technology & Engineering
    "Computer Science": "💻",
    "Information Technology": "🖥️",
    "Software Engineering": "👨‍💻",
    "Electrical Engineering": "⚡",
    "Mechanical Engineering": "⚙️",
    "Civil Engineering": "🏗️",
    "Chemical Engineering": "🧪",
    "Aerospace Engineering": "✈️",
    "Biomedical Engineering": "🦾",
    "Industrial Engineering": "🏭",
    "Robotics": "🤖",
    "Artificial Intelligence": "🧠",
    "Cybersecurity": "🔒",
    "Data Science": "📊",
    "Database Management": "🗄️",
    "Network Administration": "🌐",
    "Telecommunications Engineering": "📡",
    "Materials Science": "🔬",
    "Nanotechnology": "🧫",
    "Nuclear Engineering": "☢️",
    "Petroleum Engineering": "⛽",
    "Mining Engineering": "⛏️",
    "Geoinformatics": "🗺️",
    "Remote Sensing": "🛰️",
    "Web Development": "🌍",
    "Mobile App Development": "📱",
    "Game Development": "🎮",

    // Health & Medicine
    "Medicine": "🏥",
    "Nursing": "💉",
    "Pharmacy": "💊",
    "Physical Therapy": "🏃‍♂️",
    "Occupational Therapy": "🦾",
    "Speech Therapy": "🗣️",
    "Public Health": "🏥",
    "Epidemiology": "🦠",
    "Healthcare Management": "📋",
    "Biostatistics": "📈",
    "Bioinformatics": "💻",
    "Sports Medicine": "🏃",
    "Dietetics": "🥗",
    "Nutrition": "🍎",

    // Agriculture and Environment
    "Agriculture": "🌾",
    "Food Science": "🥘",
    "Forestry": "🌲",
    "Soil Science": "🌱",
    "Aquaculture": "🐟",
    "Ecology": "🌎",
    "Climate Change": "🌡️",
    "Sustainable Development": "🌍",
    "Renewable Energy": "🔋",
    "Waste Management": "🗑️",

    // Other Specialized Fields
    "Maritime Studies": "⚓",
    "Aviation Management": "✈️",
    "Space Law": "🚀",
    "Disaster Management": "🌪️",
    "Emergency Management": "🚨",
    "Criminal Justice": "⚖️",
    "Urban Planning": "🏙️",
    "Social Work": "🤝",
    "Media Studies": "📺",
    "Animation": "🎞️",

    // Generic Catch All
    "Other": "❓",
  };

  /// Returns the list of all subjects
  static List<String> getSubjects() {
    return _subjects.keys.toList();
  }

  /// Returns the emoji for a given subject
  static String getEmoji(String subject) {
    return _subjects[subject] ?? "❓"; // Returns "❓" if subject not found
  }
}

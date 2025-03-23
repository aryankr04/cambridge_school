class MyLists {
  // **General Purpose Lists**
  static const List<String> yesNoOptions = ['Yes', 'No'];
  static const List<String> genderOptions = [
    'Male',
    'Female',
    'Prefer not to say'
  ];
  static const List<String> maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Separated'
  ];

  // **User and Role Related Lists**
  static const List<String> userRoleOptions = [
    'Admin',
    'Director',
    'Management',
    'Principal',
    'Teacher',
    'Staff',
    'Student',
    'Driver'
  ];

  static const List<String> schoolStaffRoles = [
    "Principal",
    "Vice Principal/Assistant Principal",
    "Director",
    "School Administrator",
    "Teacher",
    "Special Education Teacher",
    "Department Head",
    "Guidance Counselor",
    "School Nurse",
    "Sports Coach",
    "Librarian",
    "School Secretary",
    "IT Support/Technician",
    "Maintenance Staff",
    "Security Guard",
    "Driver",
    'Peon'
  ];

  // **Academic Structure Lists**
  static const List<String> classOptions = [
    'Nursery',
    'LKG',
    'UKG',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11 (Arts)',
    '11 (Commerce)',
    '11 (Science)',
    '12 (Arts)',
    '12 (Commerce)',
    '12 (Science)'
  ];
  static const List<String> sectionOptions = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L'
  ];
  static const List<String> subjectOptions = [
    'Science',
    'Maths',
    'Social Science',
    'Computer',
    'Hindi',
    'English',
    'Commerce',
    'General Knowledge',
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',
    "Economics",
    'Political Science',
    'History',
    'English Grammar'
  ];
  static final Map<String, String> noticeCategoriesWithEmojis = {
    // Academic
    'Exam Schedules': '📅',
    'Class Timetables': '🕰️',
    'Assignment Deadlines': '⏰',
    'Results and Grades': '🎓',
    'Syllabus Updates': '📝',

    // Administrative
    'Fee Payment Reminders': '💰',
    'Admission Announcements': '📢',
    'School Policy Updates': '📋',
    'Parent-Teacher Meetings': '👨‍👩‍👧',
    'Administrative Holidays': '🏖️',

    // Events & Activities
    'Sports Events': '⚽',
    'Cultural Programs': '🎉',
    'Workshops & Seminars': '🎓',
    'Field Trips': '🚌',
    'Annual Day / Celebrations': '🎂',

    // Health & Safety
    'Health Checkup Camps': '🩺',
    'Emergency Announcements': '🚨',
    'COVID-19 Protocols': '😷',
    'Safety Drills': '🛡️',
    'Medical Alerts': '🚑',

    // Extracurricular
    'Club Activities': '🎤',
    'Competitions & Contests': '🏆',
    'Talent Shows': '🎬',
    'Art & Craft Events': '🎨',

    // Transport
    'Bus Schedule Changes': '🚌',
    'Route Updates': '🗺️',
    'Safety Guidelines': '🚦',
    'Pickup/Drop-off Changes': '🚏',

    // General
    'Public Holidays': '🛌 🎉 🕶️ 🏖️ 📅',
    'Weather-Related Closures': '🌧️',
    'Lost and Found': '🔍',
    'General Announcements': '📢',

    // Disciplinary
    'Code of Conduct Reminders': '📋',
    'Disciplinary Actions': '⚖️',
    'Behavioral Guidelines': '📋',

    // Special Programs
    'Scholarship Announcements': '🎓',
    'Special Coaching Classes': '✍️',
    'Internship/Placement Information': '💼',

    // Maintenance & Infrastructure
    'Facility Repairs': '🔧',
    'Lab/Library Closures': '🧪',
    'New Facility Announcements': '📢',
  };

  static String getNoticeCategoryEmoji(String category) {
    return noticeCategoriesWithEmojis[category] ?? '❓ Category not found';
  }

  static List<String> noticeCategories() {
    return noticeCategoriesWithEmojis.keys.toList();
  }

  static List<String> majorSubjects = [
    // Foundational Subjects
    "Mathematics",
    "Science",
    "English",
    "Social Studies",
    "Foreign Language",

    // Sciences
    "Physics",
    "Chemistry",
    "Biology",
    "Environmental Science",
    "Geology",
    "Astronomy",
    "Marine Biology",
    "Botany",
    "Zoology",
    "Biochemistry",
    "Genetics",
    "Neuroscience",

    // History & Social Sciences
    "History",
    "Geography",
    "Political Science",
    "Sociology",
    "Psychology",
    "Anthropology",
    "Archaeology",
    "Economics",
    "Law",
    "Philosophy",
    "Theology",
    "Linguistics",

    // Arts & Humanities
    "Arts",
    "Music",
    "Drama",
    "Creative Writing",
    "Journalism",
    "Communications",
    "Film Production",
    "Photography",
    "Graphic Design",
    "Interior Design",
    "Fashion Design",
    "Architecture",

    // Business & Management
    "Accounting",
    "Finance",
    "Marketing",
    "Business Administration",
    "Management",
    "Human Resources",
    "Project Management",
    "Supply Chain Management",
    "Logistics",
    "Business Intelligence",

    // Technology & Engineering
    "Computer Science",
    "Information Technology",
    "Software Engineering",
    "Electrical Engineering",
    "Mechanical Engineering",
    "Civil Engineering",
    "Chemical Engineering",
    "Aerospace Engineering",
    "Biomedical Engineering",
    "Industrial Engineering",
    "Robotics",
    "Artificial Intelligence",
    "Cybersecurity",
    "Data Science",
    "Database Management",
    "Network Administration",
    "Telecommunications Engineering",
    "Materials Science",
    "Nanotechnology",
    "Nuclear Engineering",
    "Petroleum Engineering",
    "Mining Engineering",
    "Geoinformatics",
    "Remote Sensing",
    "Web Development",
    "Mobile App Development",
    "Game Development",

    // Health & Medicine
    "Medicine",
    "Nursing",
    "Pharmacy",
    "Physical Therapy",
    "Occupational Therapy",
    "Speech Therapy",
    "Public Health",
    "Epidemiology",
    "Healthcare Management",
    "Biostatistics",
    "Bioinformatics",
    "Systems Biology",
    "Synthetic Biology",
    "Sports Medicine",
    "Kinesiology",
    "Athletic Training",
    "Coaching",
    "Exercise Science",
    "Dietetics",
    "Nutrition",
    "Gerontology",
    "Rehabilitation",
    "Forensic Science",
    "Biomedical Engineering",

    // Agriculture and Environment
    "Agriculture",
    "Food Science",
    "Enology",
    "Viticulture",
    "Forestry",
    "Plant Pathology",
    "Soil Science",
    "Agricultural Engineering",
    "Aquaculture",
    "Ecology",
    "Conservation Biology",
    "Wildlife Management",
    "Climate Change",
    "Environmental Law",
    "Sustainable Development",
    "Renewable Energy",
    "Water Resources Management",
    "Waste Management",
    "Pollution Control",

    // Other Specialized Fields
    "Maritime Studies",
    "Naval Architecture",
    "Port Management",
    "Logistics and Transportation",
    "Aviation Management",
    "Space Law",
    "Astronautical Engineering",
    "Disaster Management",
    "Emergency Management",
    "Homeland Security",
    "Intelligence Analysis",
    "Counterterrorism",
    "Conflict Resolution",
    "Peace Studies",
    "Human Rights",
    "Refugee Studies",
    "Development Studies",
    "Poverty Studies",
    "Urban Planning",
    "Rural Development",
    "Community Organizing",
    "Nonprofit Management",
    "Philanthropy",
    "Volunteer Management",
    "Translation",
    "Interpretation",
    "Early Childhood Education",
    "Special Education",
    "Curriculum Development",
    "Educational Technology",
    "Educational Psychology",
    "Counseling",
    "Guidance",
    "Social Work",
    "Political Theory",
    "Comparative Politics",
    "International Law",
    "Criminology",
    "Penology",
    "Corrections",
    "Oceanography",
    "Meteorology",
    "Hydrology",
    "Paleontology",
    "Public Administration",
    "International Relations",
    "Criminal Justice",
    "Green Building",
    "Conservation Ecology",
    "Ecological Engineering",
    "Systems Biology",
    "Animation",
    "Media Studies",

    // Generic Catch All
    "Other",
  ];

  static const List<String> examOptions = [
    'FA1',
    'FA2',
    'Half Yearly',
    'FA2',
    'FA3',
    'Final Exam'
  ];

  static const List<String> examPatternOptions = [
    'Annual Exams',
    'Semester Exams',
    'Trimester Exams',
    'Quarterly Exams',
  ];

  static const List<String> gradingSystemOptions = [
    'Letter Grades (A+, A, B+, B, etc.)',
    'Percentage-Based (90% and above, 80%-89%, etc.)',
    'Grade Point Average (GPA)',
    'Cumulative Grade Point Average (CGPA)',
    'Standards-Based (Exemplary, Proficient, etc.)',
  ];

  // **Time and Schedule Related Lists**
  static const List<String> dayOptions = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday' // Added Sunday
  ];

  static List<String> monthOptions = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> eventTypeOptions = [
    'Start',
    'Class',
    'Break',
    'Assembly',
    'Departure',
  ];

  // **School Specific Lists**
  static const List<String> schoolHouseOptions = [
    "Red House",
    "Blue House",
    "Green House",
    "Yellow House",
    "Alpha House",
    "Beta House",
    "Gamma House",
    "Delta House",
    "Eagle House",
    "Lion House",
    "Tiger House",
    "Falcon House",
    "Phoenix House",
    "Dragon House",
    "Victory House",
    "Unity House",
    "Courage House",
    "Wisdom House",
    "Valor House",
    "Harmony House",
    "Integrity House",
    "Perseverance House",
    "Liberty House",
    "Justice House",
  ];

  static const List<String> schoolActivityOptions = [
    'Morning Assembly',
    'Sports Day',
    'Cultural Fest',
    'Examinations',
    'Parent-Teacher Meeting',
    'Field Trips',
    'Annual Day',
    'Science Exhibition',
    'Inter-School Competitions',
    'Workshop on Career Guidance',
    'Health and Hygiene Camp',
    'Summer/Winter Camp',
    'Music Concert',
    'Art and Craft Exhibition',
    'Debate Competition',
    'Talent Show',
    'Community Service Projects',
    'Classroom Discussions',
    'Workshop on Soft Skills',
    'Environmental Awareness Campaign',
    'Farewell Party',
    'Annual Picnic',
    'Inter-Class Sports Competitions',
    'Teacher Training Sessions',
    'Skill Development Programs',
    'School Elections',
    'Book Fair',
    'Robotics Club Activities',
    'Drama and Theatre Performances',
    'Dance Performance',
    'Annual Sports Meet',
    'Academic Workshops and Seminars',
    'Quiz Competitions',
    'Dance and Drama Club Activities',
    'Technology Fair',
    'Coding Bootcamps',
    'Science Olympiad',
    'Literature Club Activities',
    'Math Olympiad',
    'Charity Events',
    'Yoga and Meditation Sessions',
    'Environmental Cleanup Activities',
    'Student Leadership Training'
  ];

  static const List<String> schoolBoardOptions = [
    'CBSE',
    'ICSE',
    'IB',
    'NIOS',
    'CIE',
    'State Board'
  ];

  static const List<String> schoolTypeOptions = [
    'Private',
    'Government Aided Private School',
    'Government'
  ];
  static const List<String> mediumOfInstructionOptions = [
    'English',
    'Hindi',
    'Bilingual (English & Hindi)',
    'Sanskrit',
    'Urdu',
    'Assamese',
    'Bengali',
    'Bodo',
    'Dogri',
    'Gujarati',
    'Kannada',
    'Kashmiri',
    'Konkani',
    'Maithili',
    'Malayalam',
    'Manipuri',
    'Marathi',
    'Nepali',
    'Odia',
    'Punjabi',
    'Sindhi',
    'Tamil',
    'Telugu',
    'Santali',
    'Meitei (Manipuri)',
    'Bhili',
    'Gondi',
    'Tulu',
    'Khasi',
    'Mizo',
    'Bhil',
    'Ho',
    'Lepcha',
    'Garhwali',
    'Ladakhi',
    'Marwari',
    'Chhattisgarhi',
    'Kumaoni',
    'Magahi',
    'Bundeli',
    'Rajasthani',
    'Brahui',
    'French',
    'Spanish',
    'German',
    'Arabic',
    'Mandarin',
  ];
  static const List<String> academicLevelOptions = [
    'Play School',
    'Kindergarten (LKG - UKG)',
    'Primary School (LKG - 5th Class) ',
    'Middle School (LKG - 8th Class)',
    'Secondary School (LKG - 10th Class)',
    'Senior Secondary (LKG - 12th Class)',
    'Undergraduate'
  ];

  // **Health and Physical Attributes Lists**
  static const List<String> heightFeetOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];
  static const List<String> heightInchOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];

  static const List<String> visionConditionOptions = [
    'No vision correction',
    'Wears glasses',
    'Wears contact lenses',
    'Uses reading glasses',
  ];
  static const List<String> bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // **Personal Preferences and Interests Lists**
  static const List<String> languageOptions = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Other',
  ];
  static const List<String> favoriteSubjectOptions = [
    'Mathematics',
    'Science',
    'English Literature',
    'History',
    'Art',
    'Physical Education',
  ];
  static const List<String> favoriteSportOptions = [
    'Soccer',
    'Basketball',
    'Cricket',
    'Tennis',
    'Swimming',
    'Gymnastics',
  ];
  static const List<String> favoriteActivityOptions = [
    'Reading',
    'Writing',
    'Playing an instrument',
    'Drawing or Painting',
    'Hiking or Outdoor Activities',
  ];
  static const List<String> hobbyOptions = [
    'Reading',
    'Writing',
    'Painting',
    'Drawing',
    'Photography',
    'Gardening',
    'Cooking',
    'Baking',
    'Traveling',
    'Hiking',
    'Cycling',
    'Swimming',
    'Fishing',
    'Dancing',
    'Singing',
    'Playing musical instruments',
    'Knitting',
    'Sewing',
    'Woodworking',
    'Coding',
    'Gaming',
    'Yoga',
    'Meditation',
    'Volunteering',
    'Bird watching',
    'Collecting (stamps, coins, etc.)',
    'Scrapbooking',
    'Pottery',
    'Running',
    'Skating',
  ];
  static const List<String> careerAspirationOptions = [
    'Doctor',
    'Engineer',
    'Teacher',
    'Scientist',
    'Artist',
    'Athlete',
    'Businessperson',
    'Other',
  ];

  static const List<String> sportsFacilities = [
    "Football", "Cricket", "Basketball", "Volleyball", "Badminton",
    "Table Tennis", "Swimming", "Athletics", "Hockey", "Tennis",
    "Kabaddi", "Kho Kho", "Chess", "Gymnastics", "Yoga",
    "Cycling", "Martial Arts", "Archery", "Boxing", "Skating"
  ];

  static const List<String> musicAndArtFacilities = [
    "Vocal Music", "Instrumental Music", "Dance", "Drama",
    "Painting", "Sculpture", "Photography", "Digital Art",
    "Calligraphy", "Cultural Performances", "Theatre Club"
  ];

  static const List<String> studentClubs = [
    "Science Club", "Math Club", "Debate Society", "Drama Club",
    "Photography Club", "Music Band", "Robotics Club",
    "Environmental Club", "Coding Club", "Chess Club",
    "Astronomy Club", "Sports Club", "Literary Club", "Art Club"
  ];

  static const List<String> specialTrainingPrograms = [
    "Robotics Workshop", "AI & Machine Learning", "Public Speaking",
    "Entrepreneurship Bootcamp", "Cyber Security Training",
    "Financial Literacy", "Coding & Programming", "Space Science",
    "Personality Development", "Creative Writing", "Leadership Training"
  ];

  static const List<String> labsAvailable = [
    "Physics Lab", "Chemistry Lab", "Biology Lab", "Computer Lab",
    "Mathematics Lab", "Electronics Lab", "Language Lab",
    "Robotics Lab", "AI & Data Science Lab", "3D Printing Lab",
    "Environmental Science Lab", "Astronomy Lab"
  ];
  static const List<String> generalFacilities = [
    "Spacious Classrooms", "Smart Classrooms", "Auditorium",
    "Conference Hall", "Library", "Computer Lab", "Science Labs",
    "Reading Room", "Activity Room", "Language Lab", "Art & Craft Room"
  ];

  static const List<String> transportFacilities = [
    "School Buses", "Vans", "Transport Tracking System",
    "Driver Attendance System", "GPS Tracking", "First Aid in Transport"
  ];

  static const List<String> sportsInfrastructure = [
    "Football Ground", "Cricket Pitch", "Basketball Court",
    "Tennis Court", "Volleyball Court", "Badminton Court",
    "Swimming Pool", "Indoor Sports Arena", "Athletics Track",
    "Gymnasium", "Yoga Hall", "Cycling Track", "Skating Rink"
  ];

  static const List<String> healthAndSafetyFacilities = [
    "Medical Room", "First Aid Kits", "Emergency Exit Plan",
    "Fire Safety Equipment", "CCTV Surveillance", "Security Guards",
    "Sanitization Facilities", "Drinking Water Facility", "Washrooms",
    "Separate Washrooms for Boys & Girls", "Handicap Accessibility"
  ];

  static const List<String> additionalFacilities = [
    "Canteen", "Hostel Facility", "WiFi Connectivity",
    "Book Store", "Stationery Shop", "Prayer Hall",
    "Parents Waiting Area", "Student Counselling Room"
  ];
  static const List<String> streamAvailable = [
    "Science", "Commerce", "Arts", "Humanities", "Vocational Studies",
    "Technical Education", "Performing Arts", "Physical Education"
  ];
  // **Transportation and Location Lists**
  static const List<String> modeOfTransportOptions = [
    'School Transport',
    'Private Car',
    'Bicycle',
    'Walking',
    'Van/Carpool',
    'Public Bus',
    'Auto-rickshaw',
    'Motorcycle/Scooter',
    'Metro/Subway',
    'Taxi/Cab',
    'Parent Drop-off',
  ];
  static const List<String> countriesOptions = [
    "India",
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Comoros",
    "Congo, Democratic Republic of the",
    "Congo, Republic of the",
    "Costa Rica",
    "Cote d'Ivoire",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Eswatini",
    "Ethiopia",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Grenada",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hungary",
    "Iceland",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, North",
    "Korea, South",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Micronesia, Federated States of",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar (Burma)",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Macedonia",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States of America",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City",
    "Venezuela",
    "Vietnam",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];

  static const List<String> nationalityOptions = [
    "Indian",
    "Afghan",
    "Albanian",
    "Algerian",
    "American",
    "Andorran",
    "Angolan",
    "Argentinian",
    "Armenian",
    "Australian",
    "Austrian",
    "Azerbaijani",
    "Bahamian",
    "Bahraini",
    "Bangladeshi",
    "Barbadian",
    "Belarusian",
    "Belgian",
    "Belizean",
    "Beninese",
    "Bhutanese",
    "Bolivian",
    "Bosnian",
    "Botswanan",
    "Brazilian",
    "British",
    "Bruneian",
    "Bulgarian",
    "Burkinabe",
    "Burmese",
    "Burundian",
    "Cambodian",
    "Cameroonian",
    "Canadian",
    "Cape Verdean",
    "Central African",
    "Chadian",
    "Chilean",
    "Chinese",
    "Colombian",
    "Comoran",
    "Congolese",
    "Costa Rican",
    "Croatian",
    "Cuban",
    "Cypriot",
    "Czech",
    "Danish",
    "Djiboutian",
    "Dominican",
    "Dutch",
    "East Timorese",
    "Ecuadorian",
    "Egyptian",
    "Emirati",
    "Equatorial Guinean",
    "Eritrean",
    "Estonian",
    "Ethiopian",
    "Fijian",
    "Finnish",
    "French",
    "Gabonese",
    "Gambian",
    "Georgian",
    "German",
    "Ghanaian",
    "Greek",
    "Grenadian",
    "Guatemalan",
    "Guinean",
    "Guyanese",
    "Haitian",
    "Honduran",
    "Hungarian",
    "Icelandic",
    "Indonesian",
    "Iranian",
    "Iraqi",
    "Irish",
    "Israeli",
    "Italian",
    "Ivorian",
    "Jamaican",
    "Japanese",
    "Jordanian",
    "Kazakh",
    "Kenyan",
    "Kiribati",
    "Kuwaiti",
    "Kyrgyz",
    "Laotian",
    "Latvian",
    "Lebanese",
    "Liberian",
    "Libyan",
    "Liechtensteiner",
    "Lithuanian",
    "Luxembourger",
    "Macedonian",
    "Malagasy",
    "Malawian",
    "Malaysian",
    "Maldivian",
    "Malian",
    "Maltese",
    "Marshallese",
    "Mauritanian",
    "Mauritian",
    "Mexican",
    "Micronesian",
    "Moldovan",
    "Monacan",
    "Mongolian",
    "Montenegrin",
    "Moroccan",
    "Mozambican",
    "Namibian",
    "Nauruan",
    "Nepalese",
    "New Zealander",
    "Nicaraguan",
    "Nigerian",
    "Nigerien",
    "North Korean",
    "Norwegian",
    "Omani",
    "Pakistani",
    "Palauan",
    "Palestinian",
    "Panamanian",
    "Papua New Guinean",
    "Paraguayan",
    "Peruvian",
    "Philippine",
    "Polish",
    "Portuguese",
    "Qatari",
    "Romanian",
    "Russian",
    "Rwandan",
    "Saint Lucian",
    "Salvadoran",
    "Samoan",
    "San Marinese",
    "Saudi Arabian",
    "Senegalese",
    "Serbian",
    "Seychellois",
    "Sierra Leonean",
    "Singaporean",
    "Slovak",
    "Slovenian",
    "Solomon Islander",
    "Somali",
    "South African",
    "South Korean",
    "Spanish",
    "Sri Lankan",
    "Sudanese",
    "Surinamese",
    "Swazi",
    "Swedish",
    "Swiss",
    "Syrian",
    "Taiwanese",
    "Tajik",
    "Tanzanian",
    "Thai",
    "Togolese",
    "Tongan",
    "Trinidadian",
    "Tunisian",
    "Turkish",
    "Turkmen",
    "Tuvaluan",
    "Ugandan",
    "Ukrainian",
    "Uruguayan",
    "Uzbek",
    "Vanuatuan",
    "Venezuelan",
    "Vietnamese",
    "Yemeni",
    "Zambian",
    "Zimbabwean",
  ];
  static const List<String> indianStateOptions = [
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli and Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  // **Administrative and Miscellaneous Lists**
  static const List<String> categoryOptions = [
    'General',
    'OBC',
    'ST/SC',
    'EWS'
  ];

  static const List<String> holidayTypeOptions = [
    'National',
    'Regional',
    'Religious',
    'Cultural',
    'Festival',
    'Public',
  ];

  static final Map<String, String> leaveTypeOptionsWithEmojis = {
    'Sick Leave': '🤒',
    'Half Day Leave': '⏰',
    'One Day Leave': '🗓️',
    'Medical Leave': '🚑',
    'Marriage Leave': '💍',
    'Vacation Leave': '🏖️',
    'Casual Leave': '🛌',
    'Bereavement Leave': '🕊️',
    'Maternity Leave': '🤰',
    'Paternity Leave': '👨‍🍼',
    'Sabbatical Leave': '📚',
  };

// Get emoji for a specific leave type
  static String getLeaveTypeEmoji(String leaveType) {
    return leaveTypeOptionsWithEmojis[leaveType] ?? '❓';
  }

// Get a list of all leave types
  static List<String> leaveTypes() {
    return leaveTypeOptionsWithEmojis.keys.toList();
  }

  static const List<String> educationDegreeOptions = [
    // Basic and Intermediate Education
    "10th Grade / Secondary School Certificate (SSC)",
    "12th Grade / Higher Secondary Certificate (HSC) / Intermediate",

    // General Education Levels
    "High School Diploma",
    "General Educational Development (GED)",
    "Vocational Training",

    // Undergraduate Degrees
    "Bachelor of Technology (B.Tech)",
    "Bachelor of Medicine, Bachelor of Surgery (MBBS)",
    "Bachelor of Business Administration (BBA)",
    "Bachelor of Computer Applications (BCA)",
    "Bachelor of Science (B.Sc)",
    "Bachelor of Arts (BA)",
    "Bachelor of Commerce (B.Com)",
    "Bachelor of Pharmacy (B.Pharm)",
    "Bachelor of Education (B.Ed)",
    "Bachelor of Fine Arts (BFA)",
    "Bachelor of Architecture (B.Arch)",
    "Bachelor of Law (LLB)",
    "Bachelor of Dental Surgery (BDS)",
    "Bachelor of Veterinary Science (B.V.Sc)",
    "Bachelor of Nursing (B.Sc Nursing)",
    "Bachelor of Design (B.Des)",
    "Bachelor of Hotel Management (BHM)",
    "Bachelor of Social Work (BSW)",
    "Bachelor of Physiotherapy (BPT)",
    "Bachelor of Management Studies (BMS)",

    // Postgraduate Degrees
    "Master of Business Administration (MBA)",
    "Master of Technology (M.Tech)",
    "Master of Science (M.Sc)",
    "Master of Computer Applications (MCA)",
    "Master of Arts (MA)",
    "Master of Commerce (M.Com)",
    "Master of Education (M.Ed)",
    "Master of Social Work (MSW)",
    "Master of Law (LLM)",
    "Master of Fine Arts (MFA)",
    "Master of Design (M.Des)",
    "Master of Pharmacy (M.Pharm)",
    "Master of Public Health (MPH)",
    "Master of Hotel Management (MHM)",

    // Doctoral Degrees
    "Doctor of Philosophy (Ph.D.)",
    "Doctor of Medicine (MD)",
    "Doctor of Dental Surgery (DDS)",
    "Doctor of Veterinary Medicine (DVM)",
    "Doctor of Education (Ed.D)",
    "Doctor of Science (D.Sc)",

    // Professional Degrees
    "Chartered Accountancy (CA)",
    "Certified Public Accountant (CPA)",
    "Company Secretary (CS)",
    "Certified Financial Analyst (CFA)",
    "Project Management Professional (PMP)",

    // Diplomas and Certifications
    "Diploma in Engineering",
    "Diploma in Computer Science",
    "Diploma in Business Management",
    "Certificate in Data Science",
    "Certificate in Digital Marketing",
    "Certificate in Project Management",
  ];
  static const List<String> religionOptions = [
    'Hinduism',
    'Islam',
    'Christianity',
    'Buddhism',
    'Sikhism',
    'Jainism',
    'Judaism',
    'Atheism',
    'Other',
  ];
  static const List<String> medicalConditionOptions = [
    'None',
    'Asthma',
    'Diabetes',
    'Epilepsy',
    'ADHD',
    'Autism Spectrum Disorder',
    'Heart Conditions',
    'Other Chronic Conditions',
  ];

  // Staff Skills

  static const List<Map<String, List<String>>> schoolStaffSkillOptions = [
    {
      "Principal": [
        "Leadership",
        "Decision Making",
        "Communication",
        "Conflict Resolution",
        "Strategic Planning",
      ],
    },
    {
      "Vice Principal/Assistant Principal": [
        "Administration",
        "Disciplinary Management",
        "Team Collaboration",
        "Problem Solving",
        "Organizational Skills",
      ],
    },
    {
      "Director": [
        "Policy Development",
        "Strategic Vision",
        "Budgeting",
        "School Operations",
        "Stakeholder Communication",
      ],
    },
    {
      "School Administrator": [
        "Operational Management",
        "Record Keeping",
        "Event Coordination",
        "Parent Communication",
        "Scheduling",
      ],
    },
    {
      "Teacher": [
        "Subject Knowledge",
        "Classroom Management",
        "Lesson Planning",
        "Student Assessment",
        "Communication",
      ],
    },
    {
      "Special Education Teacher": [
        "Individualized Education Plans",
        "Behavior Management",
        "Patience",
        "Adaptability",
        "Collaboration",
      ],
    },
    {
      "Department Head": [
        "Leadership",
        "Curriculum Development",
        "Mentorship",
        "Team Building",
        "Performance Review",
      ],
    },
    {
      "Guidance Counselor": [
        "Counseling",
        "Career Guidance",
        "Emotional Support",
        "Interpersonal Skills",
        "Crisis Management",
      ],
    },
    {
      "School Nurse": [
        "First Aid",
        "Medical Knowledge",
        "Patient Care",
        "Health Education",
        "Record Keeping",
      ],
    },
    {
      "Sports Coach": [
        "Physical Training",
        "Team Leadership",
        "Motivational Skills",
        "Sports Strategy",
        "Disciplinary Skills",
      ],
    },
    {
      "Librarian": [
        "Information Management",
        "Research Skills",
        "Literacy Promotion",
        "Organizational Skills",
        "Technology Skills",
      ],
    },
    {
      "School Secretary": [
        "Clerical Skills",
        "Scheduling",
        "Communication",
        "Multitasking",
        "Time Management",
      ],
    },
    {
      "IT Support/Technician": [
        "Technical Troubleshooting",
        "Network Management",
        "Hardware Maintenance",
        "Software Installation",
        "Cybersecurity Awareness",
      ],
    },
    {
      "Maintenance Staff": [
        "Facility Maintenance",
        "Basic Repair Skills",
        "Cleanliness Standards",
        "Safety Awareness",
        "Reliability",
      ],
    },
    {
      "Security Guard": [
        "Surveillance",
        "Emergency Response",
        "Situational Awareness",
        "Patience",
        "Physical Fitness",
      ],
    },
    {
      "Driver": [
        "Defensive Driving",
        "Safety Awareness",
        "Time Management",
        "Vehicle Maintenance",
        "Communication",
      ],
    },
  ];

  //Relationship Options
  static const List<String> relationshipOptions = [
    'Father',
    'Mother',
    'Guardian',
    'Grandfather',
    'Grandmother',
    'Aunt',
    'Uncle',
    'Other',
  ];
  final List<String> educationLevelsOptions = [
    'No Formal Education',
    'Primary Education (Class 1-5)',
    'Middle School (Class 6-8)',
    'High School (Class 9-10)',
    'Higher Secondary (Class 11-12)',
    'Diploma',
    'Undergraduate (Bachelor’s Degree - BA, BSc, BCom, BTech, etc.)',
    'Postgraduate (Master’s Degree - MA, MSc, MCom, MTech, etc.)',
    'Doctorate (PhD, DPhil, etc.)',
    'Professional Courses (CA, CS, LLB, MBBS, etc.)',
    'Vocational Training / ITI',
  ];

  // Academic Performance and Activities
  static const List<String> gradeOptions = [
    'A+', 'A', 'B+', 'B', 'C+', 'C', 'D', 'F' //Standard letter grades
  ];

  static const List<String> extracurricularInvolvementOptions = [
    'Sports Team (e.g., Soccer, Basketball)',
    'Debate Club',
    'Drama Club',
    'Music Ensemble (e.g., Band, Choir)',
    'Student Government',
    'Volunteer Organizations',
    'Coding Club',
    'Robotics Club',
    'Art Club',
    'Literary Magazine'
  ];

  static const List<String> disciplinaryActionsOptions = [
    'Detention',
    'Suspension',
    'Expulsion',
    'Warning Letter',
    'Community Service'
  ];

  // Student Support Services
  static const List<String> counselingNeedsOptions = [
    'Academic Counseling',
    'Career Counseling',
    'Personal/Social Counseling',
    'Crisis Intervention'
  ];

  static const List<String> financialAidOptions = [
    'Scholarship',
    'Grant',
    'Student Loan',
    'Work-Study'
  ];

  // Student Demographics and Background

  static const List<String> familyIncomeRangesOptions = [
    'Less than \$25,000',
    '\$25,000 - \$50,000',
    '\$50,001 - \$75,000',
    '\$75,001 - \$100,000',
    'Over \$100,000',
    'Prefer not to say'
  ];

  static const List<String> siblingInformationOptions = [
    'Number of Siblings',
    'Birth Order (e.g., Firstborn, Middle Child)',
    'Educational Levels of Siblings'
  ];

  // School Environment and Safety
  static const List<String> safetyConcernsOptions = [
    'Bullying',
    'Cyberbullying',
    'Harassment',
    'Violence',
    'Substance Abuse'
  ];

  // Additional Student Attributes

  static const List<String> learningStylesOptions = [
    'Visual',
    'Auditory',
    'Kinesthetic',
    'Reading/Writing'
  ];

  static const List<String> personalityTraitsOptions = [
    'Extroverted',
    'Introverted',
    'Optimistic',
    'Pessimistic',
    'Creative',
    'Analytical'
  ];

  static const List<String> dishOptions = [
    'Pizza',
    'Pasta',
    'Sushi',
    'Burger',
    'Tacos',
    'Steak',
    'Salad',
    'Ice Cream',
  ];

  static const List<String> teacherOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> bookOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> athleteOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> movieOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> cuisineOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> singerOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> placeToVisitOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> festivalOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> personalityOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> animalOptions = [
    'Mr. Smith',
    'Mrs. Jones',
    'Dr. Lee',
    'Prof. Brown',
    'Ms. Davis',
    'Mr. Wilson',
  ];
  static const List<String> seasonOptions = [
    'Summer',
    'Winter',
    'Spring',
    'Autumn',
  ];
  static const List<String> occupations = [
    // Most Common Professions
    "Doctor",
    "Nurse",
    "Software Developer",
    "Teacher",
    "Engineer",
    "Police Officer",
    "Lawyer",
    "Accountant",
    "Electrician",
    "Plumber",
    "Mechanic",
    "Carpenter",
    "Farmer",
    "Driver",
    "Chef",
    "Cashier",
    "Customer Service Representative",
    "Security Guard",
    "Salesperson",
    "Marketing Manager",
    "Real Estate Agent",
    "Scientist",
    "Architect",
    "Dentist",
    "Pharmacist",
    "Business Analyst",
    "Entrepreneur",
    "Banker",
    "Construction Worker",
    "Pilot",
    "Journalist",
    "Graphic Designer",
    "Web Developer",
    "Event Planner",
    "Social Worker",
    "Data Scientist",
    "Data Analyst",
    "Consultant",
    "Human Resources Manager",
    "Surgeon",
    "Professor",
    "Lab Technician",
    "Mathematician",
    "Economist",
    "Technician",
    "Librarian",
    "Receptionist",
    "Veterinarian",
    "Judge",
    "Military Officer",
    "Translator",
    "Writer",
    "Musician",
    "Photographer",
    "Artist",
    "Actor",
    "Bartender",
    "Hairdresser",
    "Fashion Designer",
    "Fisherman",
    "Blacksmith",
    "Astronomer",
    "Coach",
    "Sports Coach",
    "Travel Agent",
    "Videographer",
    "Waiter",
    "Truck Driver",
    "Miner",

    // Medical & Healthcare
    "Paramedic",
    "Psychologist",
    "Physiotherapist",
    "Radiologist",
    "Biomedical Engineer",
    "Chiropractor",
    "Dermatologist",
    "Veterinary Technician",
    "Occupational Therapist",
    "Nutritionist",
    "Speech Therapist",
    "Midwife",
    "Anesthesiologist",
    "Surgeon",
    "Optometrist",
    "Pathologist",
    "Phlebotomist",
    "Orthopedic Surgeon",

    // Science & Research
    "Biochemist",
    "Geneticist",
    "Marine Biologist",
    "Geologist",
    "Microbiologist",
    "Zoologist",
    "Botanist",
    "Ecologist",
    "Meteorologist",
    "Environmental Scientist",
    "Physicist",
    "Astrophysicist",
    "Statistician",
    "Forensic Scientist",

    // Engineering & Technology
    "Civil Engineer",
    "Mechanical Engineer",
    "Electrical Engineer",
    "Automobile Engineer",
    "Aerospace Engineer",
    "Chemical Engineer",
    "Robotics Engineer",
    "AI Engineer",
    "Cybersecurity Expert",
    "Cloud Engineer",
    "Blockchain Developer",
    "Game Developer",
    "DevOps Engineer",
    "Machine Learning Engineer",

    // Business & Finance
    "Investment Banker",
    "Stock Broker",
    "Insurance Agent",
    "Tax Consultant",
    "Risk Analyst",
    "Supply Chain Manager",
    "Financial Analyst",
    "Auditor",
    "Loan Officer",
    "Actuary",
    "Corporate Trainer",
    "E-commerce Manager",

    // Education & Academia
    "Principal",
    "School Counselor",
    "Special Education Teacher",
    "Teaching Assistant",
    "Tutor",
    "Research Scholar",
    "Linguist",
    "Educational Consultant",

    // Government & Administration
    "Civil Servant",
    "Government Officer",
    "Politician",
    "Mayor",
    "Ambassador",
    "Customs Officer",
    "Tax Officer",
    "Registrar",
    "Census Officer",

    // Arts, Media & Entertainment
    "Filmmaker",
    "Cinematographer",
    "Theater Director",
    "Animator",
    "Voice Actor",
    "Video Editor",
    "Set Designer",
    "Makeup Artist",
    "Comedian",
    "Radio Jockey",
    "TV Host",
    "Sound Engineer",
    "Music Producer",
    "Dancer",
    "Fashion Model",
    "YouTuber",
    "Social Media Influencer",
    "Podcaster",

    // Skilled Trades & Handicrafts
    "Welder",
    "Machinist",
    "Locksmith",
    "Goldsmith",
    "Potter",
    "Leatherworker",
    "Tailor",
    "Shoemaker",
    "Upholsterer",
    "Jeweler",
    "Florist",

    // Aviation & Transportation
    "Air Traffic Controller",
    "Flight Engineer",
    "Ship Captain",
    "Railway Engineer",
    "Cargo Handler",
    "Bicycle Mechanic",
    "Helicopter Pilot",

    // Hospitality & Tourism
    "Tour Guide",
    "Hotel Manager",
    "Front Desk Officer",
    "Resort Manager",
    "Concierge",
    "Cruise Ship Staff",
    "Event Coordinator",

    // Law & Legal Services
    "Notary",
    "Legal Advisor",
    "Public Prosecutor",
    "Paralegal",
    "Corporate Lawyer",
    "Human Rights Advocate",

    // Military & Defense
    "Army Officer",
    "Navy Officer",
    "Air Force Pilot",
    "Spy",
    "Drone Operator",
    "Weapon Engineer",

    // Miscellaneous & Unique Jobs
    "Tattoo Artist",
    "Astrologer",
    "Private Investigator",
    "Magician",
    "Professional Gamer",
    "Ethical Hacker",
    "Auctioneer",
    "Professional Cuddler",
    "Chess Player",
    "Bounty Hunter",
    "Clown",
    "Zookeeper",
    "Beekeeper",
    "Snake Charmer",
    "Waste Management Specialist",
    "Park Ranger",
    "Feng Shui Consultant",
  ];
}

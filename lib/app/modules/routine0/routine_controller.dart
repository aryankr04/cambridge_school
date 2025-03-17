// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cambridge_school/app/modules/routine/routine_model.dart';
// import '../class_management/class_model.dart';
// import '../school_management/models/school_model.dart';
//
// class RoutineController extends GetxController {
//   //----------------------------------------------------------------------------
//   // Instance Variables
//
//   final _firestoreService = FirestoreService();
//   // Observables
//   final selectedClass = Rxn<ClassModel>();
//   final selectedSection = Rxn<SectionModel>();
//   final selectedDay = RxString('Monday'); // Default day
//   final isLoading = false.obs;
//   final errorMessage = RxnString();
//   final classes = <ClassModel>[].obs;
//   final schoolModel = Rxn<SchoolModel>(); // Add a school model observable
//
//   // Lifecycle Hooks
//   @override
//   void onInit() {
//     super.onInit();
//     fetchSchoolData(); // Call fetchSchoolData instead of fetchClasses
//     print('🚀 RoutineController initialized');
//   }
//
//   //----------------------------------------------------------------------------
//   // Data Fetching Methods
//
//   Future<void> fetchSchoolData() async {
//     isLoading.value = true;
//     errorMessage.value = null;
//     try {
//       // Assuming you have a way to get the school ID
//       const schoolId = 'SCH00001'; // Replace with actual school ID
//       print('🏫 Fetching school data for school ID: $schoolId');
//
//       final school = await _firestoreService.getSchoolModel(schoolId);
//
//       if (school != null) {
//         schoolModel.value = school; // Set the school model.
//         classes.assignAll(school.classes); // Load ClassData into classes
//         print('✅ School and Classes fetched successfully: ${classes.length} classes');
//       } else {
//         errorMessage.value = 'Failed to fetch school data.';
//         print('❌ Error fetching school data: School data is null.');
//         Get.snackbar('Error', errorMessage.value!);
//       }
//
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch school data: $e';
//       print('❌ Error fetching school data: $e');
//       Get.snackbar('Error', errorMessage.value!);
//     } finally {
//       isLoading.value = false;
//       print('⏳ Fetching school data completed. Loading: ${isLoading.value}');
//     }
//   }
//
//
//   //----------------------------------------------------------------------------
//   // Class and Section Selection
//
//   void onClassSelected(ClassModel? classModel) {
//     selectedClass.value = classModel;
//     print('📚 Class selected: ${classModel?.className}');
//
//     // First set the selectedSection to null. VERY IMPORTANT
//     selectedSection.value = null;
//
//     if (classModel != null && classModel.sections != null && classModel.sections!.isNotEmpty) {
//
//       //  Check `sectionName` but also ensure the `selectedSection.value` is not null BEFORE accessing `sectionName`.
//       if (classModel.sections!.any((s) => selectedSection.value != null && s.sectionName == selectedSection.value?.sectionName)) {
//         // Find the section model and assign it
//         //  USE SECTION NAME TO FIND THE MODEL
//         selectedSection.value = classModel.sections!.firstWhere((s) => selectedSection.value != null && s.sectionName == selectedSection.value?.sectionName);
//       } else {
//         // Default to the first section if no existing selection is in new class.
//         selectedSection.value = classModel.sections!.first;
//       }
//
//       print('SECTION SELECTED ${selectedSection.value?.sectionName ?? "No Section Name"} FROM CLASS ${classModel.className ?? "No Class Name"}');
//     } else {
//       print('Section set to null');
//     }
//     fetchRoutine(); // Fetch routine when a class is selected
//   }
//
//   void onSectionSelected(SectionModel? section) {
//     selectedSection.value = section;
//     print('SECTION SELECTED ${section?.sectionName ?? "No Section Name"}');
//     fetchRoutine(); // Refresh routine when a new section is selected
//   }
//
//   void onDaySelected(String day) {
//     selectedDay.value = day;
//     print('🗓️ Day selected: $day');
//   }
//
//   //----------------------------------------------------------------------------
//   // Routine Management
//
//   Future<void> fetchRoutine() async {
//     if (selectedClass.value == null || selectedSection.value == null) {
//       print('⚠️ Class or Section is not selected. Skipping fetch routine.');
//       return;
//     }
//
//     isLoading.value = true;
//     errorMessage.value = null;
//
//     try {
//       // Retrieve the routine from Firestore using the class and section details.
//       // You'll need to adapt this part to match your Firestore structure.
//       print(
//           '🔄 Fetching routine for class: ${selectedClass.value!.id!}, section: ${selectedSection.value!.sectionName!}');
//       final routine = await _firestoreService.getRoutineForSection(
//         selectedClass
//             .value!.id!, // Assuming each class document has a unique ID
//         selectedSection
//             .value!.sectionName!, // Or whatever field identifies the section
//       );
//
//       // Update the selected section's routine.
//       final updatedSection = selectedSection.value!.copyWith(routine: routine);
//       final updatedSections = selectedClass.value!.sections!.map((section) {
//         if (section.sectionName == selectedSection.value!.sectionName) {
//           return updatedSection;
//         }
//         return section;
//       }).toList();
//
//       // Update the class model with the new section list.
//       final updatedClass = selectedClass.value!.copyWith(sections: updatedSections);
//       selectedClass.value = updatedClass;
//
//       // Refresh the list of classes
//       final index = classes.indexWhere((c) => c.id == updatedClass.id);
//       if (index != -1) {
//         classes[index] = updatedClass;
//       }
//
//       print('✅ Routine fetched and updated successfully.');
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch routine: $e';
//       print('❌ Error fetching routine: $e');
//       Get.snackbar('Error', errorMessage.value!);
//     } finally {
//       isLoading.value = false;
//       print('⏳ Fetching routine completed. Loading: ${isLoading.value}');
//     }
//   }
//
//   List<Event> getEventsForDay(String day) {
//     if (selectedClass.value == null ||
//         selectedSection.value == null ||
//         selectedSection.value!.routine == null) {
//       print('⚠️ Class, Section, or Routine is null. Returning empty event list.');
//       return [];
//     }
//     final dailyRoutine = selectedSection.value!.routine!.dailyRoutines
//         .firstWhereOrNull((routine) => routine.day == day);
//     final events = dailyRoutine?.events ?? [];
//     print('📅 Getting events for day: $day. Found ${events.length} events.');
//     return events;
//   }
//
//   void addEvent(Event event) {
//     if (selectedClass.value == null || selectedSection.value == null) {
//       print('⚠️ Class or Section is null. Cannot add event.');
//       return;
//     }
//     final dayRoutine = selectedSection.value!.routine!.dailyRoutines
//         .firstWhere((routine) => routine.day == selectedDay.value);
//     dayRoutine.events.add(event);
//     selectedClass.refresh(); // Trigger UI update
//     print('➕ Event added for day: ${selectedDay.value}, subject: ${event.subject}');
//   }
//
//   void editEvent(int index, Event updatedEvent) {
//     if (selectedClass.value == null || selectedSection.value == null) {
//       print('⚠️ Class or Section is null. Cannot edit event.');
//       return;
//     }
//     final dayRoutine = selectedSection.value!.routine!.dailyRoutines
//         .firstWhere((routine) => routine.day == selectedDay.value);
//     dayRoutine.events[index] = updatedEvent;
//     selectedClass.refresh(); // Trigger UI update
//     print(
//         '✏️ Event edited at index: $index, subject: ${updatedEvent.subject}');
//   }
//
//   void deleteEvent(int index) {
//     if (selectedClass.value == null || selectedSection.value == null) {
//       print('⚠️ Class or Section is null. Cannot delete event.');
//       return;
//     }
//     final dayRoutine = selectedSection.value!.routine!.dailyRoutines
//         .firstWhere((routine) => routine.day == selectedDay.value);
//     dayRoutine.events.removeAt(index);
//     selectedClass.refresh(); // Trigger UI update
//     print('🗑️ Event deleted at index: $index');
//   }
//
//   //----------------------------------------------------------------------------
//   // Firestore Update
//
//   Future<void> updateRoutineToFirestore() async {
//     if (selectedClass.value == null || selectedSection.value == null) {
//       print('⚠️ Class or Section is null. Cannot update routine to Firestore.');
//       return;
//     }
//
//     isLoading.value = true;
//     errorMessage.value = null;
//
//     try {
//       // Assuming you can update only the routine part in the section
//       print(
//           '🔥 Updating routine to Firestore for class: ${selectedClass.value!.id!}, section: ${selectedSection.value!.sectionName!}');
//       await _firestoreService.updateSectionRoutine(
//         selectedClass.value!.id!,
//         selectedSection.value!.sectionName!,
//         selectedSection.value!.routine!.toMap(), // Convert routine to map
//       );
//       Get.snackbar('Success', 'Routine updated successfully!');
//       print('✅ Routine updated to Firestore successfully!');
//     } catch (e) {
//       errorMessage.value = 'Failed to update routine: $e';
//       print('❌ Error updating routine to Firestore: $e');
//       Get.snackbar('Error', errorMessage.value!);
//     } finally {
//       isLoading.value = false;
//       print('⏳ Updating routine completed. Loading: ${isLoading.value}');
//     }
//   }
// }
//
// //----------------------------------------------------------------------------
// // UI Screen
//
// class RoutineManagementScreen extends GetView<RoutineController> {
//   const RoutineManagementScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Routine Management'),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (controller.errorMessage.value != null) {
//           return Center(
//               child: Text('Error: ${controller.errorMessage.value!}'));
//         } else {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form( // Added Form widget
//               child: Column(
//                 children: [
//                   // Class Dropdown
//                   DropdownButtonFormField<ClassModel>(
//                     value: controller.selectedClass.value,
//                     onChanged: (val) {
//                       print('selected class $val');
//                       controller.onClassSelected(val);
//                     },
//                     items: controller.classes.map((classModel) {
//                       return DropdownMenuItem(
//                         key: Key(classModel.id!), // Add a unique key
//                         value: classModel,
//                         child: Text(classModel.className ?? 'Unnamed Class'),
//                       );
//                     }).toList(),
//                     decoration: const InputDecoration(labelText: 'Select Class'),
//                     validator: (value) => value == null ? 'Please select a class' : null,
//                   ),
//                   // Section Dropdown
//                   Obx(() {  // Wrap the Section Dropdown in an Obx
//                     return DropdownButtonFormField<SectionModel>(
//                       value: controller.selectedSection.value,
//                       onChanged: (val) {
//                         print('selected section $val');
//                         controller.onSectionSelected(val);
//                       },
//                       items:
//                       controller.selectedClass.value?.sections?.map((section) {
//                         return DropdownMenuItem(
//                           key: Key(section.sectionName!), // Add a unique key
//                           value: section,
//                           child: Text(section.sectionName ?? 'Unnamed Section'),
//                         );
//                       }).toList(),
//                       decoration:
//                       const InputDecoration(labelText: 'Select Section'),
//                       validator: (value) => value == null ? 'Please select a section' : null, // Added validation
//                     );
//                   }),
//                   // Day Dropdown
//                   DropdownButtonFormField<String>(
//                     value: controller.selectedDay.value,
//                     onChanged: (val) {
//                       print('selected day $val');
//                       controller.onDaySelected(val!);
//                     },
//                     items: const [
//                       'Monday',
//                       'Tuesday',
//                       'Wednesday',
//                       'Thursday',
//                       'Friday',
//                       'Saturday',
//                       'Sunday'
//                     ].map((day) {
//                       return DropdownMenuItem(
//                         value: day,
//                         child: Text(day),
//                       );
//                     }).toList(),
//                     decoration: const InputDecoration(labelText: 'Select Day'),
//                     validator: (value) => value == null ? 'Please select a day' : null, // Added validation
//                   ),
//                   const SizedBox(height: 20),
//                   // Events List
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: controller
//                           .getEventsForDay(controller.selectedDay.value)
//                           .length,
//                       itemBuilder: (context, index) {
//                         final event = controller
//                             .getEventsForDay(controller.selectedDay.value)[index];
//                         return EventTile(
//                           event: event,
//                           onEdit: () => _showEditDialog(context, index, event),
//                           onDelete: () => controller.deleteEvent(index),
//                         );
//                       },
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _showAddDialog(context),
//                     child: const Text('Add Event'),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: controller.updateRoutineToFirestore,
//                     child: const Text('Update Routine'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }),
//     );
//   }
//
//   //----------------------------------------------------------------------------
//   // Dialogs
//
//   Future<void> _showAddDialog(BuildContext context) async {
//     final formKey = GlobalKey<FormState>();
//     String? subject;
//     String? eventType;
//     TimeOfDay? startTime;
//     TimeOfDay? endTime;
//     String? teacher;
//     String? location;
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add New Event'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Subject'),
//                     validator: (value) => value == null || value.isEmpty
//                         ? 'Please enter a subject'
//                         : null,
//                     onSaved: (value) => subject = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Event Type'),
//                     validator: (value) => value == null || value.isEmpty
//                         ? 'Please enter an event type'
//                         : null,
//                     onSaved: (value) => eventType = value,
//                   ),
//                   TimePickerFormField(
//                     decoration: const InputDecoration(labelText: 'Start Time'),
//                     onSaved: (time) => startTime = time,
//                   ),
//                   TimePickerFormField(
//                     decoration: const InputDecoration(labelText: 'End Time'),
//                     onSaved: (time) => endTime = time,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Teacher'),
//                     onSaved: (value) => teacher = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Location'),
//                     onSaved: (value) => location = value,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   formKey.currentState!.save();
//                   final newEvent = Event(
//                     subject: subject,
//                     eventType: eventType,
//                     startTime: startTime!,
//                     endTime: endTime!,
//                     teacher: teacher,
//                     location: location,
//                   );
//                   controller.addEvent(newEvent);
//                   Navigator.pop(context);
//                   print('✅ new event added');
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _showEditDialog(
//       BuildContext context, int index, Event event) async {
//     final formKey = GlobalKey<FormState>();
//     String? subject = event.subject;
//     String? eventType = event.eventType;
//     TimeOfDay? startTime = event.startTime;
//     TimeOfDay? endTime = event.endTime;
//     String? teacher = event.teacher;
//     String? location = event.location;
//
//     await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Edit Event'),
//             content: SingleChildScrollView(
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       initialValue: subject,
//                       decoration: const InputDecoration(labelText: 'Subject'),
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Please enter a subject'
//                           : null,
//                       onSaved: (value) => subject = value,
//                     ),
//                     TextFormField(
//                       initialValue: eventType,
//                       decoration: const InputDecoration(labelText: 'Event Type'),
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Please enter an event type'
//                           : null,
//                       onSaved: (value) => eventType = value,
//                     ),
//                     TimePickerFormField(
//                       initialTime: startTime,
//                       decoration: const InputDecoration(labelText: 'Start Time'),
//                       onSaved: (time) => startTime = time,
//                     ),
//                     TimePickerFormField(
//                       initialTime: endTime,
//                       decoration: const InputDecoration(labelText: 'End Time'),
//                       onSaved: (time) => endTime = time,
//                     ),
//                     TextFormField(
//                       initialValue: teacher,
//                       decoration: const InputDecoration(labelText: 'Teacher'),
//                       onSaved: (value) => teacher = value,
//                     ),
//                     TextFormField(
//                       initialValue: location,
//                       decoration: const InputDecoration(labelText: 'Location'),
//                       onSaved: (value) => location = value,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   if (formKey.currentState!.validate()) {
//                     formKey.currentState!.save();
//                     final updatedEvent = Event(
//                       subject: subject,
//                       eventType: eventType,
//                       startTime: startTime!,
//                       endTime: endTime!,
//                       teacher: teacher,
//                       location: location,
//                     );
//                     controller.editEvent(index, updatedEvent);
//                     Navigator.pop(context);
//                     print('✅ Event edited');
//                   }
//                 },
//                 child: const Text('Save'),
//               ),
//             ],
//           );
//         }
//     );
//   }
// }
//
// //----------------------------------------------------------------------------
// // Custom Widgets
//
// class EventTile extends StatelessWidget {
//   final Event event;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   const EventTile(
//       {super.key,
//         required this.event,
//         required this.onEdit,
//         required this.onDelete});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(event.subject ?? 'No Subject',
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(
//                     '${event.startTime.format(context)} - ${event.endTime.format(context)}'),
//                 Text('Type: ${event.eventType ?? 'No Type'}'),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: onEdit,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: onDelete,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TimePickerFormField extends FormField<TimeOfDay> {
//   TimePickerFormField({
//     super.key,
//     super.onSaved,
//     super.validator,
//     TimeOfDay? initialTime,
//     InputDecoration decoration = const InputDecoration(),
//   }) : super(
//     builder: (state) {
//       return InkWell(
//         onTap: () async {
//           final TimeOfDay? pickedTime = await showTimePicker(
//             context: state.context,
//             initialTime: initialTime ?? TimeOfDay.now(),
//           );
//           if (pickedTime != null) {
//             state.didChange(pickedTime);
//           }
//         },
//         child: InputDecorator(
//           decoration: decoration.copyWith(
//             errorText: state.errorText,
//           ),
//           child: Text(
//             state.value?.format(state.context) ?? 'Select Time',
//           ),
//         ),
//       );
//     },
//   );
// }
//
//
// class RoutineBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.put(RoutineController());
//   }
// }
//
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   Future<SchoolModel?> getSchoolModel(String schoolId) async {
//     try {
//       print('🔥 Getting School Model for schoolId: $schoolId');
//       final snapshot = await _db
//           .collection('schools')
//           .doc(schoolId)
//           .get();
//
//       if (snapshot.exists && snapshot.data() != null) {
//         final schoolModel = SchoolModel.fromMap(snapshot.data()!);
//         print('✅ Retrieved School Model from Firestore.');
//         return schoolModel;
//       } else {
//         print('❌ School not found with ID: $schoolId');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error getting School Model: $e');
//       return null;
//     }
//   }
//
//   Future<WeeklyRoutine?> getRoutineForSection(
//       String classId, String sectionName) async {
//     try {
//       print(
//           '🔥 get routine from section, classId: $classId section name $sectionName');
//       final docRef = _db.collection('classes').doc(classId);
//
//       final doc = await docRef.get();
//
//       if (doc.exists && doc.data() != null) {
//         final classData = doc.data()!;
//         if (classData.containsKey('sections')) {
//           final sections = classData['sections'] as List<dynamic>;
//           final section = sections.firstWhere(
//                 (section) => section['sectionName'] == sectionName,
//             orElse: () => null,
//           );
//
//           if (section != null && section.containsKey('routine')) {
//             return WeeklyRoutine.fromMap(
//                 section['routine'] as Map<String, dynamic>, classId);
//           } else {
//             print(
//                 'No routine found for section $sectionName in class $classId');
//             return null;
//           }
//         } else {
//           print('No sections found in class $classId');
//           return null;
//         }
//       } else {
//         print('Class not found with ID: $classId');
//         return null;
//       }
//     } catch (e) {
//       print(
//           'Error fetching routine for section $sectionName in class $classId: $e');
//       return null;
//     }
//   }
//
//   // Adapt this to your Firestore structure.
//   Future<void> updateSectionRoutine(String classId, String sectionName,
//       Map<String, dynamic> routineData) async {
//     try {
//       // Retrieve the class document
//       print(
//           '🔥 Updating section routine for classId: $classId, sectionName: $sectionName');
//       final classDocRef = _db.collection('classes').doc(classId);
//       final classDoc = await classDocRef.get();
//
//       if (classDoc.exists && classDoc.data() != null) {
//         final classData = classDoc.data()!;
//         if (classData.containsKey('sections')) {
//           final sections = classData['sections'] as List<dynamic>;
//
//           // Find the index of the section to update
//           int sectionIndex = sections
//               .indexWhere((section) => section['sectionName'] == sectionName);
//
//           if (sectionIndex != -1) {
//             // Update the routine for the specified section
//             sections[sectionIndex]['routine'] = routineData;
//
//             // Update the class document with the modified sections array
//             await classDocRef.update({'sections': sections});
//             print(
//                 'Routine updated successfully for section $sectionName in class $classId');
//           } else {
//             print('Section $sectionName not found in class $classId');
//             throw Exception('Section not found');
//           }
//         } else {
//           print('No sections found in class $classId');
//           throw Exception('No sections found');
//         }
//       } else {
//         print('Class not found with ID: $classId');
//         throw Exception('Class not found');
//       }
//     } catch (e) {
//       print(
//           'Error updating routine for section $sectionName in class $classId: $e');
//       rethrow; // Re-throw the exception for the controller to handle
//     }
//   }
// }
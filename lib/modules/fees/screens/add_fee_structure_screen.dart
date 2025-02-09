import 'package:cambridge_school/core/widgets/detail_card_widget.dart';
import 'package:cambridge_school/core/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/theme/widget_themes/tab_bar_theme.dart';
import '../../../core/widgets/text_field.dart';
import '../fee_structure/screens/admission_fee_structure.dart';
import '../fee_structure/screens/books_and_stationery_fee_structure_widget.dart';
import '../fee_structure/screens/hostel_fee_structure.dart';
import '../fee_structure/screens/late_fee_structure_widget.dart';
import '../fee_structure/screens/other_fee_structure_widget.dart';
import '../fee_structure/screens/re_admission_fee_structure.dart';
import '../fee_structure/screens/registration_fee_structure.dart';
import '../fee_structure/screens/transport_fee_structure.dart';
import '../fee_structure/screens/tuition_fee_structure_screen.dart';
import '../fee_structure/screens/uniform_fee_structure_widget.dart';
import '../models/fee_structure.dart';

class AddFeeStructureForm extends StatefulWidget {
  const AddFeeStructureForm({super.key});

  @override
  _AddFeeStructureFormState createState() => _AddFeeStructureFormState();
}

class _AddFeeStructureFormState extends State<AddFeeStructureForm> {
  List<String> feeCategories = [
    // Recurring Fees
    "Tuition", // (Monthly/Annually)+
    "Sports", // (Monthly/Annually)-
    "Laboratory", // (Monthly/Annually)-
    "Transport", // (distance-based)+
    "Hostel", // (Monthly/Annually)+
    "Maintenance/Development fees", // (Monthly/Annually)-

    // One-Time Fees
    "Admission", //+
    "Re-Admission", //+
    "Registration", //+
    "Security Deposit", // (Refundable)-

    // As-Needed Fees
    "Excursion/Field Trip", //-
    "ID Card", // (Lost or replacement)-
    "Late Fee", //+
    "Books & Stationery", //+
    "Meal Plan", //+
    "Special Events", // (Annual Function, Sports Day)-
    "Uniform", // (for purchase)+

    // Facility-Based Fees
    "Transport", // (varies by distance)
    "Hostel", // (boarding students only)
    "Library" // (optional for specific students)
  ];

  FeeStructure? feeStructure;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(title: const Text('Fee Structure Form')),
        body: SafeArea(
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  tabBarTheme: MyTabBarTheme.defaultTabBarTheme.copyWith(
                    indicatorColor: MyDynamicColors.activeBlue,
                    unselectedLabelColor: Colors.grey,
                    labelColor: MyDynamicColors.activeBlue,
                    dividerColor: MyDynamicColors.borderColor,
                    dividerHeight: 0.5,
                    splashFactory: NoSplash.splashFactory,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
                child: const TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Tab(
                        text: 'Tuition',
                      ),
                      Tab(
                        text: 'Transportation',
                      ),
                      Tab(
                        text: 'Hostel',
                      ),
                      Tab(
                        text: 'Admission',
                      ),
                      Tab(
                        text: 'Registration',
                      ),
                      Tab(
                        text: 'Re-Admission',
                      ),
                      Tab(
                        text: 'Books & Stationery',
                      ), Tab(
                        text: 'Uniform',
                      ),
                      Tab(
                        text: 'Late',
                      ),
                      Tab(
                        text: 'Other',
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  TuitionFeeWidget(),  // Widget for Tuition Fee
                  TransportFeeStructureWidget(),  // Widget for Transport Fee
                  HostelFeeStructureWidget(),  // Placeholder for Hostel
                  AdmissionFeeStructureWidget(),  // Placeholder for Admission
                  RegistrationFeeStructureWidget(),  // Placeholder for Registration
                  ReAdmissionFeeStructureWidget(),  // Placeholder for Re-Admission
                  BooksAndStationeryFeeStructureWidget(),  // Placeholder for Books & Stationery
                  UniformFeeStructureWidget(),
                 LateFeeStructureWidget(),  // Placeholder for Late Fee
                  OtherFeeStructureWidget(),  // Placeholder for Other
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  MyDetailCard buildOther(BuildContext context) {
    return MyDetailCard(
      title: 'Other Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField('Sports'),
            const SizedBox(height: MySizes.md),
            buildFeeTextField('Laboratory'),
            const SizedBox(height: MySizes.md),
            buildFeeTextField('Maintenance/Development '),
            const SizedBox(height: MySizes.md),
            buildFeeTextField('Security Deposit'),
            const SizedBox(height: MySizes.md),
            buildFeeTextField('Excursion/Field Trip'),
            const SizedBox(height: MySizes.md),
            buildFeeTextField('ID Card'),
            const SizedBox(height: MySizes.md),
            buildFeeTextField('Library'),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildUniform(BuildContext context) {
    return MyDetailCard(
      title: 'Uniform Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildHostel(BuildContext context) {
    return MyDetailCard(
      title: 'Hostel Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildBooksAndStationery(BuildContext context) {
    return MyDetailCard(
      title: 'Books & Stationery Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildBuildLateFee(BuildContext context) {
    return MyDetailCard(
      title: 'Late Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildRegistration(BuildContext context) {
    return MyDetailCard(
      title: 'Registration Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildReAdmission(BuildContext context) {
    return MyDetailCard(
      title: 'Re-Admission Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyDetailCard buildAdmission(BuildContext context) {
    return MyDetailCard(
      title: 'Admission Fee',
      titleStyle: Theme.of(context).textTheme.titleLarge,
      icon: Icons.error_outline,
      color: MyColors.activeOrange,
      hasSameBorderColor: true,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: MySizes.sm,
            ),
            buildFeeTextField(''),
            const SizedBox(height: MySizes.md),
            Row(
              children: [
                Text(
                  "Class 2",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                    child: MyTextField(
                  height: 42,
                  hintText: 'Adm Fee',
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            const SizedBox(height: MySizes.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Class"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildFeeTextField(String? name) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name ?? "Class 1",
            style: Theme.of(Get.context!)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 14),
            maxLines: 2,
          ),
        ),
        const SizedBox(
          width: MySizes.md,
        ),
        // const Expanded(flex: 1,
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 8.0),
        //     child: SchoolDottedLine(
        //       dashLength: 4,
        //       dashGapLength: 4,
        //       lineThickness: 1,
        //       dashColor: Colors.grey,
        //     ),
        //   ),
        // ),
        const Expanded(
            flex: 1,
            child: MyTextField(
              height: 42,
              hintText: 'Adm Fee',
              textAlign: TextAlign.center,
            )),
      ],
    );
  }
}

class FeeEntryPage extends StatefulWidget {
  const FeeEntryPage({super.key});

  @override
  _FeeEntryPageState createState() => _FeeEntryPageState();
}

class _FeeEntryPageState extends State<FeeEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String feeName = '';
  String category = 'Recurring'; // Default category
  String frequency = 'Monthly'; // Default frequency
  bool isOptional = false;
  double amount = 0.0;
  Map<String, double>? classWiseAmount = {};
  Map<String, double>? distanceWiseAmount = {};
  bool dependsOnFacility = false;
  Map<String, double>? facilityWiseAmount = {};
  DateTime? installmentDueDate;
  double installmentAmount = 0.0;
  int installmentNumber = 1;

  // Method to save the fee data
  void saveFeeData() {
    // Logic to create FeeStructure object and add installments if needed.
    if (_formKey.currentState!.validate()) {
      // Save or process the fee data.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fee Structure Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Fee Name
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Fee Name'),
                  onSaved: (value) {
                    feeName = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fee name is required';
                    }
                    return null;
                  },
                ),
                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items:
                      ['Recurring', 'One-Time', 'Facility-Based', 'As-Needed']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                // Frequency Dropdown
                DropdownButtonFormField<String>(
                  value: frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: ['Monthly', 'Annually', 'As-Needed']
                      .map((frequency) => DropdownMenuItem(
                            value: frequency,
                            child: Text(frequency),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      frequency = value!;
                    });
                  },
                ),
                // Amount Input
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    amount = double.tryParse(value ?? '0') ?? 0.0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
                    return null;
                  },
                ),
                // Is Optional Checkbox
                CheckboxListTile(
                  title: const Text('Is Optional'),
                  value: isOptional,
                  onChanged: (bool? value) {
                    setState(() {
                      isOptional = value ?? false;
                    });
                  },
                ),
                // Installment Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Installment Amount
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Installment Amount'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          installmentAmount =
                              double.tryParse(value ?? '0') ?? 0.0;
                        },
                      ),
                    ),
                    // Installment Due Date Picker
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null &&
                            pickedDate != installmentDueDate) {
                          setState(() {
                            installmentDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                // Save Button
                ElevatedButton(
                  onPressed: saveFeeData,
                  child: const Text('Save Fee Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

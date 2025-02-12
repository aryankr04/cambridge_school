import 'package:cambridge_school/app/modules/user_management/models/user_model.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/button.dart';

class SuccessScreen extends GetView<SuccessScreenController> {
  final UserModel? user;

  const SuccessScreen({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Successful Registration"),
        centerTitle: true,
      ),
      body: Container(
        color: MyColors.activeBlue.withOpacity(0.05),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(MySizes.lg),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(MySizes.cardRadiusLg)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MySizes.md, vertical: MySizes.lg),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.activeGreen.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.all(MySizes.sm),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 80,
                          ),
                        ),
                        const SizedBox(height: MySizes.md),
                        Text(
                          'Great!',
                          style: MyTextStyles.titleLarge
                              .copyWith(color: Colors.green, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Account Created Successfully',
                          style: MyTextStyles.headlineSmall
                              .copyWith(color: MyColors.headlineTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: MySizes.md),
                        Obx(() => Container(
                              decoration: BoxDecoration(
                                color: controller
                                    .getStatusColor(controller
                                        .dummyUser.value.accountStatus)
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(MySizes.cardRadiusSm),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: MySizes.md, vertical: MySizes.sm),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    controller.getStatusIcon(controller
                                        .dummyUser.value.accountStatus),
                                    color: controller.getStatusColor(controller
                                        .dummyUser.value.accountStatus),
                                    size: 20,
                                  ),
                                  const SizedBox(width: MySizes.md),
                                  Text(
                                    controller.getStatusText(controller
                                        .dummyUser.value.accountStatus),
                                    style: MyTextStyles.bodySmall.copyWith(
                                        color: controller.getStatusColor(
                                            controller.dummyUser.value
                                                .accountStatus)),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: MySizes.spaceBtwSections),
                        AccountDetailSection(
                            user: controller
                                .dummyUser.value), //Use dummy user here
                        const SizedBox(height: MySizes.spaceBtwSections),
                        MyButton(

                          onPressed: () {
                            Get.offAllNamed('/');
                          },
                          text: 'Back to home',

                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: MySizes.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountDetailSection extends GetView<SuccessScreenController> {
  final UserModel user;

  const AccountDetailSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: MySizes.md - 4, vertical: MySizes.md - 4),
              margin: const EdgeInsets.symmetric(vertical: MySizes.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                color: Colors.grey.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: user.profileImageUrl != null
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                          ),
                          const SizedBox(
                            width: MySizes.md,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: MyTextStyles.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user.userId,
                                style: MyTextStyles.bodySmall
                                    .copyWith(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                      IconButton(
                        icon: Icon(
                          controller.isExpanded.value
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          controller.toggleExpanded();
                        },
                      ),
                    ],
                  ),
                  if (controller.isExpanded.value)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: MySizes.md,
                        ),
                        const _CategoryTitle("Basic Information"),
                        _DetailTile(
                            title: "User ID",
                            value: user.userId,
                            icon: Icons.vpn_key),
                        _DetailTile(
                            title: "Username",
                            value: user.username,
                            icon: Icons.account_circle),
                        _DetailTile(
                            title: "Full Name",
                            value: user.fullName,
                            icon: Icons.person),
                        _DetailTile(
                            title: "Email",
                            value: user.email,
                            icon: Icons.email),
                        _DetailTile(
                            title: "Phone Number",
                            value: user.phoneNo,
                            icon: Icons.phone),
                        const _CategoryTitle("Personal Information"),
                        _DetailTile(
                            title: "Nationality",
                            value: user.nationality ?? 'N/A',
                            icon: Icons.flag),
                        _DetailTile(
                            title: "Religion",
                            value: user.religion ?? 'N/A',
                            icon: Icons.self_improvement),
                        _DetailTile(
                            title: "Category",
                            value: user.category ?? 'N/A',
                            icon: Icons.category),
                        _DetailTile(
                            title: "Gender",
                            value: user.gender ?? 'N/A',
                            icon: Icons.wc),
                        _DetailTile(
                          title: "Date of Birth",
                          value: user.dob != null
                              ? "${user.dob!.day}/${user.dob!.month}/${user.dob!.year}"
                              : 'N/A',
                          icon: Icons.calendar_today,
                        ),
                        _DetailTile(
                            title: "Marital Status",
                            value: user.maritalStatus ?? 'N/A',
                            icon: Icons.favorite),
                        _DetailTile(
                            title: "Languages Spoken",
                            value: user.languagesSpoken?.join(', ') ?? 'N/A',
                            icon: Icons.chat),
                        _DetailTile(
                          title: "Hobbies",
                          value: user.hobbies?.join(', ') ?? 'N/A',
                          icon: Icons.star,
                        ),
                        _DetailTile(
                          title: "Profile Description",
                          value: user.profileDescription ?? 'N/A',
                          icon: Icons.description,
                        ),
                        const _CategoryTitle("Physical and Health Information"),
                        _DetailTile(
                          title: "Height",
                          value: user.getHeightInFeetInches(),
                          icon: Icons.height,
                        ),
                        _DetailTile(
                          title: "Weight",
                          value:
                              user.weight != null ? "${user.weight} kg" : 'N/A',
                          icon: Icons.monitor_weight,
                        ),
                        _DetailTile(
                          title: "Blood Group",
                          value: user.bloodGroup ?? 'N/A',
                          icon: Icons.bloodtype,
                        ),
                        _DetailTile(
                          title: "Physical Disability",
                          value: user.isPhysicalDisability != null
                              ? (user.isPhysicalDisability! ? 'Yes' : 'No')
                              : 'N/A',
                          icon: Icons.accessible,
                        ),
                        const _CategoryTitle("User Roles"),
                        _DetailTile(
                          title: "All Roles",
                          value: user.roles?.map((e) => e.name).join(", ") ??
                              'N/A',
                          icon: Icons.manage_accounts,
                        ),
                        const _CategoryTitle("Address Details"),
                        _DetailTile(
                            title: "Permanent Address",
                            value: controller
                                    .getFullAddress(user.permanentAddress),
                            icon: Icons.home),
                        _DetailTile(
                            title: "Current Address",
                            value: controller
                                    .getFullAddress(user.currentAddress),
                            icon: Icons.location_on),
                        const _CategoryTitle("Transportation Details"),
                        _DetailTile(
                            title: "Mode Of Transport",
                            value: user.modeOfTransport ?? 'N/A',
                            icon: Icons.directions_bus),
                        _DetailTile(
                            title: "transport RouteNumber",
                            value: user.transportDetails?.routeNumber ?? 'N/A',
                            icon: Icons.bus_alert),
                        _DetailTile(
                            title: "transport PickupPoint",
                            value: user.transportDetails?.pickupPoint ?? 'N/A',
                            icon: Icons.bus_alert_outlined),
                        _DetailTile(
                            title: "transport DropOffPoint",
                            value: user.transportDetails?.dropOffPoint ?? 'N/A',
                            icon: Icons.remove_done),
                        _DetailTile(
                            title: "transport VehicleNumber",
                            value:
                                user.transportDetails?.vehicleNumber ?? 'N/A',
                            icon: Icons.keyboard),
                        _DetailTile(
                            title: "transport Fare",
                            value:
                                user.transportDetails?.fare.toString() ?? 'N/A',
                            icon: Icons.monetization_on),
                        const _CategoryTitle("Favorite Details"),
                        _DetailTile(
                            title: "Favorite Dish",
                            value: user.favorites?.dish ?? 'N/A',
                            icon: Icons.cake),
                        _DetailTile(
                            title: "Favorite Teacher",
                            value: user.favorites?.teacher ?? 'N/A',
                            icon: Icons.school),
                        _DetailTile(
                            title: "Favorite Sport",
                            value: user.favorites?.sport ?? 'N/A',
                            icon: Icons.sports_basketball),
                        _DetailTile(
                            title: "Favorite Athlete",
                            value: user.favorites?.athlete ?? 'N/A',
                            icon: Icons.emoji_events),
                        if (user.qualifications != null) ...[
                          const _CategoryTitle('Qualifications'),
                          ...(user.qualifications ?? []).map((e) => _DetailTile(
                              title: "Education",
                              value:
                                  "${e.degreeName} from ${e.institutionName} with result of ${e.result} in the subject of ${e.majorSubject}",
                              icon: Icons.school))
                        ],
                        const _CategoryTitle("More"),
                        _DetailTile(
                            title: "Performance Rating",
                            value: user.performanceRating.toString(),
                            icon: Icons.stars),
                        _DetailTile(
                          title: "Account Status",
                          value: user.accountStatus,
                          icon: Icons.check_circle,
                        ),
                        _DetailTile(
                            title: "School Id",
                            value: user.schoolId ?? 'N/A',
                            icon: Icons.corporate_fare),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}

class _DetailTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 18),
          const SizedBox(width: 8),
          Text("$title:",
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value,
                style: MyTextStyles.bodySmall.copyWith(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

class _CategoryTitle extends StatelessWidget {
  final String title;
  const _CategoryTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MySizes.xs),
      child: Text(title,
          style: MyTextStyles.titleMedium.copyWith(
              color: MyColors.activeBlue, fontWeight: FontWeight.w600)),
    );
  }
}

class SuccessScreenController extends GetxController {
  //TODO: Implement SuccessScreenController

  final dummyUser = UserModel(
          userId: 'dummy-user-123',
          username: 'Test User',
          email: 'test@example.com',
          accountStatus: 'active',
          fullName: 'Test User Full Name',
          phoneNo: '123-456-7890',
          points: 100,
          performanceRating: 4.5,
          nationality: 'Indian',
          religion: 'Christian',
          category: 'General',
          gender: 'Male',
          maritalStatus: 'Single',
          height: 175.0,
          weight: 70.0,
          bloodGroup: 'O+',
          isPhysicalDisability: false,
          modeOfTransport: 'School Transport',
          qualifications: [
            Qualification(
              degreeName: "Bachelor's Degree",
              institutionName: "Example University",
              passingYear: "2020",
              majorSubject: "Computer Science",
              resultType: "Percentage",
              result: "85",
            )
          ],
          hobbies: ['Reading', 'Coding', 'Sports'],
          languagesSpoken: ['English', 'Spanish'],
          roles: UserRole.values.toList(), //Assigning all the Roles
          permanentAddress: Address(
            houseAddress: '123 Main St',
            city: 'Anytown',
            district: 'Anydistrict',
            state: 'Anystate',
            village: 'Anyvillage',
            pinCode: '12345',
          ),
          currentAddress: Address(
            houseAddress: '456 Elm St',
            city: 'Newtown',
            district: 'Newdistrict',
            state: 'Newstate',
            village: 'Newvillage',
            pinCode: '67890',
          ),
          transportDetails: TransportDetails(
              routeNumber: "S-12",
              pickupPoint: "A",
              dropOffPoint: "Z",
              vehicleNumber: "WB2345",
              fare: 300),
          emergencyContact: EmergencyContact(
            fullName: 'Emergency Contact Person',
            relationship: 'Friend',
            phoneNumber: '987-654-3210',
            emailAddress: 'emergency@example.com',
          ),
          fatherDetails: GuardianDetails(
              fullName: "Father",
              relationshipToStudent: "Father",
              occupation: "Teacher",
              phoneNumber: "455-454-2322",
              emailAddress: "abc@gmail.com",
              highestEducationLevel: "Doctorate",
              annualIncome: "3000"),
          motherDetails: GuardianDetails(
            fullName: "Mother",
            relationshipToStudent: "Mother",
            occupation: "Software Engineer",
            phoneNumber: "566-454-2322",
            emailAddress: "sdfsdf@gmail.com",
            highestEducationLevel: "Master",
            annualIncome: "4000",
          ),
          studentDetails: StudentDetails(
              studentId: "stu1234",
              rollNumber: "12",
              admissionNo: "23234",
              className: "10",
              section: "A",
              house: "Red",
              previousSchoolName: "ABC",
              ambition: "Engineer"),
          teacherDetails: TeacherDetails(
              teacherId: "tech2323",
              subjectsTaught: ["Science", "Maths"],
              experience: "5 Years"),
          driverDetails: DriverDetails(
              licenseNumber: "23234-sdsd-232", routesAssigned: ["232"]),
          directorDetails: DirectorDetails(
              schools: ["ABC High School"],
              yearsInManagement: 5,
              permissions: ["sdfsdf-sdfsdf"]),
          securityGuardDetails: SecurityGuardDetails(assignedArea: "ABC area"),
          adminDetails: AdminDetails(
            permissions: ["sdfsdfsd"],
            assignedModules: ["manageable"],
            manageableSchools: ["School Admin"],
          ),
          maintenanceStaffDetails: MaintenanceStaffDetails(
            responsibilities: ["Maintainance"],
          ),
          departmentHeadDetails: DepartmentHeadDetails(
            department: "XYZ",
            yearsAsHead: 5,
            responsibilities: ["sdfsdf", "sdfsdf"],
          ),
          favorites: Favorite(
            dish: 'Pizza',
            subject: 'Math',
            teacher: 'Mr. Smith',
            book: 'The Example Book',
            sport: 'Football',
            athlete: 'An Athlete',
            movie: 'An Example Movie',
            cuisine: 'Italian',
            singer: 'A Singer',
            favoritePlaceToVisit: 'Example Place',
            festival: 'Example Festival',
            personality: 'An Example Personality',
            season: 'Winter',
            animal: 'Dog',
            quote: 'An example quote',
          ),
          isActive: false,
          joiningDate: DateTime.now(),
          createdAt: DateTime.now(),
          schoolId: "234-2343")
      .obs;

  final isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  String getFullAddress(Address? address) {
    if (address == null) return "N/A";
    return "${address.houseAddress ?? ''}, ${address.village ?? ''}, ${address.city ?? ''}, ${address.district ?? ''}, ${address.state ?? ''}, ${address.pinCode ?? ''}";
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'active':
        return MyColors.activeGreen;
      case 'suspended':
        return MyColors.activeRed;
      case 'pending':
        return MyColors.activeOrange;
      case 'inactive':
        return MyColors.grey;
      default:
        return MyColors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'suspended':
      case 'pending':
      case 'inactive':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Your account is active';
      case 'suspended':
        return 'Your account is suspended';
      case 'pending':
        return 'Your account is pending approval';
      case 'inactive':
        return 'Your account is inactive';
      default:
        return 'Unknown account status';
    }
  }



}

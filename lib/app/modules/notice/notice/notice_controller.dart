// notice_screen.dart
import 'package:get/get.dart';
import '../notice_model.dart';
import '../notice_repository.dart';




class NoticeController extends GetxController {
  final isLoading = false.obs;
  final noticeList = <Notice>[].obs;
  final filteredNoticeList = <Notice>[].obs;
  final errorMessage = RxnString();
  final NoticeRosterRepository noticeRepository = NoticeRosterRepository();
  String schoolId = 'SCH00001';
  String academicYear = '2024-2025';
  final selectedTargetAudience = <String>[].obs;
  final selectedForClass = <String>[].obs;
  final selectedCategory = <String>[].obs; // Added for category filter

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
    everAll([selectedTargetAudience, selectedForClass, selectedCategory],
            (_) => filterNotices()); // Included Category
  }

  Future<void> fetchNotices() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final notices =
      await noticeRepository.getAllNotices(schoolId, academicYear);
      noticeList.assignAll(notices);
      filterNotices();
    } catch (e) {
      print('Error fetching notices: $e');
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load notices. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void filterNotices() {
    filteredNoticeList.clear();

    if (selectedTargetAudience.contains('All') &&
        selectedForClass.isEmpty &&
        selectedCategory.isEmpty) {
      filteredNoticeList.assignAll(noticeList);
      return;
    }

    filteredNoticeList.assignAll(noticeList.where((notice) {
      bool audienceMatch = true;
      bool classMatch = true;
      bool categoryMatch = true;

      if (selectedTargetAudience.isNotEmpty &&
          !selectedTargetAudience.contains('All')) {
        if (notice.targetAudience.isEmpty) {
          audienceMatch = false;
        } else {
          bool anyAudienceMatch = false;
          for (String selectedAudience in selectedTargetAudience) {
            if (notice.targetAudience.contains(selectedAudience)) {
              anyAudienceMatch = true;
              break;
            }
          }
          audienceMatch = anyAudienceMatch;
        }
      }

      if (selectedForClass.isNotEmpty) {
        if (notice.targetClass == null || notice.targetClass!.isEmpty) {
          classMatch = false;
        } else {
          bool anyClassMatch = false;
          for (String selectedClass in selectedForClass) {
            if (notice.targetClass!.contains(selectedClass)) {
              anyClassMatch = true;
              break;
            }
          }
          classMatch = anyClassMatch;
        }
      }

      //Category Filter
      if (selectedCategory.isNotEmpty) {
        bool anyCategoryMatch = false;
        for (String selected in selectedCategory) {
          if (notice.category == selected) {
            anyCategoryMatch = true;
            break;
          }
        }
        categoryMatch = anyCategoryMatch;
            }

      return audienceMatch && classMatch && categoryMatch;
    }).toList());
  }

  void setSelectedTargetAudience(List<String>? audience) {
    if (audience != null) {
      selectedTargetAudience.assignAll(audience);
    } else {
      selectedTargetAudience.clear();
    }
  }

  void setSelectedForClass(List<String>? classes) {
    if (classes != null) {
      selectedForClass.assignAll(classes);
    } else {
      selectedForClass.clear();
    }
  }

  void setSelectedCategory(List<String>? categories) {
    if (categories != null) {
      selectedCategory.assignAll(categories);
    } else {
      selectedCategory.clear();
    }
  }

  Future<void> deleteNotice(Notice notice) async {
    isLoading.value = true;
    try {
      await noticeRepository.deleteNoticeFromRoster(
        schoolId: schoolId,
        academicYear: academicYear,
        noticeTitle: notice.title,
      );

      await fetchNotices();
    } catch (e) {
      print('Error deleting notice: $e');
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to delete notice. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
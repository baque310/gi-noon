import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/app_strings.dart';

import 'package:noon/data/api_services.dart';
import 'package:noon/core/print_value.dart';

class GuestHomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<dynamic> banners = <dynamic>[].obs;
  RxList<dynamic> horizontalBanners = <dynamic>[].obs;
  RxList<dynamic> verticalBanners = <dynamic>[].obs;
  RxInt currentBannerIndex = 0.obs;

  // Directory Listing categories
  RxList<dynamic> institutes = <dynamic>[].obs;
  RxList<dynamic> physicalActivities = <dynamic>[].obs;
  RxList<dynamic> privateSchools = <dynamic>[].obs;
  RxList<dynamic> kindergartens = <dynamic>[].obs;
  RxList<dynamic> libraries = <dynamic>[].obs;
  RxList<dynamic> uniforms = <dynamic>[].obs;
  RxList<dynamic> teachers = <dynamic>[].obs;
  RxList<dynamic> smartToys = <dynamic>[].obs;
  RxList<dynamic> healthDental = <dynamic>[].obs;
  RxList<dynamic> healthPediatric = <dynamic>[].obs;
  RxList<dynamic> healthSpecialist = <dynamic>[].obs;

  // Province
  RxString selectedProvince = ''.obs;
  RxInt unreadNotificationsCount = 0.obs;
  RxMap<String, int> clearedCategoryBadges = <String, int>{}.obs;
  
  RxString searchQuery = ''.obs;

  static const List<String> provinces = [
    'بغداد - الرصافة',
    'بغداد - الكرخ',
    'البصرة',
    'نينوى',
    'أربيل',
    'النجف',
    'كربلاء',
    'ذي قار',
    'بابل',
    'الأنبار',
    'ديالى',
    'كركوك',
    'صلاح الدين',
    'واسط',
    'ميسان',
    'المثنى',
    'القادسية',
    'دهوك',
    'السليمانية',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadClearedBadges();
    fetchDirectory();
    fetchBanners();
    fetchUnreadNotificationsCount();
  }

  void _loadClearedBadges() {
    try {
      var box = Hive.box(AppStrings.boxKey);
      final List<String> keys = [
        'INSTITUTE', 'PHYSICAL_ACTIVITY', 'KINDERGARTEN', 'PRIVATE_SCHOOL', 'TEACHER',
        'LIBRARY', 'UNIFORM', 'SMART_TOYS', 'HEALTH_DENTAL', 'HEALTH_PEDIATRIC', 'HEALTH_SPECIALIST'
      ];
      for (String key in keys) {
        clearedCategoryBadges[key] = box.get('badge_clear_$key', defaultValue: 0);
      }
    } catch (e) {
      dprint('Error loading badges: $e');
    }
  }

  void clearCategoryBadge(String key, int currentActualCount) {
    try {
      var box = Hive.box(AppStrings.boxKey);
      box.put('badge_clear_$key', currentActualCount);
      clearedCategoryBadges[key] = currentActualCount;
    } catch (e) {
      dprint('Error clearing badge: $e');
    }
  }

  int getBadgeDisplayCount(String key, int actualCount) {
    int cleared = clearedCategoryBadges[key] ?? 0;
    int diff = actualCount - cleared;
    return diff > 0 ? diff : 0;
  }

  Future<void> fetchUnreadNotificationsCount() async {
    try {
      final response = await ApiService().get(url: '/public/notifications');
      if (response.data != null && response.data is List) {
        final List<dynamic> allNotifications = response.data;
        var box = Hive.box(AppStrings.boxKey);
        List<String> readList = box.get('read_notifications', defaultValue: <String>[])!.cast<String>();
        
        int count = 0;
        for (var item in allNotifications) {
          if (!readList.contains(item['id'].toString())) {
            count++;
          }
        }
        unreadNotificationsCount.value = count;
      }
    } catch (e) {
      dprint('Error fetching notifications count: $e');
    }
  }

  void setProvince(String province) {
    selectedProvince.value = province;
    fetchDirectory();
  }

  Future<void> fetchBanners() async {
    try {
      final response = await ApiService().get(
        url: '/public/banner',
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          banners.value = response.data;
          horizontalBanners.assignAll(banners.where((b) => b['isVertical'] != true).toList());
          verticalBanners.assignAll(banners.where((b) => b['isVertical'] == true).toList());
        }
      }
    } catch (e) {
      dprint('Banner fetch error: $e');
    }
  }

  Future<void> fetchDirectory() async {
    if (institutes.isEmpty && banners.isEmpty) {
      isLoading.value = true;
    }
    try {
      String url = '/public/directory-listing';
      if (selectedProvince.value.isNotEmpty) {
        url += '?province=${Uri.encodeComponent(selectedProvince.value)}';
      }

      final response = await ApiService().get(url: url);

      if (response.statusCode == 200 && response.data != null) {
        final categories = response.data['categories'] ?? {};
        institutes.value = categories['institute'] ?? [];
        physicalActivities.value = categories['physical_activity'] ?? [];
        privateSchools.value = categories['private_school'] ?? [];
        kindergartens.value = categories['kindergarten'] ?? [];
        libraries.value = categories['library'] ?? [];
        uniforms.value = categories['uniform'] ?? [];
        teachers.value = categories['teacher'] ?? [];
        smartToys.value = categories['smart_toys'] ?? [];
        healthDental.value = categories['health_dental'] ?? [];
        healthPediatric.value = categories['health_pediatric'] ?? [];
        healthSpecialist.value = categories['health_specialist'] ?? [];
      }
    } catch (e) {
      dprint('Directory fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _matchesSearch(dynamic item) {
    if (searchQuery.value.trim().isEmpty) return true;
    final query = searchQuery.value.trim().toLowerCase();
    
    final name = (item['name'] ?? '').toString().toLowerCase();
    final description = (item['description'] ?? '').toString().toLowerCase();
    
    return name.contains(query) || description.contains(query);
  }

  List<dynamic> get filteredInstitutes => institutes.where(_matchesSearch).toList();
  List<dynamic> get filteredPhysicalActivities => physicalActivities.where(_matchesSearch).toList();
  List<dynamic> get filteredPrivateSchools => privateSchools.where(_matchesSearch).toList();
  List<dynamic> get filteredKindergartens => kindergartens.where(_matchesSearch).toList();
  List<dynamic> get filteredLibraries => libraries.where(_matchesSearch).toList();
  List<dynamic> get filteredUniforms => uniforms.where(_matchesSearch).toList();
  List<dynamic> get filteredTeachers => teachers.where(_matchesSearch).toList();
  List<dynamic> get filteredSmartToys => smartToys.where(_matchesSearch).toList();
  List<dynamic> get filteredHealthDental => healthDental.where(_matchesSearch).toList();
  List<dynamic> get filteredHealthPediatric => healthPediatric.where(_matchesSearch).toList();
  List<dynamic> get filteredHealthSpecialist => healthSpecialist.where(_matchesSearch).toList();

  List<dynamic> getItemsByCategory(String categoryKey) {
    switch (categoryKey) {
      case 'INSTITUTE': return filteredInstitutes;
      case 'PHYSICAL_ACTIVITY': return filteredPhysicalActivities;
      case 'PRIVATE_SCHOOL': return filteredPrivateSchools;
      case 'KINDERGARTEN': return filteredKindergartens;
      case 'LIBRARY': return filteredLibraries;
      case 'UNIFORM': return filteredUniforms;
      case 'TEACHER': return filteredTeachers;
      case 'SMART_TOYS': return filteredSmartToys;
      case 'HEALTH_DENTAL': return filteredHealthDental;
      case 'HEALTH_PEDIATRIC': return filteredHealthPediatric;
      case 'HEALTH_SPECIALIST': return filteredHealthSpecialist;
      default: return [];
    }
  }
}

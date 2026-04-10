import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/core/print_value.dart';

class GuestHomeController extends GetxController {
  final box = Hive.box(AppStrings.boxKey);

  RxBool isLoading = true.obs;
  RxList<dynamic> banners = <dynamic>[].obs;
  RxInt currentBannerIndex = 0.obs;
  RxList<dynamic> stories = <dynamic>[].obs;

  // Directory Listing categories (from new API)
  RxList<dynamic> institutes = <dynamic>[].obs;
  RxList<dynamic> privateSchools = <dynamic>[].obs;
  RxList<dynamic> kindergartens = <dynamic>[].obs;
  RxList<dynamic> libraries = <dynamic>[].obs;
  RxList<dynamic> uniforms = <dynamic>[].obs;
  RxList<dynamic> teachers = <dynamic>[].obs;

  // Province
  RxString selectedProvince = ''.obs;

  static const List<String> provinces = [
    'بغداد - الرصافة',
    'بغداد - الكرخ',
    'البصرة',
    'الموصل (نينوى)',
    'أربيل',
    'النجف',
    'ذي قار',
    'كركوك',
    'الأنبار',
    'ديالى',
    'المثنى',
    'القادسية',
    'ميسان',
    'واسط',
    'صلاح الدين',
    'دهوك',
    'السليمانية',
    'بابل',
    'كربلاء',
    'حلبجة',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDirectory();
  }

  void setProvince(String province) {
    selectedProvince.value = province;
    fetchDirectory();
  }

  Future<void> fetchDirectory() async {
    if (institutes.isEmpty && banners.isEmpty) {
      isLoading.value = true;
    }
    try {
      // Fetch banners from old API
      try {
        final bannerResponse = await ApiService().get(
          url: '${ApiUrls.baseUrl}/public/school/directory',
        );
        if (bannerResponse.statusCode == 200 && bannerResponse.data != null) {
          banners.value = bannerResponse.data['banners'] ?? [];
        }
      } catch (e) {
        dprint('Banner fetch error: $e');
      }

      // Fetch stories
      try {
        final storyResponse = await ApiService().get(
          url: '${ApiUrls.baseUrl}/public/story',
        );
        if (storyResponse.statusCode == 200 && storyResponse.data != null) {
          stories.value = (storyResponse.data as List).map((s) {
            return {
              ...s,
              'thumbnail': '${ApiUrls.filesUrl}/${s['thumbnail']}',
              'videoUrl': '${ApiUrls.filesUrl}/${s['videoUrl']}',
            };
          }).toList();
        }
      } catch (e) {
        dprint('Stories fetch error: $e');
      }

      // Fetch directory listings from new API
      String url = '${ApiUrls.baseUrl}/public/directory-listing';
      if (selectedProvince.value.isNotEmpty) {
        url += '?province=${Uri.encodeComponent(selectedProvince.value)}';
      }

      final response = await ApiService().get(url: url);

      if (response.statusCode == 200 && response.data != null) {
        final categories = response.data['categories'] ?? {};
        institutes.value = categories['institute'] ?? [];
        privateSchools.value = categories['private_school'] ?? [];
        kindergartens.value = categories['kindergarten'] ?? [];
        libraries.value = categories['library'] ?? [];
        uniforms.value = categories['uniform'] ?? [];
        teachers.value = categories['teacher'] ?? [];
      }
    } catch (e) {
      dprint('Guest fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.toNamed(ScreensUrls.loginUrl);
  }

  void goToSchoolCode() {
    Get.toNamed(ScreensUrls.schoolCodeUrl);
  }

  List<dynamic> getItemsByCategory(String categoryKey) {
    switch (categoryKey) {
      case 'INSTITUTE':
        return institutes.toList();
      case 'PRIVATE_SCHOOL':
        return privateSchools.toList();
      case 'KINDERGARTEN':
        return kindergartens.toList();
      case 'LIBRARY':
        return libraries.toList();
      case 'UNIFORM':
        return uniforms.toList();
      case 'TEACHER':
        return teachers.toList();
      default:
        return [];
    }
  }
}

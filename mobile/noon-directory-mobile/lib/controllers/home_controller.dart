import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/banner_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';

import '../core/localization/language.dart';

class HomeController extends GetxController {
  //////////// bottom naviagation bar /////////////
  // Observable integer for selected index
  var selectedIndex = 2.obs; // Default to Home (center tab)

  // Observable for assignment tabs screen
  var assignmentTabIndex = 0.obs;

  // Method to update the selected index
  void changePage(int index) {
    selectedIndex.value = index;
  }

  //////////// main screen /////////////
  RxBool loading = false.obs;
  RxList<BannerModel> banners = <BannerModel>[].obs;
  final ApiService _apiService = ApiService();

  Future getBanners() async {
    dprint("Get banners ...");

    try {
      loading(true);
      var res = await _apiService.get(url: ApiUrls.bannersUrl);

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      // DEBUG: Print raw JSON keys for the first banner to identify the image field
      final rawData = res.data['data'] as List;
      if (rawData.isNotEmpty) {
        dprint("========== BANNER DEBUG ==========");
        dprint("First banner ALL KEYS: ${(rawData[0] as Map).keys.toList()}");
        dprint("First banner ALL DATA: ${rawData[0]}");
        dprint("First banner 'url' value: ${rawData[0]['url']}");
        dprint("First banner 'imageUrl' value: ${rawData[0]['imageUrl']}");
        dprint("First banner 'image' value: ${rawData[0]['image']}");
        dprint("First banner 'attachment' value: ${rawData[0]['attachment']}");
        dprint("First banner 'file' value: ${rawData[0]['file']}");
        dprint("First banner 'photo' value: ${rawData[0]['photo']}");
        dprint("========== END BANNER DEBUG ==========");
      }

      final items = List<BannerModel>.from(
        rawData.map((e) => BannerModel.fromJson(jsonEncode(e))),
      );

      // DEBUG: Print each parsed banner URL
      for (var b in items) {
        dprint(
          "Parsed banner - id: ${b.id}, url: '${b.url}', title: '${b.title}'",
        );
      }

      banners(items);
    } catch (e) {
      dprint("Error in Get banners ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  // ? Today's Wisdom
  Rxn<String> todayWisdom = Rxn<String>(null);

  Future getTodayWisdom() async {
    try {
      final res = await _apiService.get(url: ApiUrls.todayWisdomUrl);
      if (res.data != null && res.data['title'] != null) {
        todayWisdom.value = res.data['title'];
      }
    } catch (e) {
      dprint("Error fetching today's wisdom: $e");
    }
  }

  @override
  void onInit() {
    getBanners();
    getTodayWisdom();
    super.onInit();
  }
}

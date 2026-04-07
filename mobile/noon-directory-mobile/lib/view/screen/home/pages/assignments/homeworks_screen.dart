import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/view/screen/home/pages/assignments/student/homework_section.dart';
import 'package:noon/view/widget/custom_appbar_v2.dart';
import '../../../../../core/localization/language.dart';

class HomeworksScreen extends StatefulWidget {
  const HomeworksScreen({super.key});

  @override
  State<HomeworksScreen> createState() => _HomeworksScreenState();
}

class _HomeworksScreenState extends State<HomeworksScreen>
    with SingleTickerProviderStateMixin {
  final gController = Get.put(GlobalController());
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        appBar: CustomAppBarV2(
          appBarName: AppLanguage.assignmentStr.tr,
          isLeading: gController.isTeacher ? true : false,
        ),
        body: Padding(
          padding: const .symmetric(horizontal: 16),
          child: HomeworksSection(),
        ),
      ),
    );
  }
}

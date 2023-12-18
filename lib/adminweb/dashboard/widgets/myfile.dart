import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/dashboard/widgets/card.dart';

import '../../../color.dart';
import '../../../responsive.dart';
import '../../models/dashboard/cloud_storage_model.dart';
import '../../providers/report/report_provider.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 ? 1.3 : 1,
          ),
          tablet: const FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends ConsumerStatefulWidget {
  const FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  ConsumerState<FileInfoCardGridView> createState() =>
      _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends ConsumerState<FileInfoCardGridView> {
  int totalReports = 0;
  int totalPendingreport = 0;
  int totalOngoingReport = 0;
  int totalCompletedReports = 0;

  List<CloudStorageInfo> demoMyFiles = [];

  Future<void> setAllValues() async {
    final reportProvider = ref.read(reportProviderProvider.notifier);
    totalReports = await reportProvider.monthlyReport();
    totalPendingreport = await reportProvider.pendingReports();
    totalOngoingReport = await reportProvider.onGoingReports();
    totalCompletedReports = await reportProvider.completedReports();
  }

  @override
  void initState() {
    setAllValues().then((value) => {
          setState(() {
            demoMyFiles = [
              CloudStorageInfo(
                title: "Month Reports",
                numOfFiles: totalReports,
                color: primaryColor,
                percentage: ((totalReports / 100) * 100).round(),
              ),
              CloudStorageInfo(
                title: "Pending Reports",
                numOfFiles: totalPendingreport,
                color: const Color(0xFFFFA113),
                percentage: ((totalPendingreport / 100) * 100).round(),
              ),
              CloudStorageInfo(
                title: "Ongoing Reports",
                numOfFiles: totalOngoingReport,
                color: const Color(0xFFA4CDFF),
                percentage: ((totalOngoingReport / 100) * 100).round(),
              ),
              CloudStorageInfo(
                title: "Completed Reports",
                numOfFiles: totalCompletedReports,
                color: const Color(0xFF007EE5),
                percentage: ((totalCompletedReports / 100) * 100).round(),
              ),
            ];
          })
        });
    setState(() {
      demoMyFiles = [
        CloudStorageInfo(
          title: "Month Reports",
          numOfFiles: totalReports,
          color: primaryColor,
          percentage: ((totalReports / 100) * 100).round(),
        ),
        CloudStorageInfo(
          title: "Pending Reports",
          numOfFiles: totalPendingreport,
          color: const Color(0xFFFFA113),
          percentage: ((totalPendingreport / 100) * 100).round(),
        ),
        CloudStorageInfo(
          title: "Ongoing Reports",
          numOfFiles: totalOngoingReport,
          color: const Color(0xFFA4CDFF),
          percentage: ((totalOngoingReport / 100) * 100).round(),
        ),
        CloudStorageInfo(
          title: "Completed Reports",
          numOfFiles: totalCompletedReports,
          color: const Color(0xFF007EE5),
          percentage: ((totalCompletedReports / 100) * 100).round(),
        ),
      ];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
    );
  }
}

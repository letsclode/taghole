// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:taghole/adminweb/providers/report_provider.dart';

// import '../models/report/report_model.dart';

// class Switcher extends ConsumerStatefulWidget {
//   const Switcher({super.key, required this.data, required this.uid});
//   final ReportModel data;
//   final String uid;

//   @override
//   ConsumerState<Switcher> createState() => _SwitcherState();
// }

// class _SwitcherState extends ConsumerState<Switcher> {
//   bool isVisible = false;
//   late String uid;

//   @override
//   void initState() {
//     // TODO: implement initState
//     setState(() {
//       isVisible = widget.data.isVerified;
//     });
//     super.initState();R
//   }

//   @override
//   Widget build(BuildContext context) {
//     final reportProvider = ref.watch(reportProviderProvider.notifier);
//     return FutureBuilder<bool>(
//       future: reportProvider.verifyReport(
//           isVisible, widget.uid), // This is the Future you want to listen to
//       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//         return Switch(
//             value: snapshot.data ?? false,
//             onChanged: (value) {
//               setState(() {
//                 isVisible = value;
//               });
//             });
//       },
//     );
//   }
// }

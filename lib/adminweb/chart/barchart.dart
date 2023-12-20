import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/report/report_provider.dart';

class BarChartSample2 extends ConsumerStatefulWidget {
  const BarChartSample2({super.key});
  final Color ongoingColor = Colors.yellow;
  final Color rejectedColor = Colors.red;
  final Color completedColor = Colors.blue;
  final Color pendingColor = Colors.green;
  final Color avgColor = Colors.orange;
  @override
  ConsumerState<BarChartSample2> createState() => BarChartSample2State();
}

class BarChartSample2State extends ConsumerState<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  final titles = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  Future<List<BarChartGroupData>> setAllValues() async {
    final reportProvider = ref.read(reportProviderProvider.notifier);
    print('setting all values');
    List<BarChartGroupData> items = [];
    titles.forEach((element) async {
      int totalPendingreport = await reportProvider.reportCounter(
          reportType: 'pending', month: titles.indexOf(element) + 1);
      int totalOngoingReport = await reportProvider.reportCounter(
          reportType: 'ongoing', month: titles.indexOf(element) + 1);
      int totalCompletedReports = await reportProvider.reportCounter(
          reportType: 'completed', month: titles.indexOf(element) + 1);
      int totalRejectedReport = await reportProvider.reportCounter(
          reportType: 'rejected', month: titles.indexOf(element) + 1);

      items.add(makeGroupData(
        titles.indexOf(element),
        double.parse(totalPendingreport.toString()),
        double.parse(totalOngoingReport.toString()),
        double.parse(totalCompletedReports.toString()),
        double.parse(totalRejectedReport.toString()),
      ));
      print(
          'data : $totalPendingreport $totalOngoingReport $totalCompletedReports $totalRejectedReport');
    });

    return items;
  }

  @override
  void initState() {
    super.initState();

    var items = titles
        .map((e) => makeGroupData(
              titles.indexOf(e),
              0,
              0,
              0,
              0,
            ))
        .toList();

    setState(() {
      rawBarGroups = items;
      showingBarGroups = rawBarGroups;
    });

    setAllValues().then((value) {
      setState(() {
        items = value;
        rawBarGroups = items;
        showingBarGroups = rawBarGroups;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(
                  width: 38,
                ),
                const Text(
                  'Reports',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 50,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameSize: 4 * 12,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 5) {
      text = '5';
    } else if (value == 10) {
      text = '10';
    } else if (value == 20) {
      text = '20';
    } else if (value == 30) {
      text = '30';
    } else if (value == 40) {
      text = '40';
    } else if (value == 50) {
      text = '50';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
      int x, double y1, double y2, double y3, double y4) {
    return BarChartGroupData(
      barsSpace: 5,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.rejectedColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.ongoingColor,
          width: width,
        ),
        BarChartRodData(
          toY: y3,
          color: widget.completedColor,
          width: width,
        ),
        BarChartRodData(
          toY: y4,
          color: widget.pendingColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.red.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.green.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.yellow.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.blue.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.red.withOpacity(0.4),
        ),
      ],
    );
  }
}

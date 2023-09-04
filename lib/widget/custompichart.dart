import 'package:flutter/material.dart';
import 'package:mainsenapatirajasthanadmin/utils/pichartmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

customCircularChart(final list, BuildContext context, bool isMobile) {
  return SizedBox(
    height: 400,
    // width: MediaQuery.of(context).size.width / 2,
    child: SfCircularChart(
      series: <CircularSeries>[
        PieSeries<PiChartModel, String>(
          enableTooltip: true,
          radius: '150',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
          ),
          pointColorMapper: (PiChartModel data, _) => data.color,
          dataLabelMapper: (PiChartModel data, _) => data.mapper,
          dataSource: list,
          // opacity: 4,

          xValueMapper: (PiChartModel data, _) => data.x,
          yValueMapper: (PiChartModel data, _) => data.y,
        )
      ],
    ),
  );
}

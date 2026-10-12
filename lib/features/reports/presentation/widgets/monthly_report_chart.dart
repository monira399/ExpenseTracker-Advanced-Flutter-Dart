import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyReportChart extends StatelessWidget {
  final Map<String, Map<String, double>> report;

  const MonthlyReportChart({super.key, required this.report});


  @override
  Widget build(BuildContext context) {
    final months = report.keys.toList();
    return Container(
      height: 305,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: BarChart(
        BarChartData(
          barGroups: List.generate(
              months.length,
              (index) {
                final month = months[index];

                final income = report[month]!['income'] ?? 0;
                final expense = report[month]!['expense'] ?? 0;

                return BarChartGroupData(
                    x: index,
                  barRods: [
                    BarChartRodData(
                        toY: income,
                    width: 8,
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(toY: expense,
                    width: 8,
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                    )
                  ],
                );
              },
          ),
           titlesData: FlTitlesData(
             bottomTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: true,
                 getTitlesWidget: (value, meta) {
                   final index = value.toInt();

                   if(index < 0 || index >= months.length) {
                     return const SizedBox();
                   }
                   final month = months[index];

                   final date = DateTime(
                     int.parse(month.split('-')[0]),
                     int.parse(month.split('-')[1]),
                   );

                   return Padding(padding: const EdgeInsets.only(top: 8),
                   child: Text(DateFormat.MMM().format(date),
                   style: const TextStyle(fontSize: 11),
                   ),);
                 }
               )
             ),

             leftTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: true,
                 reservedSize: 45,
               ),
             ),

             topTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: false,
               ),
             ),

             rightTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: false
               ),
             ),

           ),
          gridData: FlGridData(
            show: true,
          ),

          borderData: FlBorderData(
            show: false,
          )
        )
      )
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocChart>(context);
    return Scaffold(
      body: StreamBuilder<ChartState>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          final truc = snapshot.data;
          if (truc == null) {
            return Container(
              child: Center(
                child: MyText(
                  label: 'label 1',
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: MyText(
                  label: 'label 2',
                ),
              ),
            );
          } else {
            List<ChartSampleData>? charti = [];

            var iterable = truc.querySnapshot!.docs.toList();
            // print(truc.querySnapshot!.docs.toList());

            for (var element in iterable) {
              CategorieModel categorieModel =
                  CategorieModel.fromSnapShot(element);

              charti.add(ChartSampleData(
                x: '${categorieModel.title}',
                y: categorieModel.count == null ? 0 : categorieModel.count!,
              ));
            }

            //print(charti);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 100.0,
                  floating: true,
                  leading: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: MyText(
                      label: 'Charts',
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        height: size.height,
                        width: size.width,
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.7,
                              child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                //title: ChartTitle(te),
                                primaryXAxis: CategoryAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                    axisLine: AxisLine(width: 0),
                                    labelFormat: '{value}Ev',
                                    majorTickLines: MajorTickLines(size: 0)),
                                series: _getRoundedColumnSeries(charti),
                                // tooltipBehavior: _tooltipBehavior,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getRoundedColumnSeries(
      List<ChartSampleData> chart) {
    final List<ChartSampleData> chartData = chart;
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, textStyle: const TextStyle(fontSize: 10)),
      )
    ];
  }
}

class ChartSampleData {
  final String? x;
  final int? y;
  Stream<int>? d;

  ChartSampleData({this.x, this.y});
}

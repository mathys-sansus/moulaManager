import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moula_manager/database/depense_database.dart';

class Statistiques extends StatefulWidget {
  const Statistiques({super.key, required this.database});
  final DepenseDatabase database;

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<Statistiques> {
  int touchedIndex = -1;
  late Future<List<Map<String, dynamic>>> depensesParCategorie;

  @override
  void initState() {
    super.initState();
    depensesParCategorie = _getDepensesParCategorie();
  }

  Future<List<Map<String, dynamic>>> _getDepensesParCategorie() async {
    final depenses = await widget.database.getAllDepenses();
    double automobile = 0;
    double alimentation = 0;
    double logement = 0;
    double autre = 0;
    for (var depense in depenses) {

      switch (depense.type) {
        case 'Automobile':
          automobile += depense.montant;
          break;
        case 'Alimentation':
          alimentation += depense.montant;
          break;
        case 'Logement':
          logement += depense.montant;
          break;
        default :
          autre += depense.montant;
      }
    }
    double total = automobile + alimentation + logement + autre;
    return [
      {'categorie': 'Automobile', 'montant': automobile, 'pourcentage': (total > 0) ? (automobile / total) * 100 : 0},
      {'categorie': 'Alimentation', 'montant': alimentation, 'pourcentage': (total > 0) ? (alimentation / total) * 100 : 0},
      {'categorie': 'Logement', 'montant': logement, 'pourcentage': (total > 0) ? (logement / total) * 100 : 0},
      {'categorie': 'Autre', 'montant': autre, 'pourcentage': (total > 0) ? (autre / total) * 100 : 0},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Graphique de vos dépenses")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: depensesParCategorie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            // Vérifiez si la liste 'data' est vide
            if (data.every((element) => element['montant'] == 0)) {
              return const Center(
                child: Text(
                  "Aucune dépense enregistrée",
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: showingSections(data),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(Colors.orangeAccent, "Alimentation"),
                      const SizedBox(width: 10),
                      _buildLegendItem(Colors.blue, "Automobile"),
                      const SizedBox(width: 10),
                      _buildLegendItem(Colors.green, "Logement"),
                      const SizedBox(width: 10),
                      _buildLegendItem(Colors.red, "Autre"),
                    ],
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      String pourcentage = data[i]['pourcentage'].toStringAsFixed(1) + '%';

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: data[i]['pourcentage'],
            title: pourcentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/car.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orangeAccent,
            value: data[i]['pourcentage'],
            title: pourcentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/food.jpg',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: data[i]['pourcentage'],
            title: pourcentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/home.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: data[i]['pourcentage'],
            title: pourcentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'lib/images/money.png',
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.assetPath, {
        required this.size,
        required this.borderColor,
      });

  final String assetPath;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(assetPath),
      ),
    );
  }
}
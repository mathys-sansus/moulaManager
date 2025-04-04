import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moula_manager/database/depense_database.dart'; // Importez votre base de données
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/variables/globals.dart';
import 'package:moula_manager/widgets/customAppBar.dart';
import '../database/depense_database.dart';

class Statistiques extends StatefulWidget {
  const Statistiques({super.key, required this.database}); // Acceptez l'instance de la base de données
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
    double car = 0;
    double food = 0;
    double housing = 0;
    double other = 0;
    for (var depense in depenses) {
      // Utilisez la notation pointée pour accéder aux propriétés de l'objet Depense
      switch (depense.type) {  // Assurez-vous que 'type' correspond au nom de la propriété dans votre classe Depense
        case 'Car':
          car += depense.montant;
          break;
        case 'Food':
          food += depense.montant;
          break;
        case 'Housing':
          housing += depense.montant;
          break;
        default :
          other += depense.montant;
      }
    }
    double total = car + food + housing + other;
    return [
      {'categorie': 'Car', 'montant': car, 'pourcentage': (total > 0) ? (car / total) * 100 : 0},
      {'categorie': 'Food', 'montant': food, 'pourcentage': (total > 0) ? (food / total) * 100 : 0},
      {'categorie': 'Housing', 'montant': housing, 'pourcentage': (total > 0) ? (housing / total) * 100 : 0},
      {'categorie': 'Other', 'montant': other, 'pourcentage': (total > 0) ? (other / total) * 100 : 0},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "titleStats",
        parentContext: context),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: depensesParCategorie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            // Vérifiez si la liste 'data' est vide
            if (data.every((element) => element['montant'] == 0)) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.noExpense,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),  // Ajouter une marge à gauche
                    child: Wrap(
                      alignment: WrapAlignment.start,  // Aligner les éléments à gauche
                      spacing: 10.0,
                      runSpacing: 5.0,
                      children: [
                        _buildLegendItem(Colors.orangeAccent, AppLocalizations.of(context)!.food),
                        _buildLegendItem(Colors.blue, AppLocalizations.of(context)!.car),
                        _buildLegendItem(Colors.green, AppLocalizations.of(context)!.housing),
                        _buildLegendItem(Colors.red, AppLocalizations.of(context)!.other),
                      ],
                    ),
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
              'lib/images/food.png',
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
              'lib/images/housing.png',
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
              'lib/images/other.png',
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
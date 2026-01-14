import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/nutrition_service.dart';
import 'package:flutter_application_1/services/pregnancy_service.dart';
import 'package:flutter_application_1/theme.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutritionService = context.watch<NutritionService>();
    final pregnancyService = context.watch<PregnancyService>();
    final profile = pregnancyService.currentProfile;

    final trimester = profile != null
        ? ((profile.currentWeek - 1) / 13).ceil().clamp(1, 3)
        : 1;

    return DefaultTabController(
      length: 3,
      initialIndex: trimester - 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Guide'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Trimester 1'),
              Tab(text: 'Trimester 2'),
              Tab(text: 'Trimester 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [1, 2, 3].map((tri) {
            final items = nutritionService.getByTrimester(tri);
            final supplements =
                items.where((n) => n.category == 'Supplement').toList();
            final foods = items.where((n) => n.category == 'Food').toList();

            return SingleChildScrollView(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (supplements.isNotEmpty) ...[
                    Text('Supplements',
                        style: context.textStyles.titleLarge?.bold),
                    const SizedBox(height: 12),
                    ...supplements.map((nutrition) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                child: Icon(
                                  Icons.medication,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              title: Text(nutrition.name,
                                  style:
                                      context.textStyles.titleMedium?.semiBold),
                              subtitle: Text(nutrition.description),
                              children: [
                                Padding(
                                  padding: AppSpacing.paddingMd,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Benefits:',
                                          style: context
                                              .textStyles.titleSmall?.semiBold),
                                      const SizedBox(height: 4),
                                      Text(nutrition.benefits,
                                          style: context.textStyles.bodyMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],
                  if (foods.isNotEmpty) ...[
                    Text('Foods to Focus On',
                        style: context.textStyles.titleLarge?.bold),
                    const SizedBox(height: 12),
                    ...foods.map((nutrition) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Icon(
                                  Icons.restaurant,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(nutrition.name,
                                  style:
                                      context.textStyles.titleMedium?.semiBold),
                              subtitle: Text(nutrition.description),
                              children: [
                                Padding(
                                  padding: AppSpacing.paddingMd,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Benefits:',
                                          style: context
                                              .textStyles.titleSmall?.semiBold),
                                      const SizedBox(height: 4),
                                      Text(nutrition.benefits,
                                          style: context.textStyles.bodyMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

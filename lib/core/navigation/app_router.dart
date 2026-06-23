import 'package:go_router/go_router.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/widgets/app_scaffold.dart';
import 'package:opendiet/features/add_food/presentation/add_log_hub_screen.dart';
import 'package:opendiet/features/backup/presentation/backup_restore_screen.dart';
import 'package:opendiet/features/diary/presentation/diary_screen.dart';
import 'package:opendiet/features/diary/presentation/quick_add_screen.dart';
import 'package:opendiet/features/foods/presentation/csv_import/csv_import_screen.dart';
import 'package:opendiet/features/foods/presentation/custom_food_editor.dart';
import 'package:opendiet/features/foods/presentation/foods_screen.dart';
import 'package:opendiet/features/recipes/presentation/recipe_detail_screen.dart';
import 'package:opendiet/features/recipes/presentation/recipe_editor_screen.dart';
import 'package:opendiet/features/recipes/presentation/recipes_screen.dart';
import 'package:opendiet/features/reminders/presentation/reminders_screen.dart';
import 'package:opendiet/features/settings/presentation/daily_target_screen.dart';
import 'package:opendiet/features/settings/presentation/meal_slots_screen.dart';
import 'package:opendiet/features/settings/presentation/off_account_screen.dart';
import 'package:opendiet/features/settings/presentation/off_contribution_screen.dart';
import 'package:opendiet/features/settings/presentation/settings_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// The application router: a four-tab bottom-navigation shell (Diary, Foods,
/// Recipes, Settings). Deeper routes hang off these branches in later
/// increments (see .spec/design/ui/_index.md route table).
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) => buildAppRouter(clock: ref.watch(clockProvider));

/// Builds the application router. Exposed for widget tests.
GoRouter buildAppRouter({Clock clock = const SystemClock()}) => GoRouter(
  initialLocation: '/diary',
  routes: [
    GoRoute(
      path: '/log',
      builder: (context, state) {
        final slot = state.uri.queryParameters['slot'] ?? '';
        final dateStr = state.uri.queryParameters['date'];
        final day = dateStr != null ? DateTime.parse(dateStr) : clock.now();
        return QuickAddScreen(slotId: slot, day: day);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/diary',
              builder: (context, state) => const DiaryScreen(),
              routes: [
                GoRoute(
                  path: 'add/:mealSlotId',
                  builder: (context, state) => AddLogHubScreen(
                    mealSlotId: state.pathParameters['mealSlotId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/foods',
              builder: (context, state) => const FoodsScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) =>
                      CustomFoodEditor(onSaved: (food) => context.pop()),
                ),
                GoRoute(
                  path: 'import',
                  builder: (context, state) => const CsvImportScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recipes',
              builder: (context, state) => const RecipesScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) =>
                      RecipeEditorScreen(onSaved: () => context.pop()),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => RecipeDetailScreen(
                    recipeId: state.pathParameters['id']!,
                    onEdit: () => context.push(
                      '/recipes/${state.pathParameters['id']}/edit',
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => RecipeEditorScreen(
                        recipeId: state.pathParameters['id'],
                        onSaved: () => context.pop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'target',
                  builder: (context, state) => const DailyTargetScreen(),
                ),
                GoRoute(
                  path: 'meals',
                  builder: (context, state) => const MealSlotsScreen(),
                ),
                GoRoute(
                  path: 'reminders',
                  builder: (context, state) => const RemindersScreen(),
                ),
                GoRoute(
                  path: 'open-food-facts',
                  builder: (context, state) => const OffAccountScreen(),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => const OffContributionScreen(
                        mode: OffContributionMode.addProduct,
                      ),
                    ),
                    GoRoute(
                      path: 'correction',
                      builder: (context, state) => const OffContributionScreen(
                        mode: OffContributionMode.suggestCorrection,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'backup',
                  builder: (context, state) => const BackupRestoreScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

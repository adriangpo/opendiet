import 'package:go_router/go_router.dart';
import 'package:opendiet/core/time/clock.dart';
import 'package:opendiet/core/time/time_providers.dart';
import 'package:opendiet/core/widgets/app_scaffold.dart';
import 'package:opendiet/features/backup/presentation/backup_restore_screen.dart';
import 'package:opendiet/features/diary/presentation/add_log_hub_screen.dart';
import 'package:opendiet/features/diary/presentation/diary_entry_edit_screen.dart';
import 'package:opendiet/features/diary/presentation/diary_screen.dart';
import 'package:opendiet/features/diary/presentation/food_quantity_entry_screen.dart';
import 'package:opendiet/features/diary/presentation/meal_slot_detail_screen.dart';
import 'package:opendiet/features/diary/presentation/quick_add_screen.dart';
import 'package:opendiet/features/foods/presentation/csv_import/csv_import_screen.dart';
import 'package:opendiet/features/foods/presentation/custom_food_editor.dart';
import 'package:opendiet/features/foods/presentation/food_detail_screen.dart';
import 'package:opendiet/features/foods/presentation/foods_screen.dart';
import 'package:opendiet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:opendiet/features/recipes/presentation/recipe_detail_screen.dart';
import 'package:opendiet/features/recipes/presentation/recipe_editor_screen.dart';
import 'package:opendiet/features/recipes/presentation/recipes_screen.dart';
import 'package:opendiet/features/reminders/presentation/reminders_screen.dart';
import 'package:opendiet/features/settings/data/settings_providers.dart';
import 'package:opendiet/features/settings/domain/settings_repository.dart';
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
GoRouter goRouter(Ref ref) => buildAppRouter(
  clock: ref.watch(clockProvider),
  settingsRepository: ref.watch(settingsRepositoryProvider),
);

/// Builds the application router. Exposed for widget tests.
GoRouter buildAppRouter({
  Clock clock = const SystemClock(),
  SettingsRepository? settingsRepository,
}) => GoRouter(
  initialLocation: '/diary',
  redirect: (context, state) async {
    final repository = settingsRepository;
    if (repository == null) return null;
    try {
      final settings = await repository.load();
      final location = state.uri.path;
      final isOnboarding = location == '/onboarding';
      final isRerun = state.uri.queryParameters['rerun'] == 'true';
      if (!settings.onboardingCompleted && !isOnboarding) {
        return '/onboarding';
      }
      if (settings.onboardingCompleted && isOnboarding && !isRerun) {
        return '/diary';
      }
      return null;
    } on Object {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: '/log/quantity/:foodRef',
      builder: (context, state) {
        final foodRef = state.pathParameters['foodRef']!;
        final foodId = _savedFoodId(foodRef);
        final slot = state.uri.queryParameters['slot'];
        final dateStr = state.uri.queryParameters['date'];
        final day = dateStr != null ? DateTime.parse(dateStr) : clock.now();
        return FoodQuantityEntryScreen(
          foodId: foodId,
          mealSlotId: slot,
          day: day,
        );
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
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
                GoRoute(
                  path: 'slot/:mealSlotId',
                  builder: (context, state) => MealSlotDetailScreen(
                    mealSlotId: state.pathParameters['mealSlotId']!,
                  ),
                ),
                GoRoute(
                  path: 'entry/:entryId/edit',
                  builder: (context, state) => DiaryEntryEditScreen(
                    entryId: state.pathParameters['entryId']!,
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
                GoRoute(
                  path: ':id',
                  builder: (context, state) => FoodDetailScreen(
                    foodId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => FoodEditScreen(
                        foodId: state.pathParameters['id']!,
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
                  path: 'account',
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

String _savedFoodId(String foodRef) {
  const prefix = 'food:';
  if (!foodRef.startsWith(prefix)) return foodRef;
  return foodRef.substring(prefix.length);
}

# Holo Store – Mobile Coding Challenge

A polished Flutter e-commerce sample that consumes the FakeStore API. The goal was to showcase decision making, clean architecture, graceful UX states, and testable business logic while keeping the project approachable for review.

## What’s Included
- Product grid with loading shimmers, pull-to-refresh, error & empty states.
- Product detail view with category, rating, description, and add-to-cart CTA.
- Cart management with quantity updates, removal, totals, and mock checkout.
- Offline resilience: cached product catalogue + locally persisted cart.
- Theme toggle (light/dark) stored via hydrated state.
- Localization for English and Spanish.
- Unit and widget tests covering repositories, cubits, and core widgets.

## Architecture & Reasons Behind The Code
| Area | Implementation | Reasoning |
| --- | --- | --- |
| Project layout | `lib/app`, `lib/core`, `lib/features/<feature>/{data,domain,presentation}` | Mirrors the feature-first clean architecture requested; keeps shared tooling in `core` and feature code self-contained. |
| State management | `flutter_bloc` cubits (`ThemeCubit`, `ProductListCubit`, `ProductDetailCubit`, `CartCubit`) | Cubits provide predictable, testable state transitions without the boilerplate of full BLoC while aligning with the requested BLoC/Cubit preference. |
| Dependency injection | `get_it` via `lib/app/di/locator.dart` | Centralises object lifecycles, simplifies testing/mocking, and keeps widget constructors lean. |
| Networking | `dio` wrapped by `ApiClient` | Provides robust HTTP handling, typed responses, and easier interceptor configuration than `http` for a production-style sample. |
| Data caching | `SharedPreferencesStorage` + DTOs | Lightweight approach that still enables offline reads for products and persists cart state without introducing a heavier database. |
| Offline detection | `connectivity_plus` | Allows the repository to decide when to fall back to cached data and craft user-friendly failures. |
| Serialization | `json_serializable` generated DTOs | Eliminates manual parsing bugs and keeps DTO ↔ entity mappings explicit and testable. |
| Local state persistence | `hydrated_bloc` (for theme) & `SharedPreferences` (for cart/products) | Hydrated cubit keeps theme across sessions; shared prefs already in use for cart so extending it to product cache keeps footprint small. |
| UI polish | `cached_network_image`, `shimmer`, `intl` | Cached images reduce flicker, shimmer communicates loading, and `intl` formats currency correctly per locale. |
| Navigation | `go_router` | Declarative, deep-link friendly navigation that keeps routes discoverable and avoids manual `Navigator` calls. |
| Testing | `bloc_test`, `mocktail`, `flutter_test` | bloc_test makes expectation-driven cubit tests concise; mocktail keeps stubs lightweight; widget test validates shared UI widgets. |

## Data Flow Snapshot
1. `ProductListCubit` requests `GetProducts` use case.
2. `ProductRepositoryImpl` hits `ProductRemoteDataSource` (`ApiClient` → FakeStore) and caches DTOs via `ProductLocalDataSource` (`SharedPreferences`).
3. On API failure, repository returns cached entities if available.
4. Cart actions go through `CartRepositoryImpl`, manipulating cached DTOs before converting back to domain entities for UI.
5. Theme state travels through `ThemeCubit` and rehydrates on boot via Hydrated storage.

## Feature Breakdown & Tasks Completed
1. **Scaffold project & dependencies** – added architecture folders, pubspec dependencies, and dependency locator.
2. **Data layer** – models, DTOs, data sources, repositories, error handling, and result abstraction.
3. **Domain layer** – entities plus use-cases for products and cart mutations.
4. **Presentation** – routing, theming, localization harness, screens, widgets, and UX states.
5. **Persistence & offline** – caching products, storing cart, hydrated theme.
6. **Testing** – repository, cubit, and widget coverage to validate behaviour.
7. **Tooling & docs** – `build_runner` generation, `flutter test`, and this README with rationale per code area.

## Running The Project
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Quality Gates
- `flutter analyze`
- `flutter test`

## Known Trade-offs & Follow-ups
- Cart checkout is mocked; integrates with snackbar to confirm the flow but does not trigger a payment API.
- SharedPreferences suits the challenge scope, yet a true offline-first experience might swap to Hive/ObjectBox for better query support.
- `connectivity_plus` provides network hints but does not guarantee internet reachability; UI copy communicates that risk to the user.
- Localization covers two languages manually; scaling would ideally move to Flutter’s `gen-l10n` pipeline.

## Screens & UX Notes
- Product grid uses `RefreshIndicator` for pull-to-refresh and shimmer placeholders while loading.
- Detail page seeds cached data for instant display, then refreshes from the API when available.
- Cart badge mirrors total quantity and updates instantly through cubit state.
- Theme toggle persists; the cart and products survive app restarts thanks to hydrated/shared storage.

## Testing Summary
| Suite | Purpose |
| --- | --- |
| `product_repository_impl_test.dart` | Ensures remote fetch, offline cache fallback, and product detail logic work across network scenarios. |
| `cart_repository_impl_test.dart` | Validates local persistence, quantity updates, removals, and clearing behaviour. |
| `product_list_cubit_test.dart` | Confirms UI state progression for success and failure paths. |
| `cart_cubit_test.dart` | Verifies cart interactions emit the right states (success/failure flows). |
| `widget_test.dart` | Sanity check around reusable UI component behaviour. |

## Environment Variables & Secrets
None required—the FakeStore API is public and accessed over HTTPS without auth.

## FakeStore API Usage
Endpoints leveraged: `/products` for catalogue + `/products/{id}` for details. Responses are mapped to domain entities with explicit rating/price handling and formatted using `intl`.

Enjoy exploring the implementation! Feedback and extension ideas are always welcome.

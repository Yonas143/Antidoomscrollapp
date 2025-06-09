# mindsnap

Floder structure 

lib/
├── main.dart
├── core/
│   ├── constants.dart
│   ├── providers.dart
│   └── router.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── logic/
│   │   │   ├── auth_controller.dart
│   │   │   └── auth_state.dart
│   │   └── presentation/
│   │       ├── login_page.dart
│   │       └── register_page.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── admin_dashboard.dart
│   │       └── user_dashboard.dart
│   ├── mindful_activities/
│   │   ├── data/
│   │   │   └── activity_repository.dart
│   │   ├── logic/
│   │   │   └── activity_controller.dart
│   │   └── presentation/
│   │       ├── activity_form.dart
│   │       └── activity_list.dart
│   ├── goals/
│   │   ├── data/
│   │   │   └── goal_repository.dart
│   │   ├── logic/
│   │   │   └── goal_controller.dart
│   │   └── presentation/
│   │       ├── goal_form.dart
│   │       └── goal_list.dart
│   └── admin/
│       ├── data/
│       │   └── user_repository.dart
│       ├── logic/
│       │   └── user_controller.dart
│       └── presentation/
│           └── user_list.dart
└── widgets/
├── custom_button.dart
├── custom_textfield.dart
└── navbar.dart

pubspec.yaml
- Includes dependencies for flutter_riverpod, dio, go_router, and flutter_hooks

test/
├── unit/
│   ├── auth_test.dart
│   ├── activity_test.dart
│   └── goal_test.dart
├── widget/
│   └── login_widget_test.dart
└── integration/
└── app_flow_test.dart

📁 lib/
✅ main.dart
App initialization with Riverpod + GoRouter



| File             | Status | Description                                                    |
| ---------------- | ------ | -------------------------------------------------------------- |
| `constants.dart` | ✅      | Contains app-wide constants                                    |
| `providers.dart` | ✅      | Global providers (auth, dio, etc.)                             |
| `router.dart`    | ✅      | Configured with `GoRouter`, routes redirect based on auth role |

| File                              | Status | Description                                 |
| --------------------------------- | ------ | ------------------------------------------- |
| `data/auth_repository.dart`       | ✅      | API methods for login/register using Dio    |
| `logic/auth_controller.dart`      | ✅      | Handles login/register, updates `AuthState` |
| `logic/auth_state.dart`           | ✅      | Holds loading, user, and error states       |
| `presentation/login_page.dart`    | ✅      | Login UI with form + redirect               |
| `presentation/register_page.dart` | ✅      | Register UI                                 |



| File                                | Status | Description                                     |
| ----------------------------------- | ------ | ----------------------------------------------- |
| `presentation/user_dashboard.dart`  | ✅      | Shows nav + links to Mindful Activities & Goals |
| `presentation/admin_dashboard.dart` | ✅      | Nav + link to Manage Users                      |
| File                              | Status | Description                                             |
| --------------------------------- | ------ | ------------------------------------------------------- |
| `data/activity_repository.dart`   | ✅      | Dio API: get, post, put, delete activities              |
| `logic/activity_controller.dart`  | ✅      | Manages state via Riverpod notifier                     |
| `presentation/activity_form.dart` | ✅      | UI form for add/update activity                         |
| `presentation/activity_list.dart` | ✅      | List of all user's activities, with edit/delete buttons |
| File                          | Status | Description                               |
| ----------------------------- | ------ | ----------------------------------------- |
| `data/goal_repository.dart`   | ⏳      | To be created: CRUD APIs for goals        |
| `logic/goal_controller.dart`  | ⏳      | To be created: Riverpod controller        |
| `presentation/goal_form.dart` | ⏳      | To be created: Form to create/update goal |
| `presentation/goal_list.dart` | ⏳      | To be created: List of goals              |
| File                          | Status | Description                             |
| ----------------------------- | ------ | --------------------------------------- |
| `data/user_repository.dart`   | ✅      | Dio methods: get users, delete, promote |
| `logic/user_controller.dart`  | ✅      | Fetch + update user roles               |
| `presentation/user_list.dart` | ✅      | Admin UI to list users, promote, delete |
| File                    | Status | Description             |
| ----------------------- | ------ | ----------------------- |
| `custom_button.dart`    | ✅      | Shared button component |
| `custom_textfield.dart` | ✅      | Shared text input field |
| `navbar.dart`           | ✅      | Top nav bar with logout |


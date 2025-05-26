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

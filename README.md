# UpTodo - Modern Task Management App

A feature-rich Flutter application for managing tasks, notes, and personal productivity with a premium UI and seamless user experience.

## 📋 Features

- **Task Management**: Create, update, delete, and organize your tasks efficiently
- **Notes**: Keep track of important notes and ideas
- **Premium Store**: Access to premium features and enhancements
- **Dark Mode Support**: Switch between light and dark themes for better accessibility
- **Local Storage**: All data is securely stored locally on your device
- **File Picker Integration**: Import and manage files
- **Share Functionality**: Share tasks and notes with others
- **Splash & Onboarding**: Beautiful welcome screens for first-time users
- **State Management**: Robust state management using Provider pattern

## 🎯 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── main_navigation.dart      # Navigation setup
├── assets/                   # Static assets (icons, images)
├── core/
│   ├── constants/            # App-wide constants
│   ├── theme/                # Theme configuration (light/dark)
│   └── widgets/              # Reusable UI components
└── features/
    ├── todo/                 # Task management feature
    │   ├── screens/
    │   ├── widgets/
    │   └── providers/
    ├── notes/                # Notes feature
    │   ├── screens/
    │   ├── widgets/
    │   └── providers/
    ├── store/                # Premium store feature
    │   ├── screens/
    │   ├── widgets/
    │   └── providers/
    ├── splash/               # Splash screen
    │   └── screens/
    └── onboarding/           # Onboarding flow
        ├── screens/
        └── providers/
```

## 🚀 Getting Started

### Prerequisites

- Flutter 3.11.3 or higher
- Dart SDK 3.11.3 or higher
- Android SDK (for Android development)
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_application_1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- **provider**: ^6.1.5+1 - State management solution
- **uuid**: ^4.0.0 - Generate unique identifiers
- **intl**: ^0.19.0 - Internationalization support
- **shared_preferences**: ^2.2.0 - Local persistent storage
- **file_picker**: ^8.0.0 - File selection capability
- **share_plus**: ^9.0.0 - Share content functionality
- **path_provider**: ^2.1.0 - Access to common file system locations

### Dev Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: Lint rules for Flutter

## 🎨 Theme System

The app supports both light and dark themes with the following features:
- Automatic theme switching based on device settings
- Manual theme toggle option
- Smooth transitions between themes
- Color-coded task and note indicators

### Applying Themes

Navigate to `lib/core/theme/app_theme.dart` to customize the theme colors and typography.

## 🔄 State Management

The app uses **Provider** for state management with the following providers:

- **TaskProvider**: Manages task-related state
- **NotesProvider**: Manages notes state
- **StoreProvider**: Manages store/premium features state
- **ThemeProvider**: Manages theme selection and persistence
- **OnboardingProvider**: Manages onboarding state

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 💾 Data Persistence

All user data is stored locally using:
- **SharedPreferences**: For app preferences and settings
- **Local File System**: For extensive data storage using `path_provider`

## 🛠️ Build & Development

### Run Development Build
```bash
flutter run
```

### Build Release APK (Android)
```bash
flutter build apk --release
```

### Build Release iOS App
```bash
flutter build ios --release
```

### Build Web
```bash
flutter build web
```

### Running Tests
```bash
flutter test
```

## 📝 Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and uses `flutter_lints` for code quality.

Run linting checks:
```bash
flutter analyze
```

## 📂 Common Tasks

### Adding a New Feature

1. Create a new folder under `lib/features/<feature_name>`
2. Structure it with `screens/`, `widgets/`, and `providers/` subdirectories
3. Create a provider for state management
4. Add navigation routes to `main_navigation.dart`

### Adding Assets

Place your assets (images, icons, etc.) in `lib/assets/` and update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - lib/assets/
```

## 🤝 Contributing

1. Create a new branch for your feature
2. Make your changes
3. Test thoroughly on multiple platforms
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙋 Support

For issues, bugs, or feature requests, please open an issue on the repository.

---

**Made with ❤️ using Flutter**

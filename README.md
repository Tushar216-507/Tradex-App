# Tradex 🚀

Tradex is a modern Flutter application designed to provide users with a seamless experience for managing investments, tracking portfolios, and handling taxes. The app leverages Firebase for authentication and data storage, and features a clean, dark-themed interface with Google Fonts for enhanced readability.

## ✨ Features

- 🔐 **User Authentication**: Secure sign-in and sign-up using Firebase Authentication, including support for Google Sign-In.
- 👤 **Profile Management**: Users are prompted to complete their profile (name, date of birth, and profile image) for a personalized experience.
- 📊 **Portfolio Dashboard**: View your total portfolio value, today's profit/loss, and invested amount at a glance.
- 👀 **Watchlist**: Track your favorite stocks with real-time updates and price changes.
- 🤖 **Trading Bot**: Access a dedicated page for trading bot features (placeholder for future enhancements).
- 💸 **Investments**: Manage and review your investment options and performance.
- 🧾 **Tax Management**: Keep track of your tax-related information and documents.
- 🧭 **Responsive Navigation**: Intuitive bottom navigation bar for quick access to Home, Bot, Invest, and Taxes sections.
- 🎨 **Modern UI**: Built with Material Design, custom Google Fonts, and a dark theme for a professional look.

## 📱 Screenshots

<!-- Add screenshots of your app here if available -->

## 🚀 Getting Started

To run this project locally, ensure you have the following prerequisites:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.7.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- A configured Firebase project (see below)

### 🛠️ Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/tradex.git
   cd tradex
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform directories.
   - Update `firebase_options.dart` if you use the FlutterFire CLI.

4. **Run the app:**
   ```sh
   flutter run
   ```

## 🗂️ Project Structure

- `lib/main.dart` - Application entry point and navigation.
- `lib/auth_page.dart` - Authentication UI and logic.
- `lib/home_page.dart` - Portfolio dashboard and watchlist.
- `lib/investpage.dart` - Investment management.
- `lib/taxes_page.dart` - Tax management.
- `lib/user_details_page.dart` - User profile completion.
- `lib/auth_service.dart` - Authentication service logic.
- `lib/firebase_options.dart` - Firebase configuration.

## 📦 Dependencies

Key packages used in this project:

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `google_sign_in`
- `google_fonts`
- `webview_flutter`
- `syncfusion_flutter_charts`
- `image_picker`
- `cupertino_icons`

See `pubspec.yaml` for the full list and versions.

## 🤝 Contributing

Contributions are welcome! Please open issues and submit pull requests for new features, bug fixes, or improvements.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Syncfusion Flutter Charts](https://pub.dev/packages/syncfusion_flutter_charts)

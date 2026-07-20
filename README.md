Markdown
# flutter-quote-generator 📱

A simple single-screen Flutter application that shows a random quote whenever you press a button.

Built as a clean, minimal Flutter exercise to demonstrate basic UI state management using `StatefulWidget`.

---

## Setup & Run

Make sure you have the **Flutter SDK** installed.

1. Fetch dependencies:
   ```bash
   flutter pub get
Run the application:

Bash
flutter run
Tip: You can also run it in Chrome without an emulator using:

Bash
flutter run -d chrome
How It's Structured
The entire logic is self-contained and clean, located in lib/main.dart:

QuoteApp: The root StatelessWidget that sets up the Material 3 theme and points to the home screen.

QuoteScreen: The main StatefulWidget. It uses setState() inside the _showRandomQuote() function to trigger a UI redraw whenever a new quote is selected from the array.

Tech Stack
Flutter & Dart

Material 3 Design

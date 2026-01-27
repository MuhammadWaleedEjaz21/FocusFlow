# FocusFlow

FocusFlow is a comprehensive task management application designed to help users organize their daily activities efficiently. It features a robust Flutter frontend and a scalable Node.js backend.

## 🚀 Features

### Core Functionality
- **User Authentication**: Secure Signup, Login, and Password Recovery flows (Forgot Password, OTP verification, Reset Password).
- **Task Management**: Create, Read, Update, and Delete (CRUD) tasks.
- **Task Filtering**: Efficiently filter and search through tasks.
- **Push Notifications**: Stay updated with local notifications for task reminders.
- **Settings**: Customizable user preferences.

### UI/UX
- **Responsive Design**: Built with `flutter_screenutil` to ensure a consistent look across different device sizes.
- **Modern UI**: Clean and intuitive interface using Google Fonts and custom themes.
- **Localization**: Support for multiple languages (l10n).

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Framework**: Flutter & Dart
- **State Management**: Riverpod (`flutter_riverpod`)
- **Networking**: HTTP
- **Local Storage**: Shared Preferences
- **Notifications**: Flutter Local Notifications
- **Routing**: Named routes and custom navigation
- **UI Utilities**: Flutter ScreenUtil, Flutter SVG (if applicable), Google Fonts

### Backend (Node.js)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB (Mongoose ODM)
- **Authentication**: JWT (JSON Web Tokens), BCrypt
- **Email**: Nodemailer (for OTP services)

## 📂 Project Structure

```
FocusFlow/
├── backend/                 # Node.js Backend
│   ├── Configs/            # Database configuration
│   ├── Controllers/        # Request handlers
│   ├── Middlewares/        # Auth and other middlewares
│   ├── Models/             # Mongoose models (User, Task, OTP)
│   ├── Routes/             # API routes
│   └── index.js            # Entry point
│
├── frontend/                # Flutter Frontend
│   ├── lib/
│   │   ├── Models/         # Dart data models
│   │   ├── Providers/      # Riverpod providers
│   │   ├── Screens/        # UI Screens (Login, Home, Settings, etc.)
│   │   ├── Services/       # API services (User, Task, Notifications)
│   │   ├── Themes/         # App theming
│   │   ├── Widgets/        # Reusable UI components
│   │   ├── l10n/           # Localization files
│   │   └── main.dart       # App entry point
│   ├── assets/             # Images and static resources
│   └── pubspec.yaml        # Dependencies
```

## 🔧 Installation & Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- [Node.js](https://nodejs.org/) installed.
- [MongoDB](https://www.mongodb.com/) instance (local or Atlas).

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the `backend` root with the following variables:
   ```env
   PORT=3000
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret
   # Add other required variables (e.g., EMAIL_USER, EMAIL_PASS for Nodemailer)
   ```
4. Start the server:
   ```bash
   npm start
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## 📱 Screenshots
*(Add screenshots of your application here)*

## 🤝 Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

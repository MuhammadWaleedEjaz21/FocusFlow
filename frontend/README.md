# 🎯 FocusFlow

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)

*A comprehensive task management application designed to help users organize their daily activities efficiently.*

[Features](#-features) • [Installation](#-installation--setup) • [API Documentation](#-api-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents
- [About](#-about)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Installation & Setup](#-installation--setup)
- [API Documentation](#-api-documentation)
- [Usage](#-usage)
- [Screenshots](#-screenshots)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

## 🌟 About

FocusFlow is a full-stack task management solution that combines a beautiful Flutter mobile application with a robust Node.js backend. It's designed to help users stay organized, manage their daily tasks effectively, and boost productivity with features like push notifications, task filtering, and secure authentication.

## 🚀 Features

### 🔐 Authentication & Security
- **Secure Signup & Login**: JWT-based authentication with encrypted passwords
- **Password Recovery Flow**: 
  - Forgot Password functionality
  - OTP verification via email
  - Secure password reset
- **Session Management**: Persistent login sessions with token refresh

### ✅ Task Management
- **Full CRUD Operations**: Create, Read, Update, and Delete tasks seamlessly
- **Task Organization**: 
  - Set task priorities
  - Add due dates and deadlines
  - Categorize tasks
- **Advanced Filtering**: Search and filter tasks by status, priority, or date
- **Task Details**: Rich task descriptions and metadata

### 🔔 Notifications & Reminders
- **Push Notifications**: Stay updated with local notifications for task reminders
- **Customizable Alerts**: Set reminder times for important tasks

### ⚙️ Customization
- **User Settings**: Personalize your experience
- **Theme Support**: Clean and modern interface
- **Multi-language Support**: Localization (l10n) for global accessibility

### 📱 UI/UX Excellence
- **Responsive Design**: Optimized for all screen sizes using `flutter_screenutil`
- **Modern Interface**: Intuitive design with Google Fonts
- **Smooth Animations**: Polished user experience

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

## � API Documentation

### Base URL
```
http://localhost:3000/api
```

### Authentication Endpoints

#### Register User
```http
POST /user/signup
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "jwt_token_here"
}
```

#### Login
```http
POST /user/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

#### Forgot Password
```http
POST /user/forgot-password
Content-Type: application/json

{
  "email": "john@example.com"
}
```

#### Verify OTP
```http
POST /user/verify-otp
Content-Type: application/json

{
  "email": "john@example.com",
  "otp": "123456"
}
```

#### Reset Password
```http
POST /user/reset-password
Content-Type: application/json

{
  "email": "john@example.com",
  "newPassword": "newSecurePassword123"
}
```

### Task Endpoints

#### Get All Tasks
```http
GET /task
Authorization: Bearer {token}
```

#### Create Task
```http
POST /task
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Complete project documentation",
  "description": "Write comprehensive README",
  "priority": "high",
  "dueDate": "2026-02-15"
}
```

#### Update Task
```http
PUT /task/:id
Authorization: Bearer {token}
Content-Type: application/json

{
  "title": "Updated task title",
  "status": "completed"
}
```

#### Delete Task
```http
DELETE /task/:id
Authorization: Bearer {token}
```

## 💡 Usage

### Running the Application

1. **Start the Backend Server:**
   ```bash
   cd backend
   npm start
   ```
   The server will run on `http://localhost:3000`

2. **Launch the Flutter App:**
   ```bash
   cd frontend
   flutter run
   ```

### Using the App

1. **Sign Up**: Create a new account with your email and password
2. **Log In**: Access your account securely
3. **Create Tasks**: Tap the '+' button to add new tasks
4. **Manage Tasks**: 
   - Swipe to delete
   - Tap to edit
   - Mark as complete
5. **Filter Tasks**: Use the filter options to view specific task categories
6. **Settings**: Customize notifications and preferences

## 📱 Screenshots

### Authentication Flow
| Login | Signup | Forgot Password |
|-------|--------|-----------------|
| *Coming Soon* | *Coming Soon* | *Coming Soon* |

### Task Management
| Task List | Task Details | Filters |
|-----------|--------------|---------|
| *Coming Soon* | *Coming Soon* | *Coming Soon* |

## 🔧 Troubleshooting

### Common Issues

**Backend Server Won't Start**
- Ensure MongoDB is running
- Check if `.env` file exists with correct credentials
- Verify port 3000 is not already in use

**Flutter Build Fails**
```bash
flutter clean
flutter pub get
flutter run
```

**Database Connection Error**
- Verify MongoDB URI in `.env` file
- Check network connectivity
- Ensure MongoDB service is running

**Authentication Not Working**
- Clear app data and cache
- Verify JWT_SECRET is set in backend `.env`
- Check token expiration settings

### Getting Help
If you encounter issues not listed here, please:
1. Check existing [Issues](../../issues)
2. Create a new issue with detailed information
3. Include error logs and steps to reproduce

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/FocusFlow.git
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Commit Your Changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```

4. **Push to the Branch**
   ```bash
   git push origin feature/AmazingFeature
   ```

5. **Open a Pull Request**

### Development Guidelines
- Follow the existing code style
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

**Project Maintainer**: Muhammad Waleed Ejaz

- GitHub: [MuhammadWaleedEjaz21](https://github.com/MuhammadWaleedEjaz21)
- Email: your.email@example.com
- LinkedIn: [Your Profile](https://linkedin.com/in/yourprofile)

**Project Link**: [https://github.com/MuhammadWaleedEjaz21/FocusFlow](https://github.com/MuhammadWaleedEjaz21/FocusFlow)

---

<div align="center">

### ⭐ Star this repository if you find it helpful!

Made with ❤️ by the FocusFlow Team

</div>

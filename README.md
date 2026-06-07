# 🚗 CarServiceApp

**CarServiceApp** is a cross-platform mobile application developed with Flutter and Dart as the Final Exam Project for **CEN306 – Mobile Application Design and Development**. The app provides an offline-first solution for tracking vehicle maintenance history and service records, backed by a local SQLite database.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Video](#-video)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Technologies & Dependencies](#technologies--dependencies)
- [Getting Started](#getting-started)
- [Running the App](#running-the-app)
- [Testing](#testing)
- [Known Limitations](#known-limitations)
- [Future Improvements](#future-improvements)
- [Course Information](#course-information)

---

## 📸 Video

**Watch the application in action:**

[▶️ View Video on YouTube](https://youtube.com/shorts/NIJxinBQnDU?feature=share)

---

## Overview

CarServiceApp addresses a common real-world problem: car owners and small automotive service shops lack a simple, reliable, offline-capable tool to record and query vehicle maintenance histories. The app allows users to:

- Manage a list of vehicles with key identifying information
- Record detailed service events per vehicle (type, date, mileage, cost, notes)
- View the full service history for any vehicle, sorted chronologically
- Persist all data locally without any internet connection

The project follows a clean **four-layer architecture** (Presentation → Provider → Repository → DAO → SQLite) designed to demonstrate professional software engineering principles within the scope of a university mobile development course.

---

## Features

| Feature | Description |
|---|---|
| **Vehicle Management** | Add, edit, and delete vehicle profiles (make, model, year, plate number) |
| **Service Record CRUD** | Create, view, update, and delete service records per vehicle |
| **Service History** | Browse a chronological list of all services for a selected vehicle |
| **Local Persistence** | All data is stored in SQLite via `sqflite` — works fully offline |
| **Input Validation** | Form validation for required fields and numeric inputs (mileage, cost) |
| **User Feedback** | SnackBars for operation results; confirmation dialogs before deletions |
| **Empty States** | Friendly empty-state widget with call-to-action when no data exists |

---

## Screenshots

> Screenshots will be added here after the demo recording is complete.

| Vehicle List | Add Vehicle | Service History | Add Service |
|---|---|---|---|
| *(coming soon)* | *(coming soon)* | *(coming soon)* | *(coming soon)* |

---

## Architecture

The application is structured around a **strict four-layer architecture** with unidirectional data flow:

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                    │
│  Flutter Screens · Widgets · Navigation · Form Validation │
└───────────────────────┬─────────────────────────────────┘
                        │  Provider.of() / Consumer<T>
┌───────────────────────▼─────────────────────────────────┐
│               STATE MANAGEMENT LAYER                    │
│        VehicleProvider · ServiceProvider                │
│           (ChangeNotifier + notifyListeners)            │
└───────────────────────┬─────────────────────────────────┘
                        │  async method calls
┌───────────────────────▼─────────────────────────────────┐
│                  REPOSITORY LAYER                       │
│      VehicleRepository · ServiceRepository              │
│   (clean API, hides DAO details from business logic)    │
└───────────────────────┬─────────────────────────────────┘
                        │  DAO method calls
┌───────────────────────▼─────────────────────────────────┐
│                    DATA LAYER                           │
│    VehicleDao · ServiceDao · AppDatabase (SQLite)       │
│    VehicleModel · ServiceModel (fromMap / toMap)        │
└─────────────────────────────────────────────────────────┘
```

**Why this architecture?**

- The **Repository pattern** decouples the Provider layer from `sqflite` APIs, making Providers testable with mock repositories.
- **DAO classes** isolate all SQL queries — if the schema changes, only the DAO files need updating.
- **Provider** was chosen over Bloc/Riverpod for its simplicity and natural integration with the Flutter widget tree at this project's scale.

---

## Project Structure

```
lib/
├── main.dart                          # Entry point; MultiProvider + named route setup
│
├── data/
│   ├── database/
│   │   └── app_database.dart          # Singleton SQLite helper; table creation & versioning
│   ├── models/
│   │   ├── vehicle_model.dart         # VehicleModel with fromMap() / toMap()
│   │   └── service_model.dart         # ServiceModel with fromMap() / toMap()
│   ├── dao/
│   │   ├── vehicle_dao.dart           # CRUD SQL operations for `vehicles` table
│   │   └── service_dao.dart           # CRUD SQL operations for `service_records` table
│   └── repositories/
│       ├── vehicle_repository.dart    # Abstracts VehicleDao for the Provider layer
│       └── service_repository.dart   # Abstracts ServiceDao for the Provider layer
│
├── providers/
│   ├── vehicle_provider.dart          # ChangeNotifier; manages vehicle list state
│   └── service_provider.dart         # ChangeNotifier; manages service records per vehicle
│
└── presentation/
    ├── screens/
    │   ├── vehicle_list_screen.dart       # Root screen — vehicle list with FAB
    │   ├── vehicle_detail_screen.dart     # Service record list for a selected vehicle
    │   ├── add_edit_vehicle_screen.dart   # Create / edit vehicle form
    │   └── add_edit_service_screen.dart   # Create / edit service record form
    └── widgets/
        ├── vehicle_card.dart              # Reusable card for a single vehicle
        ├── service_card.dart             # Reusable card for a single service record
        └── empty_state_widget.dart       # Friendly placeholder for empty lists
```

---

## Database Schema

The SQLite database (`car_service.db`) contains two tables:

### `vehicles`

| Column | Type | Constraint |
|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT |
| `make` | TEXT | NOT NULL |
| `model` | TEXT | NOT NULL |
| `year` | INTEGER | NOT NULL |
| `plate_number` | TEXT | NOT NULL |

### `service_records`

| Column | Type | Constraint |
|---|---|---|
| `id` | INTEGER | PRIMARY KEY, AUTOINCREMENT |
| `vehicle_id` | INTEGER | NOT NULL, FK → `vehicles(id)` ON DELETE CASCADE |
| `service_type` | TEXT | NOT NULL |
| `service_date` | TEXT | NOT NULL (ISO 8601: YYYY-MM-DD) |
| `mileage` | INTEGER | NOT NULL |
| `cost` | REAL | NOT NULL |
| `notes` | TEXT | NULLABLE |

---

## Technologies & Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | UI framework |
| `sqflite` | `^2.3.0` | SQLite local database |
| `path` | `^1.8.3` | Database file path resolution |
| `provider` | `^6.1.1` | State management (ChangeNotifier) |
| `cupertino_icons` | `^1.0.8` | iOS-style icons |

**Development dependencies:**

| Package | Version | Purpose |
|---|---|---|
| `flutter_lints` | `^6.0.0` | Dart/Flutter linting rules |
| `flutter_test` | SDK | Widget and unit testing framework |

**Dart SDK:** `^3.11.0`  
**Platforms:** Android 6.0+ · iOS 12+

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable, 3.x or later)
- Android Studio / VS Code with the Flutter extension
- An Android emulator (API 21+), iOS Simulator, or a physical device

### Clone the Repository

```bash
git clone https://github.com/Pydko/CARSERVICE_Mobile_App_Project.git
cd CARSERVICE_Mobile_App_Project
```

### Install Dependencies

```bash
flutter pub get
```

### Verify Setup

```bash
flutter doctor
```

Ensure that at least one target platform (Android or iOS) reports no issues.

---

## Running the App

### Debug Mode

```bash
flutter run
```

### Specific Device

```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device-id>
```

### Release Build (Android APK)

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

### Release Build (iOS)

```bash
flutter build ios --release
```

> iOS builds require macOS with Xcode installed and a valid provisioning profile.

---

## Testing

### Static Analysis

```bash
flutter analyze
```

All source files pass `flutter analyze` with zero warnings or errors.

### Manual Test Coverage

The following scenarios were manually tested on Android Emulator (API 33) and iOS Simulator (iOS 16):

| Test | Result |
|---|---|
| Add vehicle — all fields valid | ✅ Pass |
| Edit vehicle — change model year | ✅ Pass |
| Delete vehicle — confirm dialog | ✅ Pass |
| Add service record — all fields valid | ✅ Pass |
| Edit service record — update cost | ✅ Pass |
| Delete service record — confirm dialog | ✅ Pass |
| Form validation — empty required field | ✅ Pass |
| Form validation — non-numeric mileage | ✅ Pass |
| Data persistence — reopen app | ✅ Pass |
| Empty-state widget — no vehicles | ✅ Pass |
| Delete cancel — no data change | ✅ Pass |

### Running Unit / Widget Tests

```bash
flutter test
```

---

## Known Limitations

- **No cloud backup** — data is stored locally only; uninstalling the app erases all records.
- **No reminders** — the app does not send notifications for upcoming service intervals.
- **No search / filter** — service records within a vehicle cannot be searched or filtered.
- **Single-user** — the app has no authentication or multi-user support.
- **No automated tests** — unit and widget tests are not yet implemented; only manual testing was conducted.

---

## Future Improvements

- ☁️ **Cloud Sync** — integrate Firebase Firestore for multi-device backup
- 🔔 **Service Reminders** — push notifications via `flutter_local_notifications` for mileage-based intervals
- 🔍 **Search & Filter** — filter records by date range, service type, or cost
- 👤 **User Authentication** — Firebase Auth for personalised data isolation
- 🧪 **Automated Testing** — unit tests for Repositories and Providers using `mockito`; widget tests for form screens
- 📄 **Export** — generate PDF or CSV reports of vehicle service history

---

## Course Information

| Item | Detail |
|---|---|
| Course | CEN306 – Mobile Application Design and Development |
| Instructor | Dr. Yıldız Karadayı |
| Developer | Muhammet Özgür Aslan |
| Academic Term | 2024–2025 Spring |
| Repository | [github.com/Pydko/CARSERVICE_Mobile_App_Project](https://github.com/Pydko/CARSERVICE_Mobile_App_Project) |

---

*Built with ❤️ and Flutter*

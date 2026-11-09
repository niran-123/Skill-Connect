import os

content = """# 🔧 Skill Connect

> **A Flutter-based on-demand home services marketplace** that connects customers with verified local professionals using AI-powered job analysis and intelligent matching.

---

## 📋 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Technology Stack](#2-technology-stack)
3. [Architecture and System Design](#3-architecture-and-system-design)
4. [Complete Folder Structure](#4-complete-folder-structure)
5. [Customer App — Complete Features](#5-customer-app--complete-features)
6. [Professional App — Complete Features](#6-professional-app--complete-features)
7. [Complete Service Request Workflow](#7-complete-service-request-workflow)
8. [Status Management and Business Rules](#8-status-management-and-business-rules)
9. [Database Schema and Data Relationships](#9-database-schema-and-data-relationships)
10. [Backend and API Documentation](#10-backend-and-api-documentation)
11. [Firebase Documentation](#11-firebase-documentation)
12. [Real-Time Synchronization](#12-real-time-synchronization)
13. [Authentication and Security](#13-authentication-and-security)
14. [Installation and Local Setup](#14-installation-and-local-setup)
15. [Environment Variables and Configuration](#15-environment-variables-and-configuration)
16. [Testing and Quality Assurance](#16-testing-and-quality-assurance)
17. [Deployment Documentation](#17-deployment-documentation)
18. [Google Play Store Readiness](#18-google-play-store-readiness)
19. [Known Issues and Future Improvements](#19-known-issues-and-future-improvements)
20. [Contribution and Maintenance](#20-contribution-and-maintenance)

---

## 1. Project Overview

**Skill Connect** is a mobile application built with **Flutter** that acts as an AI-powered fair cooperative workforce and intelligent service-matching platform. It connects customers who need local home services with professionals who provide them. 

Customers can describe their problem in natural language (or even by voice), and the app uses **Google Gemini AI** to analyze the request, identify the right service category and required skills, then ranks and suggests the best-matched local professionals.

**Problem Solved:** Finding reliable, skilled home service professionals is often manual, time-consuming, and lacks transparency.
**Proposed Solution:** A seamless two-sided marketplace where AI bridges the gap between a customer's problem description and a professional's verified skill set.
**Target Users:**
- **Customers** – Seeking reliable home services (e.g., plumbing, electrical, carpentry).
- **Professionals** – Skilled workers looking for service requests nearby.
- **Admins** – Platform oversight and professional verification.

**Supported Categories:** AC Repair, Plumbing, Electrical, Carpentry, Appliance Repair, Cleaning, Painting. (Verified in codebase).

---

## 2. Technology Stack

### Frontend & Mobile Application
- **Framework:** Flutter (Dart `^3.12.2`)
- **UI Styling:** Material 3 (`theme.dart`)
- **State Management:** Provider (`^6.1.5+1`)
- **Navigation:** GoRouter (`^18.0.2`)
- **Forms and Validation:** Flutter built-in validation
- **Location:** `geolocator` (`^14.1.1`), `geocoding` (`^5.0.0`)
- **Media:** `image_picker`, `flutter_image_compress`, `speech_to_text`, `cached_network_image`
- **Application ID:** `com.niran.skillconnect` (Android)
- **Target SDK:** 34

### Backend & Database (Serverless)
- **Database:** Firebase Cloud Firestore (`^6.10.0`)
- **Authentication:** Firebase Auth (`^6.7.0`) + Google Sign-In (`^6.2.1`)
- **Storage:** Firebase Storage (`^13.6.0`)
- **Notifications:** Firebase Cloud Messaging (`^16.7.0`)
- **API Architecture:** Direct client-to-Firestore with rigorous Security Rules. No standalone Node/Python server is used.

### Integrations
- **AI/NLP:** Google Gemini 1.5 Flash API (REST via `http` package)

---

## 3. Architecture and System Design

Skill Connect follows a **layered clean architecture** pattern with direct integration to Firebase.

```mermaid
graph TD
    subgraph "Client Applications"
        C[Customer App]
        P[Professional App]
        A[Admin App]
    end

    subgraph "Firebase Cloud (Backend)"
        Auth[Firebase Auth]
        DB[(Cloud Firestore)]
        Storage[Firebase Storage]
    end

    subgraph "External Services"
        Gemini[Google Gemini API]
    end

    C -->|Authenticate| Auth
    P -->|Authenticate| Auth
    A -->|Authenticate| Auth

    C <-->|Listen/Write Data| DB
    P <-->|Listen/Write Data| DB
    A <-->|Manage Data| DB
    
    C -->|Upload Photos| Storage
    P -->|Upload Docs/Photos| Storage

    C -->|Analyze Problem Description| Gemini
```

**Responsibilities:**
- **Client Apps:** UI, Navigation, State Management (Provider), Location fetching, Direct API calls to Gemini.
- **Firebase Auth:** Handles Email/Password and Google OAuth.
- **Cloud Firestore:** Serves as the real-time database. Streams are used for live updates.
- **Firebase Storage:** Stores avatars, job photos, and professional certificates.

---

## 4. Complete Folder Structure

```text
skill_connect/
├── android/                   # Android native build configurations
│   ├── app/
│   │   ├── build.gradle.kts   # Android app-level build config
│   │   └── upload-keystore.jks# Release Keystore
├── assets/                    # Static assets
├── lib/                       # Main Flutter source code
│   ├── core/                  # Constants, Enums, Router, Theme
│   ├── models/                # Data models (Booking, User, JobProfile)
│   ├── providers/             # State Management (JobProvider, AuthProvider)
│   ├── repositories/          # Firestore Data Access layer
│   ├── screens/               # UI Screens grouped by role (auth, customer, professional, admin)
│   ├── services/              # External APIs (GeminiService, MatchingService)
│   ├── app.dart               # Root widget
│   └── main.dart              # Entry point
├── test/                      # Testing directory
│   └── widget_test.dart       # Default widget test
├── .firebaserc                # Firebase project alias
├── env.example.json           # Example environment variables
├── firebase.json              # Firebase configuration
├── firestore.indexes.json     # Firestore composite indexes
├── firestore.rules            # Firestore security rules
└── pubspec.yaml               # Flutter package dependencies
```

---

## 5. Customer App — Complete Features

| Feature | Purpose | Backend / DB Interaction |
|---------|---------|--------------------------|
| **Account Creation & Login** | Register, Login via Email or Google | Firebase Auth, Creates `/users/{uid}` |
| **Service Discovery** | Browse services and categories | Local categorization (`JobRequestScreen`) |
| **AI Request Creation** | Describe problem (text/voice). AI extracts skills. | Calls Gemini API, Saves to `/jobs` |
| **Matches & Proposals** | Rank pros based on skills, location, rating | Reads `/professionals`, matches algorithmically |
| **Booking Request** | Select date, time, and confirm address | Writes `/bookings` (Status: `REQUEST_CREATED`) |
| **Live Tracking** | Monitor job status in real-time | Firestore Stream listener on `/bookings/{id}` |
| **Job Completion & Review** | Mark job completed and submit 1-5 star review | Updates `/bookings`, Writes `/reviews`, Updates Pro Stats |
| **Profile Management** | Edit name, avatar, address, view saved pros | Updates `/users/{uid}`, Uploads to Storage |

---

## 6. Professional App — Complete Features

| Feature | Purpose | Backend / DB Interaction |
|---------|---------|--------------------------|
| **Registration & Verification** | Create pro profile, upload certificates | Writes `/professionals`, Uploads `/images` |
| **Dashboard** | View active jobs and statistics | Reads `/professionals` & `/bookings` |
| **Incoming Requests** | View, Accept, or Reject new jobs | Reads `/bookings` (Status: `REQUEST_CREATED`) |
| **Accept Proposal** | Accept request, set estimated amount/time | Updates `/bookings` (Status: `PROFESSIONAL_ACCEPTED`) |
| **Job Execution** | Mark Arrived, Start Job | Updates `/bookings` (Status updates) |
| **Job History** | View completed and cancelled services | Reads `/bookings` |
| **Profile & Skills** | Manage skills, rates, and availability | Updates `/professionals/{uid}` |

---

## 7. Complete Service Request Workflow

```mermaid
stateDiagram-v2
    [*] --> REQUEST_CREATED : Customer Creates Request
    REQUEST_CREATED --> PROFESSIONAL_ACCEPTED : Professional Accepts & Sets Amount
    REQUEST_CREATED --> CANCELLED : Customer/Pro Cancels
    
    PROFESSIONAL_ACCEPTED --> CUSTOMER_CONFIRMED : Customer Confirms Amount/Time
    PROFESSIONAL_ACCEPTED --> CANCELLED : Customer Cancels
    
    CUSTOMER_CONFIRMED --> PROFESSIONAL_ARRIVED : Professional Arrives
    
    PROFESSIONAL_ARRIVED --> JOB_STARTED : Professional Starts Job
    
    JOB_STARTED --> JOB_COMPLETED : Customer Marks Completed
    
    JOB_COMPLETED --> [*] : Customer Submits Review
    CANCELLED --> [*]
```

**Discrepancy Note:** The codebase rigidly follows this exact 6-step flow enforced by `firestore.rules`. There is no separate "Proposal creation" step where multiple pros bid; the customer selects a specific pro, creates a request, and that pro accepts it by setting the amount and time. The customer then confirms.

---

## 8. Status Management and Business Rules

Defined in `lib/core/booking_status.dart` and strictly enforced by `firestore.rules`.

| Status | Meaning | Transition Performed By | Conditions / Validations |
|--------|---------|------------------------|---------------------------|
| `REQUEST_CREATED` | Initial request sent to Pro | Customer | Customer cannot set `estimatedCharge` |
| `PROFESSIONAL_ACCEPTED`| Pro accepts, sets amount & schedule | Professional | Pro must set `estimatedCharge`, `scheduledDate`, `timeSlot` |
| `CUSTOMER_CONFIRMED` | Customer agrees to Pro's terms | Customer | |
| `PROFESSIONAL_ARRIVED` | Pro reached location | Professional | |
| `JOB_STARTED` | Pro begins work | Professional | |
| `JOB_COMPLETED` | Job is done | Customer | |
| `CANCELLED` | Job aborted | Customer / Pro | Allowed only early in the workflow |

---

## 9. Database Schema and Data Relationships

Uses Cloud Firestore.

```mermaid
erDiagram
    USERS ||--o{ BOOKINGS : "creates"
    USERS {
        string uid
        string role
        string name
        string[] savedProfessionalIds
    }
    PROFESSIONALS ||--o{ BOOKINGS : "receives"
    PROFESSIONALS {
        string uid
        string category
        string[] skills
        map stats
    }
    BOOKINGS ||--o| REVIEWS : "has"
    BOOKINGS {
        string id
        string customerId
        string professionalId
        string status
        float estimatedCharge
    }
    REVIEWS {
        string bookingId
        string customerId
        string professionalId
        float rating
    }
```

*Note: No real customer data, tokens, or PII is exposed here.*

---

## 10. Backend and API Documentation

**There is no traditional REST API (Node.js/Python).** The app interacts directly with Firebase services via the Flutter SDK.

The only external API is Google Gemini AI:
- **HTTP Method:** `POST`
- **Route:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={API_KEY}`
- **Purpose:** Analyze natural language problem descriptions.
- **Request Body:** JSON containing the prompt.
- **Response:** JSON containing `category`, `problemType`, `requiredSkills`, `severity`, `estimatedDurationHours`.

---

## 11. Firebase Documentation

- **Firebase Authentication:** Handles Email/Password and Google OAuth.
- **Cloud Firestore:** Collections: `users`, `professionals`, `bookings`, `jobs`, `reviews`, `notifications`, `images`.
- **Firebase Storage:** Used via base64 uploads into the `images` Firestore collection (limit ~200KB per image) rather than the standard Storage bucket, based on the codebase rules.
- **Security Rules:** Extremely tight. Validates the status state machine transitions to prevent unauthorized role actions (e.g., Customers cannot mark jobs as `JOB_STARTED`).
- **Real-Time Sync:** Uses `StreamSubscription` to provide live updates for Job Tracking.

---

## 12. Real-Time Synchronization

**How it works:**
The app relies entirely on Firestore Snapshots (Streams).
- In `JobProvider.dart`, `streamCustomerBookings()` listens to the `/bookings` collection where `customerId == uid`.
- When a Professional taps "Arrived" or "Job Started", the Firestore document is updated.
- The stream instantly pushes the new `BookingModel` to the Customer App, updating the Live Tracker UI immediately without polling.

---

## 13. Authentication and Security

- **Authentication:** Managed by Firebase Auth.
- **Route Protection:** GoRouter redirect intercepts navigation. Unauthenticated users are sent to `/login`. Users with a role mismatch (Customer trying to view Pro pages) are redirected.
- **Database Security:** `firestore.rules` enforces:
  - Role-based restrictions (only Pros can edit Pro profiles, unless leaving a review).
  - Workflow validations (strictly enforces the `BookingStatus` transition matrix).
  - Data integrity (prevents spoofing `customerId` or `professionalId`).

---

## 14. Installation and Local Setup

**Prerequisites:** Flutter SDK `^3.12.2`, Android Studio, Firebase Project.

1. **Clone Repository:**
   ```bash
   git clone <repo_url>
   cd skill_connect
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Environment Setup:**
   Copy the example environment file:
   ```bash
   cp env.example.json env.json
   ```
   Add your Gemini API key inside `env.json`.
4. **Firebase Setup:**
   Run `flutterfire configure` to connect to your Firebase project.
   Deploy Firestore rules:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```
5. **Run Locally:**
   ```bash
   flutter run
   ```

---

## 15. Environment Variables and Configuration

Configuration is managed via `env.json` (gitignored).

| Variable Name | Purpose | Required/Optional | Used By | Example Placeholder |
|--------------|---------|------------------|---------|---------------------|
| `GEMINI_API_KEY` | Authenticates with Google Gemini API | Required | Frontend (GeminiService) | `YOUR_GEMINI_API_KEY_HERE` |

*Do not commit `env.json` with real API keys.*

---

## 16. Testing and Quality Assurance

- **Unit/Widget Tests:** Currently, there is only a default `test/widget_test.dart`.
- **Integration Tests:** Not implemented.
- **Missing Tests:** The project currently lacks comprehensive unit tests for `JobProvider`, `MatchingService`, and widget tests for the core booking flow.
- **Recommendation:** Implement tests for `MatchingService` logic and Firebase rules using the Firebase Emulator Suite.

---

## 17. Deployment Documentation

### Android Deployment
1. Ensure the Keystore is placed in `android/app/upload-keystore.jks`.
2. Ensure `key.properties` exists in the root directory with the signing credentials.
3. Build the Android App Bundle:
   ```bash
   flutter build appbundle --release
   ```
4. Upload the generated `.aab` file (located in `build/app/outputs/bundle/release/`) to the Google Play Console.

### Backend Deployment
Backend updates only require deploying the updated Firestore rules and indexes:
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

---

## 18. Google Play Store Readiness

- [x] **Application ID:** `com.niran.skillconnect`
- [x] **Release Build Configured:** Yes (`build.gradle.kts` signing configuration is present).
- [x] **App Signing:** Managed via `upload-keystore.jks`.
- [x] **Store Assets:** `play_store_icon.jpg`, `play_store_feature.jpg`, screenshots exist in the root folder.
- [ ] **Privacy Policy URL:** A folder `skillconnect-privacy-policy` exists, but needs hosting.
- [ ] **Data Safety Declaration:** Must be completed manually in the Play Console.
- [ ] **Crash/Error Reporting:** No Crashlytics implementation was found in the codebase.

---

## 19. Known Issues and Future Improvements

**Known Issues:**
- **Lack of Tests:** Significant test coverage is missing.
- **Image Storage Limits:** Images are stored as base64 in Firestore documents with a 200KB limit instead of directly in Firebase Storage buckets.
- **Gemini Fallback:** If the Gemini API fails, it falls back to a hardcoded response instead of a robust offline NLP approach.

**Future Improvements:**
- Implement Firebase App Check for enhanced security.
- Migrate base64 image storage completely to Firebase Storage URLs to reduce Firestore document size limits.
- Implement Firebase Crashlytics.
- Add an in-app chat feature between Customer and Professional.

---

## 20. Contribution and Maintenance

1. **Branching:** Use feature branches (`feature/add-payment`) and submit Pull Requests to `main`.
2. **Code Formatting:** Run `flutter format .` before committing.
3. **Linting:** Resolve all warnings from `flutter analyze` (enforced by `flutter_lints`).
4. **Issue Reporting:** Provide detailed steps to reproduce when filing bugs.
"""

with open("d:/MAD/Skill-connect/README.md", "w", encoding="utf-8") as f:
    f.write(content)
print("README.md written successfully.")

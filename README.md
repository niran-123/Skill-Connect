# 🔧 Skill Connect

> **A Flutter-based on-demand home services marketplace** that connects customers with verified local professionals using AI-powered job analysis and intelligent matching.

---

## 📋 Table of Contents

1. [Project Overview](#-project-overview)
2. [Key Features](#-key-features)
3. [Tech Stack](#-tech-stack)
4. [Architecture Overview](#-architecture-overview)
5. [Project Structure](#-project-structure)
6. [Frontend (Flutter)](#-frontend-flutter)
7. [Backend & Services](#-backend--services)
8. [Database (Cloud Firestore)](#-database-cloud-firestore)
9. [Data Models](#-data-models)
10. [Complete Workflow](#-complete-workflow)
11. [Booking Lifecycle](#-booking-lifecycle)
12. [Packages & Dependencies](#-packages--dependencies)
13. [Setup & Installation](#-setup--installation)
14. [Service Categories & Skills](#-service-categories--skills)

---

## 🌟 Project Overview

**Skill Connect** is a mobile application built with **Flutter** that acts as a two-sided marketplace for home services. Customers can describe their problem in natural language (or even by voice), and the app uses **Google Gemini AI** to analyze the request, identify the right service category and required skills, then ranks and suggests the best-matched local professionals.

The app supports three distinct user roles:
- **Customer** – Searches, books, tracks, and reviews professionals
- **Professional** – Manages service requests, availability, profile, and job completion
- **Admin** – Platform oversight and professional verification management

---

## ✨ Key Features

### For Customers
- 🗣️ **Natural Language / Voice Job Description** – Describe your problem in plain text or use speech-to-text
- 🤖 **AI-Powered Analysis** – Google Gemini 1.5 Flash analyzes the problem and extracts category, skills, severity, and estimated duration
- 🎯 **Smart Matching** – Multi-factor scoring algorithm ranks professionals by skill match, ratings, distance, and availability
- 📍 **Location-Aware Search** – Uses GPS to find professionals within service radius
- 📅 **Booking Management** – Schedule bookings, track real-time status, cancel if needed
- ⭐ **Reviews & Ratings** – Post-job review system that updates professional trust scores
- 💾 **Save Professionals** – Bookmark favourite professionals for quick rebooking
- 🔔 **Notifications** – Real-time booking status updates
- 🔍 **Browse & Filter** – Explore professionals by category, rating, and location

### For Professionals
- 📊 **Dashboard** – Earnings overview, upcoming jobs, quick stats
- 📥 **Service Requests** – View, accept, or reject incoming booking requests
- 📍 **Live Status Updates** – Update job status (on the way → arrived → in progress → completed)
- 📷 **Job Completion** – Upload completion photos and work summaries
- 🗓️ **Availability Calendar** – Set schedule and working hours
- 🧾 **Skill & Rate Management** – Manage skills offered and pricing
- 📜 **Document Verification** – Upload certificates for platform verification
- 📈 **Job History** – Full record of past completed and cancelled jobs
- 🔔 **Notifications** – Alerts for new requests and updates

### For Admin
- ✅ **Professional Verification** – Review and approve/reject professional registration
- 🛡️ **Platform Oversight** – Admin dashboard with full access controls

---

## 🛠 Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Framework** | Flutter | SDK ^3.12.2 |
| **Language** | Dart | ^3.12.2 |
| **Authentication** | Firebase Auth | ^6.7.0 |
| **Database** | Cloud Firestore | ^6.10.0 |
| **Storage** | Firebase Storage | ^13.6.0 |
| **AI / NLP** | Google Gemini 1.5 Flash API | REST |
| **State Management** | Provider | ^6.1.5 |
| **Navigation** | GoRouter | ^18.0.2 |
| **Location** | Geolocator + Geocoding | ^14.1.1 / ^5.0.0 |
| **Image Handling** | image_picker + flutter_image_compress | ^1.2.3 / ^2.5.1 |
| **Voice Input** | speech_to_text | ^7.5.0 |
| **HTTP Client** | http | ^1.6.0 |
| **Caching** | cached_network_image | ^4.0.3 |
| **Loading UI** | shimmer | ^4.0.0 |
| **Icons** | flutter_lucide | ^1.49.0 |
| **Date/Time** | intl | ^0.20.2 |
| **UUID** | uuid | ^4.6.0 |

---

## 🏗 Architecture Overview

Skill Connect follows a **layered clean architecture** pattern:

```
┌─────────────────────────────────────────────────────┐
│                     UI Layer                        │
│  (Screens: auth / customer / professional / admin)  │
└────────────────────┬────────────────────────────────┘
                     │ reads from / calls
┌────────────────────▼────────────────────────────────┐
│                 Provider Layer                      │
│  (AuthProvider, JobProvider, ProfessionalProvider,  │
│   SessionProvider)                                  │
└────────────────────┬────────────────────────────────┘
                     │ delegates to
┌────────────────────▼────────────────────────────────┐
│              Repository Layer                       │
│  (AuthRepo, BookingRepo, ProfessionalRepo,          │
│   UserRepo, ReviewRepo, NotificationRepo,           │
│   ImageRepo)                                        │
└───────────┬──────────────────────┬──────────────────┘
            │                      │
┌───────────▼──────┐    ┌──────────▼───────────────────┐
│  Service Layer   │    │      External Services        │
│  (GeminiService, │    │  (Firebase Auth, Firestore,   │
│  MatchingService)│    │   Firebase Storage, Gemini AI)│
└──────────────────┘    └──────────────────────────────┘
```

---

## 📁 Project Structure

```
skill_connect/
├── lib/
│   ├── main.dart                      # App entry point, Firebase init
│   ├── app.dart                       # Root widget, Provider setup
│   ├── firebase_options.dart          # Firebase platform config (auto-generated)
│   │
│   ├── core/
│   │   ├── constants.dart             # Matching weights, service categories, skill catalog
│   │   ├── enums.dart                 # App-wide enumerations
│   │   ├── router.dart                # GoRouter config, route guards, all routes
│   │   └── theme.dart                 # Material 3 design tokens, AppTheme
│   │
│   ├── models/
│   │   ├── user_model.dart            # Customer user data model
│   │   ├── professional.dart          # Professional profile data model
│   │   ├── booking.dart               # Booking lifecycle data model
│   │   ├── job_profile.dart           # AI-analyzed job request model
│   │   ├── match_result.dart          # Scoring result from matching algorithm
│   │   ├── review.dart                # Customer review/rating model
│   │   └── app_notification.dart      # In-app notification model
│   │
│   ├── providers/
│   │   ├── auth_provider.dart         # Email/Password & Google Sign-In logic
│   │   ├── session_provider.dart      # Global session state (logged-in user)
│   │   ├── job_provider.dart          # Job flow: AI analysis → matching → booking
│   │   └── professional_provider.dart # Professional data & management state
│   │
│   ├── repositories/
│   │   ├── auth_repo.dart             # Firebase Auth CRUD wrapper
│   │   ├── user_repo.dart             # Firestore users collection
│   │   ├── professional_repo.dart     # Firestore professionals collection
│   │   ├── booking_repo.dart          # Firestore bookings collection
│   │   ├── review_repo.dart           # Firestore reviews collection
│   │   ├── notification_repo.dart     # Firestore notifications collection
│   │   └── image_repo.dart            # Firestore images + Firebase Storage
│   │
│   ├── services/
│   │   ├── gemini_service.dart        # Google Gemini 1.5 Flash REST API client
│   │   └── matching_service.dart      # Multi-factor professional ranking algorithm
│   │
│   └── screens/
│       ├── auth/                      # Login, Signup, Role Selection, Pro Registration
│       ├── customer/                  # 23 screens for the customer flow
│       ├── professional/              # 16 screens for the professional flow
│       ├── admin/                     # Admin oversight screen
│       └── shared/                    # Splash, Onboarding, Help, FAQ, Terms, Privacy
│
├── firestore.rules                    # Firestore security rules
├── firestore.indexes.json             # Composite index definitions
├── firebase.json                      # Firebase project config
├── env.json                           # API keys (gitignored)
├── env.example.json                   # Example env template
└── pubspec.yaml                       # Flutter dependencies
```

---

## 📱 Frontend (Flutter)

### Screens & Modules

#### 🔐 Auth Module (`/screens/auth/`)

| Screen | Purpose |
|--------|---------|
| `SplashScreen` | App launch, Firebase init check, auto-redirects based on session |
| `OnboardingScreen` | First-launch walkthrough for new users |
| `LoginScreen` | Email/password login + Google Sign-In |
| `SignupScreen` | New user registration |
| `RoleSelectionScreen` | After auth, user picks Customer or Professional role |
| `ForgotPasswordScreen` | Firebase password reset via email |
| `ProRegistrationScreen` | Multi-step professional profile setup |

#### 👤 Customer Module (`/screens/customer/`) — 23 screens

| Screen | Purpose |
|--------|---------|
| `CustomerHomeScreen` | Home dashboard with category quick-access tiles |
| `JobRequestScreen` | Text input / voice input for job description |
| `DescribeProblemScreen` | Detailed problem description with photo upload |
| `AiAnalysisScreen` | Shows Gemini AI analysis result (category, severity, skills) |
| `ProfessionalListScreen` | Ranked list of matched professionals with match scores |
| `ProfessionalDetailScreen` | Full professional profile, reviews, skills, ratings |
| `BookingRequestScreen` | Confirm booking: schedule date, time slot, address |
| `BookingSentScreen` | Booking confirmation + tracking info |
| `CustomerBookingsScreen` | All bookings (pending / active / completed / cancelled) |
| `BookingDetailsScreen` | Full booking details with live status tracking |
| `CancelBookingScreen` | Cancel a pending/accepted booking with reason |
| `ReviewScreen` | Rate (1-5 stars) and write a review after job completion |
| `SearchProfessionalsScreen` | Free-text search with category filters |
| `FiltersScreen` | Advanced filter panel (category, rating, distance) |
| `CustomerProfileScreen` | View own profile, saved professionals, settings |
| `EditCustomerProfileScreen` | Edit name, phone, address, avatar |
| `SavedProfessionalsScreen` | Bookmarked professionals |
| `CustomerNotificationsScreen` | Booking update notifications |
| `NoProsAvailableScreen` | Shown when no match found |
| `OfflineModeScreen` | No connectivity fallback |
| `PaymentFailedScreen` | Payment error fallback |
| `MediaUploadRetryScreen` | Retry failed media uploads |

#### 🔨 Professional Module (`/screens/professional/`) — 16 screens

| Screen | Purpose |
|--------|---------|
| `ProfessionalDashboard` | Earnings stats, job summary, active job cards |
| `ServiceRequestsScreen` | List of incoming booking requests |
| `ServiceRequestDetailsScreen` | Full booking request — Accept / Reject |
| `AcceptRequestConfirmationScreen` | Confirm acceptance with expected arrival time |
| `JobExecutionScreen` | Live job status update control panel |
| `JobHistoryScreen` | Full history of all past jobs |
| `ProProfileViewScreen` | Own professional profile (public view) |
| `EditProProfileScreen` | Edit bio, service description, location |
| `ManageSkillsRatesScreen` | Add/remove skills, set hourly rates |
| `DocumentVerificationScreen` | Upload certificates for admin review |
| `ProAvailabilityCalendarScreen` | Set weekly working schedule |
| `ProNotificationsScreen` | New requests and booking status alerts |
| `ProVerificationPendingScreen` | Shown while verification is in-review |
| `DemoEarningsScreen` | Earnings breakdown and payment history |
| `ProfessionalSettingsScreen` | Account settings and logout |

#### 🛡️ Admin Module — 1 screen

| Screen | Purpose |
|--------|---------|
| `AdminScreen` | Professional verification panel + platform oversight |

#### 🌐 Shared Screens

| Screen | Purpose |
|--------|---------|
| `SplashScreen` | Loading & auth state check |
| `OnboardingScreen` | App intro slides |
| `HelpSupportScreen` | Help & support info |
| `FaqScreen` | Frequently asked questions |
| `TermsScreen` | Terms of service |
| `PrivacyScreen` | Privacy policy |
| `NotificationDetailsScreen` | Individual notification detail |

---

### State Management

The app uses **Provider** for state management with 4 `ChangeNotifier` providers:

#### `SessionProvider`
- Listens to `FirebaseAuth.authStateChanges()` stream
- Holds the current `UserModel` from Firestore
- **Single source of truth** for authentication state
- Drives GoRouter redirect logic for route guarding

#### `AuthProvider`
- Wraps `AuthRepo` for email/password and Google sign-in
- Handles loading/error states for auth operations
- Methods: `signInWithEmail`, `signUpWithEmail`, `signInWithGoogle`, `sendPasswordReset`, `signOut`

#### `JobProvider` _(Core Orchestrator)_
- Coordinates the entire customer booking flow:
  `GeminiService` → `MatchingService` → `ProfessionalRepo` → `BookingRepo`
- State held: `currentJob`, `matches`, `customerBookings`, `professionalBookings`, `savedProfessionals`
- Review submission uses atomic Firestore **batch writes** (review + booking update + professional stats update in one transaction)

#### `ProfessionalProvider`
- Manages professional profile loading and updates
- Wraps `ProfessionalRepo` for CRUD on the professional's own data

---

### Navigation & Routing

Navigation is handled by **GoRouter** with declarative URL-based routing.

#### Route Guard Logic

```
App Start
  └── Session loading? → Stay on Splash (/)
  └── Not authenticated?
        └── On Splash → redirect to /onboarding
        └── On auth routes → allow through
        └── Anywhere else → redirect to /login
  └── Authenticated but no UserModel (role not set)?
        → redirect to /role-selection
  └── Authenticated with role?
        ├── customer      → /customer/home
        ├── professional  → /professional/dashboard
        └── admin         → /admin
```

#### Shell Navigation
Both Customer and Professional use **`StatefulShellRoute.indexedStack`** for persistent bottom navigation:
- **Customer Shell** – 5 tabs: Home | Search | Bookings | Notifications | Profile
- **Professional Shell** – 5 tabs: Dashboard | Requests | Jobs | Notifications | Profile

#### Route Table

| Route | Path | Role |
|-------|------|------|
| Splash | `/` | All |
| Onboarding | `/onboarding` | Guest |
| Login | `/login` | Guest |
| Signup | `/signup` | Guest |
| Role Selection | `/role-selection` | Auth (no role) |
| Forgot Password | `/forgot-password` | Guest |
| Pro Registration | `/pro-registration` | Auth |
| Customer Home | `/customer/home` | Customer |
| Job Request | `/customer/home/request` | Customer |
| Matches | `/customer/home/matches` | Customer |
| Pro Detail | `/customer/home/matches/:id` | Customer |
| Booking Request | `/customer/home/booking-request` | Customer |
| Booking Sent | `/customer/home/booking-sent` | Customer |
| Customer Search | `/customer/search` | Customer |
| Customer Bookings | `/customer/bookings` | Customer |
| Booking Details | `/customer/bookings/:id` | Customer |
| Review | `/customer/bookings/review/:id` | Customer |
| Notifications | `/customer/notifications` | Customer |
| Customer Profile | `/customer/profile` | Customer |
| Edit Profile | `/customer/profile/edit` | Customer |
| Saved Pros | `/customer/profile/saved-pros` | Customer |
| Pro Dashboard | `/professional/dashboard` | Professional |
| Service Requests | `/professional/requests` | Professional |
| Request Details | `/professional/requests/details` | Professional |
| Job History | `/professional/jobs` | Professional |
| Job Execution | `/professional/jobs/:id` | Professional |
| Pro Notifications | `/professional/notifications` | Professional |
| Pro Profile | `/professional/profile` | Professional |
| Pro Settings | `/professional/profile/settings` | Professional |
| Edit Pro Profile | `/professional/profile/edit` | Professional |
| Manage Skills | `/professional/profile/skills` | Professional |
| Doc Verification | `/professional/profile/verification` | Professional |
| Admin | `/admin` | Admin |
| Help | `/help` | All |
| FAQ | `/faq` | All |
| Terms | `/terms` | All |
| Privacy | `/privacy` | All |

---

### Theme & Design System

Defined in `lib/core/theme.dart` using **Material 3** (`useMaterial3: true`):

| Token | Value |
|-------|-------|
| **Primary Color** | `#1D4ED8` (Indigo Blue) |
| **Background** | `#F7F9FB` (Off-white) |
| **Surface** | `#FFFFFF` |
| **Error** | `#BA1A1A` |
| **Font Family** | `Inter` |
| **Border Radius** | `8px` |

Consistent styles for: `ElevatedButton`, `OutlinedButton`, `InputDecoration`, `CardTheme`, `AppBarTheme`.

---

## ⚙️ Backend & Services

Skill Connect uses **Firebase** as its entire backend infrastructure — no custom server required.

### Firebase Authentication

Supports three methods:
1. **Email & Password** – Standard Firebase Auth
2. **Google Sign-In** – via `google_sign_in` package
3. **Password Reset** – Firebase email-based reset

After auth, the app checks Firestore for a user document. New users are redirected to role selection.

### Gemini AI Service

**File:** `lib/services/gemini_service.dart`

Communicates with **Google Gemini 1.5 Flash** via REST API using the `http` package.

**Endpoint:**
```
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=<API_KEY>
```

**Input:** Natural language problem description (text or transcribed voice).

**Output JSON:**
```json
{
  "category": "Plumbing",
  "problemType": "Pipe Leak",
  "requiredSkills": ["pipe_repair", "leak_fixing"],
  "severity": "High",
  "estimatedDurationHours": 2
}
```

**Fallback:** Keyword-based rule engine activates when API key is missing/invalid.

**Config:** API key loaded from `env.json` at runtime as a Flutter asset.

### Matching Algorithm

**File:** `lib/services/matching_service.dart`

Ranks verified professionals using a **multi-factor weighted scoring system**:

| Factor | Max Score | Logic |
|--------|-----------|-------|
| **Skill Match** | 40 pts | `(matched / required) × 40` |
| **Trust Score** | 30 pts | `(rating/5 × 20) + min(jobs/10 × 10, 10)` |
| **Location/Distance** | 20 pts | `max(0, 20 − km)` if within radius; `−20` penalty if outside |
| **Availability** | 10 pts | Reserved for future implementation |

**Distance:** Uses the **Haversine formula** for great-circle GPS distance.

---

## 🗄 Database (Cloud Firestore)

### Collections & Schema

#### `/users/{uid}` — Customer profile
```
uid, role, name, email, phone, address,
lat, lng, avatarThumb, avatarImageId,
savedProfessionalIds[], createdAt, updatedAt
```

#### `/professionals/{uid}` — Professional profile
```
uid, name, category, city, area, lat, lng,
bio, serviceDescription, experienceYears,
serviceRadiusKm, skills[], available, schedule{},
verificationStatus, verificationNote, certificates[],
avatarThumb, stats{averageRating, reviewCount, jobsCompleted},
skillStats{}, searchTokens[], createdAt, updatedAt
```

#### `/bookings/{bookingId}` — Full booking record
```
id, jobId, customerId, customerName, customerThumb,
professionalId, professionalName, professionalThumb,
jobSnapshot{}, scheduledDate, timeSlot, address,
lat, lng, distanceKm, estimatedCharge, finalCharge,
match{}, status, statusHistory[], workSummary,
completionImageId, completionNotes, reviewed,
createdAt, updatedAt
```

#### `/reviews/{bookingId}` — Post-job review (1:1 with booking)
```
bookingId, customerId, professionalId,
rating (1–5), comment, createdAt
```

#### `/notifications/{notificationId}` — In-app notification
```
toUid, fromUid, title, body, type,
bookingId (optional), read, createdAt
```

#### `/images/{imageId}` — Base64 image store (≤200KB)
```
ownerId, base64, purpose [avatar|certificate|jobPhoto|completion],
bookingId (optional), createdAt
```

#### `/jobs/{jobId}` — AI-analyzed job request
```
id, customerId, description, categoryChosen,
analysis{}, lat, lng, createdAt
```

---

### Security Rules

| Collection | Read Access | Write Access | Special Rules |
|------------|-------------|--------------|---------------|
| `users` | Owner or Admin | Owner only | Cannot self-change `role` |
| `professionals` | Any signed-in user | Owner (restricted) or Admin | Admin controls `verificationStatus`; customers can update `stats` during review |
| `jobs` | Owner only | Owner only | — |
| `bookings` | Customer, Professional, or Admin | Customer creates (pending only); transitions follow state machine | Strictly enforced state machine |
| `reviews` | Any signed-in user | Customer only, post-completion | Immutable after creation |
| `notifications` | Recipient only | Sender only | Only `read` field can be updated |
| `images` | Role-context based | Owner only, ≤200KB | Immutable after creation |

**Booking Status State Machine (enforced by rules):**

```
pending  →  accepted    (by professional)
pending  →  rejected    (by professional)
pending  →  cancelled   (by customer)
accepted →  onTheWay    (by professional)
accepted →  cancelled   (by customer or professional)
onTheWay →  arrived     (by professional)
arrived  →  inProgress  (by professional)
inProgress → completed  (by professional)
```

---

### Composite Indexes

| Collection | Index Fields | Purpose |
|------------|-------------|---------|
| `bookings` | `customerId ASC` + `createdAt DESC` | Customer bookings list |
| `bookings` | `professionalId ASC` + `createdAt DESC` | Professional bookings list |
| `notifications` | `toUid ASC` + `read ASC` + `createdAt DESC` | Unread notifications |
| `reviews` | `professionalId ASC` + `createdAt DESC` | Professional review history |

---

## 📦 Data Models

| Model | File | Mapped Collection | Purpose |
|-------|------|------------------|---------|
| `UserModel` | `models/user_model.dart` | `/users` | Customer profile |
| `ProfessionalModel` | `models/professional.dart` | `/professionals` | Professional profile |
| `BookingModel` | `models/booking.dart` | `/bookings` | Full booking lifecycle |
| `JobProfile` | `models/job_profile.dart` | `/jobs` | AI-analyzed job request |
| `MatchResult` | `models/match_result.dart` | — (in-memory) | Scored professional match |
| `ReviewModel` | `models/review.dart` | `/reviews` | Post-job rating |
| `AppNotification` | `models/app_notification.dart` | `/notifications` | In-app notification |

---

## 🔄 Complete Workflow

### Customer Workflow

```
1. ONBOARDING
   └── Open app → Splash → Onboarding slides → Login / Signup

2. AUTHENTICATION
   ├── Email/Password or Google Sign-In
   ├── New user → Role Selection → [Customer]
   └── Creates /users/{uid} with role = 'customer'

3. HOME
   └── Category tiles: AC Repair, Plumbing, Electrical, Carpentry, etc.

4. AI JOB REQUEST FLOW
   ├── Tap category OR describe custom problem
   ├── Type OR speak problem description (speech_to_text)
   ├── Add problem photos (optional)
   ├── Submit → JobProvider.processJobRequest()
   │   ├── GeminiService → Gemini 1.5 Flash API
   │   │   └── Returns: category, skills, severity, duration
   │   ├── ProfessionalRepo → Fetch all verified pros in category
   │   └── MatchingService.rankProfessionals() → sorted MatchResult[]
   └── AI Analysis Screen → shows analysis to customer

5. BROWSE MATCHES
   ├── Ranked professional list with scores
   ├── Filter / sort
   └── Tap → Full professional profile (bio, skills, ratings, reviews)

6. BOOK
   ├── Booking Request Screen: select date, time slot, confirm address
   ├── Confirm → creates /bookings/{id} with status = 'pending'
   └── Booking Sent Screen → confirmation

7. TRACK
   ├── Customer Bookings → live status display
   │   pending → accepted → onTheWay → arrived → inProgress → completed
   └── Cancel (if pending/accepted)

8. REVIEW (after completion)
   └── Rate 1–5 stars + written comment
       └── Atomic batch write:
           ├── Creates /reviews/{bookingId}
           ├── Updates /bookings/{id}.reviewed = true
           └── Recalculates /professionals/{id}.stats
```

---

### Professional Workflow

```
1. REGISTRATION (multi-step form)
   ├── Basic Info: name, category, bio
   ├── Location: city, area, GPS, service radius
   ├── Skills & Experience (from skill catalog)
   └── Creates /professionals/{uid} + /users/{uid}

2. VERIFICATION
   ├── Upload certificates → verificationStatus = 'pending'
   ├── Locked on Pro Verification Pending Screen
   └── Admin approves → verificationStatus = 'verified'
       └── Professional appears in search results

3. DASHBOARD
   └── Earnings, active job, quick stats, notifications

4. MANAGE REQUESTS
   ├── View incoming pending bookings
   ├── View full customer + job details
   ├── ACCEPT → status: pending → accepted
   └── REJECT → status: pending → rejected

5. JOB EXECUTION
   ├── On the Way → status: onTheWay
   ├── Arrived → status: arrived
   ├── Started → status: inProgress
   └── Complete:
       ├── Upload completion photo
       ├── Write work summary
       ├── Enter final charge
       └── status: inProgress → completed

6. PROFILE
   └── Edit profile, manage skills/rates, set availability, upload docs
```

---

### Admin Workflow

```
1. Login with admin account (role = 'admin')
2. Admin Screen:
   ├── View professionals with verificationStatus = 'pending'
   ├── Review uploaded certificates
   ├── Approve → verificationStatus = 'verified'
   └── Reject → verificationStatus = 'rejected' (with note)
```

---

## 📊 Booking Lifecycle

```
                    ┌─────────┐
                    │ PENDING │  ← Customer creates
                    └────┬────┘
           ┌─────────────┼──────────────┐
           ▼             ▼              ▼
      ┌──────────┐  ┌──────────┐  ┌───────────┐
      │ ACCEPTED │  │ REJECTED │  │ CANCELLED │ ← By Customer
      └────┬─────┘  └──────────┘  └───────────┘
           ├─────────────────────────────────────┐
           ▼                                     ▼
     ┌──────────┐                         ┌───────────┐
     │ ON THE   │                         │ CANCELLED │ ← Customer/Pro
     │   WAY    │                         └───────────┘
     └────┬─────┘
          ▼
     ┌──────────┐
     │ ARRIVED  │
     └────┬─────┘
          ▼
     ┌────────────┐
     │ IN PROGRESS│
     └─────┬──────┘
           ▼
     ┌───────────┐    ┌─────────────────────────────────┐
     │ COMPLETED │───►│ Customer Review (atomic batch)   │
     └───────────┘    │  → /reviews + /bookings + /stats │
                      └─────────────────────────────────┘
```

---

## 📦 Packages & Dependencies

### Core
| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.5 | State management (ChangeNotifier pattern) |
| `go_router` | ^18.0.2 | Declarative URL routing with guards |

### Firebase
| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | ^4.15.0 | Firebase SDK init |
| `firebase_auth` | ^6.7.0 | User authentication |
| `cloud_firestore` | ^6.10.0 | NoSQL real-time database |
| `firebase_storage` | ^13.6.0 | File and image storage |
| `google_sign_in` | ^6.2.1 | Google OAuth |

### AI & Network
| Package | Version | Purpose |
|---------|---------|---------|
| `http` | ^1.6.0 | REST calls to Gemini AI |

### Location
| Package | Version | Purpose |
|---------|---------|---------|
| `geolocator` | ^14.1.1 | GPS position |
| `geocoding` | ^5.0.0 | Address ↔ coordinates |

### Media
| Package | Version | Purpose |
|---------|---------|---------|
| `image_picker` | ^1.2.3 | Camera / gallery |
| `flutter_image_compress` | ^2.5.1 | Image compression |
| `speech_to_text` | ^7.5.0 | Voice-to-text |

### UI & Utilities
| Package | Version | Purpose |
|---------|---------|---------|
| `shimmer` | ^4.0.0 | Loading skeleton animations |
| `cached_network_image` | ^4.0.3 | Image caching |
| `flutter_lucide` | ^1.49.0 | Lucide icon set |
| `intl` | ^0.20.2 | Date/time formatting |
| `uuid` | ^4.6.0 | UUID v4 for document IDs |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

### Dev
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | ^6.0.0 | Code quality linting |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |
| `flutter_native_splash` | ^2.4.8 | Native splash screen |

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK `>=3.12.2`
- Android Studio / VS Code with Flutter extension
- A Firebase project (Firestore, Auth, Storage enabled)
- Google Gemini API key

### Steps

**1. Clone and install dependencies**
```bash
git clone <repository-url>
cd skill_connect
flutter pub get
```

**2. Configure Firebase**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (select your project)
flutterfire configure
```
Enable in Firebase Console: Authentication (Email + Google), Cloud Firestore, Firebase Storage.

**3. Set environment variables**
```bash
cp env.example.json env.json
```
Edit `env.json`:
```json
{
  "GEMINI_API_KEY": "your-gemini-api-key-here"
}
```

**4. Deploy Firestore rules and indexes**
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

**5. Run the app**
```bash
flutter run
```

---

## 🔐 Environment Configuration

| File | Purpose | Committed to Git? |
|------|---------|-------------------|
| `env.json` | Runtime API keys | ❌ No (gitignored) |
| `env.example.json` | Template | ✅ Yes |
| `lib/firebase_options.dart` | Firebase SDK config | ✅ Yes (auto-generated) |
| `.firebaserc` | Firebase project alias | ✅ Yes |
| `firebase.json` | Firebase hosting/rules config | ✅ Yes |

---

## 🔧 Service Categories & Skills

The app supports **7 service categories** with a predefined skill catalog:

| Category | Available Skills |
|----------|-----------------|
| **AC Repair** | AC repair, gas refilling, compressor repair, PCB repair, deep cleaning |
| **Plumbing** | Pipe repair, leak fixing, water heater, faucet installation, drain cleaning |
| **Electrical** | Wiring, fan installation, switch repair, inverter setup, MCB replacement |
| **Carpentry** | Furniture repair, door installation, lock repair, wood polishing |
| **Appliance Repair** | Washing machine, refrigerator, microwave, TV repair, water purifier |
| **Cleaning** | Deep cleaning, sofa cleaning, bathroom cleaning, pest control |
| **Painting** | Wall painting, waterproofing, texture painting |

---

## 📐 Matching Score Weights

| Factor | Weight |
|--------|--------|
| Skill Match | 35% |
| Trust Score | 20% |
| Similar Jobs Experience | 20% |
| Success Rate | 10% |
| Availability | 5% |
| Location Proximity | 5% |
| Review Recency | 5% |

**Trust Score Sub-weights:**

| Factor | Weight |
|--------|--------|
| Verified Status | 20% |
| Successful Jobs | 20% |
| Similar Job Types | 20% |
| Average Rating | 15% |
| Complaints (inverse) | 10% |
| Cancellation Rate (inverse) | 5% |
| Activity Recency | 5% |
| Certifications | 5% |

---

*Built with Flutter & Firebase — Powered by Google Gemini AI*

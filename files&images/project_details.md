# MH StayHub Documentation Manager & Technical Knowledge System

*This document is the ultimate source of truth for MH StayHub. It is maintained strictly according to the Documentation Update Rule.*

---

# 1. Product Documentation

## Vision
To become the ultimate student accommodation and community platform in India, creating a transparent, secure, and thriving ecosystem for students.

## Mission
To help students discover, compare, and book verified hostels near their colleges with a simple, trustworthy experience, while providing them with exclusive community and career benefits.

## Problem Statement
Students moving to new cities face massive information asymmetry, fake photos, hidden brokerages, and unsafe environments. They also lack a unified platform to connect with seniors, find roommates, and buy/sell essential items locally.

## Target Users
- **Primary:** College students (18-24 years old) looking for hostels, PGs, or coliving spaces.
- **Secondary:** Hostel/PG Owners looking for verified student leads.
- **Tertiary:** College seniors and alumni offering guidance.

## User Personas
1. **The Fresher (Rahul):** Moving to Greater Noida. Needs a verified, safe hostel near his college. Parents are anxious about security and food.
2. **The Senior (Priya):** Wants to move out of the college hostel into a flat. Needs a roommate with matching vibes (budget, sleep schedule).
3. **The Owner (Sharma Ji):** Owns a 50-bed PG. Struggles to find tenants outside of the peak admission month. Hates paying massive broker commissions.

## Competitive Advantage
- **Zero Brokerage:** Direct connection between students and owners.
- **Verified Inventory:** Premium "Verified Student" badges and strictly audited properties.
- **Ecosystem Approach:** Not just a real estate app—it's a student hub with Marketplace, Roommates, and Career opportunities.
- **Tech Superiority:** A seamless Mobile App for daily use + an SEO-optimized Web platform for discovery.

## Roadmap
- **V1 (Current):** Core accommodation discovery, Lead generation, Student Verification, Command Center, Hub (Coupons, Events, Roommates, Marketplace, Seniors).
- **V2:** In-app rent payments, digital lease agreements, owner dashboard app.
- **V3:** Expansion to multiple cities, AI-driven roommate matching, integrated student loans.

## Business Model
- Lead Generation Marketplace.
- Free for students to browse and connect.

---

# 2. Business Documentation

## Revenue Model
- **Priority Hold Fees:** Students pay a fully refundable token amount (e.g., ₹500) to reserve a bed. MH StayHub takes a convenience fee or platform cut.
- **Verified Owner Subscriptions:** Owners pay a monthly/yearly SaaS fee to be listed as "Premium Verified" and rank higher in search results.
- **Lead Generation Fees:** Owners pay per verified student lead (e.g., per WhatsApp click or scheduled visit).
- **Partner Commissions:** Affiliate revenue from student discounts, loan providers, and local businesses (e.g., gym memberships, laptops).

## Unit Economics
- **LTV (Lifetime Value):** High, because a student stays in a hostel for 1-4 years. If we capture rent payments later, LTV skyrockets.
- **Take Rate:** Currently focused on lead volume over high take rates to build liquidity.

## Lead Generation Strategy
- **SEO (Web):** Target long-tail keywords like "Best boys hostel near Galgotias University".
- **Campus Ambassadors:** Recruit college students to onboard their peers onto the Student Hub.
- **Viral Loop:** "Share this hostel with your parents/roommate" built into the core UI.

## Hostel Acquisition Strategy
- **Direct Sales:** Ground team visiting hostels in Greater Noida to onboard the initial 50-100 high-quality properties.
- **Freemium:** List them for free initially to show them lead volume, then upsell Premium Verification.

## Growth Strategy
- Build liquidity in one micro-market (e.g., Knowledge Park, Greater Noida) before expanding to the next city.
- Use the "Student Advantage" coupons to drive app downloads even if the student already has a hostel.

---

# 3. Founder Dashboard

*Metrics to track daily/weekly to measure startup health:*

- **Total Properties:** Total active listings on the platform.
- **Verified Properties:** Percentage of inventory that is physically verified.
- **Active Leads:** Number of "Schedule Visit", "WhatsApp", and "Call" clicks per week.
- **Conversion Rate:** Percentage of app visitors who trigger a lead action.
- **CAC (Customer Acquisition Cost):** Marketing spend / New verified students.
- **Revenue:** Total priority hold fees + Owner subscriptions.
- **DAU/MAU:** Daily/Monthly Active Users (driven primarily by the Student Hub features).

---

# 4. System Architecture

## High Level Architecture
- **Client Tier:** Next.js (Web) + Flutter (Mobile).
- **API Tier:** Node.js + Express.js REST APIs.
- **Database Tier:** MongoDB Atlas (NoSQL Document Store).
- **Storage Tier:** Cloudinary (Images/Media).
- **Services Tier:** Firebase (Auth, Analytics, Push), Razorpay (Payments).

## Data Flow
1. Client requests data via HTTPS REST.
2. Express Router hits Auth Middleware (JWT validation).
3. Controller parses request and calls Service layer.
4. Service performs business logic and queries Mongoose Models.
5. Response is formatted and returned to client.

## Request Lifecycle
- Standard CRUD lifecycle. Geospatial queries utilize MongoDB `$near` and `2dsphere` indexes to sort by distance to colleges.

## Deployment Architecture
- **Frontend (Web):** Vercel (Edge network, optimized Next.js caching).
- **Backend:** Render/Railway (Node.js container).
- **Database:** MongoDB Atlas (Cloud-hosted replica set).

---

# 5. Website Documentation

## Pages
- `/` (Home): SEO landing page.
- `/accommodations`: Search and filter catalog.
- `/accommodations/[slug]`: Property details.
- `/colleges`: SEO hubs for specific universities.
- `/student-command-center`: Dashboard for logged-in students.
- `/verification`: Document upload flow.
- `/admin/verifications`: Admin dashboard for approving students.

## Routing
- Next.js App Router (`src/app/`).

## SEO & Metadata
- Dynamic OpenGraph tags generated per property `[slug]`.
- Canonical URLs and structured JSON-LD data for real estate listings.

---

# 6. Mobile App Documentation

## Screens
- **Auth:** Splash, Onboarding, Login, OTP.
- **Discovery:** Home, Search, College List.
- **Details:** Accommodation Details, Image Gallery.
- **Student Hub:** Command Center, Advantage, Career, Marketplace, Roommates, Seniors.
- **Profile:** Saved Hostels, Settings.

## Navigation
- `GoRouter` for declarative routing and deep linking support.

## State Management
- `Riverpod` (`FutureProvider` for API calls, `NotifierProvider` for complex state).

## API Integration
- `Dio` with custom interceptors for attaching JWTs and centralized error handling (`ApiErrorHandler`).

---

# 7. Design System Documentation

## Color Palette
- **Brand Primary:** `#6C3CE1` (Deep Purple) - Represents trust and youth.
- **Brand Secondary:** `#14B8A6` (Teal) - Represents growth and safety.
- **Surface:** `#FFFFFF` (Light), `#131825` (Dark).
- **Background:** `#F8FAFC` (Light), `#0B0F19` (Dark).

## Typography
- **Font Family:** `Inter` (Sans-serif, highly legible).

## Design Tokens & Components
- **Radius:** `radius-md` (8px), `radius-lg` (12px), `radius-xl` (16px).
- **Cards:** Glassmorphism headers, soft drop shadows (`shadow-lg`).
- **Dark Mode:** Fully semantic variables (`var(--surface)`, `AppTheme.surfaceDark`) across both Web and Mobile.

## Critical Design Rule
*Website and Mobile App must share the exact same design language. Any UI change implemented on one must be replicated on the other to maintain brand consistency.*

---

# 8. Backend Documentation

## Folder Structure
Follows a modular feature-based pattern: `src/modules/[featureName]/[routes, controller, model, service].js`

## Modules
- `auth`: JWT generation, OTP handling.
- `accommodations`: Core property logic, geospatial queries.
- `colleges`: University data.
- `leads`: Visit requests, priority holds.
- `studentAdvantage`: Coupons, Events, Roommates, Marketplace, Seniors.
- `notifications`: In-app notification feeds.

## Middleware
- `auth.middleware.js`: Verifies JWT from headers.
- `admin.middleware.js`: Ensures `role === 'admin'`.
- `error.middleware.js`: Global try/catch handler.

---

# 9. Database Documentation

## Collections
1. **Users:** Students, Admins, Owners. (Used for auth, profiles).
2. **Accommodations:** Hostels, PGs. (Core inventory).
3. **Colleges:** Universities. (Used as geographical anchors for search).
4. **Verifications:** Student ID uploads. (Used for trust and gating features).
5. **Coupons:** Student Advantage local deals.
6. **Events:** Career Hub webinars and internships.
7. **Roommates:** Student roommate profiles.
8. **MarketplaceItems:** Used books, electronics for sale.
9. **SeniorPosts:** Q&A threads in Senior Connect.
10. **Notifications:** User activity alerts.

## Indexes
- `Accommodations.location`: `2dsphere` index for geospatial queries.

---

# 10. API Documentation

*Refer to the Postman collection or Swagger UI for full schemas. Key endpoints:*
- `GET /api/v1/accommodations`: Fetches properties. Supports `?lat=&lng=&radius=`.
- `POST /api/v1/auth/verify-otp`: Returns JWT.
- `GET /api/v1/student-advantage/*`: Hub endpoints (coupons, events, etc.).
- `POST /api/v1/verifications`: Uploads Student ID.

---

# 11. Security Documentation

- **JWT:** Short-lived access tokens, stored securely in `FlutterSecureStorage` (Mobile) and HTTP-only cookies/local storage (Web).
- **OTP:** Mitigates password brute-forcing and ensures phone number validity.
- **Environment Variables:** Secrets (DB URIs, Razorpay keys) kept strictly in `.env`.

---

# 12. Third Party Integrations

- **MongoDB Atlas:** Managed database. Failure scenario: Connection timeout (handled by global error middleware).
- **Cloudinary:** Image hosting. Scales infinitely. Cost: Free tier is generous, pay per bandwidth later.
- **Firebase:** Push notifications and analytics.
- **Razorpay:** Priority hold payments. Webhook integration required for status updates.

---

# 13. Analytics & Monitoring Documentation

## Tracked Events
- `user_signup`: Funnel start.
- `property_viewed`: Measures inventory interest.
- `call_owner` / `whatsapp_owner`: Core lead metrics (Business Value: HIGH).
- `token_booking`: Revenue metric.

## Monitoring
- **Mobile:** Firebase Crashlytics for unhandled Dart exceptions.
- **Backend:** Morgan for HTTP logging. Sentry (planned) for error tracking.

---

# 14. Feature Inventory

| Feature | Status | Owner | Priority | Dependencies | Release Version |
|---|---|---|---|---|---|
| OTP Auth | Completed | Dev | High | MSG91 (Bypassed) | V1.0 |
| Geospatial Search | Completed | Dev | High | MongoDB | V1.0 |
| Student Command Center | Completed | Dev | High | Auth | V1.1 |
| Admin Verifications | Completed | Dev | Medium | Command Center | V1.1 |
| Student Hub (Marketplace etc)| Completed | Dev | Medium | Auth | V1.1 |
| Razorpay Payments | Planned | Dev | High | Razorpay API | V1.2 |

---

# 15. Founder Knowledge Base (Mandatory)

## Feature: Student Verification System
- **What it does:** Allows students to upload their College ID or use a `.edu` email to get a "Verified Student" badge.
- **Why it exists:** To build trust on the platform. Owners want verified students, and students want to know they are talking to real peers in the community hub.
- **User problem solved:** Removes creepy/fake profiles from the roommate finder and marketplace.
- **Frontend flow:** Command Center -> Upload ID Form -> Pending State -> Verified Badge appears platform-wide.
- **Backend flow:** Form submits to `/api/v1/verifications`. Admin reviews via `/admin/verifications` and changes status to `approved`.
- **Database impact:** Updates `verificationStatus` on the `User` document.
- **Interview explanation:** "We built a zero-trust verification engine. Before interacting in our marketplace, students must prove their identity via college credentials, ensuring a 100% safe micro-network."
- **60-second founder summary:** It's the blue-tick of our platform. Students upload their ID, we verify it, and they unlock exclusive discounts and community access.

## Feature: Student Hub (Advantage, Career, Marketplace, Roommates, Seniors)
- **What it does:** A suite of 5 tools inside the app connecting students to discounts, jobs, second-hand goods, roommates, and alumni advice.
- **Why it exists:** A student only looks for a hostel once a year. We need them opening the app every week. The Hub provides daily utility.
- **User problem solved:** Students waste money buying new books, struggle to find good roommates, and miss out on local cafe discounts.
- **Business impact:** Massively increases DAU/MAU (Daily/Monthly Active Users) and retention. This is how we lower CAC (Customer Acquisition Cost) through viral word-of-mouth.
- **Interview explanation:** "MH StayHub isn't just real estate. It's a student super-app. We solved the retention problem inherent in real estate by building a highly engaging community ecosystem around the core booking engine."
- **60-second founder summary:** Hostels get them in the door, the community keeps them here. It's an internal marketplace for everything a college student needs, driving our daily active usage through the roof.

---

# 16. Technical Decision Records (TDR)

## Why Flutter?
- **Context:** We need iOS and Android apps fast.
- **Decision:** Use Flutter.
- **Reason:** Single codebase, beautiful UI rendering engine, massive developer velocity compared to building native Swift + Kotlin.

## Why Next.js?
- **Context:** We need a website to capture Google searches.
- **Decision:** Next.js App Router.
- **Reason:** Server-Side Rendering (SSR) is mandatory for real estate SEO. React SPAs fail at SEO.

## Why Node.js + Express?
- **Decision:** Node.js.
- **Reason:** JavaScript everywhere. The frontend web team and backend team can read the same language. Massive ecosystem.

## Why MongoDB?
- **Decision:** MongoDB Atlas.
- **Reason:** Real estate attributes change constantly (new amenities, different room structures). NoSQL handles flexible schemas better than strict SQL tables. Plus, it has built-in `2dsphere` geospatial indexing which is perfect for "Hostels near me" queries.

## Why Riverpod?
- **Decision:** Riverpod for Flutter state management.
- **Reason:** Compile-time safety. It catches dependency errors before the app even runs, unlike Provider or GetX.

## Why OTP Authentication?
- **Decision:** Phone + OTP instead of Email + Password.
- **Reason:** Indian students forget passwords. OTP is frictionless and verifies their phone number immediately, providing higher quality leads to hostel owners.

## Why Accommodation Model?
- **Decision:** Named the collection `Accommodations` instead of `Hostels`.
- **Reason:** Future proofs the database. We can seamlessly add PGs, Coliving, and Flats without migrating the entire database structure.

## Why Mobile + Web Strategy?
- **Decision:** Build both simultaneously.
- **Reason:** Web acquires users for free via Google SEO. Mobile retains them via push notifications and a better daily UX.

## Why Browse Without Login?
- **Decision:** Do not force login on launch.
- **Reason:** Forcing login causes a 30-50% drop-off rate. Let them fall in love with the properties first, then ask for their phone number when they want to contact the owner.

---

# 17. Release Notes

## Version 1.1.0
- **Added:** Student Command Center UI.
- **Added:** Admin Verifications Dashboard.
- **Added:** Backend models and APIs for Coupons, Events, Roommates, Marketplace, and Senior Connect.
- **Updated:** Mobile app theme overhauled to perfectly match Next.js dark mode semantic tokens.
- **Fixed:** Contrast issues in dark mode on web accommodation cards.
- **Deprecated:** Old `project_details.md` moved to Archive.

## Version 1.0.0
- **Added:** Core Auth, Accommodations list, Geospatial Search, Mobile App framework.

---

# 18. Documentation Rule

*After every completed task, the developer MUST automatically generate:*
- Documentation Update Required (Y/N)
- Architecture Impact
- API Impact
- Database Impact
- UI Impact
- Security Impact
- Analytics Impact
- Founder Knowledge Update
- Changelog Entry

---
---

# 19. Archive (Historical Notes & V1 Planning)

# MH StayHub - Technical Documentation (V1)

## chatgpt : https://chatgpt.com/share/6a1acbf4-1de8-83aa-94d5-dd17f0cb76b1

1. Project Overview

### Product Name

MH StayHub

### Mission

Help students discover, compare, and book hostels near their colleges with a simple and trustworthy experience.

### Future Expansion

- PGs
- Coliving Spaces
- Flats
- Student Services
- Roommate Matching
- Student Marketplace

---

# 2. System Architecture

Frontend (Flutter App)

↓

Backend APIs (Node.js + Express.js)

↓

MongoDB Atlas Database

↓

Cloudinary (Images & Videos)

↓

Firebase (Notifications, Analytics, Crash Reporting)

↓

Razorpay (Payments)

↓

Google Maps APIs

---

# 3. Tech Stack

## Mobile App

Framework:

Flutter

Language:

Dart

State Management:

Riverpod

Navigation:

GoRouter

Networking:

Dio

Local Storage:

SharedPreferences

Flutter Secure Storage

Maps:

Google Maps Flutter

Notifications:

Firebase Cloud Messaging

Analytics:

Firebase Analytics

Crash Monitoring:

Firebase Crashlytics

Authentication:

JWT Authentication

Payment Gateway:

Razorpay

---

## Backend

Runtime:

Node.js

Framework:

Express.js

Database:

MongoDB Atlas

ODM:

Mongoose

Authentication:

JWT

Password Security:

bcrypt

File Upload:

Cloudinary

Validation:

Zod

Logging:

Morgan

Environment Variables:

dotenv

---

## Deployment

Backend:

Render

Database:

MongoDB Atlas

Images:

Cloudinary

Domain:

Custom Domain

SSL:

HTTPS

---

# 4. User Flow

Splash Screen

↓

Onboarding

↓

Login / Signup

↓

Choose College

↓

Choose Preferred Area

↓

Home Screen

↓

Search Hostel

↓

Hostel Details

↓

Book Visit OR Book Hostel

↓

Payment

↓

Confirmation

---

# 5. Database Design

Users

- _id
- name
- email
- phone
- password
- college
- savedHostels
- bookings
- role

Role:

- student
- admin

---

Hostels

- _id
- name
- description
- area
- city
- latitude
- longitude
- price
- images
- videos
- amenities
- roomTypes
- ratings
- ownerId

---

Bookings

- _id
- userId
- hostelId
- roomType
- paymentStatus
- bookingStatus
- createdAt

---

Reviews

- _id
- userId
- hostelId
- rating
- comment

---

Owners

- _id
- name
- phone
- email
- hostels

---

# 6. API Structure

Authentication

POST /api/auth/register

POST /api/auth/login

POST /api/auth/logout

GET /api/auth/profile

---

Hostels

GET /api/hostels

GET /api/hostels/:id

POST /api/hostels

PUT /api/hostels/:id

DELETE /api/hostels/:id

---

Reviews

POST /api/reviews

GET /api/reviews/:hostelId

DELETE /api/reviews/:id

---

Bookings

POST /api/bookings

GET /api/bookings

PUT /api/bookings/:id

---

Users

GET /api/users

PUT /api/users/:id

DELETE /api/users/:id

---

# 7. Flutter Folder Structure

lib/

core/

config/

constants/

theme/

network/

utils/

features/

auth/

hostels/

bookings/

reviews/

profile/

widgets/

routes/

main.dart

---

# 8. Screens Required

Authentication

- Splash
- Onboarding
- Login
- Signup
- OTP Verification

Home

- Home Screen
- Search Screen
- Filter Screen

Hostel

- Hostel List
- Hostel Details
- Gallery
- Map View

Booking

- Book Visit
- Book Hostel
- Payment
- Confirmation

Profile

- Profile
- Saved Hostels
- Booking History
- Settings

Admin

- Dashboard
- Hostel Management
- Booking Management
- Analytics

---

# 9. Third Party Services

Firebase

Purpose:

- Push Notifications
- Analytics
- Crashlytics

Cloudinary

Purpose:

- Store Hostel Images
- Store Videos

Google Maps

Purpose:

- Directions
- Nearby Search

Razorpay

Purpose:

- Payments

---

# 10. Security

- JWT Authentication
- Password Hashing (bcrypt)
- HTTPS
- Environment Variables
- Rate Limiting
- Input Validation
- MongoDB Injection Protection

---

# 11. Performance

- Lazy Loading
- Pagination
- Image Compression
- Caching
- Skeleton Loaders

---

# 12. Play Store Requirements

Required Before Launch

- Privacy Policy
- Terms and Conditions
- Support Email
- App Icon
- Screenshots
- Feature Graphic
- App Bundle (.aab)
- Firebase Setup
- Google Play Console Account

---

# 13. V1 Features (Launch Fast)

1. Authentication
2. Hostel Listing
3. Search
4. Filters
5. Wishlist
6. Hostel Details
7. Call Owner
8. Book Visit
9. Maps
10. Reviews

Launch immediately after these features are stable.

---

# 14. V2 Features

1. PG Listings
2. Roommate Finder
3. Student Community
4. Safety Score
5. Expense Calculator
6. AI Recommendations
7. Referral System
8. Student Discounts

---

# 15. Development Roadmap

Phase 1

- UI Design
- Backend Setup
- Database Design

Phase 2

- Authentication
- Hostel APIs

Phase 3

- Flutter Integration

Phase 4

- Payments

Phase 5

- Testing

Phase 6

- Play Store Release

Phase 7

- User Feedback

Phase 8

- PG Expansion

---

# 16. Founder Notes (Mayank)

As the technical founder, you must understand:

- Flutter Architecture
- State Management (Riverpod)
- API Integration (Dio)
- JWT Authentication
- MongoDB Schema Design
- Node.js & Express APIs
- Firebase
- Cloudinary
- Razorpay
- Play Store Deployment
- CI/CD Basics
- Git & GitHub Workflow

You do NOT need to become a Flutter expert before building.

Focus on:

Backend → API Design → Business Logic → Flutter Integration

Because the backend architecture is the foundation of MH StayHub.

As a technical founder, you should know **why** each change was made, not just what changed.

# 1. Hostel → Accommodation

### Before

```
Hostels Collection
```

### Now

```
Accommodations Collection
```

### Why?

Initially you're serving hostels.

Future:

- Hostel
- PG
- Coliving
- Flats

If you kept "Hostels", migration becomes painful.

### Startup Lesson

Design for the next 2-3 years, not 20 years.

---

# 2. Mobile Only → Mobile + Website

### Before

```
Flutter App
```

### Now

```
Flutter App
+
Next.js Website
```

### Why?

Students search:

- Hostel near GL Bajaj
- PG near Galgotias

on Google.

Nobody opens Play Store first.

### Technical Impact

Same Backend

```
Node.js

     ↓

Web (Next.js)
App (Flutter)
```

One API serves both.

---

# 3. Forced Login → Browse First

### Before

```
Open App
↓
Login
↓
Browse
```

### Now

```
Open App
↓
Browse
↓
Login only when needed
```

### Why?

Reduces user drop-off.

This is a UX optimization.

---

# 4. Community Removed

### Before

```
Community
Roommate Finder
Q&A
```

### Why Removed?

A community with 0 users looks dead.

### Startup Principle

Solve one problem first.

Problem:

```
Find Hostel
```

Not

```
Make Friends
```

---

# 5. Owner Panel Delayed

### Before

Build owner app.

### Now

Admin manually adds hostels.

Owner gets:

```
WhatsApp
Phone Call
Lead Notification
```

### Why?

Saves 2-3 weeks development.

Faster launch.

---

# 6. Email Login → OTP Login

### Before

```
Email
Password
```

### Now

```
Phone
OTP
```

### Why?

Indian students prefer phone login.

Faster.

Better conversion.

---

# 7. Added Colleges Collection

### Before

No college relation.

### Now

```jsx
College

GL Bajaj
Galgotias
Bennett
Sharda
```

### Why?

Students search by college.

Not by coordinates.

They think:

```
Hostel near GL Bajaj
```

not

```
Hostel at latitude x
```

---

# 8. Added Geospatial Search

### Before

Normal search.

### Now

MongoDB

```jsx
2dsphere Index
```

### Why?

Supports:

```
Nearby Hostels
Within 2 km
Within 5 km
```

Professionally.

---

# 9. Added Verification System

### Before

Any hostel.

### Now

```
Unverified
Verified
Premium Verified
```

### Why?

Marketplace = Trust.

Trust = Conversions.

---

# 10. Added Sharing System

### Before

No viral loop.

### Now

```
WhatsApp Share
Copy Link
Native Share
```

### Why?

Free growth.

Student shares hostel with:

- Parents
- Friends
- Roommates

---

# 11. Added Analytics

### Before

No data.

### Now

Track:

```
view_property
share_property
save_property
call_owner
book_visit
payment_success
```

### Why?

Data drives decisions.

Example:

```
1000 views
50 calls
5 bookings
```

Now you know where users drop.

---

# 12. Added SEO

### Before

Play Store only.

### Now

```
Next.js
SEO Pages
```

### Why?

Google traffic is free.

Search:

```
Hostel near GL Bajaj
```

↓

Website

↓

App Download

↓

Lead

---

# 13. Added Lead Tracking

### Before

Booking only.

### Now

```
Visit Request
Call
WhatsApp
Token Booking
```

### Why?

Your real business is leads.

Not listings.

---

# 14. Production Readiness

Added:

```
Sentry
Crashlytics
Backups
Rate Limiting
Environment Variables
```

### Why?

Startup code and production code are different.

These prevent disasters.

---

# 15. Focus on First 50 Hostels

This is the biggest improvement.

### Before

Build app.

### Now

```
Get 50 Hostels
Then Build
```

### Why?

Marketplace Rule:

No inventory = No users.

No users = Startup dead.

---

# Biggest Technical Lessons You Learned

### Flutter

Frontend

### Node + Express

Backend APIs

### MongoDB

Database

### 2dsphere Index

Location Search

### Riverpod

State Management

### GoRouter

Navigation + Deep Links

### JWT

Authentication

### Firebase

Analytics + Crash Reports

### Razorpay

Payments

### Next.js

SEO + Google Traffic

---

### The biggest mindset shift

Initially the plan was:

```
Let's build a hostel app.
```

Now the plan is:

```
Let's build a student accommodation marketplace.
```

That's the difference between a college project and a scalable startup. 🚀

# MH StayHub: Final Execution Architecture & Plan

This document serves as the final technical blueprint before code generation begins. It covers the architecture review, folder structures, database schemas, API contracts, and the Week 1 Execution Plan as requested.

## User Review Required

> [!IMPORTANT]
Please review the architectural mitigations and the exact folder structures below. If approved, I will immediately begin executing Phase 1 (Week 1) by initializing the monorepo and writing the backend code in your workspace.
> 

---

## 1. Architecture Review & Final Improvements

### Identified Risks & Mitigations

1. **Risk:** Maintaining separate Web (Next.js) and Mobile (Flutter) codebases can slow down MVP velocity.
    - **Mitigation:** We will use a **Monorepo Structure** in your root directory. The Next.js web app will be kept extremely lean—focusing solely on SEO and driving app downloads. Complex user flows (saved properties, profile management) will be prioritized on Mobile first.
2. **Risk:** Taking Razorpay token bookings without live inventory tracking could result in students paying for unavailable rooms.
    - **Mitigation:** In the UI and Terms, "Token Booking" must be explicitly labeled as a "Priority Hold Request". The ₹500 is fully refundable if the owner rejects the hold. The booking status will be `pending_owner_approval`.
3. **Risk:** MSG91 OTP delivery requires DLT Registration in India (which takes 3-7 days).
    - **Mitigation:** For Week 1 & 2 development, we will build the MSG91 service but allow a "bypass" in the `.env` (e.g., if phone is `9999999999`, accept OTP `123456`) to ensure frontend development isn't blocked by DLT registration.

---

## 2. Complete Folder Structures (Monorepo)

The project will reside in `MH StayHub/` with three distinct directories.

### 2.1 Backend (Node.js + Express)

Follows a modular, feature-based architecture for scalability.

```
backend/
├── src/
│   ├── config/              # DB, Environment, Logger configs
│   ├── middleware/          # Auth, Error handlers, Rate limiters
│   ├── modules/             # Feature modules
│   │   ├── auth/            # routes.js, controller.js, service.js
│   │   ├── users/
│   │   ├── colleges/
│   │   ├── accommodations/
│   │   └── leads/
│   ├── shared/              # Utils, Custom Errors
│   └── server.js            # Express App entry point
├── .env.example
├── package.json
└── README.md
```

### 2.2 Website (Next.js 15 App Router)

```
web/
├── src/
│   ├── app/                 # Next.js App Router (Pages & Layouts)
│   │   ├── (marketing)/     # Landing page
│   │   ├── colleges/        # /colleges/:id
│   │   └── accommodations/  # /accommodations/:id
│   ├── components/          # Reusable UI (Tailwind)
│   ├── lib/                 # API clients (Axios/Fetch), Utils
│   └── styles/              # Global CSS
├── tailwind.config.js
└── package.json
```

### 2.3 Mobile App (Flutter)

```
mobile/
├── lib/
│   ├── core/                # Core configurations
│   │   ├── api/             # Dio interceptors
│   │   ├── constants/       # Colors, Typography
│   │   ├── routing/         # GoRouter
│   │   └── theme/           # Material 3 Themes
│   ├── features/            # Riverpod Feature Modules
│   │   ├── auth/
│   │   ├── discovery/       # Home, Search, College lists
│   │   ├── accommodation/   # Details, Amenities
│   │   └── profile/
│   ├── shared/              # Generic widgets
│   └── main.dart
├── pubspec.yaml
└── android/ & ios/
```

---

## 3. MongoDB Schema Design (Mongoose)

```jsx
// Colleges
{
  name: { type: String, required: true },
  city: { type: String, required: true },
  state: { type: String, required: true },
  location: {
    type: { type: String, default: 'Point' },
    coordinates: { type: [Number], required: true } // [lng, lat]
  },
  logo: { type: String },
  isActive: { type: Boolean, default: true }
}

// Accommodations
{
  name: { type: String, required: true },
  type: { type: String, enum: ['hostel', 'pg', 'coliving', 'flat'] },
  gender: { type: String, enum: ['boys', 'girls', 'coed'] },
  location: {
    type: { type: String, default: 'Point' },
    coordinates: { type: [Number], required: true }
  },
  address: { type: String, required: true },
  nearbyColleges: [{
    collegeId: { type: ObjectId, ref: 'College' },
    distanceMeters: { type: Number }
  }],
  verification: {
    status: { type: String, enum: ['unverified', 'verified', 'premium_verified'], default: 'unverified' },
    verifiedAt: { type: Date }
  },
  images: [{ type: String }],
  amenities: [{ type: String }],
  pricing: {
    startingPrice: { type: Number, required: true },
    deposit: { type: Number }
  },
  ownerId: { type: ObjectId, ref: 'User' },
  status: { type: String, enum: ['active', 'hidden'], default: 'active' }
}

// Leads & Bookings
{
  studentId: { type: ObjectId, ref: 'User' },
  accommodationId: { type: ObjectId, ref: 'Accommodation' },
  type: { type: String, enum: ['visit', 'token_booking'] },
  status: { type: String, enum: ['pending', 'visited', 'converted', 'cancelled'] },
  payment: {
    amount: { type: Number },
    transactionId: { type: String },
    status: { type: String, enum: ['pending', 'success', 'failed'] }
  }
}
```

---

## 4. API Contract Documentation

- **Auth Module**
    - `POST /api/v1/auth/send-otp` -> Body: `{ phone: "+91..." }`
    - `POST /api/v1/auth/verify-otp` -> Body: `{ phone: "+91...", otp: "1234" }` -> Returns: `{ token, user }`
- **Colleges Module**
    - `GET /api/v1/colleges` -> Returns: `[{ id, name, city, location }]`
    - `GET /api/v1/colleges/:id/accommodations` -> Returns Accommodations sorted by distance.
- **Accommodations Module**
    - `GET /api/v1/accommodations` -> Query: `?lat=&lng=&radius=&type=&gender=&maxPrice=`
    - `GET /api/v1/accommodations/:id` -> Returns detailed info.
- **Leads Module (Protected)**
    - `POST /api/v1/leads/visit` -> Body: `{ accommodationId, scheduledDate }`
    - `POST /api/v1/leads/token` -> Body: `{ accommodationId, amount }` -> Returns Razorpay Order ID.

---

## 5. Week 1 Implementation Plan (Phase 1: Backend Setup)

**Goal:** Establish the monorepo and build the core Node.js APIs to ensure the Web and Mobile apps have data to consume.

**Step-by-Step Execution for Week 1:**

1. **Repository Setup:** Create `backend`, `web`, and `mobile` directories.
2. **Backend Initialization:** Setup `npm`, `express`, `mongoose`, `dotenv`, and standard middleware (Helmet, CORS, Morgan logger).
3. **Database:** Define Mongoose schemas for `User`, `College`, and `Accommodation`.
4. **Auth Module:** Implement JWT generation and MSG91 boilerplate (with dev-bypass).
5. **Core APIs:** Implement `GET /accommodations` (with geospatial `$near` queries) and `GET /colleges`.
6. **Seeding:** Create a seed script to inject 5 dummy colleges and 10 dummy accommodations to facilitate UI testing.

> [!TIP]
If you approve of this final architectural breakdown and the Week 1 plan, reply "Approved". I will immediately initialize the backend Node.js project and begin coding Phase 1!
> 
> 
> ## As Founder, What Have You Actually Built?
> 
> ```
> Student
> ↓
> Website / App
> ↓
> Search Accommodation
> ↓
> Visit Request
> ↓
> Priority Hold
> ↓
> Lead
> ↓
> Hostel Owner
> ```
> 
> That is a **student accommodation lead-generation marketplace**.
> 
> Not just a hostel app.
> 
> ---
> 
> ## What I Would Do Next
> 
> ### Week 1
> 
> ```
> Deployment
> ```
> 
> ### Week 2
> 
> ```
> Get 20 hostel owners
> ```
> 
> ### Week 3
> 
> ```
> Launch near GL Bajaj
> ```
> 
> ### Week 4
> 
> ```
> Get first 100 students
> ```
> 
> ### Week 5
> 
> ```
> Improve based on feedback
> ```
> 
> At this stage, stop adding features. Focus on **real users and real hostel owners**. That's
>
# Product Explorer (trainee_assignment)

A Flutter mobile and web application for browsing, searching, and managing products. Built with Flutter, BLoC/Cubit state management, and integrated with a RESTful MockAPI backend.

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12.0 or later)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / Xcode / Chrome (for emulators or web testing)
- An active internet connection (for API communication)

---

### Setup & Installation

1. **Navigate to the project folder:**
   ```bash
   cd t_assignment
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup (optional):**
   ```bash
   flutter doctor
   ```

---

### Running the App

- **Run on default connected device / emulator:**
  ```bash
  flutter run
  ```

- **Run on Chrome (Web):**
  ```bash
  flutter run -d chrome
  ```

- **List available devices:**
  ```bash
  flutter devices
  ```

---

## 📱 Features

- **Product Listing:** View products with titles, prices, ratings, and categories.
- **Pull-to-Refresh:** Pull down to refresh the product catalogue.
- **Search & Filter:** Real-time search across product names and categories.
- **Product Details:** Detailed view displaying high-resolution images, descriptions, and ratings.
- **Add Product:** Form with validation to submit new products to the remote database.
- **Database Operations:** Dedicated tab to seed initial sample data or wipe existing data.

---

## 📌 Important Notes

1. **Initial Data Seeding:**
   - On the first run, if the catalogue is empty, switch to the **Operation** tab via the bottom navigation bar and tap **"Seed Sample Data"**.
   - This will read the 70 default products from `assets/products.json` and upload them to the remote MockAPI database.

2. **API & Rate Limiting:**
   - The app communicates with a MockAPI endpoint (`https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData`).
   - Seeding and wiping operations are throttled sequentially with retry handling and exponential backoff to avoid HTTP 429 (rate-limiting) responses from the free MockAPI tier.
   - Please wait for the operation snackbar confirmation before triggering another bulk action.

3. **Architecture & State Management:**
   - State management is implemented using **BLoC (`ProductCubit`)**.
   - UI reflects states seamlessly (`ProductInitial`, `ProductLoading`, `ProductLoaded`, `ProductActionSuccess`, and `ProductError`).

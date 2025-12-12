# 🍽️ Food Explorer App - UAS Mobile Programming

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

Aplikasi mobile pemesanan makanan yang modern dan lengkap, dibangun dengan Flutter dan Firebase. Jelajahi hidangan lezat dari seluruh dunia, kelola keranjang belanja Anda, dan nikmati pengalaman pengguna yang mulus dengan autentikasi dan data real-time.

## ✨ Fitur

### 🔐 Sistem Autentikasi
- **Registrasi Pengguna** - Buat akun baru dengan email, password, nama, dan nomor telepon
- **Login Aman** - Autentikasi email dan password melalui Firebase
- **Reset Password** - Fitur lupa password dengan pemulihan via email
- **Manajemen Sesi** - Persistensi status login otomatis
- **Profil Pengguna** - Lihat dan kelola informasi pengguna

### 🏠 Fitur Home
- **Browser Kategori** - Jelajahi makanan berdasarkan kategori (Seafood, Dessert, Chicken, dll.)
- **Fungsi Pencarian** - Cari makanan berdasarkan nama dengan pencarian real-time
- **Penawaran Spesial** - Banner promosi dengan informasi diskon
- **Item Populer** - Tampilan grid makanan yang sedang trending
- **Pull to Refresh** - Perbarui konten dengan gestur swipe-down

### 📖 Katalog & Browse
- **Filter Kategori** - Filter makanan berdasarkan kategori tertentu
- **Mode Tampilan** - Beralih antara "Lihat Semua", "Trending", dan "Hampir Kadaluarsa"
- **Layout Grid** - Tampilan grid 2 kolom yang indah
- **Sistem Favorit** - Tandai makanan sebagai favorit (UI ready)
- **Refresh Manual** - Tombol refresh untuk memperbarui data

### 🛒 Keranjang Belanja
- **Tambah ke Keranjang** - Tambahkan item ke keranjang dengan mudah
- **Kelola Kuantitas** - Tambah atau kurangi jumlah item
- **Hapus Item** - Hapus item individual atau bersihkan seluruh keranjang
- **Kalkulasi Otomatis** - Subtotal, biaya pengiriman, dan total otomatis
- **Checkout** - Proses checkout dengan konfirmasi pesanan

### 📱 Detail Makanan
- **Gambar Hero** - Transisi animasi gambar yang smooth
- **Informasi Lengkap** - Nama, kategori, area, rating, dan ulasan
- **Ingredients List** - Daftar lengkap bahan dengan takaran
- **Instruksi Memasak** - Panduan lengkap cara memasak
- **Rating & Review** - Sistem rating 5 bintang dengan review pengguna
- **Customer Support** - Akses cepat ke dukungan pelanggan (Telepon, Email, Live Chat)
- **Produk Terkait** - Rekomendasi makanan serupa dengan horizontal scroll

### 👤 Profil Pengguna
- **Info Pengguna** - Tampilan nama, email, telepon, dan alamat
- **Menu Navigasi** - Edit Profile, Order History, Favorites, Settings
- **Logout Aman** - Konfirmasi logout dengan dialog

---

## 📸 Screenshot

### Login & Register
```
┌─────────────────────────────────────────────────────────────┐
│                    🔐 Login Page                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Food Explorer                                       │   │
│  │  Welcome Back!                                       │   │
│  │  ┌───────────────────────────────────────┐          │   │
│  │  │  📧 Email                             │          │   │
│  │  └───────────────────────────────────────┘          │   │
│  │  ┌───────────────────────────────────────┐          │   │
│  │  │  🔒 Password                          │          │   │
│  │  └───────────────────────────────────────┘          │   │
│  │  [Login]                                             │   │
│  │  Don't have account? [Register]                     │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Home Page
```
┌─────────────────────────────────────────────────────────────┐
│                    🏠 Home Page                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Welcome, Food Explorer       🔔                     │   │
│  │  ┌───────────────────────────────────────┐          │   │
│  │  │  🔍 Search here...                    │          │   │
│  │  └───────────────────────────────────────┘          │   │
│  │  [All] [Coffee] [Dessert] [Chicken] [Seafood]       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  Special Offers                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  35% Discount                    🍽️                  │   │
│  │  Explore delicious meals                             │   │
│  │  from around the world                               │   │
│  │  [Shop Now]                                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  Popular Items                           [View All >]       │
│  ┌────────────┐  ┌────────────┐                            │
│  │    🍕      │  │    🍔      │                            │
│  │ Pizza      │  │ Burger     │                            │
│  │ Italian  + │  │ American + │                            │
│  └────────────┘  └────────────┘                            │
└─────────────────────────────────────────────────────────────┘
```

### Detail & Cart Page
```
┌─────────────────────────────────────────────────────────────┐
│                 📱 Meal Detail Page                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  [Hero Image - Teriyaki Chicken]                     │   │
│  │  ⭐ 4.8 (135 Reviews)                                │   │
│  │                                                       │   │
│  │  Ingredients:                                         │   │
│  │  • soy sauce — 3/4 cup                               │   │
│  │  • water — 1/2 cup                                   │   │
│  │  • brown sugar — 1/4 cup                             │   │
│  │                                                       │   │
│  │  [Details] [Support] [Ratings]                       │   │
│  │                                                       │   │
│  │  Related Items →                                      │   │
│  │  [Item1] [Item2] [Item3]                            │   │
│  └─────────────────────────────────────────────────────┘   │
│  [Add to Cart]                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🏗️ Arsitektur

Aplikasi ini menggunakan arsitektur **MVC (Model-View-Controller)** dengan pemisahan yang jelas antara logika bisnis dan UI:

```
┌──────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                 │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐    │
│  │   Login    │  │    Home    │  │   Detail   │    │
│  │    Page    │  │    Page    │  │    Page    │    │
│  └────────────┘  └────────────┘  └────────────┘    │
└──────────────────────────────────────────────────────┘
                        ↕
┌──────────────────────────────────────────────────────┐
│                   SERVICE LAYER                       │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐    │
│  │   Auth     │  │    API     │  │    Cart    │    │
│  │  Service   │  │  Service   │  │  Service   │    │
│  └────────────┘  └────────────┘  └────────────┘    │
└──────────────────────────────────────────────────────┘
                        ↕
┌──────────────────────────────────────────────────────┐
│                     DATA LAYER                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐    │
│  │  Firebase  │  │  TheMealDB │  │   Local    │    │
│  │    Auth    │  │     API    │  │   State    │    │
│  └────────────┘  └────────────┘  └────────────┘    │
└──────────────────────────────────────────────────────┘
```

### Design Patterns Yang Digunakan

1. **Singleton Pattern** - `CartService` menggunakan singleton untuk manajemen state global
2. **Observer Pattern** - `ChangeNotifier` untuk reactive state management di cart
3. **Factory Pattern** - Model parsing dengan factory constructors
4. **Repository Pattern** - Service layer sebagai abstraksi data source

---

## 📁 Struktur Project

```
lib/
├── main.dart                      # Entry point aplikasi
├── firebase_options.dart          # Konfigurasi Firebase
│
├── models/
│   └── meal_model.dart           # Model data Meal
│
├── services/
│   ├── auth_service.dart         # Service autentikasi Firebase
│   ├── api_service.dart          # Service API TheMealDB
│   └── cart_service.dart         # Service manajemen keranjang
│
└── navigasi/
    ├── login_page.dart           # Halaman login
    ├── register_page.dart        # Halaman registrasi
    ├── home_page.dart            # Halaman utama
    ├── catalog_page.dart         # Halaman katalog produk
    ├── meal_detail_page.dart     # Halaman detail makanan
    ├── cart_page.dart            # Halaman keranjang belanja
    └── profile_page.dart         # Halaman profil pengguna
```

---

## 📦 Dependensi

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  
  # HTTP & Networking
  http: ^1.1.0
  
  # State Management
  provider: ^6.1.1
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## 🚀 Instalasi

### Prasyarat

- Flutter SDK (3.0.0 atau lebih baru)
- Dart SDK (2.17.0 atau lebih baru)
- Android Studio / VS Code dengan Flutter plugin
- Akun Firebase
- Git

### Langkah-langkah Instalasi

1. **Clone Repository**
```bash
git clone https://github.com/n2nd22uli2/food-explorer-app.git
cd food-explorer-app
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Konfigurasi Firebase** (Lihat bagian [Setup Firebase](#-setup-firebase))

4. **Jalankan Aplikasi**
```bash
# Untuk Android
flutter run

# Untuk iOS
flutter run --release

# Untuk mode debug dengan hot reload
flutter run --debug
```

5. **Build APK (Optional)**
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APK berdasarkan ABI
flutter build apk --split-per-abi
```

---

## 🔥 Setup Firebase

### 1. Buat Project Firebase

1. Kunjungi [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"**
3. Masukkan nama project: `food-explorer-app`
4. Ikuti langkah-langkah setup

### 2. Tambahkan Firebase ke Flutter

#### Untuk Android:

1. Download file `google-services.json` dari Firebase Console
2. Letakkan di: `android/app/google-services.json`
3. Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

4. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

#### Untuk iOS:

1. Download file `GoogleService-Info.plist` dari Firebase Console
2. Letakkan di: `ios/Runner/GoogleService-Info.plist`
3. Buka Xcode dan tambahkan file ke project

### 3. Aktifkan Authentication

1. Di Firebase Console, buka **Authentication**
2. Klik **"Get Started"**
3. Enable **Email/Password** authentication

### 4. Setup Cloud Firestore

1. Di Firebase Console, buka **Firestore Database**
2. Klik **"Create Database"**
3. Pilih mode: **"Start in test mode"** (untuk development)
4. Pilih lokasi server terdekat

### 5. Aturan Firestore (Security Rules)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 6. Generate Firebase Options

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

Ini akan generate file `firebase_options.dart` secara otomatis.

---

## 🌐 Integrasi API

Aplikasi menggunakan **TheMealDB API** untuk data makanan.

### Base URL
```
https://www.themealdb.com/api/json/v1/1/
```

### Endpoints Yang Digunakan

| Endpoint | Method | Deskripsi |
|----------|--------|-----------|
| `/categories.php` | GET | Mendapatkan daftar kategori |
| `/filter.php?c={category}` | GET | Filter makanan berdasarkan kategori |
| `/search.php?s={query}` | GET | Cari makanan berdasarkan nama |
| `/lookup.php?i={id}` | GET | Detail makanan berdasarkan ID |
| `/random.php` | GET | Mendapatkan makanan random |

### Contoh Response

**GET `/lookup.php?i=52772`**
```json
{
  "meals": [
    {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken Casserole",
      "strCategory": "Chicken",
      "strArea": "Japanese",
      "strInstructions": "Preheat oven to 350°...",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
      "strIngredient1": "soy sauce",
      "strMeasure1": "3/4 cup"
    }
  ]
}
```

### Rate Limiting
- API gratis tanpa rate limiting
- Untuk production, pertimbangkan caching data

---

## 📊 Pengolahan Data Dummy & JSON

Aplikasi ini menggunakan kombinasi data dari dua sumber: **Firebase Firestore** untuk data user dan **TheMealDB API** untuk data makanan.

### 🗄️ Struktur Data

#### 1. Data User (Firebase Firestore)

**Collection**: `users`

```json
{
  "uid": "abc123xyz",
  "name": "John Doe",
  "email": "user1@test.com",
  "phone": "081234567890",
  "address": "",
  "photoUrl": "",
  "createdAt": Timestamp(1234567890)
}
```

**Field Details:**

| Field | Type | Required | Deskripsi |
|-------|------|----------|-----------|
| `uid` | String | ✅ | User ID dari Firebase Auth |
| `name` | String | ✅ | Nama lengkap user |
| `email` | String | ✅ | Email user (unique) |
| `phone` | String | ✅ | Nomor telepon |
| `address` | String | ❌ | Alamat pengiriman (optional) |
| `photoUrl` | String | ❌ | URL foto profil |
| `createdAt` | Timestamp | ✅ | Waktu registrasi |

#### 2. Data Meal (TheMealDB API)

**Struktur JSON dari API:**

```json
{
  "idMeal": "52772",
  "strMeal": "Teriyaki Chicken Casserole",
  "strCategory": "Chicken",
  "strArea": "Japanese",
  "strInstructions": "Preheat oven to 350° F...",
  "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
  "strIngredient1": "soy sauce",
  "strMeasure1": "3/4 cup"
}
```

**Model Dart:**

```dart
class Meal {
  final String id;                    // idMeal
  final String name;                  // strMeal
  final String thumbnail;             // strMealThumb
  final String? category;             // strCategory
  final String? area;                 // strArea
  final String? instructions;         // strInstructions
  final Map<String, String>? ingredients; // strIngredient + strMeasure
}
```

### 🔄 Proses Parsing JSON

#### 1. Parsing Data Sederhana (Filter/List)

```dart
// Response dari filter.php?c=Seafood
{
  "meals": [
    {
      "strMeal": "Baked Salmon",
      "strMealThumb": "https://...",
      "idMeal": "52959"
    }
  ]
}

// Parsing dengan factory constructor
factory Meal.fromFilterJson(Map<String, dynamic> json) {
  return Meal(
    id: json['idMeal'] as String,
    name: json['strMeal'] as String,
    thumbnail: json['strMealThumb'] as String,
    category: null,
    area: null,
    instructions: null,
    ingredients: null,
  );
}
```

#### 2. Parsing Data Detail (Lookup)

```dart
factory Meal.fromDetailJson(Map<String, dynamic> json) {
  // Parsing ingredients dinamis (1-20)
  final Map<String, String> ingr = {};
  
  for (int i = 1; i <= 20; i++) {
    final ingKey = 'strIngredient$i';
    final measureKey = 'strMeasure$i';
    
    final ing = (json[ingKey] ?? '').toString().trim();
    final measure = (json[measureKey] ?? '').toString().trim();
    
    if (ing.isNotEmpty) {
      ingr[ing] = measure;
    }
  }

  return Meal(
    id: json['idMeal'] as String,
    name: json['strMeal'] as String,
    thumbnail: json['strMealThumb'] as String,
    category: json['strCategory'] as String?,
    area: json['strArea'] as String?,
    instructions: json['strInstructions'] as String?,
    ingredients: ingr.isNotEmpty ? ingr : null,
  );
}
```

### 🔗 Keterhubungan Data Antar Halaman

#### Flow Data dalam Aplikasi

```
┌─────────────────────────────────────────────────────────┐
│                    1. LOGIN PAGE                         │
│  Input: email, password                                  │
│  ↓ AuthService.login()                                   │
│  ↓ Firebase Auth                                         │
│  Output: User object                                     │
└────────────────────────┬────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                    2. HOME PAGE                          │
│  Input: User uid                                         │
│  ↓ ApiService.getCategories()                           │
│  ↓ ApiService.getRandomMeals()                          │
│  Output: List<String> categories                         │
│          List<Meal> meals (summary)                      │
└────────────────────────┬────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                    3. CATALOG PAGE                       │
│  Input: category (opsional)                              │
│  ↓ ApiService.getMealsByCategory()                      │
│  Output: List<Meal> meals (filtered)                     │
└────────────────────────┬────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                 4. MEAL DETAIL PAGE                      │
│  Input: Meal.id                                          │
│  ↓ ApiService.getMealDetail(id)                         │
│  Output: Meal (full detail dengan ingredients)           │
│  ↓ CartService.addToCart(meal)                          │
└────────────────────────┬────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                    5. CART PAGE                          │
│  Input: CartService.items                                │
│  ↓ Calculate subtotal & total                            │
│  Output: Order confirmation                              │
└────────────────────────┬────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│                   6. PROFILE PAGE                        │
│  Input: User uid                                         │
│  ↓ AuthService.getUserData(uid)                         │
│  Output: Map<String, dynamic> userData                   │
└─────────────────────────────────────────────────────────┘
```

### 📋 Detail Keterhubungan Per Fitur

#### A. Home → Catalog

```dart
// Di HomePage
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => CatalogPage(
      initialCategory: 'Seafood'
    ),
  ),
);
```

#### B. Catalog → Detail

```dart
// Di CatalogPage
GestureDetector(
  onTap: () async {
    final detail = await ApiService.getMealDetail(m.id);
    if (detail != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MealDetailPage(meal: detail),
        ),
      );
    }
  },
  child: MealCard(meal: m),
)
```

#### C. Detail → Cart (State Management)

```dart
// Di MealDetailPage
FloatingActionButton.extended(
  onPressed: () {
    CartService.instance.addToCart(widget.meal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.meal.name} ditambahkan')),
    );
  },
  label: Text('Add to Cart'),
)
```

### 🎯 Best Practices dalam Handling Data

#### 1. Null Safety

```dart
final category = meal.category ?? 'Unknown Category';
final address = userData?['address'] ?? 'No address';

if (meal.ingredients != null && meal.ingredients!.isNotEmpty) {
  displayIngredients(meal.ingredients!);
}
```

#### 2. Error Handling

```dart
FutureBuilder<List<Meal>>(
  future: _mealsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (snapshot.hasError) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64),
            Text('Failed to load data'),
            ElevatedButton(
              onPressed: () => setState(() {
                _mealsFuture = ApiService.getMealsByCategory(category);
              }),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return MealsList(meals: snapshot.data ?? []);
  },
)
```

---

## 🔐 Alur Autentikasi

### Diagram Alur

```
App Start → Check Login Status
    ↓
    ├─ Logged In → Home Page
    │
    └─ Not Logged In → Login Page
           ↓
           ├─ Have Account → Enter Credentials
           │      ↓
           │      ├─ Valid → Home Page
           │      └─ Invalid → Error Message
           │
           └─ No Account → Register Page
                  ↓
                  Fill Form → Create Account
                  ↓
                  Save to Firestore → Home Page
```

### Proses Registrasi

1. User mengisi form registrasi (nama, email, phone, password)
2. Validasi input di client-side
3. `AuthService.register()` dipanggil
4. Firebase Authentication membuat user baru
5. Data tambahan disimpan ke Firestore collection `users`
6. User otomatis login dan diarahkan ke Home

### Proses Login

1. User mengisi email dan password
2. Validasi input
3. `AuthService.login()` dipanggil
4. Firebase Authentication memverifikasi kredensial
5. Jika berhasil, `StreamBuilder` mendeteksi perubahan auth state
6. User diarahkan ke Home Page

### Session Management

```dart
// Di main.dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return RootPage(); // User logged in
    }
    return LoginPage(); // User not logged in
  },
)
```

---

## 📖 Panduan Penggunaan

### 1. Registrasi Akun Baru

1. Buka aplikasi
2. Tap "Register" pada halaman login
3. Isi form registrasi dengan lengkap
4. Tap "Register"
5. Login dengan kredensial yang baru dibuat

### 2. Login

Gunakan demo account atau buat akun baru:
- Email: `user1@test.com`
- Password: `password123`

### 3. Menjelajahi Makanan

1. Browse kategori di Home Page
2. Gunakan search bar untuk mencari makanan
3. Tap "View All" untuk katalog lengkap

### 4. Melihat Detail Makanan

1. Tap pada card makanan
2. Lihat detail lengkap: gambar, rating, ingredients, instruksi
3. Scroll untuk produk terkait

### 5. Menambah ke Keranjang

1. Di detail page, tap "Add to Cart"
2. Notifikasi konfirmasi akan muncul
3. Badge counter di bottom nav terupdate

### 6. Checkout

1. Buka Cart dari bottom navigation
2. Review items dan adjust quantity
3. Cek total harga
4. Tap "Checkout" dan konfirmasi

### 7. Mengelola Profil

1. Tap icon Profile di bottom nav
2. Lihat informasi akun
3. Gunakan menu untuk edit profile, history, settings
4. Tap "Logout" untuk keluar

---

## 💻 Dokumentasi Kode

### Model: Meal

```dart
class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;
  final String? instructions;
  final Map<String, String>? ingredients;

  factory Meal.fromFilterJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }

  factory Meal.fromDetailJson(Map

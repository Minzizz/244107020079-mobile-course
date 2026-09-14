# 📱 Responsive Dashboard - Week 2

## Identitas

| Aspek       | Keterangan |
|-------------|-----------|
| **Nama**    | Amin Aziz Sudjud |
| **NIM**     | 244107020079 |
| **Kelas**   | TI-3D |
| **Minggu**  | Week 2 - Declarative UI & Responsive Design |

---

## Tujuan Pembelajaran

Proyek ini dirancang untuk memahami dan menerapkan konsep-konsep fundamental dalam pengembangan aplikasi mobile dengan Flutter:

- ✅ **Declarative UI** — Memahami paradigma deklaratif Flutter dalam membangun antarmuka pengguna yang reaktif
- ✅ **Responsive Layout** — Menggunakan `LayoutBuilder` dan `GridView` untuk membuat tata letak yang menyesuaikan dengan berbagai ukuran layar
- ✅ **Material vs Cupertino** — Mengintegrasikan komponen Material Design (AppBar, Card) dan Cupertino (CupertinoSwitch) dalam satu aplikasi
- ✅ **Aksesibilitas** — Menerapkan `Semantics` untuk meningkatkan aksesibilitas aplikasi bagi semua pengguna

---

## Refactoring Code

### Ekstraksi Widget Reusable
Kode awalnya memiliki card-card yang sama. Oleh karena itu, saya mengekstrak menjadi widget `InfoCard` yang dapat digunakan kembali:

```dart
class InfoCard extends StatelessWidget {
  const InfoCard({required this.title, required this.value, super.key});
  final String title;
  final String value;
  
  @override
  Widget build(BuildContext context) { ... }
}
```

### Penggunaan `Theme.of(context)` untuk Warna Dinamis
Alih-alih menggunakan warna yang di-hardcode, aplikasi menggunakan `Theme.of(context)` agar warna otomatis menyesuaikan dengan tema terang atau gelap:

```dart
color: Theme.of(context).colorScheme.primaryContainer,
style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
```

### Breakpoint Konstanta
Untuk menghindari hardcoding, saya mendefinisikan breakpoint responsif sebagai konstanta:

```dart
const double kWideBreakpoint = 700;
```

Breakpoint ini digunakan dalam `LayoutBuilder` untuk menentukan jumlah kolom GridView:
- **Layar Sempit** (< 700px): 1 kolom
- **Layar Lebar** (≥ 700px): 2 kolom

### Implementasi Dark Mode
Menggunakan `CupertinoSwitch` dengan widget `Semantics` untuk memberikan label aksesibilitas, memungkinkan pengguna memilih tema gelap atau terang secara dinamis.

---

## Hasil Testing

### Flutter Analyze
✅ Analisis kode telah dijalankan dengan hasil:
- **Status:** 0 issues
- **Keterangan:** Kode memenuhi standar linting Flutter dan tidak ada peringatan atau kesalahan analisis.

### Widget Tests
✅ Semua pengujian widget telah **PASSED**:

| Test | Deskripsi | Status |
|------|-----------|--------|
| **Dashboard satu kolom di layar sempit** | Memastikan layout dengan 1 kolom saat lebar layar < 700px | ✅ PASSED |
| **Dashboard dua kolom di layar lebar** | Memastikan layout dengan 2 kolom saat lebar layar ≥ 700px | ✅ PASSED |

Pengujian dilakukan dengan mensimulasikan berbagai ukuran layar (400px untuk sempit, 1200px untuk lebar).

---

## Screenshots

### Tampilan Layar Sempit (Smartphone)
![Tampilan Layar Sempit](screenshots/sempit.png)

*Layout dengan 1 kolom, optimal untuk perangkat mobile dengan ukuran layar kecil.*

### Tampilan Layar Lebar (Tablet/Desktop)
![Tampilan Layar Lebar](screenshots/lebar.png)

*Layout dengan 2 kolom, memanfaatkan ruang layar yang lebih besar pada perangkat tablet atau desktop.*

---

## Struktur Proyek

```
responsive_dashboard/
├── lib/
│   └── main.dart           # Komponen utama aplikasi
├── test/
│   └── widget_test.dart    # Pengujian widget responsif
├── pubspec.yaml            # Konfigurasi dependensi
└── README.md               # Dokumentasi proyek (file ini)
```

---

## Cara Menjalankan

### 1. Install Dependensi
```bash
flutter pub get
```

### 2. Jalankan Aplikasi
```bash
flutter run
```

### 3. Jalankan Tests
```bash
flutter test
```

### 4. Analisis Kode
```bash
flutter analyze
```

---

## Catatan dan Pembelajaran

- Penggunaan `LayoutBuilder` memungkinkan aplikasi untuk mengetahui constraint ukuran dan menyesuaikan layout secara dinamis.
- `GridView.count` dengan `crossAxisCount` yang dinamis memberikan pengalaman pengguna yang optimal di berbagai perangkat.
- Integrasi Material dan Cupertino widgets menunjukkan fleksibilitas Flutter dalam mengikuti desain platform.
- `Semantics` widget penting untuk aksesibilitas, terutama bagi pengguna yang menggunakan screen reader.

---

## Referensi

- [Flutter Documentation - Declarative UI](https://flutter.dev/docs/development/ui/declarative)
- [Flutter Documentation - LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
- [Flutter Documentation - Responsiveness](https://flutter.dev/docs/development/ui/layout/adaptive-responsive)
- [Material Design 3](https://m3.material.io/)
- [Semantics in Flutter](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)

---

**Terakhir diperbarui:** 2026-09-14
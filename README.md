# Evand Coding Wallet

Evand Coding Wallet adalah aplikasi dompet digital berbasis Flutter yang terintegrasi dengan Evand Coding Store. Aplikasi ini digunakan untuk mengelola saldo pengguna, melakukan top up, melihat riwayat transaksi, dan menjadi sumber dana saat melakukan pembayaran pada aplikasi Coding Store.

## Fitur

* Login menggunakan akun yang sama dengan Coding Store
* Autentikasi menggunakan Firebase Authentication
* Menampilkan informasi saldo secara real-time
* Top Up saldo
* Riwayat transaksi wallet
* Integrasi dengan Cloud Firestore
* Sinkronisasi data wallet dengan Coding Store

## Teknologi

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Provider
* Firebase

## Struktur Project

```text
lib/
│
├── data/
│   └── services/
│       ├── auth_service.dart
│       ├── wallet_service.dart
│       ├── transaction_service.dart
│       ├── email_service.dart
│       └── authenticator_service.dart
│
├── features/
│   ├── auth/
│   │   └── screens/
│   │
│   └── wallet/
│       └── screens/
│
└── widgets/
```

## Firebase Collections

### users

```text
uid
email
name
isVerified
authProvider
createdAt
```

### wallets

```text
userId
email
balance
pin
authSecret
createdAt
```

### wallet_transactions

```text
transactionId
userId
type
amount
description
createdAt
```



### Login

<img width="493" height="570" alt="Screenshot 2026-06-30 035422" src="https://github.com/user-attachments/assets/2d72eeed-bd10-4ce0-81f6-18e87346ac46" />


---

### Home



<img width="487" height="574" alt="Screenshot 2026-06-30 043110" src="https://github.com/user-attachments/assets/21ca0578-597c-4600-ad32-6ee1a88ca3b6" />


---

### Top Up



<img width="480" height="563" alt="Screenshot 2026-06-30 043130" src="https://github.com/user-attachments/assets/b1558664-275b-4ffb-bad0-46b7c9baa524" />


---

### Transaction History


<img width="486" height="489" alt="Screenshot 2026-06-30 043339" src="https://github.com/user-attachments/assets/dec22906-a58e-4682-937b-08d088c7eafe" />


## Instalasi

Clone repository

```bash
git clone <repository-url>
```

Masuk ke folder project

```bash
cd wallet-coding-store-evand
```

Install dependency

```bash
flutter pub get
```

Jalankan aplikasi

```bash
flutter run
```

## Integrasi

Aplikasi ini menggunakan akun Firebase yang sama dengan Evand Coding Store.

Data pengguna disimpan pada collection:

```text
users
```

Sedangkan informasi saldo dan keamanan dompet disimpan pada collection:

```text
wallets
```

Setiap akun yang dibuat pada Coding Store akan otomatis memiliki wallet sehingga pengguna dapat langsung masuk ke aplikasi Wallet menggunakan akun yang sama.



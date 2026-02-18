# 💸 NearbyPay: Secure Proximity Payment System

**NearbyPay** is a secure fintech application facilitating instant peer-to-peer payments using proximity detection logic. It eliminates the need for phone numbers or QR codes by detecting users nearby via Bluetooth/Wi-Fi.

## 🚀 Key Features

* [cite_start]**Proximity Payments:** Instantly find and pay users within your immediate vicinity using proximity detection[cite: 86].
* [cite_start]**Bank-Grade Security:** Implements **AES-128 End-to-End Encryption** to secure all sensitive transaction data and payloads[cite: 87].
* [cite_start]**Atomic Transactions:** High-performance backend handling atomic wallet transactions to ensure data integrity during transfers[cite: 88].
* [cite_start]**Financial Dashboard:** Features real-time balance updates, transaction history, and PIN-based authentication[cite: 88, 89].

## 🛠️ Tech Stack

* **Mobile App:** Flutter (Dart)
* **Backend:** Python (FastAPI)
* **Database:** MongoDB
* **Security:** AES-128 Encryption

## ⚙️ Installation

1.  **Backend Setup:**
    ```bash
    cd backend
    pip install -r requirements.txt
    python -m uvicorn main:app --reload
    ```

2.  **Mobile App Setup:**
    * Update the API URL in `lib/constants.dart` to your local IP.
    ```bash
    cd mobile_app
    flutter run
    ```

---

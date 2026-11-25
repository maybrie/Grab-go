# Grab-go

**Grab&Go — pre-order, skip the line, ease the canteen rush.**

Grab&Go is a Flutter mobile app built to **lessen congestion and long queues in campus cafeterias** (Batangas State University). Students pre-order meals and pick a short pickup window; when they arrive, they scan/show their QR receipt at the express lane and go — no waiting in the food line. Stalls prepare orders ahead of time against a live prep list, so the counter moves faster and crowds thin out during break time.

Flutter + Firebase (Firestore + Auth). Live pickup windows, stall prep lists,
receipt verification with QR claim flow, counter payments only.

## Purpose
- Reduce crowding and queueing at the canteen during breaks
- Let students order ahead and collect at a dedicated express lane
- Give stalls a real-time prep list so food is ready at the chosen window

## Features
- Customer self-registration; stall and main-admin accounts created by the canteen office
- Pickup windows generated per stall operating hours (7 AM–7 PM default), 10-minute slots, per-stall order limits
- Pay at counter only (GCash/QRPh coming soon)
- Claim flow with expiry; claimed receipts cannot be reused
- Store profile with storefront photo; dish photos
- Role-scoped Firestore rules (see `firestore.rules`)

## Setup
1. Install Flutter (stable channel)
2. `flutter pub get`
3. `flutter run` (Android/Web) — requires `google-services.json` (Android) and `lib/src/firebase_options.dart` for the `grab-go-60f46` project
4. Publish `firestore.rules` from the Firebase Console before real use

## Release
- `flutter build apk --release` (signs with the release keystore — not committed)
- `flutter test` / `flutter analyze` clean

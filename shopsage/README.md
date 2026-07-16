# ShopSage Flutter MVCS Auth

Very simple Flutter pages for:
- Login
- Sign up
- Forgot password request

## Architecture
- Model: `lib/models`
- View: `lib/views`
- Controller: `lib/controllers`
- Service: `lib/services`

## Backend findings
The supplied backend has login and registration, but registration has a `roleId`/`role` mismatch and forgot password is missing. Ready-to-copy fixes are in `backend_patch/`.

## 1. Apply backend patch
Copy the files from `backend_patch/server/` into the same paths inside `ShopSage-Ecommerce/server/`.

Then start MongoDB and backend:
```bash
npm install
npm run dev
```

## 2. Generate Flutter platform folders
Flutter SDK was not available in the build environment, so run this once inside this folder:
```bash
flutter create .
flutter pub get
```
The provided `lib/` and `pubspec.yaml` are the application code.

## 3. Set API URL
Edit `lib/config/api_config.dart`:
- Android emulator: `http://10.0.2.2:5000/api/auth`
- iOS simulator: `http://127.0.0.1:5000/api/auth`
- Real phone: `http://YOUR_COMPUTER_LAN_IP:5000/api/auth`

## 4. Android HTTP development setting
For local HTTP during development, add this attribute to `<application>` in `android/app/src/main/AndroidManifest.xml`:
```xml
android:usesCleartextTraffic="true"
```
Use HTTPS in production.

## 5. Run
```bash
flutter run
```

## API bodies used
### Register
```json
{"name":"Test User","email":"test@example.com","password":"Test@123","roleId":["CUSTOMER"]}
```
### Login
```json
{"email":"test@example.com","password":"Test@123"}
```
### Forgot password
```json
{"email":"test@example.com"}
```

Note: the supplied backend has no email provider or OTP setup. The included forgot-password endpoint safely accepts the request and returns a generic response; actual email delivery needs SMTP/Nodemailer configuration from the backend team.

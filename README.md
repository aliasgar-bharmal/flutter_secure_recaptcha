# flutter_secure_recaptcha

Secure, cross-platform reCAPTCHA integration for Flutter (Web & Mobile) with minimal setup.  
This plugin handles the entire flow internally—no need to manually inject HTML or update platform-specific code.

---

## 🔧 Installation

Add the plugin to your **pubspec.yaml**:

```yaml
dependencies:
  flutter_secure_recaptcha: <latest_version>
```

Then run:

```bash
flutter pub get
```

---

## 📱 For Mobile (Android & iOS)

### 1. Generate Required Files

Generate the assets and configuration files specifically for mobile:

```bash
dart run flutter_secure_recaptcha:generate --target=mobile
```

This command will create a `recaptcha_asset` folder that contains all necessary files.

### 2. Initialize Firebase Hosting (Mobile)

Since for mobile you only need to host the `r
ecaptcha_assets` folder, follow these steps:

1. **Initialize Firebase Hosting:**

   Navigate to your project folder where you want to host the recaptcha assets.

   ```bash
   firebase init hosting
   ```

   - **When prompted:**
     - **Select Firebase project:** Choose your project.
     - **Public directory:** Set it to `recaptcha_asset` (or the directory that was generated).
     - **Single-page app configuration:** You can usually answer `No` (unless your assets setup needs URL rewrites).

2. **Deploy to Firebase Hosting:**

   After initialization, deploy only the assets folder:

   ```bash
   firebase deploy --only hosting
   ```

### 3. Configure reCAPTCHA Key

After deployment, obtain your Firebase hosting URL (e.g., `your-app.web.app`) and add it as an allowed domain in your [Google reCAPTCHA admin console](https://www.google.com/recaptcha/admin).

---

## 🌐 For Web & Mobile (Combined)

If you are targeting both platforms using a unified approach:

### 1. Generate Web Files

Generate the files required for web. This step not only creates the needed reCAPTCHA files (including the critical `recaptcha.html`) but also sets up configurations that work across platforms:

```bash
dart run flutter_secure_recaptcha:generate --target=web
```

### 2. Initialize Firebase Hosting (Web)

1. **Initialize Firebase Hosting:**

   ```bash
   firebase init hosting
   ```

   - **When prompted:**
     - **Select Firebase project:** Choose your project.
     - **Public directory:** Set it to your web build directory (default for Flutter web builds is usually `build/web`).
     - **Include reCAPTCHA assets:** Ensure that the `recaptcha.html` file is included in this directory (if not, copy it manually from the generated folder).

2. **Build your Web App**

   Build your Flutter web application:

   ```bash
   flutter build web
   ```

3. **Deploy to Firebase Hosting:**

   With the build output in `build/web`, deploy your app including the `recaptcha.html`:

   ```bash
   firebase deploy --only hosting
   ```

### 3. Configure reCAPTCHA Key

Add your Firebase hosting domain (e.g., `your-app.web.app`) in the [Google reCAPTCHA admin console](https://www.google.com/recaptcha/admin) as an allowed domain.

---

## ⚙️ Using a Personal Server Instead of Firebase

If you prefer to host the reCAPTCHA assets on your own server rather than using Firebase, follow these steps:

### For Mobile:

1. **Generate Mobile Assets:**

   ```bash
   dart run flutter_secure_recaptcha:generate --target=mobile
   ```

   This command creates the `recaptcha_asset` folder.

2. **Upload Assets to Your Server:**

   - Use an FTP client, SSH, or your preferred deployment process to upload the entire `recaptcha_asset` folder to a designated directory on your server (for example, `https://yourserver.com/recaptcha.html`).

3. **Configure Allowed Domains:**

   In the [Google reCAPTCHA admin console](https://www.google.com/recaptcha/admin), add your custom domain (e.g., `yourserver.com`) as an allowed domain.

### For Web:

1. **Generate Web Files:**

   ```bash
   dart run flutter_secure_recaptcha:generate --target=web
   ```

   Make sure the generated output includes `recaptcha.html` along with other required files.

2. **Build the Flutter Web App:**

   ```bash
   flutter build web
   ```

3. **Modify the Build (if needed):**

   Verify that the `build/web` folder contains the `recaptcha.html` file. If it is not present, copy it manually from the generated output into the build folder.

4. **Upload to Your Server:**

   Upload the entire contents of the `build/web` folder to your server’s web root or a desired subdirectory (for example, `https://yourserver.com/`).

5. **Configure Allowed Domains:**

   In your [Google reCAPTCHA admin console](https://www.google.com/recaptcha/admin), add your server domain (e.g., `yourserver.com`) as an allowed domain.

---

## ✅ Plugin Usage

Inside your Flutter app, import and use the plugin:

```dart
import 'package:flutter_secure_recaptcha/flutter_secure_recaptcha.dart';

FlutterSecureRecaptcha(
  siteKey: 'YOUR_SITE_KEY',
  // For mobile, this should be your hosted domain for assets; for web, it is your Firebase or custom hosting domain
  domain: 'YOUR_HOSTED_DOMAIN',
  onVerifiedSuccessfully: (String token) {
    // Handle the successful token verification
  },
);
```

**Notes:**

- **Whitelisting Domains:**  
  Make sure your app's domain is whitelisted in Google reCAPTCHA for it to work correctly.

- **Cross-Platform Considerations:**  
  The plugin automatically handles HTML injection for web builds, asset management for Firebase Hosting, and cross-platform logic abstraction.

---

## 💬 Need Help?

If you encounter any issues or have suggestions, please open an issue or contribute on [GitHub](https://github.com/your_repo_here).

# flutter_secure_recaptcha

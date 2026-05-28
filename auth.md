# Auth module structure and flow

This document explains why the auth module is structured this way and what each file does.

## Why it is structured this way

- Separation of concerns keeps UI, state, and data access isolated so each part can evolve without breaking others.
- Testability is improved because repositories and providers can be tested without UI.
- Scalability is easier because new features like refresh tokens or roles add to the data/provider layers without rewiring pages.

## Folder layout (auth feature)

- data/
  - auth_repository.dart
- domain/
  - user_model.dart
- presentation/
  - providers/
    - auth_provider.dart
  - pages/
    - splash_page.dart
    - login_page.dart
    - register_page.dart
  - widgets/
    - auth_form_field.dart

## File-by-file details

### data/auth_repository.dart

Purpose:
- Central place for auth API calls.
- Returns a UserModel and a token for login and register.

Current behavior:
- Uses a simulated delay and returns demo data.
- This is where you would plug in Dio or any HTTP client to call your backend.

Key methods:
- login(email, password) -> AuthResult(user, token)
- register(fullName, email, phone, password) -> AuthResult(user, token)

### domain/user_model.dart

Purpose:
- Represents the user entity used across the app.
- Matches the users table: userId, roleId, fullName, email, phone, avatarUrl, createdAt, isActive.

Key methods:
- fromJson(map) to build a UserModel from backend responses.
- toJson() to serialize if needed.

### presentation/providers/auth_provider.dart

Purpose:
- Holds auth state and business rules in one place.
- Exposes simple methods the UI can call.

State model:
- AuthStatus.loading
- AuthStatus.authenticated
- AuthStatus.unauthenticated
- AuthStatus.error

Methods:
- login(email, password)
- register(fullName, email, phone, password)
- logout()
- checkAuth()
- clearError()

Behavior:
- Saves JWT to local storage (SharedPreferences) on successful login/register.
- Uses checkAuth() to see if a token exists and restores an authenticated state.

### presentation/widgets/auth_form_field.dart

Purpose:
- Reusable styled TextFormField.
- Ensures consistent form styling across login and register pages.

Style rules:
- 48px height
- Warm border
- Focus border 2px dark border
- Optional suffix icon for show/hide password

### presentation/pages/splash_page.dart

Purpose:
- Displays the splash animation.
- After the animation, decides where to go based on auth status.

Flow:
- Calls checkAuth() from authProvider.
- If token exists -> /home
- Else -> /login

### presentation/pages/login_page.dart

Purpose:
- Login UI with email and password fields.
- Handles show/hide password.
- Uses authProvider to perform login.

Flow:
- User taps Login -> authProvider.login()
- On success: route to /home
- On error: show SnackBar

### presentation/pages/register_page.dart

Purpose:
- Registration UI with full name, email, phone, password, confirm password.
- Uses authProvider to register and auto-login on success.

Flow:
- Validate confirm password
- Call authProvider.register()
- On success: route to /home
- On error: show SnackBar

## App routing and startup

- main.dart creates the ProviderScope and uses AppWidget.
- app.dart defines MaterialApp.router and GoRouter routes.
- splash_page.dart is the initial route and decides auth routing.

## How to extend

- Replace the mock AuthRepository with real API calls.
- Add refresh token handling inside auth_provider.dart.
- Store user profile data in local storage or a secure store if needed.
- Add validation in the login and register pages for better UX.

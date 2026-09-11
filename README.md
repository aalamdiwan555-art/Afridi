# Smartyt

**Smartyt** is the all-in-one YouTube creator live-streaming app built in Flutter.

> Stream Everything. One App.

## Monetization Strategy (100% Ad-Free)

Smartyt has **zero advertisements**.
- Every new user receives a **1-day free trial** (24 hours) on first launch.
- After the trial ends, the user must **upgrade to a paid plan** to continue using the app.
- Revenue comes **only** from subscriptions.

### Pricing Plans

| Plan   | Price    | Duration | Badge        |
|--------|----------|----------|--------------|
| Daily  | $0.99    | 1 day    | -            |
| Weekly | $4.99    | 7 days   | -            |
| Monthly| $14.99   | 30 days  | MOST POPULAR |
| Yearly | $99.99   | 365 days | BEST VALUE   |

All plans unlock the same streaming features; longer plans include 24x7 cloud streams, AI tools, team seats and priority relay.

## Features

- **Screen Live Stream** – games, tutorials, presentations with face-cam overlay
- **Camera Live Stream** – beauty filters, AR effects, multi-guest rooms
- **Pre-Recorded Live** – schedule videos as "live" streams with chat
- **24x7 Always-On** – auto-loop playlist channels
- **Live Chat & Moderation** – slow mode, followers-only, AI auto-mod, timeout/ban
- **Analytics** – views, peak concurrents, watch time, revenue, stream grade
- **SEO & AI Tools** – title/description generator, thumbnail lab, trending radar
- **Cloud Recording** – every stream auto-saved as MP4

## Tech Stack

- **Mobile:** Flutter 3.x (Dart)
- **State:** Provider + ChangeNotifier
- **Auth:** Google Sign-In (with demo fallback)
- **Local Storage:** SharedPreferences (trial, subscription, user)
- **Billing:** Simulated in this source – see `WHATS_NEEDED_TO_ADD.txt` for real store integration

## Run Locally

```bash
# 1. Install Flutter (>=3.3.0) and set up an Android emulator or device.
# 2. Clone / extract this project
cd smartytapp

# 3. Get dependencies
flutter pub get

# 4. Run
flutter run
```

## Project Structure

```
lib/
  core/           – constants, theme
  data/
    models/       – AppUser, SubscriptionPlan
    services/     – AppStorage (trial + subscription persistence)
  features/
    auth/         – login, demo sign-in
    subscription/ – trial logic, paywall gating
    paywall/      – upgrade screen with 4 plans
    onboarding/   – 3-page intro
    home/         – dashboard, quick stats
    golive/       – screen, camera, pre-recorded, 24x7 stream UIs
    chat/         – live chat with mod tools
    analytics/    – stats + bar chart
    settings/     – account, plan management, sign out
```

## License

This source code is provided as a buildable scaffold. Replace simulated billing with real in-app purchases before publishing.

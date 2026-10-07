# ClubPlay

ClubPlay is an iOS application for football clubs to manage weekly games, player registrations, waitlists, attendance, and game updates.

## Repository

GitHub: 
```
https://github.com/envydiace/ClubPlay.git
```

## Key Features

- Member sign-in and community access
- View upcoming football games
- Register for games and join the waitlist when full
- Cancel registrations before the cancellation deadline
- Organiser game creation, publishing, editing, and player management
- Attendance management
- Home Screen widget for the next upcoming game
- Custom notification content for important published-game updates
- Notification tap opens the relevant game details

## Architecture

ClubPlay follows a layered architecture:

`SwiftUI Views → ViewModels → Use Cases → Repository Protocols → Data Sources`

Business rules are handled in Use Cases, while persistence and external data access are kept behind repository protocols.

## Persistence

- **Supabase** — remote data source and authentication
- **Core Data** — local persistent storage and offline cache

The app can display previously cached domain data when the network is unavailable.

## iOS Extensions

### WidgetKit
Displays the member's next upcoming game using a shared App Group container.

Supported widget families:
- Small
- Medium

### Notification Content Extension
Displays a custom expanded notification when a published game is updated, including meaningful changes such as venue or kick-off time.

## Testing

Unit tests use mock repositories instead of the real Core Data or Supabase stack.

Tests cover:
- Happy paths
- Boundary conditions
- Domain error cases
- Registration, cancellation, game management, attendance, authentication, and waitlist use cases

## Requirements

- Xcode
- iOS 18.0+
- Supabase project configuration

## Run

1. Clone the repository.
2. Open `ClubPlay.xcodeproj` in Xcode.
3. Select the `ClubPlay` scheme.
4. Build and run the app.

## Marker Test Scenarios

### Member
- Sign in using a member demo account.
- Open **Upcoming Games** and register for a game.
- Verify a full game places the member on the waitlist.
- Open **My Games** and cancel an active registration before the deadline.
- Add the ClubPlay widget and verify the next upcoming game is displayed.

### Organiser
- Sign in using an organiser demo account.
- Create and publish a game.
- Edit the venue or kick-off time of a published game.
- Verify the custom game-update notification appears.
- Expand the notification to view the changed game details.
- Tap the notification and verify ClubPlay opens the correct game.
- Open **Manage Games → Players** to update registration status or attendance.

### Offline Cache
- Load ClubPlay while online first.
- Disable network access.
- Reopen the app and verify previously loaded game data remains available from Core Data.

### Unit Tests
- Select the `ClubPlay` scheme.
- Run the test suite with `⌘U`.
- Verify all unit tests pass using mock repositories.

## Demo Accounts
- Default password:
    ```
    Test1!
    ```
- Organiser email:
    ```bash
    ninhkhoai2106@gmail.com
    ``` 
- Member 1 email:
    ```bash
    member1@test.com
    ```
- Member 2 email:
    ```bash
    member2@test.com
    ```

---
Developed for UTS Advanced iOS Development Assignment 3.

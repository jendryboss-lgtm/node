# Dating App iOS

A modern, feature-rich dating app built with SwiftUI for iOS 16+. Inspired by Tinder, Bumble, and Hinge.

## Features

- **Swipeable Card Stack**: Smooth gesture-based swiping with like, pass, and super like
- **Real-time Messaging**: Chat with your matches instantly
- **Profile Management**: Photos, bio, prompts, and preferences
- **Premium Subscriptions**: In-app purchases via StoreKit 2
- **Authentication**: Phone verification and social login
- **Secure Storage**: Keychain for sensitive data

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Project Structure

```
ios/
├── DatingApp/
│   ├── App/
│   │   ├── DatingAppApp.swift      # App entry point
│   │   └── ContentView.swift       # Root view
│   │
│   ├── Models/
│   │   ├── User.swift              # User & profile models
│   │   ├── Match.swift             # Match & message models
│   │   └── APIModels.swift         # API request/response models
│   │
│   ├── Views/
│   │   ├── Auth/
│   │   │   └── AuthenticationView.swift
│   │   ├── Discovery/
│   │   │   └── DiscoveryView.swift
│   │   ├── Matches/
│   │   │   └── MatchesView.swift
│   │   ├── Messages/
│   │   │   └── ChatView.swift
│   │   ├── Profile/
│   │   │   └── ProfileView.swift
│   │   └── Components/
│   │
│   ├── ViewModels/
│   │   ├── AuthViewModel.swift
│   │   ├── DiscoveryViewModel.swift
│   │   ├── MatchesViewModel.swift
│   │   └── MessagesViewModel.swift
│   │
│   ├── Services/
│   │   ├── APIService.swift        # Network layer
│   │   └── KeychainService.swift   # Secure storage
│   │
│   ├── Utilities/
│   ├── Extensions/
│   └── Resources/
```

## Setup

### 1. Open in Xcode

1. Open `DatingApp.xcodeproj` in Xcode 15+
2. Wait for Swift packages to resolve

### 2. Configure API Endpoint

Update the base URL in `APIService.swift`:

```swift
self.baseURL = "https://your-api-domain.com/api/v1"
```

Or set via environment variable:
- Edit scheme > Run > Arguments > Environment Variables
- Add: `API_BASE_URL` = `https://your-api-domain.com/api/v1`

### 3. Build and Run

1. Select your target device/simulator
2. Press `Cmd + R` to build and run

## Architecture

### MVVM Pattern

- **Models**: Data structures matching backend API
- **Views**: SwiftUI views for UI
- **ViewModels**: Business logic and state management

### Networking

The `APIService` handles all network requests:
- Generic request method with Codable support
- JWT token management via Keychain
- Multipart upload for images
- Error handling with custom `APIError` enum

### State Management

- `@StateObject` for view-owned state
- `@EnvironmentObject` for shared state (auth, app state)
- `@Published` properties for reactive updates

## Key Components

### Discovery View

The main swiping interface with:
- Card stack with staggered appearance
- Gesture-based swipe actions
- Photo pagination
- Like/Nope overlay indicators
- Match celebration modal

### Chat View

Real-time messaging with:
- Message bubbles with timestamps
- Auto-scroll to latest message
- Media attachment support
- Profile detail sheet

### Profile View

User profile management:
- Photo editing
- Bio and prompts
- Discovery preferences
- Premium upsell

## Customization

### Colors

Update the accent color in views:
```swift
.accentColor(.pink)
```

Or create a custom color set in Assets.xcassets.

### Fonts

The app uses system fonts. To customize:
```swift
Text("Hello")
    .font(.custom("YourFont-Bold", size: 24))
```

### API Endpoints

All endpoints are defined in `APIService.swift`:
```swift
// Discovery
"/discovery"
"/swipes"

// Matches
"/matches"
"/matches/{id}/messages"

// Auth
"/auth/register"
"/auth/login"
"/auth/verify"
```

## Testing

### Unit Tests

Run tests with `Cmd + U`:
```swift
func testUserDecoding() {
    let json = """
    {"id": "123", "first_name": "John", ...}
    """
    let user = try JSONDecoder().decode(User.self, from: json.data(using: .utf8)!)
    XCTAssertEqual(user.firstName, "John")
}
```

### UI Tests

Use XCUITest for UI automation:
```swift
func testSwipeRight() {
    let app = XCUIApplication()
    app.launch()

    let card = app.otherElements["profileCard"]
    card.swipeRight()

    XCTAssertTrue(app.staticTexts["LIKE"].exists)
}
```

## Deployment

### App Store

1. Update version and build number
2. Archive: Product > Archive
3. Upload to App Store Connect
4. Submit for review

### TestFlight

1. Archive the app
2. Upload to App Store Connect
3. Add testers in TestFlight

## Dependencies

No external dependencies - uses native iOS frameworks:
- SwiftUI
- Combine
- Security (Keychain)
- Photos (for photo picker)

## Backend API

This app requires the Dating App backend API to be running. See the main project README for setup instructions.

Default API URL: `http://localhost:3000/api/v1`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License

## Screenshots

### Discovery
Swipeable cards with profile info, photos, and prompts.

### Matches
Grid of new matches and conversation list.

### Chat
Real-time messaging with read receipts.

### Profile
Edit photos, bio, and preferences.

## Roadmap

- [ ] Video profiles
- [ ] Voice messages
- [ ] Video calling
- [ ] Apple Pay integration
- [ ] Widgets
- [ ] App Clips
- [ ] Share extension

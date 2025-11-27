# Flutter Range Bar Widget

A Flutter application that visualizes health range data with an interactive bar widget.

## Features

- Dynamic range visualization with color-coded sections
- Real-time value indicator
- API integration for fetching range data
- Reload functionality

## Getting Started

### Prerequisites

- Flutter SDK (>=3.38.3)
- Dart SDK (>=3.10.1)

### Installation

1. Clone the repository
```bash
git clone https://github.com/sammedlimbikai/neodocs_task.git
cd neodocs_task
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Environment Configuration

The app uses environment variables for API configuration. You can set them in three ways:

### Option 1: Using Default Values (Quick Start)

The app comes with default values configured in `lib/envornment_config.dart`. Just run the app directly:

```bash
flutter run
```

### Option 2: Using Command Line Arguments

Pass custom values when running the app:

```bash
flutter run --dart-define=BASE_URL=https://your-api.com --dart-define=AUTH_TOKEN=your_token_here
```

### Option 3: Using VS Code launch.json

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Development)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=BASE_URL=https://your-api.com",
        "--dart-define=AUTH_TOKEN=your_token_here"
      ]
    }
  ]
}
```

### Option 4: Using Android Studio Run Configuration

1. Go to **Run** → **Edit Configurations**
2. Add to **Additional run args**:
```
--dart-define=BASE_URL=https://your-api.com --dart-define=AUTH_TOKEN=your_token_here
```

### Environment Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `BASE_URL` | API base URL | `https://nd-assignment.azurewebsites.net` |
| `AUTH_TOKEN` | Bearer authentication token | `eb3dae0a10614a7e...` |

## API Integration

### Custom HTTP Client

The app uses a custom HTTP client (`CustomHttp`) that:
- Automatically adds base URL to requests
- Includes authentication headers
- Logs all requests and responses
- Handles timeouts (30 seconds)

### Usage Example

```dart
import 'package:neodocs_task/core/custom_http.dart';

// Make API calls
final response = await CustomHttp.instance.get(
  Uri.parse('/api/ranges'),
);

// The client automatically adds:
// - Base URL
// - Authorization header
// - Content-Type header
```

### Expected API Response

The API should return a JSON array:

```json
[
  {
    "range": "0-40",
    "meaning": "Low",
    "color": "#ff0000"
  },
  {
    "range": "41-70",
    "meaning": "Normal",
    "color": "#00ff00"
  }
]
```

## Project Structure

```
lib/
├── core/
│   └── custom_http.dart           # HTTP client wrapper
├── envornment_config.dart         # Environment variables
├── commons/
│   └── endpoints.dart             # API endpoints
└── modules/
    └── range_bar/
        ├── controllers/           # State management
        ├── models/               # Data models
        └── views/                # UI widgets
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  logging: ^1.2.0
```

## Building for Release

### Android

```bash
flutter build apk --dart-define=BASE_URL=https://your-api.com --dart-define=AUTH_TOKEN=your_token
```

### iOS

```bash
flutter build ios --dart-define=BASE_URL=https://your-api.com --dart-define=AUTH_TOKEN=your_token
```

## License

This project is licensed under the MIT License.
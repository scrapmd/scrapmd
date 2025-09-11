# Scrapmd

[![](https://ngs.io/images/appstore-5eb1a238.svg)][AppStore]

![Tests](https://github.com/scrapmd/scrapmd/workflows/Tests/badge.svg)
![SwiftLint](https://github.com/scrapmd/scrapmd/workflows/SwiftLint/badge.svg)
[![License](https://img.shields.io/github/license/scrapmd/scrapmd.svg)](https://github.com/scrapmd/scrapmd/blob/master/LICENSE)
[![App Store](https://img.shields.io/itunes/v/1517295689?label=App%20Store&maxAge=3600)][AppStore]
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/atsnngs)

A Markdown-formatted web page scrapbook for iOS and macOS. Save and organize web content as Markdown files for offline reading.

![](Scrapmd/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png)

## Features

- 📝 **Save Web Pages as Markdown**: Convert any web page to clean, readable Markdown format
- 📁 **Organize Content**: Create folders and organize your saved content hierarchically
- ☁️ **iCloud Sync**: Seamlessly sync your content across all your Apple devices
- 🌙 **Dark Mode Support**: Comfortable reading experience in any lighting condition
- 📱 **Universal App**: Native support for iPhone, iPad, and Mac (via Mac Catalyst)
- 🔗 **Share Extension**: Quickly save content from any app using the iOS/macOS share sheet
- 🚀 **Fast & Native**: Built with SwiftUI for optimal performance

## Requirements

- iOS 13.0+ / macOS 10.15+
- Xcode 12.0+
- Swift 5.0+

## Installation

### From App Store
Download Scrapmd from the [App Store][AppStore].

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/scrapmd/scrapmd.git
cd scrapmd
```

2. Install dependencies:
```bash
bundle install
bundle exec fastlane ios develop_match  # For iOS development
bundle exec fastlane mac develop_match  # For macOS development
```

3. Open the project in Xcode:
```bash
open Scrapmd.xcodeproj
```

4. Select your development team in the project settings and build.

## Development

### Project Structure
- `Scrapmd/` - Main application code
  - `Views/` - SwiftUI views
  - `Data/` - Data models and view models
  - `Networking/` - API client for fetching web content
  - `Extensions/` - Swift extensions
- `ActionExtension/` - Share extension
- `fastlane/` - Build automation and deployment

### Running Tests
```bash
bundle exec fastlane tests
```

### Code Style
This project uses SwiftLint for code style enforcement. Run linting with:
```bash
swiftlint
```

### Contributing
Please read [CLAUDE.md](CLAUDE.md) for detailed development guidelines and contribution instructions.

## Architecture

Scrapmd follows the MVVM (Model-View-ViewModel) architecture pattern:
- **SwiftUI Views** for the presentation layer
- **ViewModels** handle business logic and state management
- **FileKit** for file system operations
- **Core Data** for metadata caching

## Technology Stack

- **SwiftUI** - Modern declarative UI framework
- **FileKit** - File system operations
- **Ink** - Markdown parsing and rendering
- **Firebase** - Analytics and crash reporting
- **Fastlane** - Build automation and deployment

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


----

&copy; 2020 LittleApps Inc.

[AppStore]: https://apps.apple.com/app/id1517295689

# Scrapmd Project Documentation

## Project Overview
Scrapmd is an iOS/macOS application that serves as a Markdown-formatted web page scrapbook. It allows users to save web content as Markdown files for offline reading and organization.

## Tech Stack
- **Platform**: iOS/macOS (Universal app using Mac Catalyst)
- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Architecture**: MVVM pattern
- **Dependencies**:
  - FileKit (File system operations)
  - Ink (Markdown parsing)
  - Firebase (Analytics & Crashlytics)
- **Build & CI/CD**: Fastlane
- **Testing**: XCTest

## Project Structure
```
scrapmd/
├── Scrapmd/                    # Main iOS/macOS app
│   ├── Data/                   # Data models and view models
│   ├── Views/                  # SwiftUI views
│   ├── Networking/             # API client and content fetching
│   └── Extensions/             # Swift extensions
├── ActionExtension/            # Share extension for saving content
├── fastlane/                   # Fastlane configuration
│   ├── Fastfile               # Build and deployment lanes
│   └── metadata/              # App Store metadata
└── Resources/                  # App resources

```

## Key Features
- Save web pages as Markdown files
- Organize content in folders
- Share extension for quick saving
- iCloud sync support
- Dark mode support
- Universal app (iOS & macOS)

## Development Guidelines

### Documentation Language
**IMPORTANT**: All code documentation, comments, and inline documentation must be written in English. This includes:
- Code comments
- Function/method documentation
- TODO/FIXME comments
- Git commit messages
- Pull request descriptions
- Technical documentation

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for code style enforcement
- Prefer value types (structs) over reference types where appropriate
- Use meaningful variable and function names
- Keep functions small and focused

### Architecture Patterns
- **MVVM**: Views bind to ViewModels which handle business logic
- **ObservableObject/Published**: For reactive UI updates
- **EnvironmentObject**: For shared state across views
- **FileKit**: For file system operations

### Testing
Run tests using:
```bash
fastlane tests
```

### Build Commands
- **Run tests**: `fastlane tests`
- **Build for beta**: `fastlane ios beta_build` or `fastlane mac beta_build`
- **Build for release**: `fastlane ios release_build` or `fastlane mac release_build`

### Key Components

#### Content Saving Flow
1. User shares URL via share sheet or pastes URL
2. `APIClient` fetches web content
3. `ContentSaver` converts HTML to Markdown
4. Content saved to selected directory using FileKit

#### Directory Management
- `DirectoryBrowser`: Manages file/folder navigation
- `CoreDataManager`: Handles timestamp caching
- iCloud container support for sync

#### UI Components
- `ContentView`: Main navigation structure
- `DirectoryBrowserView`: File browser interface
- `ScrapReaderView`: Markdown content viewer
- `NewScrapView`: New content creation
- `SaveActionView`: Share extension UI

## Modernization Tasks
This project has not been maintained for 5 years and requires the following updates:

1. **Swift & iOS Version Updates**
   - Update to latest Swift version
   - Update minimum iOS deployment target
   - Update deprecated APIs

2. **Dependencies**
   - Update all third-party dependencies
   - Review and replace deprecated libraries
   - Update Firebase SDK

3. **UI/UX Improvements**
   - Modernize UI design
   - Improve accessibility
   - Add new iOS features (widgets, shortcuts, etc.)

4. **Code Quality**
   - Add comprehensive unit tests
   - Improve error handling
   - Add proper logging
   - Update to modern Swift patterns (async/await, etc.)

5. **CI/CD**
   - Update GitHub Actions workflows
   - Modernize Fastlane configuration
   - Add automated testing

## Contributing
When contributing to this project:
1. Write all documentation in English
2. Follow the existing code style
3. Add tests for new features
4. Update this documentation as needed
5. Use meaningful commit messages in English

## License
MIT License - Copyright © 2020 LittleApps Inc.
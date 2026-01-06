Digidex

A simple iOS application built with Swift 5 that consumes the free Digi-API to display Digimon cards.

This project demonstrates:

Pagination with 8 cards per page

Infinite scroll

Search and filtering

Digimon card list and detail views

Clean architecture (MVVM / Service / Mapper)

Basic error handling (no internet / API errors)

Unit tests and UI tests

📱 App Overview

Digidex shows a list of Digimon in a grid layout.
Each screen displays:

Digimon image and name

Infinite scroll — load 8 cards at a time

Search by name

Filter options (attribute, level, type, field)

Detail page with additional Digimon information

🧱 Architecture

This app is structured using a clean and modular approach inspired by common iOS assessment patterns:

Digidex
├── AppDelegate/SceneDelegate
├── Services
│   ├── HTTPClient.swift
│   └── DigimonServiceAPI.swift
├── Mapper
│   └── CharacterMapper.swift
├── ViewModel
│   └── CharactersViewModel.swift
├── Views
│   ├── CharactersListController.swift
│   └── DetailCharacterController.swift
├── Helpers
│   ├── UIImageView+Helper.swift
│   └── Reachability.swift
├── Supporting Files
│   ├── Assets.xcassets
│   └── Info.plist
├── DigidexTests
└── DigidexUITests

⚙️ Features
✅ Pagination

Loads 8 Digimon per page

Appends next set automatically when scrolling near bottom

🔍 Search & Filter

Search by name

Filter by:

Attribute

Level

Type

Field

🔎 Detail Page

Larger image

Lists of attributes, types, levels and fields

📶 Error Handling

No Internet

API failures

Graceful fallback UI

🧪 Testing

Unit tests for Mapper and ViewModel

Minimal UI tests for basic navigation flow

📦 Dependencies

Managed through CocoaPods:

FittedSheets – for filter modal

(Others can be added if needed)

To install dependencies:

pod install

🧪 Running Tests
Unit Tests

Navigate to DigidexTests and run:

Product > Test in Xcode

or ⌘ + U

UI Tests

Navigate to DigidexUITests and run:

Same as above

Ensures basic interaction (launch → list → detail)

📌 API Used

Digi-API
Base URL:

https://digi-api.com/api/v1


Endpoints:

List Digimon: GET /digimon

Digimon detail: GET /digimon/{id}

🪩 Notes

UI is kept simple and functional

Architecture focuses on separation of concerns

Designed to be clear and easy to extend

Some filters may be applied client-side depending on API support

📷 Screenshots (Optional)

You can optionally add screenshots here using Markdown:

![List Screen](path/to/list.png)
![Detail Screen](path/to/detail.png)

🧠 Submission Ready

This project is suitable for take-home technical assessments, demonstrating:

Clear architecture

Pagination logic

Decoupled networking

Readable code

Testing strategy

Basic but functional UI

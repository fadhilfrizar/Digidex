# Digidex

Digidex is a simple iOS application built using **Swift 5** that consumes the public **Digi-API** to display Digimon data.

This project is created as a technical assessment and focuses on **clean architecture, pagination, and error handling**, rather than complex UI or animations.

---

## Description

The application displays Digimon in a **card-based grid layout** with image and name.

Each page loads **8 Digimon at a time**.  
When the user scrolls to the bottom, the next page is fetched automatically.

Users can search and filter Digimon, and tap a card to view detailed information.

---

## Features

- Digimon card list (image + name)
- Pagination (8 items per page)
- Infinite scrolling
- Search Digimon by name
- Filter by:
  - Attribute
  - Level
  - Type
  - Field
- Digimon detail page
- Error handling:
  - No internet connection
  - API failure
- Swift 5
- UIKit
- Auto Layout
- No retain cycle

---

## Architecture

- UIKit
- MVVM
- URLSession for networking
- Mapper layer for data transformation
- CocoaPods for dependency management

---

## API

This app uses a free public API:

https://digi-api.com/api/v1


Main endpoints:
- `GET /digimon`
- `GET /digimon/{id}`

---

## Pagination

- Initial request loads **8 Digimon**
- When user scrolls near the bottom:
  - Next page is fetched
  - 8 new items are appended
- Pagination stops automatically when no more data is returned

---

## Error Handling

Error handling is implemented in the networking layer and propagated to the UI through the ViewModel.

Handled cases:
- No internet connection
- Invalid response
- API error
- Decoding failure

---

## Dependencies

Managed using **CocoaPods**:

- FittedSheets

Install dependencies using:

```bash
pod install
```
## Testing

### Unit Tests
- Mapper tests
- ViewModel tests (pagination & parameters)

### UI Tests
- Basic flow:
  - App launch
  - Digimon list loaded
  - Navigate to detail screen

Tests are located in:
- `DigidexTests`
- `DigidexUITests`

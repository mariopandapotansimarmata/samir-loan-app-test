# Samir Mini Project

A UIKit application that displays loans from a remote API and provides borrower, collateral, repayment schedule, and document details.

## How to Run

1. Open `Samir-MiniProject.xcodeproj` using Xcode 26 or a compatible version.
2. Select the **Samir-MiniProject** scheme and an iOS Simulator.
3. Make sure the device has an internet connection.
4. Run the project with **Cmd + R**.

Loan data is fetched from [loans.json](https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/api/json/loans.json). The project does not use third-party dependencies.

## Architecture

The project uses programmatic UIKit, MVVM, the Coordinator Pattern, and layered separation:

- **App**: dependency container, configuration, and navigation coordinator.
- **Presentation**: ViewControllers, ViewModels, ViewData, and reusable views.
- **Domain**: entities, repository contracts, use cases, and domain types.
- **Data**: DTOs, mappers, endpoints, and repository implementations.
- **Core**: generic networking built with URLSession.

Data flow:

```text
HomeViewController -> HomeViewModel -> FetchLoansUseCase
                   -> LoanRepository -> NetworkManager
                   -> LoanDTO -> LoanMapper -> Loan
```

## Key Decisions

- DTOs and Domain models are separated through a mapper so the Domain layer does not depend on the JSON structure.
- Home state uses Combine and `@Published`.
- Amount and term sorting lives in HomeViewModel because it is presentation logic.
- The `None` sorting option preserves the original backend order.
- The selected `Loan` object is passed to Loan Detail through AppCoordinator without another request.
- AppContainer provides dependencies, while AppCoordinator creates screens and manages navigation.

## Features

- Card-based loan list.
- Loading, empty, error, retry, and pull-to-refresh states.
- Ascending and descending sorting by amount and term.
- Distinct badge colors for each risk rating.
- Loan Detail sections for borrower, collateral, repayment schedule, and documents.
- In-app document preview using `SFSafariViewController`.

## Folder Structure

```text
Samir-MiniProject/
├── App/
├── Core/
├── Data/
├── Domain/
└── Presentation/
    ├── Home/
    └── LoanDetail/
```

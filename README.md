# TalenvyraMCOTest - News App

An iOS News Application built using the **VIPER Architecture**. The app connects to the `newsapi.org` endpoint to fetch global news dynamically.

## 📝 Assessment Note
This repository was developed as part of a technical assessment to complete the recruitment selection process at **Talentvyra**. 

## 🚀 Features
- **Category Selector (Screen 1)**: Allows users to filter news based on industries like Business, Entertainment, General, Health, Science, Sports, and Technology.
- **News Sources List (Screen 2)**: Displays list of news outlets filtering by category with dynamic local pagination support.
- **Articles Discovery (Screen 3)**:
  - Features real-time server-side pagination (Infinite Scroll via `willDisplayCell`).
  - Search functionality implemented with a **500ms Debounce Mechanism** (`Task.sleep`) to prevent redundant API throttling.
  - Image handling powered by **Kingfisher** for asynchronous downloading and advanced caching mechanisms.
- **Article Detail (Screen 4)**: Seamless in-app web viewing utilizing `WebKit`'s `WKWebView` with native activity loading animations.

## 🛠️ Architecture & Tech Stack
- **Architecture**: VIPER (View, Interactor, Presenter, Entity, Router) — ensuring loose coupling, single responsibility, and great testability.
- **UI Framework**: Programmatic UIKit (100% Code-based UI, No Storyboards/XIBs).
- **Networking**: Alamofire integrated with modern Swift Concurrency (`async/await`).
- **Image Caching**: Kingfisher.
- **Dependency Manager**: Swift Package Manager (SPM).

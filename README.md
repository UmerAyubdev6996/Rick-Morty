#  AssignmentApp – Rick & Morty Explorer

A cleanly modularized SwiftUI app that displays **Rick and Morty characters** with smooth pagination, offline caching, and an efficient, modern architecture.  
Built to demonstrate modular code structure, async networking, and lightweight SwiftUI animations.

---

##  Project Overview

The app fetches character data from the **Rick and Morty API** and presents it in a scrollable list.  
It supports:
- **Async/Await networking** for smooth performance  
- **Pagination** (20 characters per request, up to 100 total)  
- **Offline caching** of both data and images  
- **MVVM + Repository** architecture for clean separation of concerns  
- **SDWebImageSwiftUI** for efficient image loading and caching  
- **SwiftUI animations** for a modern, polished feel  

---

##  Architecture Diagram

+---------------------+
|    Rick & Morty     |
|   (Main App Entry)  |
+----------+----------+
           |
           v
+---------------------+
|  CharactersFeature  |
|  (UI + ViewModels)  |
+----------+----------+
           |
           v
+---------------------+
|      DataLayer      |
| (Repository + Cache)|
+----------+----------+
           |
           v
+---------------------+
|      Network        |
| (APIService client) |
+----------+----------+
           |
           v
+---------------------+
|       Models        |
|  (DTOs + Entities)  |
+---------------------+

---

##  Module Breakdown

| Module | Responsibility |
|---------|----------------|
| **Models** | Defines `Character`, `CharacterDTO`, and response structs |
| **Network** | Handles all API calls via `NetworkClient` and `APIService` |
| **DataLayer** | Implements `CharacterRepository` for caching and data fetching |
| **CharactersFeature** | Contains SwiftUI views (`CharacterListView`, `CharacterDetailView`), and `CharacterListViewModel` , `CharacterDetailViewModel` |
| **SharedUI** | Reusable UI elements like `ShimmerLoadingView`, `CharacterRow` |

---

##  Caching Strategy

- **API Caching**:  
  Each page’s response is saved as a local JSON file inside the app’s cache directory (`characters_page_X.json`).  
  When offline, the repository automatically loads cached pages instead of hitting the network.

- **Image Caching**:  
  Managed by **SDWebImageSwiftUI**, which stores images locally once downloaded — ensuring previously viewed images remain visible offline.

---

##  Pagination Flow

- Initially loads **20 characters** (page 1).  
- When the user scrolls near the bottom, the next 20 characters load automatically.  
- Caching saves each page individually, so in offline mode the app can only show pages that were already loaded online.  
- The app stops fetching after **100 characters (5 pages)** as per the assignment requirement.

---

##  Architecture Trade-offs & Decisions

- **SwiftUI + Combine** used for simple state handling instead of heavy frameworks.  
- **Repository pattern** ensures easy testability and clear separation between UI and data layers.  
- **File-based caching** (instead of Core Data or Realm) was chosen for simplicity and transparency.  
- **SDWebImageSwiftUI** was preferred over `AsyncImage` for advanced caching and performance.  
- Avoided third-party pagination libraries to keep control and transparency over logic.

---

##  Setup Instructions

1. Clone the project:
   git clone https://github.com/UmerAyubdev6996/Rick-Morty.git
2. Open in Xcode:
   open Rick&Morty.xcodeproj

3. Run the app on any iPhone simulator or device (iOS 15.6+).

---

##  Summary

The app shows how modular SwiftUI projects can stay **scalable, offline-capable, and memory efficient**, while still feeling lightweight and fast.  
Each layer has a single responsibility — making it easier to debug, extend, and maintain.

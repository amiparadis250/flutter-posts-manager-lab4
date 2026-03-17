# Posts Manager

A Flutter mobile app for viewing, creating, editing, and deleting posts using the [JSONPlaceholder](https://jsonplaceholder.typicode.com) test API.

---


## Screens
| Screen | Description |
|--------|-------------|
| Post List | Home screen — all posts in a card list |
| Post Detail | Full view of a single post |
| Post Form | Create or edit a post |

---

## API
**Base URL:** `https://jsonplaceholder.typicode.com/posts`

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Get all posts | `GET` | `/posts` |
| Create a post | `POST` | `/posts` |
| Update a post | `PUT` | `/posts/{id}` |
| Delete a post | `DELETE` | `/posts/{id}` |

---

## Project Structure
```
lib/
├── main.dart
├── models/post.dart
├── services/api_service.dart
└── screens/
    ├── post_list_screen.dart
    ├── post_detail_screen.dart
    └── post_form_screen.dart
```

---

## Run & Build
```bash
flutter pub get
flutter run

# Build APK
flutter build apk --release
```

---

## Dependencies
```yaml
http: ^1.2.0
```

> Requires internet connection at runtime. `INTERNET` permission declared in `AndroidManifest.xml`.

---

## Screenshots

<!-- Add your screenshots below -->


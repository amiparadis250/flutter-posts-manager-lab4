# Posts Manager

A Flutter mobile app for viewing, creating, editing, and deleting posts using the [JSONPlaceholder](https://jsonplaceholder.typicode.com) test API.

---

## Screenshots

<!-- Add your screenshots below -->

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



# Posts Manager
A Flutter mobile app for viewing, creating, editing, and deleting posts using the [JSONPlaceholder](https://jsonplaceholder.typicode.com) test API.
## Screenshots
![Homescreen](https://github.com/user-attachments/assets/fb1291bf-c59d-47a5-a86f-0c64323e5f91)
![SinglePostView screen](https://github.com/user-attachments/assets/d4e1cb46-df84-4069-bb37-675d1765dc83)
![Deleting post  alert](https://github.com/user-attachments/assets/93b94d4f-676c-4a3d-af8c-7e45d926411c)
![Editing post screen](https://github.com/user-attachments/assets/e892f23f-0b6b-4561-bf40-972a0528819f)
![Creating  Post screen](https://github.com/user-attachments/assets/2157efca-ceb0-4fd9-9642-3196b7d1a9d8)
## API
**Base URL:** `https://jsonplaceholder.typicode.com/posts`
| Operation | Method | Endpoint |
|-----------|--------|----------|
| Get all posts | `GET` | `/posts` |
| Create a post | `POST` | `/posts` |
| Update a post | `PUT` | `/posts/{id}` |
| Delete a post | `DELETE` | `/posts/{id}` |
## Run & Build
```bash
flutter pub get
flutter run

# Build APK
flutter build apk --release
```
## Dependencies
```yaml
http: ^1.2.0
```

> Requires internet connection at runtime. `INTERNET` permission declared in `AndroidManifest.xml`.

---



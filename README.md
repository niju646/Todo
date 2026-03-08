# Flutter Todo App with Auth & Profile Management

A Flutter Todo app demonstrating:

- Authentication with **access + refresh tokens**
- Profile screen with user info & todo stats
- Token auto-refresh on **401 errors**
- Persistent storage using **Hive**
- API calls using **Dio** with **custom interceptors**
- State management with **Riverpod**
- Dark mode & notifications toggle


## Features

- Login & Logout with **JWT tokens**
- Automatic token refresh when **access token expires**
- Persistent user data using **Hive**
- Profile screen with:
  - Total, Done, Pending todos
  - Edit profile / change password (UI only)
- Dark mode toggle
- Notifications toggle
- Safe retry mechanism for expired tokens
- Analytics screen 

---

## Tech Stack

- **Flutter** – Frontend
- **Dio** – HTTP client
- **Hive** – Local storage
- **Riverpod** – State management
- **JWT** – Authentication tokens

---

## Installation

1. Clone the repository for the application
2. Run Flutter pub get
3. Run the application

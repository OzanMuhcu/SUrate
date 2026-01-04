# SUrate 

**SUrate** is a mobile application developed specifically for Sabancı University students to facilitate informed course selections through peer reviews, ratings, and collaborative discussions.

## Motivation

At Sabancı University, students traditionally rely on scattered sources like WhatsApp groups or word-of-mouth to gather information about courses. Important details regarding exam difficulty, instructor teaching styles, and workload often get lost in chat histories or remain fragmented across different channels.

**SUrate** was built to solve this "information chaos." Our goal is to provide a **centralized, reliable platform** where students can access organized data, share their experiences, and make better academic decisions without having to dig through archived chat logs.

---

## Features

* **Secure Authentication:** Integration with Firebase Auth for secure Sign Up/Login.
* **Course Ratings:** Detailed rating system for course content, grading, and difficulty.
* **Instructor Feedback:** Specific ratings for instructor effectiveness.
* **Dynamic UI:** Dark/Light mode support and intuitive drawer navigation.
* **Discussion Boards:** Thread-based comments for Q&A on specific courses.
* **Search & Filter:** Advanced filtering by faculty and course level.

---
## Known Limitations

- The full Sabancı University course database is not included.
- To demonstrate functionality, only 1–2 sample courses from each department were added.
- Course data was intentionally limited due to time and scope constraints.

## Known Bugs

- No known bugs were identified during development.
- All implemented features worked as expected in the conducted unit and widget tests.
---

## Tech Stack

* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Authentication, Firestore Database)
* **State Management:** Provider
* **Testing:** Flutter Test (Unit & Widget Testing)

---

## Team Members

| Name | Student ID | Contribution |
| :--- | :--- | :--- |
| **Yağmur Geçim** | 32331 | Auth, Profile, Testing |
| **Berkay Bilici** | 32176 | Comments, Discussions, Video |
| **Osman Ozan Muhçu** | 32434 | Filters, Terms & Conditions |
| **Sinan Altıntuğ** | 31954 | Ratings, Main UI, Integration |
| **Yiğit Narcı** | 32419 | Navigation, Data Entry |

---

## ⚙️ Setup & Installation

Follow these steps to run the project locally:

### 1. Prerequisites
* Flutter SDK installed (Stable channel recommended).
* A physical device or an emulator (Android Studio/Xcode).
* Git installed.

### 2. Installation
Clone the repository:
```bash
git clone [https://github.com/YOUR_GITHUB_USERNAME/surate.git](https://github.com/YOUR_GITHUB_USERNAME/surate.git)
cd surate
```
### 3. Install Dependencies
* flutter pub get

### 4. Run the Application
* flutter run

### 5. How to run tests?
-The project includes unit and widget tests to verify core functionalities such as authentication validation, rating logic, and UI behavior. To run all tests:
* flutter test

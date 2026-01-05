# SUrate

**SUrate** is a mobile application developed specifically for Sabancı University students to facilitate informed course selections through peer reviews, ratings, and collaborative discussions.

## Motivation

At Sabancı University, students traditionally rely on scattered sources like WhatsApp groups or word-of-mouth to gather information about courses. Important details regarding exam difficulty, instructor teaching styles, and workload often get lost in chat histories or remain fragmented across different channels.

**SUrate** was built to solve this "information chaos." Our goal is to provide a **centralized, reliable platform** where students can access organized data, share their experiences, and make better academic decisions without having to dig through archived chat logs.

---

## Features

* **Secure Authentication:** Integration with Firebase Auth for secure Sign Up/Login.
* **Course Ratings (Difficulty Scale):** * **Stars represent "Hardness":** Unlike traditional apps where stars indicate "liking," in SUrate, star ratings strictly represent the **difficulty** of the course (Higher Stars = Higher Difficulty).
  * **Calculation Logic:** A user's hardness rating for a course is calculated automatically as the average of three factors:
  
    $$\text{Average Hardness} = \frac{\text{Overall} + \text{Midterm} + \text{Final}}{3}$$
    
  * This average is stored in our persistent database to maintain accurate difficulty metrics for the community.
* **Dynamic UI:** Dark/Light mode support and intuitive drawer navigation.
* **Discussion Boards:** Thread-based comments for Q&A on specific courses.
* **Search & Filter:** Advanced filtering by faculty and course level.

---

## Known Limitations & Future Work

* **Database Scope:** The full Sabancı University course database is not included. To demonstrate functionality, only 1–2 sample courses from each department were added due to time constraints.
* **Profile Page Functionality:**
  * While the UI includes buttons for **Change Username**, **Change Password**, and **Delete Account**, these functions are **not yet implemented** on the backend.
  * These buttons currently exist to demonstrate the intended UI design and user flow; their functional implementation is scheduled for future work.
* **Course Data:** Course data was intentionally limited due to time and scope constraints.

## Known Bugs

- Extensive manual testing and automated widget tests have been performed throughout the development process. As of the final build, no critical bugs have been identified. All core features (Authentication, Rating, Filtering, and Navigation) function as intended.

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
git clone [https://github.com/OzanMuhcu/SUrate.git](https://github.com/OzanMuhcu/SUrate.git)
cd SUrate

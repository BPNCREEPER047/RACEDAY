# 🏅 RaceDay – Event Management System

A full-stack web-based event management platform built for the South African road running, walking, and cycling community.

---

## 📋 System Description

**RaceDay** allows event organisers and participants to connect around South African road events like marathons, cycle tours, and community walks.

- **Organisers** can create and manage events, set up event categories, capture participant results, and view all enrolments for their events.
- **Participants** can browse upcoming events, enrol in events by category, track their personal results and performance history, and view route information to prepare for race day.

The system is built progressively across three parts, ending in a fully containerised, cloud-aware, API-driven platform.

---

## 👤 User Roles

### Organiser
- Create, edit, and delete events
- Manage event categories
- Capture and update participant results
- View all enrolments for any event

### Participant
- Register and log in to their account
- Browse and search upcoming events
- Enrol in events by selecting a category
- View their own enrolments and track personal results

> Role-based access is enforced at the API level (Part 2) and reflected in the MVC interface (Part 3).

---

## 📁 Repository Structure

```
RaceDay/
├── .github/
│   └── workflows/
│       └── validate-docs.yml      ← GitHub Actions CI/CD workflow
├── docs/
│   ├── erd_raceday.png            ← Entity Relationship Diagram (ERD)
│   ├── api_endpoint_plan.md       ← Full API Endpoint Plan table
│   └── raceday_database.sql       ← SQL Server database script
└── README.md                      ← This file
```

---

## ⚙️ Setup Instructions (Running the SQL Script)

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your local SQL Server instance
3. Click **File → Open → File** and navigate to `docs/raceday_database.sql`
4. Click **Execute (F5)** to run the full script
5. The script will:
   - Create the `RaceDay` database
   - Create all 6 tables with constraints and foreign keys
   - Insert realistic seed data (users, categories, events, enrolments, results, routes)
6. In the **Object Explorer**, expand `Databases → RaceDay → Tables` to verify all tables were created

> ⚠️ The script drops and recreates the database on each run — safe for a clean instance.

---

## 🎥 Video Presentation

📺 **YouTube Link:** `[PASTE YOUR YOUTUBE LINK HERE BEFORE SUBMITTING]`

The video covers:
- Walkthrough of the ERD and design decisions
- Explanation of the API endpoint plan choices
- Live run of the SQL script in SSMS

---

## ✅ CI/CD Screenshot

![CI/CD Green Build](docs/ci_screenshot.png)

<img width="1919" height="1064" alt="image" src="https://github.com/user-attachments/assets/4a74d7bd-12fc-4feb-9402-8ba6fcc47d21" />


---

## 🛠️ Tools Used

- SQL Server Management Studio (SSMS) – database design and scripting
- GitHub Actions – CI/CD workflow for document validation
- Draw.io / manual ERD design

---

## 📌 AI Usage Disclosure

> *(If you used any AI tools during planning, proofreading, or structuring — disclose briefly here as required by the assignment instructions. Example: "AI was used to assist with proofreading the README and checking SQL syntax.")*

---

*© The Independent Institute of Education (Pty) Ltd 2026 – Student Submission*

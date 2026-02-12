# ArctiLab

**Tagline:** Plan, track, and grow your hobbies — all in one place.

## Overview

ArctiLab is a beautifully designed habit and project tracker for hobbyists. It helps users organize, log, and visualize their progress across multiple hobbies — from painting and coding to gardening and music. With session tracking, project management, progress visuals, and light gamification, ArctiLab turns casual interests into meaningful journeys.

## Design

- **Primary Color:** #55BEEB (fresh, friendly cyan-blue)
- **Style:** Clean, card-based UI with soft shadows and rounded corners
- **Icons:** Minimalistic outlined SF Symbols, filled with primary color when active
- **Animations:** Smooth transitions for adding sessions, completing tasks, and leveling up

## Features

### 1. Hobby Dashboard
- Add and manage multiple hobbies with customizable categories
- Quick stats overview (Level, Total Hobbies, Total Hours)
- Today's progress tracking
- Visual hobby cards with streaks and project counts

### 2. Project & Session Tracking
- **Projects:** Break hobbies into long-term projects with progress tracking
- **Sessions:** Log time spent per session with notes, tags, and date
- **Tasks:** Create to-do lists under each project with priority levels
- Automatic progress calculation based on task completion

### 3. Progress Tracker
- Visual progress bars and rings
- Milestone markers
- Streak counters for consistency
- Project completion tracking

### 4. Calendar Integration
- Interactive calendar grid with session indicators
- Daily/weekly/monthly views
- Session history browsing
- Quick session lookup by date

### 5. Idea Bank
- Store inspiration, links, and ideas for each hobby
- Tag-based organization
- Favorites system
- Search and filter functionality

### 6. Analytics & Stats
- Time distribution by hobby
- Daily activity charts
- Weekly, monthly, and yearly views
- Completion rates and productivity trends

### 7. Gamification Layer
- **Avatar & Levels:** Earn XP from sessions and completed tasks
- **Achievements:** Unlock badges for consistency, milestones, and variety
- **Progress Tracking:** Visual XP bar and level progression
- **Predefined Achievements:**
  - First Steps (Complete first session)
  - Dedicated (7-day streak)
  - Diverse Interests (5+ hobbies)
  - Century Club (100 sessions)
  - Rising Star (Level 10)
  - Time Master (100 hours)
  - Task Crusher (50 tasks)
  - Project Pro (10 projects)

### 8. Onboarding Flow
- Welcome screen with app introduction
- Profile customization (name & avatar emoji)
- Interest selection
- Automatic hobby creation based on selections

## User Flow

1. **Onboarding:** Pick interests, set profile, customize avatar
2. **Home Dashboard:** View all hobbies, today's sessions, weekly progress
3. **Hobby Detail:** View projects, log sessions, check stats, access ideas
4. **Project Detail:** Manage tasks, log project sessions, track progress
5. **Calendar:** Browse session history and schedule
6. **Analytics:** Review time distribution and productivity insights
7. **Profile:** View avatar level, achievements, overall stats

## Technical Architecture

### Models
- `Hobby`: Main hobby entity with projects and ideas
- `Project`: Long-term goals with tasks and sessions
- `Session`: Individual practice sessions with duration and XP
- `ProjectTask`: To-do items with priority levels
- `Idea`: Inspiration storage with tags and links
- `UserProfile`: User data with level, XP, and achievements
- `Achievement`: Unlockable badges

### ViewModels
- `HobbyViewModel`: Central state management for all app data
  - Hobby/Project/Session/Task management
  - Analytics calculations
  - Achievement tracking
  - Streak calculation

### Views
- **Navigation:** `MainTabView` with 4 tabs
- **Dashboard:** `DashboardView`, `AddHobbyView`
- **Hobby Detail:** `HobbyDetailView`, `ProjectDetailView`
- **Session Tracking:** `AddSessionView`, `AddProjectView`, `AddTaskView`
- **Ideas:** `IdeaBankView`, `AddIdeaView`, `IdeaDetailView`
- **Calendar:** `CalendarView` with interactive grid
- **Analytics:** `AnalyticsView` with Charts framework
- **Profile:** `ProfileView`, `EditProfileView`, `AllAchievementsView`
- **Onboarding:** `OnboardingView` with 4-step flow

### Utilities
- Color extensions with hex support
- Date formatting extensions
- Custom view modifiers (CardStyle, Button Styles)
- Progress Ring component
- FlowLayout for tags

## Hobby Categories

- 🎨 Art
- 🎵 Music
- ⚽️ Sports
- 💻 Coding
- ✍️ Writing
- 🌱 Gardening
- 🍳 Cooking
- ✂️ Crafts
- 📸 Photography
- 📚 Reading
- 🎮 Gaming
- ⭐️ Other

## Color Scheme

- **Primary:** #55BEEB (Cyan Blue)
- **Success:** #4CAF50 (Green)
- **Warning:** #FF9800 (Orange)
- **Error:** #F44336 (Red)
- **Secondary Accents:**
  - Pink: #FF6B9D
  - Purple: #9C27B0
  - Blue: #2196F3
  - Yellow: #FFC107

## Platform

- **Target:** iOS 17.0+
- **Framework:** SwiftUI
- **Charts:** Swift Charts
- **Persistence:** In-memory (ready for Core Data/CloudKit integration)

## Future Enhancements

- Data persistence with Core Data
- iCloud sync across devices
- Photo uploads for sessions
- Reminders and notifications
- Social features (share achievements)
- Custom themes and color schemes
- Export data and statistics
- Widget support
- Apple Watch companion app

## Inspiration

- Notion (organization)
- Duolingo (gamification)
- Toggl (session tracking)
- Pinterest (idea bank)
- Minimalist design principles

---

Built with ❤️ in SwiftUI

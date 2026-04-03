# Product Requirements Document: Adhkar AI

## Project Overview
Adhkar AI is a modern iOS application designed to help users manage and track their daily Adhkar (Islamic supplications). It features a sleek, intuitive interface with robust state management, cloud synchronization, and a spaced repetition system (SRS) for memorization.

## Core Features

### 1. Authentication & Onboarding
- **Guest Mode**: Users can skip login and use the app in offline mode.
- **Real Auth**: Email/Password authentication via Supabase.
- **Apple Sign-In**: Integrated Apple authentication for a seamless experience.
- **Onboarding**: A multi-step introductory flow for new users.
- **App Tour**: An interactive walkthrough of the main interface elements.

### 2. Adhkar Management
- **Categories**: Core categories include Morning, Evening, and Daily.
- **Dhikr Interaction**:
    - Tap to increment repetition count.
    - Reset individual or category counts.
    - Toggle visibility of specific Dhikr items.
    - Reorder Daily items.
- **Custom Adhkar**: Users can add their own supplications with Arabic text, translation, and custom repetition goals.

### 3. Mastery & Progress (SRS)
- **Spaced Repetition**: Users rate their confidence for each Dhikr to schedule future reviews.
- **Statuses**: Items transition through "New", "Learning", and "Memorized" based on performance.
- **Due Items**: Automatically identifies and highlights items that need review each day.
- **Streak Tracking**: Tracks daily completion streaks (requiring both morning and evening Adhkar to be finished).
- **Progress Visualization**: 14-day activity history and overall mastery percentages.

### 4. Customization & UI
- **Themes**: Support for Light, Dark, and System modes.
- **Typography**: Adjustable Arabic font size, line spacing, and font selection.
- **Content Toggles**: Option to show/hide transliterations and translations.
- **Modern Navigation**: Custom floating pill-style bottom tab bar.

## Technical Stack
- **Framework**: SwiftUI
- **State Management**: Combine / ObservableObject (`AppState`)
- **Backend/Database**: Supabase
- **Persistence**: UserDefaults (Local) + Supabase (Cloud)
- **Authentication**: Supabase Auth + Apple Sign-In

## Testing Objectives for TestSprite
1. **Authentication Flows**: Verify login, signup, guest mode, and Apple Sign-In success/failure states.
2. **State Persistence**: Ensure that incremented counts and visibility changes persist across app restarts (simulated via state updates).
3. **SRS Logic**: Validate the transition of Dhikr items through mastery statuses based on confidence inputs.
4. **Onboarding/Tour**: Ensure the onboarding and tour flags are correctly updated and the views are dismissed appropriately.
5. **UI Responsiveness**: Verify the custom tab bar navigation and theme transitions.

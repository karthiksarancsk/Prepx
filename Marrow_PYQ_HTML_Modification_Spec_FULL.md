# Marrow PYQ — Complete HTML Modification Specification (Full Version)

## Purpose
This document defines the FULL architecture, UI, system flow, and coding standards of the Marrow PYQ application.

Use this file as a **master blueprint** to:
- Modify new HTML files
- Maintain feature parity
- Ensure consistent UX + data flow

⚠️ Migration logic intentionally excluded.

---

# 1. Core Stack
- HTML5 (SPA)
- Tailwind CSS
- Vanilla JS
- Firebase Auth
- Firestore
- localStorage

---

# 2. App State Machine
AUTH → DASHBOARD → INSTRUCTIONS → QUIZ → RESULTS → REVIEW

---

# 3. UI Sections
- Auth Screen
- Dashboard
- Instructions
- Quiz
- Results

All inside ONE HTML, toggled via JS.

---

# 4. Header System
Title + metadata + controls:
- Dark mode
- Sync
- Account

---

# 5. Design System
Cards:
- rounded
- shadow
- padded

Buttons:
- Primary
- Gray
- Warn
- Success

---

# 6. Authentication
- Email/password
- Signup
- Logout
- Auth observer

---

# 7. Dashboard
- Test cards
- Responsive grid
- Navigation

---

# 8. Instructions Screen
- Test rules
- Time
- Shortcuts

---

# 9. Quiz Engine
- MCQ selection
- Prev/Next
- Jump
- Bookmark
- Review
- Explanation
- Timer

---

# 10. Question States
- Unanswered
- Answered
- Correct
- Incorrect
- Marked
- Bookmarked

---

# 11. Navigation Grid
Clickable question index with status colors.

---

# 12. Timer
- Countdown
- Warning state
- Auto-submit logic

---

# 13. Results
- Stats (correct/wrong/etc)
- Review mode
- Retake

---

# 14. Local Storage
Key:
quiz_<testId>

Stores:
- answers
- marked
- time
- current question

---

# 15. Firebase Data
Only USER data:
- bookmarks
- progress
- completions

---

# 16. Data Separation
QUESTION DATA ≠ USER DATA

---

# 17. Sync Model
Local → UI → Cloud

---

# 18. Theme
- toggle html.dark
- persist

---

# 19. Dark Mode
Custom styles for all components.

---

# 20. Loading System
- Initial loader
- Action loader

---

# 21. Error Handling
Handle:
- auth
- network
- firebase
- data

---

# 22. Question Data
- JSON-based
- lazy-loaded

---

# 23. Lazy Loading
Use loadScriptOnce()

---

# 24. Media
- video/audio
- hidden until active

---

# 25. Responsive
Mobile-first

---

# 26. Touch UX
- large buttons
- no hover dependency

---

# 27. Modals
Reusable overlays

---

# 28. Event Flow
User → Event → State → UI → Save → Sync

---

# 29. Code Structure
1. Config
2. Firebase
3. State
4. Storage
5. Data
6. Auth
7. Sync
8. UI
9. Quiz
10. Results
11. Theme
12. Events

---

# 30. Init Flow
Load → Firebase → Auth → State → UI

---

# 31. Performance
- lazy load
- cache
- minimal writes

---

# 32. Sync Button
Manual trigger for reconciliation.

---

# 33. Keyboard Shortcuts
A/B/C/D, arrows, M, E, Enter, Esc

---

# 34. Bookmark System
Persistent + synced

---

# 35. Review System
Mark + navigate

---

# 36. Results Navigation
Separate from quiz state

---

# 37. Future Modification Rules
DO:
- Preserve data
- Preserve Firebase
- Adapt UI

DON'T:
- Break structure
- Merge all data
- Remove localStorage

---

# 38. Modification Workflow
Inspect → Map → Adapt → Test → Deliver

---

# 39. Validation Checklist
- UI works
- Auth works
- Quiz works
- Results correct
- Sync works

---

# 40. Final Rule
Match EXPERIENCE, not structure.

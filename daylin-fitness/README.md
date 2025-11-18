# Daylin Fitness 🔥

An AI-powered fitness tracking application built with Next.js 15, featuring beautiful animations, dark mode support, and personalized workout insights.

## Features

- 🎯 **Dashboard**: Track calories, recovery, strength, and workout streaks
- 💪 **Workouts**: Interactive workout player with timer and exercise tracking
- 🤖 **AI Insights**: Daily personalized insights based on your performance
- 🌙 **Dark Mode**: Beautiful light and dark themes
- ✨ **Smooth Animations**: Framer Motion-powered transitions
- 📱 **Responsive**: Works seamlessly on all devices

## Tech Stack

- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Animations**: Framer Motion
- **Icons**: Lucide React

## Project Structure

```
daylin-fitness/
├── app/                          # Next.js 15 App Router
│   ├── (auth)/                   # Auth pages (login, signup)
│   ├── dashboard/                # Dashboard page
│   ├── workout/                  # Workout pages
│   └── layout.tsx                # Root layout
├── components/
│   ├── ui/                       # Reusable primitives (Button, Card)
│   ├── dashboard/                # Dashboard-specific components
│   ├── workout/                  # Workout-specific components
│   └── shared/                   # Shared components (ThemeToggle)
├── lib/
│   ├── motion.ts                 # Framer Motion spring presets
│   └── utils.ts                  # Utility functions
├── hooks/
│   └── useStreak.ts              # Streak tracking logic
├── constants/
│   └── colors.ts                 # Brand color tokens
└── types/
    └── index.ts                  # TypeScript type definitions
```

## Getting Started

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Run the development server**:
   ```bash
   npm run dev
   ```

3. **Open your browser**:
   Navigate to [http://localhost:3000](http://localhost:3000)

## Pages

- `/` - Home (redirects to dashboard)
- `/dashboard` - Main dashboard with stats and insights
- `/workout` - Browse and start workouts
- `/login` - User login
- `/signup` - User registration

## Components

### UI Components
- **Button**: Animated button with variants (primary, secondary, ghost)
- **Card**: Container with hover lift effect

### Dashboard Components
- **ProgressRing**: Circular progress indicator with animations
- **StreakFire**: Workout streak display with fire emoji
- **AIDailyInsight**: AI-generated daily insights card
- **DashboardStatsGrid**: Grid layout for all dashboard stats

### Workout Components
- **WorkoutCard**: Preview card for workouts
- **WorkoutPlayer**: Full-screen interactive workout player

## Customization

### Colors
Edit `constants/colors.ts` to customize brand colors.

### Animations
Adjust spring presets in `lib/motion.ts`:
- `spring`: Snappy animations
- `springSoft`: Smooth animations
- `springBounce`: Bouncy animations

### Theme
Update CSS custom properties in `app/globals.css` for light/dark themes.

## Build for Production

```bash
npm run build
npm start
```

## License

MIT

---

Built with ❤️ using Next.js 15

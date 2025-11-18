# 🔥 Daylin Fitness Dashboard - Visual Preview

## Dashboard Layout (`/dashboard`)

```
┌─────────────────────────────────────────────────────────────────┐
│  Welcome back                                      [🌙/☀️]      │
│  (Gradient: Red → Purple)                    (Theme Toggle)     │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   ProgressRing   │  │   ProgressRing   │  │   ProgressRing   │
│    🔴 CALORIES   │  │   🟢 RECOVERY    │  │   🟣 STRENGTH    │
│                  │  │                  │  │                  │
│       ◯ 62%      │  │      ◯ 86%       │  │      ◯ 92%       │
│    1245/2000     │  │    86/100        │  │    92/100        │
│                  │  │                  │  │                  │
│    Calories      │  │    Recovery      │  │    Strength      │
└──────────────────┘  └──────────────────┘  └──────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         🔥 StreakFire                            │
│                                                                  │
│                             21                                   │
│                    (Huge gradient text)                          │
│                  🔥 DAY STREAK (pulsing)                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  🤖  AI Daily Insight              [Live Adaptation]            │
│                                                                  │
│     Your HRV jumped 18% overnight — we increased lower body     │
│     volume 12%. You're in peak form! 🔥                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. Header
- **Text**: "Welcome back" (5xl, bold)
- **Gradient**: Red (#E63946) → Purple (#8A2BE2)
- **Theme Toggle**: Sun/Moon icon button (animated)

### 2. Progress Rings (3 columns)

#### Calories Ring
- **Color**: Red (#E63946)
- **Value**: 1245 / 2000 = 62%
- **Animation**: Circle draws from 0 to 62% with smooth spring
- **Glow**: Red shadow effect
- **Label**: "Calories"

#### Recovery Ring
- **Color**: Green (#00C853)
- **Value**: 86%
- **Animation**: Circle draws from 0 to 86% with smooth spring
- **Glow**: Green shadow effect
- **Label**: "Recovery"

#### Strength Ring
- **Color**: Purple (#8A2BE2)
- **Value**: 92%
- **Animation**: Circle draws from 0 to 92% with smooth spring
- **Glow**: Purple shadow effect
- **Label**: "Strength"

### 3. Streak Fire
- **Number**: 21 (9xl text!)
- **Gradient**: Orange → Red → Yellow
- **Animation**: Spins and scales in with bounce
- **Icon**: Flame icon (pulsing)
- **Text**: "DAY STREAK"

### 4. AI Daily Insight Card
- **Background**: Gradient (Primary/10 → Purple/10)
- **Border**: Primary color with 30% opacity
- **Icon**: Bot icon in circular container
- **Badge**: "Live Adaptation" pill
- **Message**: Dynamic AI-generated insight
- **Animation**: Fades up smoothly

## Animations

### Entry Animations
1. **Progress Rings**: Circles animate from 0% to target value (springSoft)
2. **Percentage Numbers**: Scale from 0.8 to 1.0
3. **Streak Fire**: Rotates from -180° and scales from 0 (springBounce)
4. **AI Insight**: Fades in from bottom with y-offset (fadeInUp)

### Hover Effects
- **Theme Toggle**: Scales to 1.1 on hover, 0.9 on tap
- **All interactive elements**: Smooth transitions

## Color Palette

### Light Mode
- Background: #F5F5F5
- Surface: #FFFFFF
- Text Primary: #1A1A1A
- Text Secondary: #6B7280

### Dark Mode (Default)
- Background: #0F0F0F
- Surface: #1A1A1A
- Text Primary: #F5F5F5
- Text Secondary: #9CA3AF

### Accent Colors
- Primary: #E63946 (Red)
- Success: #00C853 (Green)
- Purple: #8A2BE2
- Orange: #FF6B35

## Responsive Design

### Mobile (< 768px)
```
┌──────────────────┐
│  Welcome back 🌙 │
└──────────────────┘

┌──────────────────┐
│  Calories 62%    │
└──────────────────┘
┌──────────────────┐
│  Recovery 86%    │
└──────────────────┘
┌──────────────────┐
│  Strength 92%    │
└──────────────────┘

┌──────────────────┐
│   21 🔥 STREAK   │
└──────────────────┘

┌──────────────────┐
│  AI Insight...   │
└──────────────────┘
```

### Desktop (≥ 768px)
- 3 column grid for progress rings
- Full-width streak display
- Full-width AI insight
- Max width: 1280px (5xl)
- Centered layout

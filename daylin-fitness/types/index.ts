export interface Exercise {
  name: string;
  description: string;
  duration: number;
  reps?: number;
  sets?: number;
}

export interface Workout {
  id: string;
  title: string;
  description: string;
  duration: number;
  difficulty: "Beginner" | "Intermediate" | "Advanced";
  thumbnail?: string;
  exercises?: Exercise[];
}

export interface UserStats {
  calories: number;
  caloriesGoal: number;
  recovery: number;
  strength: number;
  streak: number;
}

export interface DailyInsight {
  message: string;
  timestamp: Date;
  type: "hrv" | "performance" | "recovery" | "motivation";
}

export interface UserProfile {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  stats: UserStats;
  createdAt: Date;
}

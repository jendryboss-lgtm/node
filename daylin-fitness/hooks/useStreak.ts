"use client";

import { useState, useEffect } from "react";

export const useStreak = () => {
  const [streak, setStreak] = useState(0);
  const [lastWorkoutDate, setLastWorkoutDate] = useState<Date | null>(null);

  useEffect(() => {
    // Load streak from localStorage
    const savedStreak = localStorage.getItem("workout_streak");
    const savedDate = localStorage.getItem("last_workout_date");

    if (savedStreak) {
      setStreak(parseInt(savedStreak, 10));
    }

    if (savedDate) {
      setLastWorkoutDate(new Date(savedDate));
    }
  }, []);

  const incrementStreak = () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (!lastWorkoutDate) {
      // First workout
      setStreak(1);
      setLastWorkoutDate(today);
      localStorage.setItem("workout_streak", "1");
      localStorage.setItem("last_workout_date", today.toISOString());
      return;
    }

    const lastDate = new Date(lastWorkoutDate);
    lastDate.setHours(0, 0, 0, 0);

    const daysDiff = Math.floor((today.getTime() - lastDate.getTime()) / (1000 * 60 * 60 * 24));

    if (daysDiff === 0) {
      // Already worked out today
      return;
    } else if (daysDiff === 1) {
      // Consecutive day
      const newStreak = streak + 1;
      setStreak(newStreak);
      setLastWorkoutDate(today);
      localStorage.setItem("workout_streak", newStreak.toString());
      localStorage.setItem("last_workout_date", today.toISOString());
    } else {
      // Streak broken
      setStreak(1);
      setLastWorkoutDate(today);
      localStorage.setItem("workout_streak", "1");
      localStorage.setItem("last_workout_date", today.toISOString());
    }
  };

  const resetStreak = () => {
    setStreak(0);
    setLastWorkoutDate(null);
    localStorage.removeItem("workout_streak");
    localStorage.removeItem("last_workout_date");
  };

  return {
    streak,
    lastWorkoutDate,
    incrementStreak,
    resetStreak,
  };
};

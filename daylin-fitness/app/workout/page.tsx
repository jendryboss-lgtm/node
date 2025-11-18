"use client";

import { useState } from "react";
import { WorkoutCard } from "@/components/workout/WorkoutCard";
import { WorkoutPlayer } from "@/components/workout/WorkoutPlayer";
import { ThemeToggle } from "@/components/shared/ThemeToggle";
import { Workout } from "@/types";

const sampleWorkouts: Workout[] = [
  {
    id: "1",
    title: "HIIT Cardio Blast",
    description: "High-intensity interval training to burn calories and build endurance",
    duration: 20,
    difficulty: "Advanced",
    exercises: [
      { name: "Jumping Jacks", description: "Full body warm-up", duration: 30 },
      { name: "Burpees", description: "Explosive full body movement", duration: 30 },
      { name: "Mountain Climbers", description: "Core and cardio combo", duration: 30 },
      { name: "High Knees", description: "Fast-paced cardio", duration: 30 },
    ],
  },
  {
    id: "2",
    title: "Core Strength",
    description: "Build a powerful core with targeted exercises",
    duration: 15,
    difficulty: "Intermediate",
    exercises: [
      { name: "Plank Hold", description: "Static core stability", duration: 45 },
      { name: "Russian Twists", description: "Oblique targeting", duration: 30 },
      { name: "Bicycle Crunches", description: "Dynamic ab work", duration: 30 },
    ],
  },
  {
    id: "3",
    title: "Beginner Full Body",
    description: "Perfect introduction to strength training",
    duration: 25,
    difficulty: "Beginner",
    exercises: [
      { name: "Bodyweight Squats", description: "Lower body foundation", duration: 30 },
      { name: "Push-ups", description: "Upper body strength", duration: 30 },
      { name: "Lunges", description: "Single leg strength", duration: 30 },
    ],
  },
];

export default function WorkoutPage() {
  const [activeWorkout, setActiveWorkout] = useState<Workout | null>(null);

  return (
    <main className="min-h-screen p-6 bg-background">
      <div className="max-w-6xl mx-auto">
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-5xl font-black bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">
            Workouts
          </h1>
          <ThemeToggle />
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {sampleWorkouts.map((workout) => (
            <WorkoutCard
              key={workout.id}
              workout={workout}
              onStart={() => setActiveWorkout(workout)}
            />
          ))}
        </div>
      </div>

      {activeWorkout && (
        <WorkoutPlayer
          workout={activeWorkout}
          onComplete={() => {
            alert("Workout completed! Great job! 🔥");
            setActiveWorkout(null);
          }}
          onExit={() => setActiveWorkout(null)}
        />
      )}
    </main>
  );
}

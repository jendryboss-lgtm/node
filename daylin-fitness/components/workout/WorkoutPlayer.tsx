"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Play, Pause, SkipForward, X } from "lucide-react";
import { Workout } from "@/types";
import { spring } from "@/lib/motion";

interface WorkoutPlayerProps {
  workout: Workout;
  onComplete?: () => void;
  onExit?: () => void;
}

export const WorkoutPlayer = ({ workout, onComplete, onExit }: WorkoutPlayerProps) => {
  const [currentExerciseIndex, setCurrentExerciseIndex] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [timeRemaining, setTimeRemaining] = useState(30);

  const currentExercise = workout.exercises?.[currentExerciseIndex];

  useEffect(() => {
    if (!isPlaying) return;

    const timer = setInterval(() => {
      setTimeRemaining((prev) => {
        if (prev <= 1) {
          handleNext();
          return 30;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [isPlaying, currentExerciseIndex]);

  const handleNext = () => {
    if (currentExerciseIndex < (workout.exercises?.length || 0) - 1) {
      setCurrentExerciseIndex((prev) => prev + 1);
      setTimeRemaining(30);
    } else {
      setIsPlaying(false);
      onComplete?.();
    }
  };

  return (
    <div className="fixed inset-0 bg-background/95 backdrop-blur-sm z-50 flex items-center justify-center p-6">
      <motion.div
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={spring}
        className="w-full max-w-4xl"
      >
        <Card className="relative">
          <button
            onClick={onExit}
            className="absolute top-4 right-4 p-2 rounded-full hover:bg-surface"
          >
            <X className="w-6 h-6" />
          </button>

          <div className="flex flex-col items-center gap-8 py-8">
            <h2 className="text-3xl font-black text-text-primary">{workout.title}</h2>

            {currentExercise && (
              <>
                <motion.div
                  key={currentExerciseIndex}
                  initial={{ scale: 0.8, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  transition={spring}
                  className="text-center"
                >
                  <h3 className="text-5xl font-black text-primary mb-4">{currentExercise.name}</h3>
                  <p className="text-text-secondary text-lg">{currentExercise.description}</p>
                </motion.div>

                <motion.div
                  className="text-9xl font-black bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent"
                  animate={{ scale: isPlaying ? [1, 1.1, 1] : 1 }}
                  transition={{ duration: 1, repeat: isPlaying ? Infinity : 0 }}
                >
                  {timeRemaining}
                </motion.div>

                <div className="flex items-center gap-4">
                  <Button
                    onClick={() => setIsPlaying(!isPlaying)}
                    variant="primary"
                  >
                    {isPlaying ? <Pause className="w-6 h-6" /> : <Play className="w-6 h-6" />}
                  </Button>
                  <Button onClick={handleNext} variant="secondary">
                    <SkipForward className="w-6 h-6" />
                  </Button>
                </div>

                <div className="text-text-secondary">
                  Exercise {currentExerciseIndex + 1} of {workout.exercises?.length || 0}
                </div>
              </>
            )}
          </div>
        </Card>
      </motion.div>
    </div>
  );
};

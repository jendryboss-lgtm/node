import { motion } from "framer-motion";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { CheckCircle, Clock, Flame } from "lucide-react";
import { fadeInUp } from "@/lib/motion";
import Link from "next/link";

interface WorkoutHistoryItem {
  id: string;
  title: string;
  date: string;
  duration: number;
  caloriesBurned: number;
  completed: boolean;
}

export const RecentWorkouts = () => {
  const recentWorkouts: WorkoutHistoryItem[] = [
    {
      id: "1",
      title: "HIIT Cardio Blast",
      date: "Today, 7:30 AM",
      duration: 20,
      caloriesBurned: 245,
      completed: true,
    },
    {
      id: "2",
      title: "Core Strength",
      date: "Yesterday, 6:00 PM",
      duration: 15,
      caloriesBurned: 180,
      completed: true,
    },
    {
      id: "3",
      title: "Full Body Power",
      date: "2 days ago",
      duration: 30,
      caloriesBurned: 320,
      completed: true,
    },
  ];

  return (
    <Card className="mb-8">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-black text-text-primary">Recent Workouts</h2>
        <Link href="/workout">
          <Button variant="ghost" className="text-sm px-4 py-2">
            View All
          </Button>
        </Link>
      </div>

      <div className="space-y-4">
        {recentWorkouts.map((workout, index) => (
          <motion.div
            key={workout.id}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: index * 0.1 }}
            className="flex items-center gap-4 p-4 rounded-2xl bg-surface border border-border hover:border-primary transition-colors cursor-pointer"
          >
            <div className="w-12 h-12 rounded-xl bg-green-900 flex items-center justify-center flex-shrink-0">
              <CheckCircle className="w-6 h-6 text-green-500" />
            </div>

            <div className="flex-1">
              <h3 className="font-bold text-text-primary">{workout.title}</h3>
              <p className="text-sm text-text-secondary">{workout.date}</p>
            </div>

            <div className="flex items-center gap-6 text-sm text-text-secondary">
              <div className="flex items-center gap-1">
                <Clock className="w-4 h-4" />
                <span>{workout.duration} min</span>
              </div>
              <div className="flex items-center gap-1">
                <Flame className="w-4 h-4 text-orange-500" />
                <span className="font-semibold">{workout.caloriesBurned} cal</span>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </Card>
  );
};

import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Clock, Flame } from "lucide-react";
import { Workout } from "@/types";

interface WorkoutCardProps {
  workout: Workout;
  onStart?: () => void;
}

export const WorkoutCard = ({ workout, onStart }: WorkoutCardProps) => {
  return (
    <Card>
      <div className="flex flex-col gap-4">
        <div className="aspect-video rounded-2xl bg-gradient-to-br from-primary/20 to-purple-600/20 flex items-center justify-center overflow-hidden">
          {workout.thumbnail ? (
            <img src={workout.thumbnail} alt={workout.title} className="w-full h-full object-cover" />
          ) : (
            <Flame className="w-16 h-16 text-primary" />
          )}
        </div>

        <div>
          <h3 className="text-xl font-bold text-text-primary">{workout.title}</h3>
          <p className="text-text-secondary mt-2">{workout.description}</p>
        </div>

        <div className="flex items-center gap-4 text-sm text-text-secondary">
          <div className="flex items-center gap-1">
            <Clock className="w-4 h-4" />
            <span>{workout.duration} min</span>
          </div>
          <div className="flex items-center gap-1">
            <Flame className="w-4 h-4" />
            <span>{workout.difficulty}</span>
          </div>
        </div>

        <Button onClick={onStart} variant="primary">
          Start Workout
        </Button>
      </div>
    </Card>
  );
};

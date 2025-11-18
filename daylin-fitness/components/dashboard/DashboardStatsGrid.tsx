import { ProgressRing } from "./ProgressRing";
import { StreakFire } from "./StreakFire";
import { AIDailyInsight } from "./AIDailyInsight";

export const DashboardStatsGrid = () => {
  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
      <ProgressRing value={1245} max={2000} label="Calories" color="#E63946" />
      <ProgressRing value={86} label="Recovery" color="#00C853" />
      <ProgressRing value={92} label="Strength" color="#8A2BE2" />

      <div className="md:col-span-3 flex justify-center">
        <StreakFire streak={21} size="large" />
      </div>

      <div className="md:col-span-3">
        <AIDailyInsight
          message="Your HRV jumped 18% overnight — we increased lower body volume 12%. You're in peak form! 🔥"
        />
      </div>
    </div>
  );
};

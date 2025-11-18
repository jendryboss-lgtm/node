import { motion } from "framer-motion";
import { Flame } from "lucide-react";
import { springBounce } from "@/lib/motion";

interface StreakFireProps {
  streak: number;
  size?: "small" | "large";
}

export const StreakFire = ({ streak, size = "small" }: StreakFireProps) => {
  const scale = size === "large" ? "text-9xl" : "text-6xl";

  return (
    <motion.div
      initial={{ scale: 0, rotate: -180 }}
      animate={{ scale: 1, rotate: 0 }}
      transition={springBounce}
      className="flex flex-col items-center"
    >
      <div className={`font-black ${scale} bg-gradient-to-r from-orange-500 via-red-500 to-yellow-500 bg-clip-text text-transparent leading-none`}>
        {streak}
      </div>
      <div className="flex items-center gap-2 mt-2">
        <Flame className="w-8 h-8 text-orange-500 animate-pulse" fill="currentColor" />
        <span className="text-xl font-bold text-text-primary">DAY STREAK</span>
      </div>
    </motion.div>
  );
};

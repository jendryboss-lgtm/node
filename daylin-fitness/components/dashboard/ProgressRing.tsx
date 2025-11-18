import { motion } from "framer-motion";
import { springSoft } from "@/lib/motion";

interface ProgressRingProps {
  value: number;
  max?: number;
  size?: number;
  stroke?: number;
  color?: string;
  label?: string;
}

export const ProgressRing = ({
  value,
  max = 100,
  size = 160,
  stroke = 12,
  color = "#E63946",
  label
}: ProgressRingProps) => {
  const progress = (value / max) * 100;
  const radius = (size - stroke) / 2;
  const circumference = radius * 2 * Math.PI;
  const offset = circumference - (progress / 100) * circumference;

  return (
    <div className="relative flex flex-col items-center">
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size/2} cy={size/2} r={radius} stroke="#222222" strokeWidth={stroke} fill="none" opacity="0.3" />
        <motion.circle
          cx={size/2} cy={size/2} r={radius}
          stroke={color}
          strokeWidth={stroke}
          fill="none"
          strokeLinecap="round"
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: offset }}
          transition={springSoft}
          style={{ strokeDasharray: circumference }}
          className="drop-shadow-glow"
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <motion.span
          initial={{ scale: 0.8 }}
          animate={{ scale: 1 }}
          className="text-4xl font-black text-text-primary"
        >
          {Math.round(progress)}%
        </motion.span>
        {label && <span className="text-sm text-text-secondary mt-1">{label}</span>}
      </div>
    </div>
  );
};

import { motion } from "framer-motion";
import { cn } from "@/lib/utils";
import { spring } from "@/lib/motion";

interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  hoverLift?: boolean;
}

export const Card = ({ className, hoverLift = true, ...props }: CardProps) => (
  <motion.div
    whileHover={hoverLift ? { y: -8, scale: 1.02 } : {}}
    transition={spring}
    className={cn(
      "rounded-3xl bg-surface border border-border p-6 shadow-xl",
      className
    )}
    {...props}
  />
);

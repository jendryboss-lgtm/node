import { motion } from "framer-motion";
import { cn } from "@/lib/utils";
import { spring } from "@/lib/motion";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "ghost";
  loading?: boolean;
}

export const Button = ({
  children,
  variant = "primary",
  loading,
  className,
  ...props
}: ButtonProps) => {
  const variants = {
    primary: "bg-primary text-white hover:bg-primary-hover",
    secondary: "bg-surface border border-border hover:bg-background/50",
    ghost: "hover:bg-primary/10 text-primary"
  };

  return (
    <motion.button
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      transition={spring}
      className={cn(
        "px-8 py-4 rounded-full font-semibold text-base transition-all disabled:opacity-50",
        variants[variant],
        className
      )}
      disabled={loading}
      {...props}
    >
      {loading ? "..." : children}
    </motion.button>
  );
};

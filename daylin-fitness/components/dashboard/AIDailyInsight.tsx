import { motion } from "framer-motion";
import { Bot } from "lucide-react";
import { Card } from "@/components/ui/Card";
import { fadeInUp } from "@/lib/motion";

interface AIDailyInsightProps {
  message: string;
  avatar?: string;
}

export const AIDailyInsight = ({ message, avatar = "/coach-avatar.png" }: AIDailyInsightProps) => {
  return (
    <motion.div {...fadeInUp}>
      <Card className="bg-gradient-to-r from-primary/10 to-purple-600/10 border-primary/30">
        <div className="flex gap-4">
          <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">
            <Bot className="w-8 h-8 text-primary" />
          </div>
          <div>
            <h3 className="font-bold text-lg flex items-center gap-2">
              AI Daily Insight
              <span className="text-xs bg-primary/20 px-2 py-1 rounded-full">Live Adaptation</span>
            </h3>
            <p className="text-text-primary mt-2 leading-relaxed">{message}</p>
          </div>
        </div>
      </Card>
    </motion.div>
  );
};

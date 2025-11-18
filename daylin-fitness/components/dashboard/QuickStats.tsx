import { motion } from "framer-motion";
import { Card } from "@/components/ui/Card";
import { TrendingUp, Zap, Activity, Target } from "lucide-react";
import { spring } from "@/lib/motion";

interface StatItemProps {
  icon: React.ReactNode;
  label: string;
  value: string;
  trend?: string;
  color: string;
}

const StatItem = ({ icon, label, value, trend, color }: StatItemProps) => (
  <motion.div
    whileHover={{ scale: 1.05 }}
    transition={spring}
    className="flex items-center gap-3 p-4 rounded-2xl bg-surface/50 border border-border"
  >
    <div className={`p-3 rounded-xl ${color}`}>
      {icon}
    </div>
    <div className="flex-1">
      <p className="text-sm text-text-secondary">{label}</p>
      <p className="text-2xl font-black text-text-primary">{value}</p>
      {trend && (
        <p className="text-xs text-green-500 flex items-center gap-1 mt-1">
          <TrendingUp className="w-3 h-3" />
          {trend}
        </p>
      )}
    </div>
  </motion.div>
);

export const QuickStats = () => {
  return (
    <Card className="mb-8">
      <h2 className="text-2xl font-black text-text-primary mb-6">Quick Stats</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatItem
          icon={<Zap className="w-6 h-6 text-yellow-500" />}
          label="Active Minutes"
          value="245"
          trend="+12% this week"
          color="bg-yellow-500/10"
        />
        <StatItem
          icon={<Activity className="w-6 h-6 text-blue-500" />}
          label="Avg Heart Rate"
          value="142 bpm"
          trend="+5 bpm"
          color="bg-blue-500/10"
        />
        <StatItem
          icon={<Target className="w-6 h-6 text-green-500" />}
          label="Goals Hit"
          value="18/21"
          trend="86% success"
          color="bg-green-500/10"
        />
        <StatItem
          icon={<TrendingUp className="w-6 h-6 text-purple-500" />}
          label="Weight Lifted"
          value="2.4k lbs"
          trend="+18% this week"
          color="bg-purple-500/10"
        />
      </div>
    </Card>
  );
};

import { motion } from "framer-motion";
import { Card } from "@/components/ui/Card";
import { spring } from "@/lib/motion";

interface DayData {
  day: string;
  value: number;
  label: string;
}

export const WeeklyProgress = () => {
  const weekData: DayData[] = [
    { day: "Mon", value: 85, label: "85%" },
    { day: "Tue", value: 92, label: "92%" },
    { day: "Wed", value: 78, label: "78%" },
    { day: "Thu", value: 95, label: "95%" },
    { day: "Fri", value: 88, label: "88%" },
    { day: "Sat", value: 100, label: "100%" },
    { day: "Sun", value: 72, label: "72%" },
  ];

  const maxHeight = 200;

  return (
    <Card className="mb-8">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-black text-text-primary">Weekly Activity</h2>
        <div className="flex items-center gap-2 text-sm text-text-secondary">
          <div className="w-3 h-3 rounded-full bg-primary"></div>
          <span>Goal Completion</span>
        </div>
      </div>

      <div className="flex items-end justify-between gap-4 h-64">
        {weekData.map((data, index) => (
          <div key={data.day} className="flex-1 flex flex-col items-center gap-2">
            <div className="relative w-full flex items-end justify-center" style={{ height: maxHeight }}>
              <motion.div
                initial={{ height: 0 }}
                animate={{ height: `${(data.value / 100) * maxHeight}px` }}
                transition={{ ...spring, delay: index * 0.1 }}
                className="w-full rounded-t-lg bg-gradient-to-t from-primary to-purple-600 relative group cursor-pointer"
              >
                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 + 0.3 }}
                  className="absolute -top-8 left-1/2 -translate-x-1/2 text-sm font-bold text-text-primary opacity-0 group-hover:opacity-100 transition-opacity"
                >
                  {data.label}
                </motion.div>
              </motion.div>
            </div>
            <span className="text-sm font-semibold text-text-secondary">{data.day}</span>
          </div>
        ))}
      </div>
    </Card>
  );
};

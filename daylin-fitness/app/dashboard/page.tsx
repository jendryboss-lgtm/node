import { DashboardStatsGrid } from "@/components/dashboard/DashboardStatsGrid";
import { ThemeToggle } from "@/components/shared/ThemeToggle";

export default function DashboardPage() {
  return (
    <main className="min-h-screen p-6 bg-background">
      <div className="max-w-5xl mx-auto">
        <header className="flex justify-between items-center mb-12">
          <h1 className="text-5xl font-black bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">
            Welcome back
          </h1>
          <ThemeToggle />
        </header>

        <DashboardStatsGrid />
      </div>
    </main>
  );
}

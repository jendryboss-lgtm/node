import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Daylin Fitness - AI-Powered Workout Tracker",
  description: "Transform your fitness journey with AI-powered insights and personalized workouts",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}

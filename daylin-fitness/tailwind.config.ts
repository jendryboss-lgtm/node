import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        surface: "var(--surface)",
        primary: "var(--primary)",
        "primary-hover": "var(--primary-hover)",
        border: "var(--border)",
        "text-primary": "var(--text-primary)",
        "text-secondary": "var(--text-secondary)",
      },
      dropShadow: {
        glow: [
          "0 0 20px rgba(230, 57, 70, 0.5)",
          "0 0 40px rgba(230, 57, 70, 0.3)",
        ],
      },
    },
  },
  plugins: [],
};

export default config;

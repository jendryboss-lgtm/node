export const spring = { type: "spring", stiffness: 400, damping: 30 } as const;
export const springSoft = { type: "spring", stiffness: 300, damping: 35 } as const;
export const springBounce = { type: "spring", stiffness: 600, damping: 20 } as const;

export const fadeInUp = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  transition: springSoft,
} as const;

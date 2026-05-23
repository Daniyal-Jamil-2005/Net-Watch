import { Sun, Moon } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import { motion } from 'motion/react';

export function ThemeToggle() {
  const { theme, toggleTheme } = useTheme();

  return (
    <motion.button
      onClick={toggleTheme}
      className="w-11 h-11 flex items-center justify-center rounded-xl bg-gradient-to-br from-slate-100 to-slate-200 dark:from-slate-700 dark:to-slate-800 hover:from-blue-100 hover:to-indigo-100 dark:hover:from-blue-900 dark:hover:to-indigo-900 transition-all duration-300 shadow-lg hover:shadow-xl"
      aria-label="Toggle theme"
      whileHover={{ scale: 1.1, rotate: 15 }}
      whileTap={{ scale: 0.95 }}
    >
      <motion.div
        initial={false}
        animate={{
          rotate: theme === 'dark' ? 0 : 180,
          scale: 1
        }}
        transition={{ duration: 0.5, type: "spring", stiffness: 200, damping: 15 }}
      >
        {theme === 'dark' ? (
          <Moon size={20} className="text-blue-400 drop-shadow-lg" strokeWidth={2.5} />
        ) : (
          <Sun size={20} className="text-amber-500 drop-shadow-lg" strokeWidth={2.5} />
        )}
      </motion.div>
    </motion.button>
  );
}

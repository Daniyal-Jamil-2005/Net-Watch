import { Outlet, useLocation, Link } from 'react-router';
import { Home, Activity, Smartphone, Zap, Router } from 'lucide-react';
import { motion } from 'motion/react';

export function AppLayout() {
  const location = useLocation();

  const tabs = [
    { path: '/app', icon: Home, label: 'Overview' },
    { path: '/app/health', icon: Activity, label: 'Health' },
    { path: '/app/my-device', icon: Smartphone, label: 'My Device' },
    { path: '/app/hogs', icon: Zap, label: 'Hogs' },
    { path: '/app/router', icon: Router, label: 'Router' },
  ];

  return (
    <div className="h-screen w-full bg-gradient-to-br from-slate-50 to-blue-50 dark:from-slate-950 dark:to-slate-900 flex flex-col">
      <div className="flex-1 overflow-y-auto">
        <Outlet />
      </div>

      <nav className="h-[60px] border-t border-slate-200 dark:border-slate-700 bg-white/90 dark:bg-slate-900/90 backdrop-blur-xl flex items-center justify-around px-2 flex-shrink-0 shadow-2xl shadow-slate-900/10">
        {tabs.map(({ path, icon: Icon, label }) => {
          const isActive = location.pathname === path;
          return (
            <Link
              key={path}
              to={path}
              className={`flex flex-col items-center justify-center gap-1.5 px-3 py-1.5 relative rounded-xl transition-all duration-300 ${
                isActive ? 'bg-blue-50 dark:bg-blue-900/20' : 'hover:bg-slate-100 dark:hover:bg-slate-800'
              }`}
            >
              <Icon
                size={24}
                className={`transition-all duration-300 ${
                  isActive
                    ? 'text-blue-600 dark:text-blue-400 drop-shadow-lg'
                    : 'text-slate-900 dark:text-slate-50'
                }`}
                strokeWidth={isActive ? 2.5 : 2}
              />
              <span className={`text-[10px] font-bold transition-all duration-300 ${
                isActive
                  ? 'text-blue-600 dark:text-blue-400'
                  : 'text-slate-900 dark:text-slate-50'
              }`}>
                {label}
              </span>
              {isActive && (
                <motion.div
                  layoutId="activeTab"
                  className="absolute top-0 left-0 right-0 h-[3px] bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full shadow-lg shadow-blue-500/50"
                  transition={{ type: "spring", stiffness: 300, damping: 30 }}
                />
              )}
            </Link>
          );
        })}
      </nav>
    </div>
  );
}

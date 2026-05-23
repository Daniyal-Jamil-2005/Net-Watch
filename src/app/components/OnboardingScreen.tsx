import { useState } from 'react';
import { useNavigate } from 'react-router';
import { MapPin, Wifi, BarChart3 } from 'lucide-react';
import { motion } from 'motion/react';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';

export function OnboardingScreen() {
  const navigate = useNavigate();
  const [permissions, setPermissions] = useState({
    location: false,
    wifi: false,
    network: false,
  });

  const handleContinue = () => {
    navigate('/app');
  };

  return (
    <div className="h-screen w-full bg-gradient-to-br from-slate-50 to-blue-50 dark:from-slate-950 dark:to-slate-900 overflow-y-auto pb-6 relative">
      <NetworkBackground />
      <div className="absolute top-4 right-4 z-10">
        <ThemeToggle />
      </div>
      <div className="max-w-[390px] mx-auto px-6 pt-16 relative z-10">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="flex flex-col items-center"
        >
          <motion.div
            className="w-full bg-gradient-to-br from-blue-400 to-indigo-600 dark:from-blue-600 dark:to-indigo-800 rounded-3xl p-12 flex items-center justify-center mb-10 shadow-2xl shadow-blue-500/30"
            style={{ aspectRatio: '1.5' }}
            whileHover={{ scale: 1.02 }}
            transition={{ type: "spring", stiffness: 300 }}
          >
            <div className="relative">
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.3, type: "spring", stiffness: 200 }}
              >
                <svg width="140" height="140" viewBox="0 0 140 140" fill="none">
                  <motion.circle
                    cx="70" cy="70" r="8"
                    fill="white"
                    initial={{ scale: 0 }}
                    animate={{ scale: [1, 1.2, 1] }}
                    transition={{ delay: 0.5, duration: 2, repeat: Infinity }}
                  />
                  <circle cx="40" cy="40" r="6" fill="white" opacity="0.9" />
                  <circle cx="100" cy="40" r="6" fill="white" opacity="0.9" />
                  <circle cx="40" cy="100" r="6" fill="white" opacity="0.9" />
                  <circle cx="100" cy="100" r="6" fill="white" opacity="0.9" />
                  <motion.line
                    x1="70" y1="70" x2="40" y2="40"
                    stroke="white"
                    strokeWidth="3"
                    opacity="0.8"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ delay: 0.6, duration: 0.5 }}
                  />
                  <motion.line
                    x1="70" y1="70" x2="100" y2="40"
                    stroke="white"
                    strokeWidth="3"
                    opacity="0.8"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ delay: 0.7, duration: 0.5 }}
                  />
                  <motion.line
                    x1="70" y1="70" x2="40" y2="100"
                    stroke="white"
                    strokeWidth="3"
                    opacity="0.8"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ delay: 0.8, duration: 0.5 }}
                  />
                  <motion.line
                    x1="70" y1="70" x2="100" y2="100"
                    stroke="white"
                    strokeWidth="3"
                    opacity="0.8"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ delay: 0.9, duration: 0.5 }}
                  />
                </svg>
              </motion.div>
            </div>
          </motion.div>

          <motion.h1
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.4 }}
            className="text-[32px] font-bold text-slate-900 dark:text-slate-50 tracking-tight mb-3"
          >
            NetWatch
          </motion.h1>
          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5 }}
            className="text-[15px] text-slate-600 dark:text-slate-400 mb-10"
          >
            Understand every device on your network
          </motion.p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4, duration: 0.5 }}
          className="space-y-4 mb-8"
        >
          <PermissionCard
            icon={MapPin}
            label="Location access"
            sublabel="Find nearby networks and devices"
            granted={permissions.location}
            onToggle={() => setPermissions(p => ({ ...p, location: !p.location }))}
          />
          <PermissionCard
            icon={Wifi}
            label="WiFi information"
            sublabel="View network name and status"
            granted={permissions.wifi}
            onToggle={() => setPermissions(p => ({ ...p, wifi: !p.wifi }))}
          />
          <PermissionCard
            icon={BarChart3}
            label="Network monitoring"
            sublabel="Scan devices and track usage"
            granted={permissions.network}
            onToggle={() => setPermissions(p => ({ ...p, network: !p.network }))}
          />
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8 }}
        >
          <motion.button
            onClick={handleContinue}
            className="w-full h-[58px] bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white rounded-2xl font-semibold text-[16px] shadow-xl shadow-blue-500/30 transition-all duration-300"
            whileHover={{ scale: 1.02, boxShadow: "0 20px 40px rgba(59, 130, 246, 0.4)" }}
            whileTap={{ scale: 0.98 }}
          >
            Grant permissions & continue
          </motion.button>
          <button className="w-full mt-4 text-[13px] text-slate-600 dark:text-slate-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors font-medium">
            Learn why we need these
          </button>
        </motion.div>
      </div>
    </div>
  );
}

function PermissionCard({
  icon: Icon,
  label,
  sublabel,
  granted,
  onToggle
}: {
  icon: any;
  label: string;
  sublabel: string;
  granted: boolean;
  onToggle: () => void;
}) {
  return (
    <motion.div
      className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-5 flex items-center gap-4 shadow-lg hover:shadow-xl hover:border-blue-300 dark:hover:border-blue-600 transition-all duration-300"
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      <div className={`w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 transition-all duration-300 ${
        granted
          ? 'bg-gradient-to-br from-blue-500 to-indigo-600 shadow-lg shadow-blue-500/30'
          : 'bg-slate-100 dark:bg-slate-700'
      }`}>
        <Icon
          size={22}
          className={granted ? 'text-white' : 'text-slate-500 dark:text-slate-400'}
          strokeWidth={2.5}
        />
      </div>
      <div className="flex-1 min-w-0">
        <div className="text-[14px] font-semibold text-slate-900 dark:text-slate-50 mb-1">{label}</div>
        <div className="text-[11px] text-slate-600 dark:text-slate-400 leading-tight">{sublabel}</div>
      </div>
      <button
        onClick={onToggle}
        className={`flex-shrink-0 w-[50px] h-[28px] rounded-full transition-all duration-300 relative ${
          granted
            ? 'bg-gradient-to-r from-blue-500 to-indigo-600 shadow-lg shadow-blue-500/40'
            : 'bg-slate-300 dark:bg-slate-600'
        }`}
      >
        <motion.div
          className="absolute top-[3px] w-[22px] h-[22px] bg-white rounded-full shadow-md"
          animate={{ left: granted ? '25px' : '3px' }}
          transition={{ type: "spring", stiffness: 500, damping: 30 }}
        />
      </button>
    </motion.div>
  );
}

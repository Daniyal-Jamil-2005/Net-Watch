import { useState } from 'react';
import { useNavigate } from 'react-router';
import { ChevronLeft, Router, Lock, Smartphone, Laptop, Tv, Zap } from 'lucide-react';
import { motion } from 'motion/react';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';

export function RouterScreen() {
  const navigate = useNavigate();
  const [blockedDevices, setBlockedDevices] = useState<Set<string>>(new Set());

  const devices = [
    { id: '1', name: 'iPhone 14', ip: '192.168.0.10', icon: Smartphone, download: 4.2, upload: 0.8, usage: 85 },
    { id: '2', name: 'MacBook Pro', ip: '192.168.0.11', icon: Laptop, download: 1.3, upload: 0.3, usage: 45 },
    { id: '3', name: 'Samsung Smart TV', ip: '192.168.0.15', icon: Tv, download: 8.7, upload: 0.1, usage: 95 },
    { id: '4', name: 'iPad Air', ip: '192.168.0.12', icon: Smartphone, download: 0.5, upload: 0.1, usage: 20 },
  ];

  const toggleBlock = (deviceId: string) => {
    setBlockedDevices(prev => {
      const next = new Set(prev);
      if (next.has(deviceId)) {
        next.delete(deviceId);
      } else {
        next.add(deviceId);
      }
      return next;
    });
  };

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-between border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <div className="flex items-center gap-2">
          <Router size={18} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />
          <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">Router</h1>
        </div>
        <div className="flex items-center gap-2">
          <ThemeToggle />
          <span className="text-[11px] font-mono text-slate-600 dark:text-slate-400">TP-Link Archer C6</span>
          <Lock size={14} className="text-emerald-500" strokeWidth={2.5} />
        </div>
      </div>

      <div className="px-4 pt-4 space-y-5">
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 shadow-xl"
        >
          <div className="flex items-center gap-3 mb-3">
            <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg shadow-blue-500/30">
              <Router size={24} className="text-white drop-shadow" strokeWidth={2.5} />
            </div>
            <div className="flex-1">
              <div className="text-[15px] font-semibold text-slate-900 dark:text-slate-50">TP-Link Archer C6</div>
              <div className="text-[12px] font-mono text-slate-600 dark:text-slate-400">192.168.0.1</div>
            </div>
          </div>

          <div className="flex gap-2 flex-wrap text-[11px]">
            <div className="bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 px-2 py-1 rounded font-mono font-semibold">Firmware: V1.2.1</div>
            <div className="bg-emerald-50 dark:bg-emerald-900/20 text-emerald-700 dark:text-emerald-300 px-2 py-1 rounded font-mono font-semibold">WAN: Connected</div>
            <div className="bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300 px-2 py-1 rounded font-mono font-semibold">IP: 103.x.x.x</div>
          </div>
        </motion.div>

        <div className="flex items-center justify-between">
          <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold">
            Connected devices
          </h2>
          <span className="text-[12px] font-mono font-bold text-blue-600 dark:text-blue-400">8 devices</span>
        </div>

        <div className="space-y-3">
          {devices.map((device, i) => {
            const isBlocked = blockedDevices.has(device.id);
            return (
              <motion.div
                key={device.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.05 }}
                whileHover={{ scale: isBlocked ? 1 : 1.02 }}
                className={`bg-white/80 dark:bg-slate-800/50 backdrop-blur border rounded-xl p-4 flex items-start gap-3 relative shadow-lg transition-all ${
                  isBlocked
                    ? 'opacity-50 border-l-4 border-l-red-500 border-slate-300 dark:border-slate-600'
                    : 'border-slate-200 dark:border-slate-700 hover:shadow-xl hover:border-blue-300 dark:hover:border-blue-600'
                }`}
              >
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg ${
                  isBlocked
                    ? 'bg-slate-200 dark:bg-slate-700'
                    : 'bg-gradient-to-br from-blue-500 to-indigo-600 shadow-blue-500/30'
                }`}>
                  <device.icon size={20} className={isBlocked ? 'text-slate-500 dark:text-slate-400' : 'text-white drop-shadow'} strokeWidth={2.5} />
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <div className="text-[14px] font-semibold text-slate-900 dark:text-slate-50">{device.name}</div>
                    {isBlocked && (
                      <span className="bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-300 text-[10px] font-bold px-2 py-0.5 rounded">
                        Blocked
                      </span>
                    )}
                  </div>
                  <div className="text-[11px] font-mono text-slate-600 dark:text-slate-400 mb-2">{device.ip}</div>

                  {!isBlocked && (
                    <div className="space-y-1.5">
                      <div className="flex items-center justify-between text-[12px] font-mono">
                        <span className="font-bold text-blue-600 dark:text-blue-400">↓ {device.download} MB/s</span>
                        <span className="text-slate-600 dark:text-slate-400">↑ {device.upload} MB/s</span>
                      </div>
                      <div className="relative w-full h-1.5 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                        <motion.div
                          initial={{ width: 0 }}
                          animate={{ width: `${device.usage}%` }}
                          transition={{ delay: i * 0.05 + 0.2, duration: 0.5 }}
                          className="absolute left-0 top-0 h-full bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full shadow-sm"
                        />
                      </div>
                    </div>
                  )}
                </div>

                <motion.button
                  onClick={() => toggleBlock(device.id)}
                  className="flex-shrink-0 mt-1"
                  whileHover={{ scale: 1.1 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <div className={`w-12 h-7 rounded-full transition-all relative shadow-md ${
                    isBlocked
                      ? 'bg-slate-300 dark:bg-slate-600'
                      : 'bg-gradient-to-r from-emerald-500 to-green-600 shadow-emerald-500/40'
                  }`}>
                    <motion.div
                      className="absolute top-0.5 w-6 h-6 bg-white rounded-full shadow-md"
                      animate={{ left: isBlocked ? '2px' : '22px' }}
                      transition={{ type: "spring", stiffness: 500, damping: 30 }}
                    />
                  </div>
                </motion.button>
              </motion.div>
            );
          })}
        </div>

        <div className="flex gap-2 overflow-x-auto pb-2 -mx-4 px-4">
          <button className="flex items-center gap-2 bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-slate-50 text-[11px] font-semibold px-3 py-2 rounded-lg whitespace-nowrap flex-shrink-0 shadow-md hover:shadow-lg hover:border-blue-300 dark:hover:border-blue-600 transition-all">
            <Lock size={12} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />
            <span>Block all unknown</span>
          </button>
          <button className="flex items-center gap-2 bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-slate-50 text-[11px] font-semibold px-3 py-2 rounded-lg whitespace-nowrap flex-shrink-0 shadow-md hover:shadow-lg hover:border-blue-300 dark:hover:border-blue-600 transition-all">
            <Zap size={12} className="text-amber-500" strokeWidth={2.5} />
            <span>Prioritize this device</span>
          </button>
          <button className="flex items-center gap-2 bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-slate-50 text-[11px] font-semibold px-3 py-2 rounded-lg whitespace-nowrap flex-shrink-0 shadow-md hover:shadow-lg hover:border-blue-300 dark:hover:border-blue-600 transition-all">
            <Router size={12} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />
            <span>Refresh data</span>
          </button>
        </div>
      </div>
    </div>
  );
}

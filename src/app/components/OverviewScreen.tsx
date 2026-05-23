import { useState, useEffect } from 'react';
import { Link } from 'react-router';
import { Bell, Settings, Smartphone, Laptop, Tv, Router, Cpu, ChevronRight, Wifi, AlertTriangle } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';

const mockDevices = [
  { id: '1', name: 'iPhone 14', ip: '192.168.0.10', vendor: 'Apple Inc.', os: 'iOS', status: 'active', icon: Smartphone, isNew: false },
  { id: '2', name: 'MacBook Pro', ip: '192.168.0.11', vendor: 'Apple Inc.', os: 'macOS', status: 'active', icon: Laptop, isNew: false },
  { id: '3', name: 'Samsung Smart TV', ip: '192.168.0.15', vendor: 'Samsung', os: 'Android', status: 'idle', icon: Tv, isNew: false },
  { id: '4', name: 'TP-Link Router', ip: '192.168.0.1', vendor: 'TP-Link', os: '', status: 'active', icon: Router, isNew: false },
  { id: '5', name: 'Unknown Device', ip: '192.168.0.25', vendor: '', os: '', status: 'unknown', icon: Cpu, isNew: true },
];

export function OverviewScreen() {
  const [devices, setDevices] = useState(mockDevices);
  const [scanning, setScanning] = useState(false);
  const [lastScan, setLastScan] = useState(18);
  const [newDeviceBanner, setNewDeviceBanner] = useState(true);

  useEffect(() => {
    const interval = setInterval(() => {
      setLastScan(s => s + 1);
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  const handleRescan = () => {
    setScanning(true);
    setTimeout(() => setScanning(false), 2000);
    setLastScan(0);
  };

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-between border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">NetWatch</h1>
        <div className="flex items-center gap-2">
          <ThemeToggle />
          <button className="w-10 h-10 flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-all duration-200">
            <Bell size={22} className="text-slate-600 dark:text-slate-400" strokeWidth={2} />
          </button>
          <Link to="/app/settings" className="w-10 h-10 flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-all duration-200">
            <Settings size={22} className="text-slate-600 dark:text-slate-400" strokeWidth={2} />
          </Link>
        </div>
      </div>

      <div className="px-4 pt-4">
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-slate-800 dark:to-slate-900 rounded-2xl p-5 mb-6 shadow-lg shadow-blue-500/10 dark:shadow-blue-500/20 border border-blue-100 dark:border-slate-700"
        >
          <div className="flex items-center justify-between mb-4">
            <span className="text-[15px] font-semibold text-blue-900 dark:text-blue-100">Home Network</span>
            <span className="text-[13px] font-mono font-medium text-blue-600 dark:text-blue-400">MyWiFi-5G</span>
          </div>

          <div className="flex gap-2 mb-4">
            <div className="bg-white/80 dark:bg-slate-700/50 backdrop-blur border border-blue-200 dark:border-blue-500/30 rounded-lg px-3 py-1.5 text-[11px] font-semibold text-blue-900 dark:text-blue-100 shadow-sm">
              12 devices
            </div>
            <div className="bg-white/80 dark:bg-slate-700/50 backdrop-blur border border-blue-200 dark:border-blue-500/30 rounded-lg px-3 py-1.5 text-[11px] font-mono font-semibold text-blue-900 dark:text-blue-100 shadow-sm">
              8ms ping
            </div>
            <div className="bg-white/80 dark:bg-slate-700/50 backdrop-blur border border-blue-200 dark:border-blue-500/30 rounded-lg px-3 py-1.5 text-[11px] font-mono font-semibold text-blue-900 dark:text-blue-100 shadow-sm">
              0% loss
            </div>
          </div>

          <div className="h-px bg-gradient-to-r from-transparent via-blue-300 dark:via-blue-700 to-transparent mb-4" />

          <button onClick={handleRescan} className="flex items-center justify-between w-full group">
            <span className="text-[11px] text-slate-600 dark:text-slate-400">
              Last scanned {lastScan} seconds ago · Tap to rescan
            </span>
            <motion.div
              animate={{ rotate: scanning ? 360 : 0 }}
              transition={{ duration: 1, repeat: scanning ? Infinity : 0, ease: "linear" }}
              className="relative"
            >
              <div className={`w-5 h-5 rounded-full border-2 border-slate-300 dark:border-slate-600 border-t-blue-500 dark:border-t-blue-400 ${scanning ? 'shadow-lg shadow-blue-500/50' : ''}`} />
              {scanning && (
                <div className="absolute inset-0 rounded-full border-2 border-blue-500/30 animate-ping" />
              )}
            </motion.div>
          </button>
        </motion.div>

        <AnimatePresence>
          {newDeviceBanner && (
            <motion.div
              initial={{ height: 0, opacity: 0, y: -20 }}
              animate={{ height: 'auto', opacity: 1, y: 0 }}
              exit={{ height: 0, opacity: 0, y: -20 }}
              className="bg-gradient-to-r from-blue-500 to-indigo-600 dark:from-blue-600 dark:to-indigo-700 rounded-xl p-4 mb-5 flex items-center gap-3 overflow-hidden shadow-xl shadow-blue-500/30 border border-blue-400 dark:border-blue-500"
            >
              <motion.div
                animate={{ scale: [1, 1.2, 1] }}
                transition={{ duration: 2, repeat: Infinity }}
              >
                <Wifi size={18} className="text-white drop-shadow-lg" strokeWidth={2.5} />
              </motion.div>
              <span className="text-[13px] font-semibold text-white flex-1 drop-shadow-sm">
                New device joined · iPhone 14
              </span>
              <button
                onClick={() => setNewDeviceBanner(false)}
                className="text-white hover:bg-white/20 rounded-lg w-7 h-7 flex items-center justify-center transition-all duration-200"
              >
                <span className="text-[20px] font-light">×</span>
              </button>
            </motion.div>
          )}
        </AnimatePresence>

        <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-5 font-semibold">
          Devices on network
        </h2>

        <div className="space-y-3">
          {devices.map((device, i) => (
            <motion.div
              key={device.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              <Link
                to={`/app/device/${device.id}`}
                className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 flex items-center gap-4 transition-all duration-300 hover:shadow-xl hover:shadow-blue-500/10 dark:hover:shadow-blue-500/20 hover:border-blue-300 dark:hover:border-blue-600 group"
              >
                <div className={`w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 transition-all duration-300 ${
                  device.status === 'idle'
                    ? 'bg-slate-100 dark:bg-slate-700'
                    : 'bg-gradient-to-br from-blue-400 to-indigo-500 dark:from-blue-500 dark:to-indigo-600 shadow-lg shadow-blue-500/30'
                }`}>
                  <device.icon
                    size={22}
                    className={device.status === 'idle' ? 'text-slate-500 dark:text-slate-400' : 'text-white drop-shadow'}
                    strokeWidth={2.5}
                  />
                </div>

                <div className="flex-1 min-w-0">
                  <div className="text-[14px] font-semibold text-slate-900 dark:text-slate-50 truncate mb-1">
                    {device.name}
                  </div>
                  <div className="text-[12px] font-mono text-slate-600 dark:text-slate-400">
                    {device.ip} {device.vendor && `· ${device.vendor}`}
                  </div>
                  {device.os && (
                    <div className="inline-block mt-1.5 bg-blue-100 dark:bg-blue-900/40 text-blue-700 dark:text-blue-300 text-[10px] font-semibold px-2 py-0.5 rounded-md">
                      {device.os}
                    </div>
                  )}
                </div>

                <div className="flex items-center gap-3 flex-shrink-0">
                  {device.status === 'active' && (
                    <div className="relative">
                      <div className="w-2.5 h-2.5 rounded-full bg-emerald-500 shadow-lg shadow-emerald-500/50" />
                      <div className="absolute inset-0 rounded-full bg-emerald-500 animate-ping opacity-75" />
                    </div>
                  )}
                  {device.status === 'idle' && <div className="w-2.5 h-2.5 rounded-full bg-slate-400 dark:bg-slate-600" />}
                  {device.status === 'unknown' && (
                    <>
                      <motion.div animate={{ scale: [1, 1.1, 1] }} transition={{ duration: 2, repeat: Infinity }}>
                        <AlertTriangle size={16} className="text-amber-500 drop-shadow" strokeWidth={2.5} />
                      </motion.div>
                      <div className="relative">
                        <div className="w-2.5 h-2.5 rounded-full bg-amber-500 shadow-lg shadow-amber-500/50" />
                        <div className="absolute inset-0 rounded-full bg-amber-500 animate-ping opacity-75" />
                      </div>
                    </>
                  )}
                  <ChevronRight size={18} className="text-slate-400 dark:text-slate-600 group-hover:text-blue-500 dark:group-hover:text-blue-400 transition-colors" strokeWidth={2} />
                </div>
              </Link>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}

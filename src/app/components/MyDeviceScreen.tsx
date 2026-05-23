import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { ChevronLeft, Smartphone, ArrowDown, ArrowUp } from 'lucide-react';
import { motion } from 'motion/react';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';

const mockApps = [
  { name: 'YouTube', data: 890, background: true },
  { name: 'Instagram', data: 540, background: true },
  { name: 'Chrome', data: 340, background: false },
  { name: 'Spotify', data: 180, background: false },
  { name: 'Gmail', data: 120, background: true },
  { name: 'WhatsApp', data: 85, background: false },
  { name: 'Maps', data: 45, background: false },
];

export function MyDeviceScreen() {
  const navigate = useNavigate();
  const [downloadSpeed, setDownloadSpeed] = useState(2.3);
  const [uploadSpeed, setUploadSpeed] = useState(0.4);
  const [timeRange, setTimeRange] = useState<'today' | '7days'>('today');

  useEffect(() => {
    const interval = setInterval(() => {
      setDownloadSpeed(1 + Math.random() * 3);
      setUploadSpeed(0.1 + Math.random() * 0.8);
    }, 2000);
    return () => clearInterval(interval);
  }, []);

  const maxData = Math.max(...mockApps.map(a => a.data));

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-center border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <button onClick={() => navigate(-1)} className="absolute left-2 w-10 h-10 flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-all">
          <ChevronLeft size={24} className="text-slate-900 dark:text-slate-50" strokeWidth={2} />
        </button>
        <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">My Device</h1>
        <div className="absolute right-2">
          <ThemeToggle />
        </div>
      </div>

      <div className="px-4 pt-4 space-y-5">
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-2xl p-5 shadow-xl"
        >
          <div className="flex items-start gap-4 mb-4">
            <div className="w-14 h-14 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg shadow-blue-500/30">
              <Smartphone size={28} className="text-white drop-shadow" strokeWidth={2.5} />
            </div>
            <div className="flex-1">
              <div className="text-[16px] font-semibold text-slate-900 dark:text-slate-50 mb-1.5">
                Samsung Galaxy S23
              </div>
              <div className="text-[12px] font-mono text-slate-600 dark:text-slate-400 mb-2">
                Connected · 5 GHz · -52 dBm
              </div>
              <div className="flex items-center gap-1">
                {[1, 2, 3, 4].map(i => (
                  <motion.div
                    key={i}
                    initial={{ scaleY: 0 }}
                    animate={{ scaleY: 1 }}
                    transition={{ delay: i * 0.1 }}
                    className={`w-1.5 h-3.5 rounded-sm ${i <= 3 ? 'bg-gradient-to-t from-blue-600 to-blue-400 shadow-sm shadow-blue-500/50' : 'bg-slate-300 dark:bg-slate-600'}`}
                  />
                ))}
              </div>
            </div>
          </div>

          <div className="h-px bg-gradient-to-r from-transparent via-slate-300 dark:via-slate-600 to-transparent mb-4" />

          <div className="flex gap-2">
            <div className="bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 text-[12px] font-mono font-semibold px-3 py-1.5 rounded-lg">
              Downloaded today: 1.4 GB
            </div>
            <div className="bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300 text-[12px] font-mono font-semibold px-3 py-1.5 rounded-lg">
              Uploaded: 340 MB
            </div>
          </div>
        </motion.div>

        <div className="grid grid-cols-2 gap-3">
          <motion.div
            key={downloadSpeed}
            initial={{ scale: 0.95 }}
            animate={{ scale: 1 }}
            transition={{ duration: 0.3 }}
            className="bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl p-4 shadow-xl shadow-blue-500/30 relative overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-white/10 to-transparent" />
            <ArrowDown size={18} className="text-white drop-shadow-lg mb-2 relative z-10" strokeWidth={2.5} />
            <div className="text-[20px] font-mono font-bold text-white mb-1 relative z-10 drop-shadow-lg">
              ↓ {downloadSpeed.toFixed(1)} MB/s
            </div>
            <div className="text-[11px] font-semibold text-blue-100 relative z-10">Download</div>
          </motion.div>

          <motion.div
            key={uploadSpeed}
            initial={{ scale: 0.95 }}
            animate={{ scale: 1 }}
            transition={{ duration: 0.3 }}
            className="bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl p-4 shadow-xl shadow-indigo-500/30 relative overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-white/10 to-transparent" />
            <ArrowUp size={18} className="text-white drop-shadow-lg mb-2 relative z-10" strokeWidth={2.5} />
            <div className="text-[20px] font-mono font-bold text-white mb-1 relative z-10 drop-shadow-lg">
              ↑ {uploadSpeed.toFixed(1)} MB/s
            </div>
            <div className="text-[11px] font-semibold text-indigo-100 relative z-10">Upload</div>
          </motion.div>
        </div>

        <div className="flex items-center justify-between">
          <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold">
            App usage
          </h2>
          <div className="flex bg-slate-100 dark:bg-slate-800 rounded-lg overflow-hidden border border-slate-200 dark:border-slate-700 shadow-sm">
            <button
              onClick={() => setTimeRange('today')}
              className={`px-3 py-1.5 text-[11px] font-bold transition-all duration-300 ${
                timeRange === 'today'
                  ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md'
                  : 'text-slate-600 dark:text-slate-400 hover:bg-slate-200 dark:hover:bg-slate-700'
              }`}
            >
              Today
            </button>
            <button
              onClick={() => setTimeRange('7days')}
              className={`px-3 py-1.5 text-[11px] font-bold transition-all duration-300 ${
                timeRange === '7days'
                  ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md'
                  : 'text-slate-600 dark:text-slate-400 hover:bg-slate-200 dark:hover:bg-slate-700'
              }`}
            >
              7 days
            </button>
          </div>
        </div>

        <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur rounded-2xl overflow-hidden divide-y divide-slate-100 dark:divide-slate-700 border border-slate-200 dark:border-slate-700 shadow-xl">
          {mockApps.map((app, i) => (
            <motion.div
              key={app.name}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.05 }}
              whileHover={{ x: 4, backgroundColor: 'rgba(59, 130, 246, 0.05)' }}
              className="px-4 py-4 flex items-center gap-3 transition-colors"
            >
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg shadow-blue-500/30">
                <div className="w-5 h-5 bg-white/20 rounded" />
              </div>

              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-[14px] font-semibold text-slate-900 dark:text-slate-50">
                    {app.name}
                  </span>
                  {app.background && (
                    <span className="bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-300 text-[9px] font-bold px-1.5 py-0.5 rounded">
                      BG
                    </span>
                  )}
                </div>
                <div className="text-[12px] font-mono text-slate-600 dark:text-slate-400">
                  {app.background ? 'Background' : 'Active'} · {app.data} MB
                </div>
              </div>

              <div className="flex items-center gap-2 flex-shrink-0">
                <div className="relative w-20 h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                  <motion.div
                    initial={{ width: 0 }}
                    animate={{ width: `${(app.data / maxData) * 100}%` }}
                    transition={{ delay: i * 0.05 + 0.2, duration: 0.6, ease: "easeOut" }}
                    className="absolute left-0 top-0 h-full bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full shadow-sm"
                  />
                </div>
                <span className="text-[12px] font-mono font-bold text-blue-600 dark:text-blue-400 w-14 text-right">
                  {app.data} MB
                </span>
              </div>
            </motion.div>
          ))}
        </div>

        <motion.div
          whileHover={{ scale: 1.02 }}
          className="bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-900/20 dark:to-orange-900/20 border border-amber-200 dark:border-amber-800 rounded-xl p-4 flex items-center gap-3 shadow-lg cursor-pointer"
        >
          <div className="w-8 h-8 bg-amber-500 rounded-full flex items-center justify-center flex-shrink-0 shadow-lg shadow-amber-500/50">
            <div className="w-2.5 h-2.5 bg-white rounded-full" />
          </div>
          <div className="flex-1 text-[12px] font-semibold text-amber-900 dark:text-amber-100">
            YouTube & Instagram used 890 MB while screen was off
          </div>
          <ChevronLeft size={16} className="text-amber-600 dark:text-amber-400 rotate-180" strokeWidth={2.5} />
        </motion.div>
      </div>
    </div>
  );
}

import { useNavigate } from 'react-router';
import { ChevronLeft, Zap, Activity, Tv, Clock, Smartphone, Laptop } from 'lucide-react';
import { motion } from 'motion/react';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';

export function HogsScreen() {
  const navigate = useNavigate();
  const lagDetected = true;

  const suspects = [
    {
      rank: 1,
      name: 'Samsung Smart TV',
      icon: Tv,
      behavior: 'Likely streaming video',
      confidence: 87,
      detail: 'Response time +220ms when lag started · 21:03'
    },
    {
      rank: 2,
      name: 'iPhone 14',
      icon: Smartphone,
      behavior: 'App download in progress',
      confidence: 62,
      detail: 'Constant throughput of 8 MB/s · 21:02'
    },
    {
      rank: 3,
      name: 'MacBook Pro',
      icon: Laptop,
      behavior: 'Cloud backup running',
      confidence: 45,
      detail: 'Upload activity detected · 21:00'
    },
  ];

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-center border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <button onClick={() => navigate(-1)} className="absolute left-2 w-10 h-10 flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-all">
          <ChevronLeft size={24} className="text-slate-900 dark:text-slate-50" strokeWidth={2} />
        </button>
        <div className="flex items-center gap-2">
          <Zap size={18} className="text-amber-500" strokeWidth={2.5} />
          <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">Bandwidth Hogs</h1>
        </div>
        <div className="absolute right-2">
          <ThemeToggle />
        </div>
      </div>

      <div className="px-4 pt-4 space-y-5">
        {lagDetected && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-900/20 dark:to-orange-900/20 border border-amber-300 dark:border-amber-700 rounded-xl p-4 flex items-center gap-3 shadow-xl shadow-amber-500/10"
          >
            <motion.div
              animate={{ scale: [1, 1.2, 1] }}
              transition={{ duration: 1.5, repeat: Infinity }}
            >
              <Activity size={22} className="text-amber-600 dark:text-amber-400 drop-shadow" strokeWidth={2.5} />
            </motion.div>
            <div className="flex-1">
              <div className="text-[15px] font-bold text-amber-900 dark:text-amber-100 mb-0.5">
                Lag detected · 340ms avg ping
              </div>
              <div className="text-[12px] text-amber-700 dark:text-amber-300">
                Analyzing 8 active devices...
              </div>
            </div>
            <div className="relative">
              <div className="bg-red-500 text-white text-[10px] font-bold px-2 py-1 rounded shadow-lg shadow-red-500/50">
                Live
              </div>
              <div className="absolute inset-0 bg-red-500 rounded animate-ping opacity-75" />
            </div>
          </motion.div>
        )}

        <div className="flex items-center justify-between mb-2">
          <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold">
            Most likely causes
          </h2>
          <span className="text-[11px] font-mono text-slate-400 dark:text-slate-500">Updated 3s ago</span>
        </div>

        <div className="space-y-3">
          {suspects.map((suspect, i) => (
            <motion.div
              key={suspect.rank}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.1 }}
              whileHover={{ scale: 1.02 }}
              className={`bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 relative shadow-lg hover:shadow-xl transition-all ${
                suspect.rank === 1 ? 'border-l-4 border-l-amber-500' : ''
              }`}
            >
              <div className="flex items-center gap-3 mb-3">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center text-[13px] font-bold flex-shrink-0 shadow-lg ${
                  suspect.rank === 1
                    ? 'bg-gradient-to-br from-amber-500 to-orange-600 text-white shadow-amber-500/50'
                    : 'bg-gradient-to-br from-blue-600 to-indigo-600 text-white shadow-blue-500/30'
                }`}>
                  {suspect.rank}
                </div>
                <div className={`w-11 h-11 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg ${
                  suspect.rank === 1
                    ? 'bg-gradient-to-br from-amber-500 to-orange-600 shadow-amber-500/30'
                    : 'bg-gradient-to-br from-blue-500 to-indigo-600 shadow-blue-500/30'
                }`}>
                  <suspect.icon size={22} className="text-white drop-shadow" strokeWidth={2.5} />
                </div>
                <div className="text-[15px] font-semibold text-slate-900 dark:text-slate-50">
                  {suspect.name}
                </div>
              </div>

              <div className="bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 text-[11px] font-semibold px-3 py-1.5 rounded-lg inline-block mb-3">
                {suspect.behavior}
              </div>

              <div className="mb-2">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[11px] text-slate-600 dark:text-slate-400 font-semibold">Confidence</span>
                  <span className="text-[13px] font-mono font-bold text-blue-600 dark:text-blue-400">{suspect.confidence}%</span>
                </div>
                <div className="relative w-full h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                  <motion.div
                    initial={{ width: 0 }}
                    animate={{ width: `${suspect.confidence}%` }}
                    transition={{ delay: i * 0.1 + 0.3, duration: 0.6 }}
                    className="absolute left-0 top-0 h-full bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full shadow-sm"
                  />
                </div>
              </div>

              <div className="text-[11px] font-mono text-slate-600 dark:text-slate-400 italic">
                {suspect.detail}
              </div>
            </motion.div>
          ))}
        </div>

        <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 shadow-xl">
          <div className="flex items-center gap-2 mb-4">
            <Clock size={16} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />
            <h3 className="text-[14px] font-semibold text-slate-900 dark:text-slate-50">Incident timeline</h3>
          </div>

          <div className="space-y-3">
            <TimelineEvent time="21:01" event="Smart TV became active" active={false} />
            <TimelineEvent time="21:03" event="Router ping rose to 340ms" active={true} />
            <TimelineEvent time="21:08" event="Ping normalized · TV went idle" active={false} />
          </div>
        </div>
      </div>
    </div>
  );
}

function TimelineEvent({ time, event, active }: { time: string; event: string; active: boolean }) {
  return (
    <div className="flex items-start gap-3 relative">
      <div className="flex flex-col items-center">
        <div className={`relative ${active ? 'w-2.5 h-2.5' : 'w-2 h-2'} rounded-full ${
          active ? 'bg-amber-500 shadow-lg shadow-amber-500/50' : 'bg-slate-400 dark:bg-slate-600'
        }`}>
          {active && <div className="absolute inset-0 rounded-full bg-amber-500 animate-ping opacity-75" />}
        </div>
        <div className="w-px h-6 bg-gradient-to-b from-slate-300 to-transparent dark:from-slate-600 mt-1" />
      </div>
      <div className="flex-1 -mt-0.5">
        <div className="text-[11px] font-mono text-slate-500 dark:text-slate-400 mb-0.5">{time}</div>
        <div className={`text-[12px] ${active ? 'text-slate-900 dark:text-slate-50 font-semibold' : 'text-slate-600 dark:text-slate-400'}`}>
          {event}
        </div>
      </div>
    </div>
  );
}

import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { ChevronLeft, Settings, CheckCircle, Router, Globe, Percent } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, ResponsiveContainer } from 'recharts';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';
import { motion } from 'motion/react';

export function HealthScreen() {
  const navigate = useNavigate();
  const [chartData, setChartData] = useState<Array<{ time: number; router: number; internet: number; dns: number }>>([]);

  useEffect(() => {
    const data = [];
    for (let i = 60; i >= 0; i--) {
      data.push({
        time: i,
        router: 5 + Math.random() * 6,
        internet: 18 + Math.random() * 10,
        dns: 12 + Math.random() * 8,
      });
    }
    setChartData(data);

    const interval = setInterval(() => {
      setChartData(prev => {
        const newData = [...prev.slice(1)];
        newData.push({
          time: 0,
          router: 5 + Math.random() * 6,
          internet: 18 + Math.random() * 10,
          dns: 12 + Math.random() * 8,
        });
        return newData;
      });
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-between border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <button onClick={() => navigate(-1)} className="w-10 h-10 flex items-center justify-center -ml-2 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-all">
          <ChevronLeft size={24} className="text-slate-900 dark:text-slate-50" strokeWidth={2} />
        </button>
        <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">Network Health</h1>
        <ThemeToggle />
      </div>

      <div className="px-4 pt-4 space-y-5">
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-emerald-50 to-green-50 dark:from-emerald-900/20 dark:to-green-900/20 border-l-4 border-emerald-500 dark:border-emerald-400 rounded-2xl p-5 flex items-center gap-4 shadow-xl shadow-emerald-500/10"
        >
          <div className="flex-1">
            <div className="text-[20px] font-bold text-emerald-900 dark:text-emerald-100 mb-2">
              Network Healthy
            </div>
            <div className="text-[13px] text-emerald-700 dark:text-emerald-300">
              Router and internet connection are performing well
            </div>
          </div>
          <motion.div
            animate={{ scale: [1, 1.1, 1] }}
            transition={{ duration: 2, repeat: Infinity }}
          >
            <CheckCircle size={36} className="text-emerald-500 dark:text-emerald-400 drop-shadow-lg" strokeWidth={2.5} />
          </motion.div>
        </motion.div>

        <div className="grid grid-cols-3 gap-2">
          <StatCard icon={Router} value="8ms" label="Router ping" />
          <StatCard icon={Globe} value="23ms" label="Internet ping" />
          <StatCard icon={Percent} value="0%" label="Packet loss" />
        </div>

        <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-2xl p-5 shadow-xl">
          <div className="flex items-center justify-between mb-5">
            <div className="flex items-center gap-2">
              <span className="text-[14px] font-semibold text-slate-900 dark:text-slate-50">Live latency</span>
              <div className="relative">
                <div className="w-2 h-2 bg-blue-500 rounded-full animate-pulse-glow" />
                <div className="absolute inset-0 bg-blue-500 rounded-full animate-ping" />
              </div>
            </div>
            <div className="flex items-center gap-3 text-[11px]">
              <div className="flex items-center gap-1.5">
                <div className="w-2 h-2 rounded-full bg-blue-900 dark:bg-blue-600 shadow-lg shadow-blue-500/50" />
                <span className="text-slate-600 dark:text-slate-400 font-mono font-semibold">Router</span>
              </div>
              <div className="flex items-center gap-1.5">
                <div className="w-2 h-2 rounded-full bg-blue-500 shadow-lg shadow-blue-500/50" />
                <span className="text-slate-600 dark:text-slate-400 font-mono font-semibold">Internet</span>
              </div>
              <div className="flex items-center gap-1.5">
                <div className="w-2 h-2 rounded-full bg-blue-300 shadow-lg shadow-blue-300/50" />
                <span className="text-slate-600 dark:text-slate-400 font-mono font-semibold">DNS</span>
              </div>
            </div>
          </div>

          <ResponsiveContainer width="100%" height={200}>
            <LineChart data={chartData}>
              <defs>
                <linearGradient id="healthRouterGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop key="router-start" offset="0%" stopColor="#1E3A8A" stopOpacity={0.3} />
                  <stop key="router-end" offset="100%" stopColor="#1E3A8A" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="healthInternetGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop key="internet-start" offset="0%" stopColor="#3B82F6" stopOpacity={0.3} />
                  <stop key="internet-end" offset="100%" stopColor="#3B82F6" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="healthDnsGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop key="dns-start" offset="0%" stopColor="#93C5FD" stopOpacity={0.3} />
                  <stop key="dns-end" offset="100%" stopColor="#93C5FD" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" opacity={0.3} />
              <XAxis
                dataKey="time"
                tickFormatter={(val) => val === 60 ? '60s ago' : val === 0 ? 'Now' : ''}
                tick={{ fontSize: 10, fill: '#94a3b8', fontFamily: 'JetBrains Mono' }}
                axisLine={false}
                tickLine={false}
              />
              <YAxis
                tick={{ fontSize: 10, fill: '#94a3b8', fontFamily: 'JetBrains Mono' }}
                axisLine={false}
                tickLine={false}
                tickFormatter={(val) => `${val}ms`}
              />
              <Line key="router" type="monotone" dataKey="router" stroke="#1E3A8A" strokeWidth={3} dot={false} fill="url(#healthRouterGradient)" />
              <Line key="internet" type="monotone" dataKey="internet" stroke="#3B82F6" strokeWidth={3} dot={false} fill="url(#healthInternetGradient)" />
              <Line key="dns" type="monotone" dataKey="dns" stroke="#93C5FD" strokeWidth={3} dot={false} fill="url(#healthDnsGradient)" />
            </LineChart>
          </ResponsiveContainer>
        </div>

        <div>
          <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-4 font-semibold">
            Connection breakdown
          </h2>
          <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl divide-y divide-slate-100 dark:divide-slate-700 shadow-lg overflow-hidden">
            <MetricRow label="Jitter" value="2ms" />
            <MetricRow label="DNS resolution" value="15ms" />
            <MetricRow label="Min ping" value="5ms" />
            <MetricRow label="Max ping" value="34ms" />
          </div>
        </div>

        <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-2xl p-5 shadow-xl">
          <div className="text-[14px] font-semibold text-slate-900 dark:text-slate-50 mb-5">
            Where is the issue?
          </div>
          <div className="flex items-center justify-between mb-4">
            <div className="flex flex-col items-center gap-2">
              <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-400 flex items-center justify-center text-[11px] font-bold shadow-md">
                1
              </div>
              <span className="text-[10px] text-slate-600 dark:text-slate-400 font-semibold">Your device</span>
            </div>
            <div className="flex-1 h-[2px] bg-gradient-to-r from-slate-200 to-blue-500 dark:from-slate-700 dark:to-blue-600 mx-2" />
            <div className="flex flex-col items-center gap-2">
              <motion.div
                animate={{ scale: [1, 1.1, 1] }}
                transition={{ duration: 2, repeat: Infinity }}
                className="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 text-white flex items-center justify-center text-[11px] font-bold shadow-lg shadow-blue-500/50"
              >
                2
              </motion.div>
              <span className="text-[10px] text-blue-600 dark:text-blue-400 font-bold">Router</span>
            </div>
            <div className="flex-1 h-[2px] bg-gradient-to-r from-blue-500 to-slate-200 dark:from-blue-600 dark:to-slate-700 mx-2" />
            <div className="flex flex-col items-center gap-2">
              <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-400 flex items-center justify-center text-[11px] font-bold shadow-md">
                3
              </div>
              <span className="text-[10px] text-slate-600 dark:text-slate-400 font-semibold">ISP/Internet</span>
            </div>
          </div>
          <p className="text-[12px] text-slate-700 dark:text-slate-300 text-center bg-blue-50 dark:bg-blue-900/20 p-3 rounded-lg">
            Connection is stable at the router level
          </p>
        </div>
      </div>
    </div>
  );
}

function StatCard({ icon: Icon, value, label }: { icon: any; value: string; label: string }) {
  return (
    <motion.div
      whileHover={{ scale: 1.05, y: -2 }}
      className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 flex flex-col items-center shadow-lg hover:shadow-xl hover:border-blue-300 dark:hover:border-blue-600 transition-all duration-300"
    >
      <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center mb-3 shadow-lg shadow-blue-500/30">
        <Icon size={20} className="text-white drop-shadow" strokeWidth={2.5} />
      </div>
      <div className="text-[24px] font-mono font-bold text-slate-900 dark:text-slate-50">{value}</div>
      <div className="text-[10px] text-slate-600 dark:text-slate-400 text-center font-semibold uppercase tracking-wide mt-1">{label}</div>
    </motion.div>
  );
}

function MetricRow({ label, value }: { label: string; value: string }) {
  return (
    <motion.div
      whileHover={{ x: 4 }}
      className="flex items-center justify-between px-4 py-3.5 hover:bg-blue-50 dark:hover:bg-blue-900/10 transition-colors"
    >
      <span className="text-[12px] text-slate-600 dark:text-slate-400 font-medium">{label}</span>
      <span className="text-[14px] font-mono font-bold text-blue-600 dark:text-blue-400">{value}</span>
    </motion.div>
  );
}

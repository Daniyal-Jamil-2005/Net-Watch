import { useState } from 'react';
import { ChevronRight, Lock, Download, Trash2, Smartphone, Moon } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, ResponsiveContainer } from 'recharts';
import { useTheme } from '../context/ThemeContext';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';
import { motion } from 'motion/react';

const chartData = Array.from({ length: 24 }, (_, i) => ({
  id: `hour-${i}`,
  time: i,
  ping: i >= 20 && i <= 21 ? 340 : 8 + Math.random() * 12
}));

const knownDevices = [
  { name: "Mom's Phone", mac: 'A4:C3:F0:12:34:56', icon: Smartphone },
  { name: "Work Laptop", mac: 'B8:27:EB:78:90:AB', icon: Smartphone },
  { name: "Smart Speaker", mac: 'DC:A6:32:CD:EF:12', icon: Smartphone },
];

export function SettingsScreen() {
  const { theme, toggleTheme } = useTheme();
  const [autoRescan, setAutoRescan] = useState(true);
  const [portScan, setPortScan] = useState(true);
  const [newDeviceAlerts, setNewDeviceAlerts] = useState(true);
  const [securityWarnings, setSecurityWarnings] = useState(true);
  const [congestionAlerts, setCongestionAlerts] = useState(false);

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-between border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">Settings</h1>
        <ThemeToggle />
      </div>

      <div className="px-4 pt-4 space-y-6">
        <div>
          <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold mb-3">
            24-hour ping history
          </h2>
          <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 shadow-xl">
            <ResponsiveContainer width="100%" height={160}>
              <LineChart data={chartData}>
                <defs>
                  <linearGradient id="settingsPingGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop key="settings-ping-start" offset="0%" stopColor="#93C5FD" stopOpacity={0.3} />
                    <stop key="settings-ping-end" offset="100%" stopColor="#93C5FD" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <XAxis
                  dataKey="time"
                  tickFormatter={(val) => {
                    if (val === 0) return '12am';
                    if (val === 6) return '6am';
                    if (val === 12) return '12pm';
                    if (val === 18) return '6pm';
                    if (val === 23) return 'Now';
                    return '';
                  }}
                  tick={{ fontSize: 10, fill: '#94a3b8', fontFamily: 'JetBrains Mono' }}
                  axisLine={false}
                  tickLine={false}
                />
                <YAxis
                  tick={{ fontSize: 10, fill: '#94a3b8', fontFamily: 'JetBrains Mono' }}
                  axisLine={false}
                  tickLine={false}
                  tickFormatter={(val) => `${val}ms`}
                  domain={[0, 400]}
                />
                <Line
                  key="ping"
                  type="monotone"
                  dataKey="ping"
                  stroke="#3B82F6"
                  strokeWidth={2}
                  fill="url(#settingsPingGradient)"
                  dot={false}
                />
              </LineChart>
            </ResponsiveContainer>

            <div className="text-[11px] font-mono text-slate-600 dark:text-slate-400 text-center mt-2">
              Avg: 12ms · Worst: 340ms · Uptime: 99.8%
            </div>
          </div>
        </div>

        <div>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold">
              Known devices
            </h2>
            <button className="text-[12px] font-bold text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 transition-colors">+ Add</button>
          </div>
          <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl divide-y divide-slate-100 dark:divide-slate-700 overflow-hidden shadow-xl">
            {knownDevices.map((device) => (
              <motion.div
                key={device.mac}
                whileHover={{ x: 4, backgroundColor: 'rgba(59, 130, 246, 0.05)' }}
                className="px-4 py-3.5 flex items-center gap-3 transition-colors"
              >
                <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center shadow-lg shadow-blue-500/30">
                  <device.icon size={20} className="text-white drop-shadow" strokeWidth={2.5} />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-[14px] font-semibold text-slate-900 dark:text-slate-50">{device.name}</div>
                  <div className="text-[11px] font-mono text-slate-600 dark:text-slate-400">{device.mac}</div>
                </div>
                <button className="hover:bg-red-50 dark:hover:bg-red-900/20 p-2 rounded-lg transition-colors">
                  <Trash2 size={16} className="text-slate-400 dark:text-slate-500 hover:text-red-500 transition-colors" strokeWidth={2} />
                </button>
              </motion.div>
            ))}
          </div>
        </div>

        <SettingsGroup title="Appearance">
          <SettingRow label="Dark mode" icon={<Moon size={14} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />} toggle value={theme === 'dark'} onToggle={toggleTheme} />
        </SettingsGroup>

        <SettingsGroup title="Scanning">
          <SettingRow label="Scan interval" value="30 seconds" hasChevron />
          <SettingRow label="Auto-rescan" toggle value={autoRescan} onToggle={() => setAutoRescan(!autoRescan)} />
          <SettingRow label="Port scan on discovery" toggle value={portScan} onToggle={() => setPortScan(!portScan)} />
        </SettingsGroup>

        <SettingsGroup title="Alerts">
          <SettingRow label="New device alerts" toggle value={newDeviceAlerts} onToggle={() => setNewDeviceAlerts(!newDeviceAlerts)} />
          <SettingRow label="Security warnings" toggle value={securityWarnings} onToggle={() => setSecurityWarnings(!securityWarnings)} />
          <SettingRow label="Congestion alerts" toggle value={congestionAlerts} onToggle={() => setCongestionAlerts(!congestionAlerts)} />
        </SettingsGroup>

        <SettingsGroup title="Router">
          <SettingRow label="Saved credentials" icon={<Lock size={14} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />} hasChevron />
          <SettingRow label="Default credentials DB" value="841 routers" hasChevron />
          <SettingRow label="Clear router session" destructive />
        </SettingsGroup>

        <SettingsGroup title="About">
          <SettingRow label="Version" value="1.0.0 (build 42)" />
          <SettingRow label="Privacy policy" hasChevron />
          <SettingRow label="Export network report" icon={<Download size={14} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />} />
        </SettingsGroup>
      </div>
    </div>
  );
}

function SettingsGroup({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h2 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold mb-3 mt-4">
        {title}
      </h2>
      <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl divide-y divide-slate-100 dark:divide-slate-700 overflow-hidden shadow-lg">
        {children}
      </div>
    </div>
  );
}

function SettingRow({
  label,
  value,
  icon,
  toggle,
  hasChevron,
  destructive,
  onToggle
}: {
  label: string;
  value?: string | boolean;
  icon?: React.ReactNode;
  toggle?: boolean;
  hasChevron?: boolean;
  destructive?: boolean;
  onToggle?: () => void;
}) {
  return (
    <motion.div
      whileHover={{ x: 4, backgroundColor: destructive ? 'rgba(239, 68, 68, 0.05)' : 'rgba(59, 130, 246, 0.05)' }}
      className="px-4 py-3.5 flex items-center justify-between min-h-[52px] transition-colors"
    >
      <span className={`text-[14px] font-medium ${destructive ? 'text-red-600 dark:text-red-400' : 'text-slate-900 dark:text-slate-50'}`}>
        {label}
      </span>
      <div className="flex items-center gap-2">
        {icon}
        {toggle && typeof value === 'boolean' && (
          <button
            onClick={onToggle}
            className={`w-12 h-7 rounded-full transition-all relative shadow-md ${
              value
                ? 'bg-gradient-to-r from-blue-500 to-indigo-600 shadow-blue-500/40'
                : 'bg-slate-300 dark:bg-slate-600'
            }`}
          >
            <motion.div
              className="absolute top-0.5 w-6 h-6 bg-white rounded-full shadow-md"
              animate={{ left: value ? '22px' : '2px' }}
              transition={{ type: "spring", stiffness: 500, damping: 30 }}
            />
          </button>
        )}
        {!toggle && value && typeof value === 'string' && (
          <span className="text-[13px] font-mono font-semibold text-blue-600 dark:text-blue-400">{value}</span>
        )}
        {hasChevron && <ChevronRight size={16} className="text-slate-400 dark:text-slate-500" strokeWidth={2} />}
      </div>
    </motion.div>
  );
}

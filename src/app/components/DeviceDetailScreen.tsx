import { useNavigate, useParams } from 'react-router';
import { ChevronLeft, Bell, Lock, Wifi, Copy, ShieldAlert, ShieldCheck, Ban, Tv } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, ResponsiveContainer } from 'recharts';
import { ThemeToggle } from './ThemeToggle';
import { NetworkBackground } from './NetworkBackground';
import { motion } from 'motion/react';

const behaviorData = Array.from({ length: 30 }, (_, i) => ({
  id: `point-${i}`,
  time: i,
  response: i >= 20 && i <= 25 ? 340 : 8 + Math.random() * 8
}));

export function DeviceDetailScreen() {
  const navigate = useNavigate();
  const { id } = useParams();

  const device = {
    name: 'Samsung Smart TV',
    type: 'Smart TV',
    ip: '192.168.0.15',
    mac: 'A4:C3:F0:XX:XX:YY',
    vendor: 'Samsung Electronics',
    os: 'Linux (TTL 64)',
    hostname: 'Samsung-TV.local',
    status: 'Active',
    lastSeen: 'just now',
    openPorts: [
      { port: 80, service: 'HTTP', risk: 'safe' },
      { port: 443, service: 'HTTPS', risk: 'safe' },
      { port: 23, service: 'Telnet', risk: 'danger' },
    ],
    securityScore: 72,
    deductions: [
      { reason: 'Telnet port open', points: -30 },
      { reason: 'No hostname resolved', points: -5 },
    ]
  };

  return (
    <div className="max-w-[390px] mx-auto pb-6 relative">
      <NetworkBackground />
      <div className="h-[56px] px-6 flex items-center justify-between border-b border-slate-200 dark:border-slate-700 backdrop-blur-sm bg-white/80 dark:bg-slate-900/80 relative z-10">
        <button onClick={() => navigate(-1)} className="w-10 h-10 flex items-center justify-center -ml-2 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition-all">
          <ChevronLeft size={24} className="text-slate-900 dark:text-slate-50" strokeWidth={2} />
        </button>
        <h1 className="text-[17px] font-semibold text-slate-900 dark:text-slate-50 tracking-tight">Device Detail</h1>
        <ThemeToggle />
      </div>

      <div className="bg-gradient-to-b from-blue-50 to-transparent dark:from-slate-800 dark:to-transparent py-8 relative">
        <div className="flex flex-col items-center">
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 0.4 }}
            className="w-20 h-20 bg-gradient-to-br from-blue-500 to-indigo-600 border-4 border-white dark:border-slate-900 rounded-2xl flex items-center justify-center mb-3 shadow-2xl shadow-blue-500/40"
          >
            <Tv size={40} className="text-white drop-shadow-lg" strokeWidth={2.5} />
          </motion.div>
          <div className="text-[11px] uppercase tracking-wider text-blue-600 dark:text-blue-400 mb-2 font-bold">
            {device.type}
          </div>
          <h2 className="text-[20px] font-bold text-slate-900 dark:text-slate-50 mb-2">
            {device.name}
          </h2>
          <div className="flex items-center gap-2 text-[13px] text-slate-600 dark:text-slate-400 mb-4">
            <div className="relative">
              <div className="w-2 h-2 rounded-full bg-emerald-500 shadow-lg shadow-emerald-500/50" />
              <div className="absolute inset-0 rounded-full bg-emerald-500 animate-ping opacity-75" />
            </div>
            <span className="font-semibold">{device.status} · Last seen {device.lastSeen}</span>
          </div>

          <div className="flex gap-3">
            <ActionButton icon={Bell} label="Alert" />
            <ActionButton icon={Lock} label="Block" />
            <ActionButton icon={Wifi} label="Ping" />
          </div>
        </div>
      </div>

      <div className="px-4 pt-4 space-y-4">
        <DetailSection title="Network identity">
          <DetailRow label="IP address" value={device.ip} copyable />
          <DetailRow label="MAC address" value={device.mac} copyable />
          <DetailRow label="Vendor" value={device.vendor} />
          <DetailRow label="OS" value={device.os} />
          <DetailRow label="Hostname" value={device.hostname} />
        </DetailSection>

        <DetailSection title="Open ports">
          {device.openPorts.map((port) => (
            <div key={port.port} className={`px-4 py-3 flex items-center gap-3 ${
              port.risk === 'danger' ? 'bg-red-50 dark:bg-red-900/10' : ''
            }`}>
              {port.risk === 'danger' && (
                <ShieldAlert size={16} className="text-red-600 dark:text-red-400" strokeWidth={2.5} />
              )}
              <div className="bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 text-[10px] font-mono font-bold px-2 py-1 rounded">
                {port.port}
              </div>
              <span className={`text-[13px] flex-1 font-medium ${
                port.risk === 'danger' ? 'text-red-700 dark:text-red-300' : 'text-slate-900 dark:text-slate-50'
              }`}>
                {port.service} {port.risk === 'danger' && '— Security risk'}
              </span>
              <div className={`w-2 h-2 rounded-full shadow-lg ${
                port.risk === 'safe' ? 'bg-emerald-500 shadow-emerald-500/50' :
                port.risk === 'danger' ? 'bg-red-500 shadow-red-500/50' : 'bg-amber-500 shadow-amber-500/50'
              }`} />
            </div>
          ))}
        </DetailSection>

        <div>
          <h3 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold mb-3">
            Behavior history
          </h3>
          <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-4 shadow-xl">
            <ResponsiveContainer width="100%" height={100}>
              <LineChart data={behaviorData}>
                <defs>
                  <linearGradient id="deviceBehaviorGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop key="device-behavior-start" offset="0%" stopColor="#60A5FA" stopOpacity={0.3} />
                    <stop key="device-behavior-end" offset="100%" stopColor="#60A5FA" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <XAxis hide />
                <YAxis hide domain={[0, 400]} />
                <Line
                  key="response"
                  type="monotone"
                  dataKey="response"
                  stroke="#60A5FA"
                  strokeWidth={2.5}
                  fill="url(#deviceBehaviorGradient)"
                  dot={false}
                />
              </LineChart>
            </ResponsiveContainer>
            <div className="text-[11px] font-mono text-slate-600 dark:text-slate-400 mt-2">
              Avg response: 12ms · Peak: 340ms at 21:03
            </div>
          </div>
        </div>

        <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl p-5 flex items-center gap-4 shadow-xl">
          <div className="relative w-16 h-16 flex-shrink-0">
            <svg className="transform -rotate-90" width="64" height="64">
              <circle
                cx="32"
                cy="32"
                r="28"
                fill="none"
                stroke="#e2e8f0"
                strokeWidth="6"
              />
              <motion.circle
                cx="32"
                cy="32"
                r="28"
                fill="none"
                stroke="url(#scoreGradient)"
                strokeWidth="6"
                strokeDasharray={`${(device.securityScore / 100) * 176} 176`}
                initial={{ strokeDasharray: "0 176" }}
                animate={{ strokeDasharray: `${(device.securityScore / 100) * 176} 176` }}
                transition={{ duration: 1, delay: 0.2 }}
              />
              <defs>
                <linearGradient id="scoreGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#3B82F6" />
                  <stop offset="100%" stopColor="#6366F1" />
                </linearGradient>
              </defs>
            </svg>
            <div className="absolute inset-0 flex items-center justify-center text-[20px] font-bold text-slate-900 dark:text-slate-50">
              {device.securityScore}
            </div>
          </div>

          <div className="flex-1">
            <div className="text-[14px] font-semibold text-slate-900 dark:text-slate-50 mb-2">
              Security score
            </div>
            <div className="space-y-1">
              {device.deductions.map((d, i) => (
                <div key={i} className={`text-[12px] font-medium ${
                  d.points <= -20 ? 'text-red-600 dark:text-red-400' : 'text-amber-600 dark:text-amber-400'
                }`}>
                  {d.points} {d.reason}
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3 pt-2">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className="h-[50px] border-2 border-red-500 text-red-600 dark:text-red-400 rounded-xl font-semibold text-[14px] flex items-center justify-center gap-2 shadow-lg hover:bg-red-50 dark:hover:bg-red-900/20 transition-all"
          >
            <Ban size={18} strokeWidth={2.5} />
            Block device
          </motion.button>
          <motion.button
            whileHover={{ scale: 1.05, boxShadow: "0 10px 30px rgba(59, 130, 246, 0.4)" }}
            whileTap={{ scale: 0.95 }}
            className="h-[50px] bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded-xl font-semibold text-[14px] flex items-center justify-center gap-2 shadow-xl shadow-blue-500/30 transition-all"
          >
            <ShieldCheck size={18} strokeWidth={2.5} />
            Add to known
          </motion.button>
        </div>
      </div>
    </div>
  );
}

function ActionButton({ icon: Icon, label }: { icon: any; label: string }) {
  return (
    <motion.button
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.95 }}
      className="flex flex-col items-center gap-1.5"
    >
      <div className="w-12 h-12 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl flex items-center justify-center shadow-lg hover:shadow-xl hover:border-blue-300 dark:hover:border-blue-600 transition-all">
        <Icon size={22} className="text-blue-600 dark:text-blue-400" strokeWidth={2.5} />
      </div>
      <span className="text-[10px] text-slate-600 dark:text-slate-400 font-semibold">{label}</span>
    </motion.button>
  );
}

function DetailSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h3 className="text-[12px] uppercase tracking-wider text-slate-500 dark:text-slate-400 font-semibold mb-3">
        {title}
      </h3>
      <div className="bg-white/80 dark:bg-slate-800/50 backdrop-blur border border-slate-200 dark:border-slate-700 rounded-xl divide-y divide-slate-100 dark:divide-slate-700 overflow-hidden shadow-lg">
        {children}
      </div>
    </div>
  );
}

function DetailRow({ label, value, copyable }: { label: string; value: string; copyable?: boolean }) {
  return (
    <motion.div
      whileHover={{ x: 4, backgroundColor: 'rgba(59, 130, 246, 0.05)' }}
      className="px-4 py-3 flex items-center justify-between transition-colors"
    >
      <span className="text-[12px] text-slate-600 dark:text-slate-400 font-medium">{label}</span>
      <div className="flex items-center gap-2">
        <span className="text-[13px] font-mono font-semibold text-slate-900 dark:text-slate-50">{value}</span>
        {copyable && (
          <button className="hover:bg-blue-50 dark:hover:bg-blue-900/20 p-1.5 rounded transition-colors">
            <Copy size={14} className="text-slate-400 dark:text-slate-500 hover:text-blue-600 dark:hover:text-blue-400 transition-colors" strokeWidth={2} />
          </button>
        )}
      </div>
    </motion.div>
  );
}

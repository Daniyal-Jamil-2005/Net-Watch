import { useState } from "react";

const colors = {
  bg: "#080c10",
  surface: "#0d1117",
  border: "#1c2a3a",
  borderBright: "#1e3a52",
  accent: "#00d4aa",
  accentDim: "#00a07d",
  accentGlow: "rgba(0,212,170,0.15)",
  blue: "#4da6ff",
  blueDim: "#1a4a7a",
  yellow: "#ffd166",
  red: "#ff6b6b",
  purple: "#c084fc",
  orange: "#fb923c",
  textPrimary: "#e2e8f0",
  textSecondary: "#64748b",
  textMuted: "#334155",
};

const layerConfig = [
  {
    id: "ui",
    label: "SCREEN LAYER",
    sublabel: "What users see & interact with",
    color: colors.blue,
    glow: "rgba(77,166,255,0.12)",
    border: "#1a4a7a",
    icon: "⬡",
    screens: [
      {
        name: "Network Overview",
        tag: "CORE",
        tagColor: colors.accent,
        items: [
          "Device cards: IP · MAC · Vendor · Hostname",
          "Status dot: Active 🟢 Idle ⚪ New 🔵 Unknown ⚠️",
          "Device type icon (inferred: phone/TV/PC/IoT)",
          "\"New Device Joined\" banner alert",
          "Tap → Device Detail bottom sheet",
          "OS badge via TTL fingerprint",
        ],
      },
      {
        name: "Network Health",
        tag: "CORE",
        tagColor: colors.accent,
        items: [
          "Live ping: Router / Google DNS / Cloudflare",
          "Jitter (std dev over 10 samples)",
          "Packet loss % (20-ping burst)",
          "DNS resolution timing",
          "60-second live LineChart",
          "Verdict card: plain-English diagnosis",
          "Problem localization: Router vs ISP vs Local",
        ],
      },
      {
        name: "My Device",
        tag: "CORE",
        tagColor: colors.accent,
        items: [
          "Per-app RX/TX (TrafficStats API)",
          "Top 8 apps bar chart",
          "Background data hogs (screen-off usage)",
          "Real-time bytes/sec live counter",
          "iOS fallback: total device traffic only",
          "Usage history: today vs 7-day avg",
        ],
      },
      {
        name: "Suspected Hogs",
        tag: "SMART",
        tagColor: colors.yellow,
        items: [
          "Ranked suspect list with confidence %",
          "Behavioral labels: Streaming / Download / Call",
          "Response time correlation timeline",
          "\"Lag spike at 9:02 PM — Smart TV spiked same time\"",
          "10-second rolling measurement window",
          "Trigger: when router ping degrades > threshold",
        ],
      },
      {
        name: "Router Control",
        tag: "ADVANCED",
        tagColor: colors.orange,
        items: [
          "State 1: Auto-detecting router brand",
          "State 2: No-login data (UPnP/TR-064)",
          "State 3: Login form + default creds suggester",
          "State 4: Full dashboard (post-login)",
          "Real bandwidth per device (horizontal bar)",
          "Block / Unblock toggle per device",
          "Guided credential helper UI",
        ],
      },
      {
        name: "Device Detail",
        tag: "DRILL-DOWN",
        tagColor: colors.purple,
        items: [
          "Full device profile: all collected signals",
          "Open ports list (from port scan)",
          "Security flags: open Telnet, default creds risk",
          "Response time history graph",
          "Wake-on-LAN button (if MAC stored)",
          "Rename / whitelist / block",
        ],
      },
      {
        name: "Settings & History",
        tag: "UTILITY",
        tagColor: colors.textSecondary,
        items: [
          "Known devices whitelist manager",
          "24-hour ping history graph",
          "Notification preferences",
          "Scan interval config",
          "Credential vault (secure storage)",
          "Export network report",
        ],
      },
    ],
  },
  {
    id: "discovery",
    label: "DISCOVERY ENGINE",
    sublabel: "How devices are found — no login, no root needed",
    color: colors.accent,
    glow: colors.accentGlow,
    border: "#1c4a3a",
    icon: "◈",
    methods: [
      {
        name: "ARP Table Reader",
        req: "NO PERMISSIONS",
        reqColor: colors.accent,
        how: "Read /proc/net/arp via Kotlin native channel. Gives IPs + MACs of all devices that recently communicated. Fastest signal — always run first.",
        output: "IP address + MAC address + completeness flag",
      },
      {
        name: "TCP Connect Scan",
        req: "INTERNET ONLY",
        reqColor: colors.accent,
        how: "Parallel Socket.connect() on ports 80, 443, 22, 7 across all IPs in subnet. 300ms timeout. 30 IPs concurrently via Future.wait(). Catches devices not yet in ARP cache.",
        output: "Live/dead status per IP + which port responded",
      },
      {
        name: "mDNS / Bonjour",
        req: "INTERNET ONLY",
        reqColor: colors.accent,
        how: "Multicast DNS queries via multicast_dns package. Apple devices, Chromecasts, smart speakers broadcast hostnames and service types continuously. Zero probing needed.",
        output: "Hostname (e.g., iPhone-Daniyal.local) + service types",
      },
      {
        name: "SSDP / UPnP Broadcast",
        req: "INTERNET ONLY",
        reqColor: colors.accent,
        how: "Send M-SEARCH to 239.255.255.250:1900. Smart TVs, consoles, routers respond with XML describing device name, model, manufacturer, and UPnP control URL.",
        output: "Device friendly name + model + manufacturer + control URL",
      },
      {
        name: "NetBIOS Query",
        req: "INTERNET ONLY",
        reqColor: colors.accent,
        how: "UDP query to port 137 on discovered IPs. Windows PCs and NAS devices respond with machine name and workgroup.",
        output: "Windows hostname + workgroup name",
      },
      {
        name: "MAC Vendor Lookup",
        req: "LOCAL ASSET",
        reqColor: colors.blue,
        how: "OUI database stored as local JSON asset (first 3 bytes of MAC → vendor). Top 2000 vendors covers 95%+ of home network devices. Wireshark OUI database, trimmed.",
        output: "Vendor string: TP-Link, Apple, Samsung, Xiaomi...",
      },
      {
        name: "TTL OS Fingerprint",
        req: "FREE SIGNAL",
        reqColor: colors.blue,
        how: "Inspect ICMP ping reply TTL: 64 = Linux/Android/iOS/macOS, 128 = Windows, 255 = network hardware. No extra probing — piggybacked on ping sweep.",
        output: "OS family: Linux · Windows · Network Equipment",
      },
    ],
  },
  {
    id: "noLoginRouter",
    label: "NO-LOGIN ROUTER ACCESS",
    sublabel: "Real router data without credentials — often overlooked layer",
    color: colors.yellow,
    glow: "rgba(255,209,102,0.10)",
    border: "#4a3a1a",
    icon: "◎",
    methods: [
      {
        name: "UPnP IGD Protocol",
        potential: "HIGH",
        potColor: colors.accent,
        how: "Most consumer routers support the UPnP Internet Gateway Device standard. Send SOAP requests to the control URL found via SSDP. Can query WAN IP, connection status, and on many routers — the connected client table. Completely standardized, works across brands.",
        unlocks: "WAN IP · Connection type · Client list (router-dependent) · Port mappings",
      },
      {
        name: "TR-064 Protocol",
        potential: "MEDIUM",
        potColor: colors.yellow,
        how: "ISP-deployed routers (especially PTCL Huawei, Jazz ZTE) often expose TR-064 management protocol on LAN port 49000 without requiring auth. Probe http://192.168.1.1:49000/tr64desc.xml — if it responds, you have an API.",
        unlocks: "Device info · WAN status · Connected clients · DNS settings",
      },
      {
        name: "SSDP Response Parsing",
        potential: "MEDIUM",
        potColor: colors.yellow,
        how: "The SSDP M-SEARCH response from the router itself contains its modelName, modelNumber, friendlyName, and a URL to its full UPnP description XML. Parse this before attempting any login — it gives you brand + model for free.",
        unlocks: "Router brand · Model number · Firmware generation hint",
      },
      {
        name: "HTTP Header Fingerprinting",
        potential: "LOW-MEDIUM",
        potColor: colors.orange,
        how: "GET request to http://router-ip/ — inspect Server: header, WWW-Authenticate: realm, and HTML content of the login page. TP-Link uses specific form IDs, Huawei has characteristic meta tags. Build a brand classifier from these signals.",
        unlocks: "Router brand confirmation · Admin panel structure map",
      },
      {
        name: "Gateway ARP + ICMP TTL",
        potential: "LOW",
        potColor: colors.textSecondary,
        how: "The router's MAC OUI gives vendor. Its ICMP TTL (usually 64 or 255) hints at firmware OS. Combined with HTTP fingerprint, this improves brand detection accuracy significantly.",
        unlocks: "Router vendor · Firmware OS family",
      },
      {
        name: "OpenWRT / DD-WRT Detection",
        potential: "HIGH (if present)",
        potColor: colors.accent,
        how: "Check http://router-ip/cgi-bin/luci (OpenWRT) or http://router-ip/Info.htm (DD-WRT). If present, OpenWRT exposes a full JSON ubus API — no scraping needed, clean REST calls.",
        unlocks: "Full client list · Real-time traffic per device · All settings",
      },
    ],
  },
  {
    id: "intelligence",
    label: "INTELLIGENCE LAYER",
    sublabel: "Behavioral inference, correlation, and health scoring",
    color: colors.purple,
    glow: "rgba(192,132,252,0.10)",
    border: "#3a1a5a",
    icon: "◆",
    modules: [
      {
        name: "Ping Engine",
        detail: "3 concurrent streams: Router / 8.8.8.8 / 1.1.1.1. dart_ping package. Rolling 10-sample window for jitter (std dev). 20-ping bursts every 30s for packet loss. 5-minute samples stored to SQLite (288 rows = 24 hours). Problem localization logic: router fast + internet slow = ISP issue.",
      },
      {
        name: "Device Response Profiler",
        detail: "Every 10s, TCP probe each discovered device on its fastest-responding port. Record response time. Maintain 20-sample rolling window. When router ping degrades, diff which device response times increased simultaneously. Rank by correlation strength → suspect list.",
      },
      {
        name: "Behavioral Classifier",
        detail: "Heuristic rules applied to response patterns: Low + stable variance = idle. Periodic bursts every ~10s = video stream. Sustained high TX correlation = upload/call. Sudden activity spike = large download. Output: behavioral label + confidence score (0–100).",
      },
      {
        name: "Jitter & Loss Analyzer",
        detail: "Jitter = std dev of last 10 ping samples. Loss = (timeouts / total) × 100. Thresholds: Jitter >30ms = poor, >80ms = bad. Loss >1% = noticeable, >5% = severe. DNS resolution time tracked separately — elevated DNS + normal ICMP = upstream DNS issue.",
      },
      {
        name: "Rogue Device Detector",
        detail: "On every scan, compare MACs against SQLite known_devices table. First-run seeds whitelist from current scan. New MACs trigger local push notification immediately. Devices that disappear for >7 days are flagged as stale. Unknown vendor + unknown hostname = Unknown Device ⚠️ warning.",
      },
      {
        name: "Correlation Timeline Engine",
        detail: "Timestamps stored per event: device appeared, device went idle, lag spike start, lag spike end. At report time, find temporal overlaps. Output: human-readable incident narrative. \"Smart TV became active at 21:02. Lag spike started at 21:03. Probable cause.\"",
      },
    ],
  },
  {
    id: "routerAuth",
    label: "AUTHENTICATED ROUTER LAYER",
    sublabel: "Per-brand handlers for real bandwidth data and device control",
    color: colors.orange,
    glow: "rgba(251,146,60,0.10)",
    border: "#4a2a1a",
    icon: "⬡",
    brands: [
      { name: "TP-Link", market: "Most common in Pakistan", loginPath: "/", method: "Form POST + session cookie", endpoints: "AssignedIpAddrListRpm.htm · ARP list · QoS control", block: "MAC filter via userRpm/WlanMacFilterRpm.htm" },
      { name: "Huawei HG Series", market: "PTCL default router", loginPath: "/html/index.html", method: "Token-based auth", endpoints: "api/system/deviceinfo · api/wlan/host-list", block: "api/security/mac-filter POST" },
      { name: "ZTE (Jazz/Zong)", market: "Mobile broadband routers", loginPath: "/", method: "Form + cookie session", endpoints: "/goform/GetConnectedDevice · /goform/getStat", block: "/goform/SetMacFilter POST" },
      { name: "D-Link", market: "Common mid-range", loginPath: "/", method: "Basic auth header", endpoints: "getcfg.php?PAGE=Internet · getclientinfo", block: "setclientfilter.php POST" },
      { name: "Netgear", market: "Premium segment", loginPath: "/", method: "SOAP API (ReadyDLNA)", endpoints: "soap/server_sa/XMLHandler.php", block: "MAC ACL via SOAP call" },
      { name: "OpenWRT", market: "Power users / custom firmware", loginPath: "/cgi-bin/luci", method: "ubus JSON-RPC API", endpoints: "ubus: network.wireless · luci-rpc", block: "firewall rule via ubus call" },
    ],
  },
  {
    id: "security",
    label: "SECURITY FEATURES",
    sublabel: "The cybersecurity layer that differentiates this from Fing",
    color: colors.red,
    glow: "rgba(255,107,107,0.10)",
    border: "#4a1a1a",
    icon: "⬡",
    features: [
      { name: "Port Scanner", detail: "On-demand per device. Common ports: 21 (FTP), 22 (SSH), 23 (Telnet — flag red), 80 (HTTP), 443 (HTTPS), 554 (RTSP cameras), 8080, 8443. Display open ports with service label. Telnet open = critical warning. Camera RTSP open = privacy notice." },
      { name: "Default Credential DB", detail: "JSON asset mapping vendor → credential list. Sources: RouterPasswords.com, RouterSploit credentials module. Try list silently in background when router detected. Show: \"This TP-Link may still use admin/admin\" before user even tries." },
      { name: "Device Security Score", detail: "Per-device score 0–100. Deductions: open Telnet (-30), open FTP (-15), unknown device (-10), no hostname (-5), default-cred router (-25). Show badge on device card. Tap for breakdown." },
      { name: "Network Security Report", detail: "Aggregate view: total devices, unknown count, security-flagged devices, router credential status, open dangerous ports. Exportable as PDF/text. Good for screenshots to show in your portfolio." },
      { name: "Wake-on-LAN", detail: "Store MAC addresses. Send UDP magic packet (6x FF + MAC repeated 16x) to broadcast address port 9. Works on same subnet without root. Toggle in Device Detail screen." },
      { name: "Vulnerability Alerts", detail: "Known CVE patterns by device type: cameras with RTSP on default port, routers with Telnet enabled, devices with mDNS exposing sensitive service types. Shown as banner alerts, not buried in settings." },
    ],
  },
  {
    id: "native",
    label: "NATIVE ANDROID LAYER",
    sublabel: "Kotlin platform channels — things Dart alone cannot do",
    color: colors.textSecondary,
    glow: "rgba(100,116,139,0.08)",
    border: "#1c2a3a",
    icon: "◈",
    channels: [
      { name: "ARP Table Reader", api: "/proc/net/arp (filesystem read)", perm: "None", note: "World-readable file. Returns all ARP entries the kernel has cached." },
      { name: "TrafficStats API", api: "android.net.TrafficStats", perm: "None (public API)", note: "Per-UID TX/RX bytes since boot. Diff every second for real-time rate." },
      { name: "UsageStatsManager", api: "android.app.usage.UsageStatsManager", perm: "PACKAGE_USAGE_STATS (user-granted)", note: "Per-app usage over time windows. Needed for background hog detection." },
      { name: "NetworkInterface", api: "java.net.NetworkInterface", perm: "ACCESS_WIFI_STATE", note: "Enumerate local interfaces to get subnet mask for scan range calculation." },
      { name: "WifiManager", api: "android.net.wifi.WifiManager", perm: "ACCESS_FINE_LOCATION", note: "BSSID, SSID, RSSI, channel, frequency band, link speed. Required for WiFi Quality section." },
      { name: "Multicast Lock", api: "WifiManager.MulticastLock", perm: "CHANGE_WIFI_MULTICAST_STATE", note: "Must be held for mDNS and SSDP multicast to work on Android. Acquire before scan, release after." },
    ],
  },
];

const TAGS = {
  "CORE": colors.accent,
  "SMART": colors.yellow,
  "ADVANCED": colors.orange,
  "DRILL-DOWN": colors.purple,
  "UTILITY": colors.textSecondary,
};

function Badge({ text, color }) {
  return (
    <span style={{
      fontSize: 9,
      fontFamily: "'Courier New', monospace",
      fontWeight: 700,
      letterSpacing: "0.12em",
      color,
      border: `1px solid ${color}`,
      borderRadius: 2,
      padding: "1px 5px",
      opacity: 0.9,
    }}>{text}</span>
  );
}

function ScreenCard({ screen }) {
  const [open, setOpen] = useState(false);
  return (
    <div
      onClick={() => setOpen(!open)}
      style={{
        background: open ? "rgba(77,166,255,0.06)" : "rgba(13,17,23,0.8)",
        border: `1px solid ${open ? "#1a4a7a" : colors.border}`,
        borderRadius: 6,
        padding: "10px 12px",
        cursor: "pointer",
        transition: "all 0.2s",
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 12, fontFamily: "'Courier New', monospace", color: colors.textPrimary, fontWeight: 600 }}>
          {screen.name}
        </span>
        <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
          <Badge text={screen.tag} color={screen.tagColor} />
          <span style={{ color: colors.textSecondary, fontSize: 10 }}>{open ? "▲" : "▼"}</span>
        </div>
      </div>
      {open && (
        <ul style={{ margin: "10px 0 0 0", padding: 0, listStyle: "none" }}>
          {screen.items.map((item, i) => (
            <li key={i} style={{
              fontSize: 11,
              color: colors.textSecondary,
              fontFamily: "'Courier New', monospace",
              padding: "3px 0",
              borderLeft: `2px solid ${colors.blue}22`,
              paddingLeft: 8,
              marginBottom: 2,
            }}>
              {item}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

function MethodCard({ method, accentColor }) {
  const [open, setOpen] = useState(false);
  const potential = method.potential || method.req;
  const potColor = method.potColor || method.reqColor;

  return (
    <div
      onClick={() => setOpen(!open)}
      style={{
        background: open ? `${accentColor}08` : "rgba(13,17,23,0.8)",
        border: `1px solid ${open ? accentColor + "44" : colors.border}`,
        borderRadius: 6,
        padding: "10px 12px",
        cursor: "pointer",
        transition: "all 0.2s",
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 12, fontFamily: "'Courier New', monospace", color: colors.textPrimary, fontWeight: 600 }}>
          {method.name}
        </span>
        <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
          <Badge text={potential} color={potColor} />
          <span style={{ color: colors.textSecondary, fontSize: 10 }}>{open ? "▲" : "▼"}</span>
        </div>
      </div>
      {open && (
        <div style={{ marginTop: 10 }}>
          <div style={{
            fontSize: 11,
            color: colors.textSecondary,
            fontFamily: "'Courier New', monospace",
            lineHeight: 1.7,
            borderLeft: `2px solid ${accentColor}44`,
            paddingLeft: 10,
            marginBottom: 8,
          }}>
            {method.how}
          </div>
          {(method.output || method.unlocks) && (
            <div style={{
              fontSize: 10,
              color: accentColor,
              fontFamily: "'Courier New', monospace",
              background: `${accentColor}10`,
              border: `1px solid ${accentColor}22`,
              borderRadius: 4,
              padding: "5px 8px",
            }}>
              OUTPUT → {method.output || method.unlocks}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function ModuleCard({ module, accentColor }) {
  const [open, setOpen] = useState(false);
  return (
    <div
      onClick={() => setOpen(!open)}
      style={{
        background: open ? `${accentColor}08` : "rgba(13,17,23,0.8)",
        border: `1px solid ${open ? accentColor + "44" : colors.border}`,
        borderRadius: 6,
        padding: "10px 12px",
        cursor: "pointer",
        transition: "all 0.2s",
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 12, fontFamily: "'Courier New', monospace", color: colors.textPrimary, fontWeight: 600 }}>
          {module.name}
        </span>
        <span style={{ color: colors.textSecondary, fontSize: 10 }}>{open ? "▲" : "▼"}</span>
      </div>
      {open && (
        <div style={{
          marginTop: 10,
          fontSize: 11,
          color: colors.textSecondary,
          fontFamily: "'Courier New', monospace",
          lineHeight: 1.7,
          borderLeft: `2px solid ${accentColor}44`,
          paddingLeft: 10,
        }}>
          {module.detail}
        </div>
      )}
    </div>
  );
}

function BrandCard({ brand, accentColor }) {
  const [open, setOpen] = useState(false);
  return (
    <div
      onClick={() => setOpen(!open)}
      style={{
        background: open ? `${accentColor}08` : "rgba(13,17,23,0.8)",
        border: `1px solid ${open ? accentColor + "44" : colors.border}`,
        borderRadius: 6,
        padding: "10px 12px",
        cursor: "pointer",
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div>
          <span style={{ fontSize: 12, fontFamily: "'Courier New', monospace", color: colors.textPrimary, fontWeight: 600 }}>{brand.name}</span>
          <span style={{ fontSize: 10, color: colors.textSecondary, fontFamily: "'Courier New', monospace", marginLeft: 8 }}>— {brand.market}</span>
        </div>
        <span style={{ color: colors.textSecondary, fontSize: 10 }}>{open ? "▲" : "▼"}</span>
      </div>
      {open && (
        <div style={{ marginTop: 10, display: "grid", gap: 4 }}>
          {[
            { label: "LOGIN PATH", val: brand.loginPath },
            { label: "AUTH METHOD", val: brand.method },
            { label: "DATA ENDPOINTS", val: brand.endpoints },
            { label: "BLOCK METHOD", val: brand.block },
          ].map(({ label, val }) => (
            <div key={label} style={{ display: "flex", gap: 8 }}>
              <span style={{ fontSize: 9, color: accentColor, fontFamily: "'Courier New', monospace", fontWeight: 700, width: 120, flexShrink: 0, paddingTop: 2 }}>{label}</span>
              <span style={{ fontSize: 11, color: colors.textSecondary, fontFamily: "'Courier New', monospace", lineHeight: 1.5 }}>{val}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function ChannelCard({ ch, accentColor }) {
  const [open, setOpen] = useState(false);
  return (
    <div
      onClick={() => setOpen(!open)}
      style={{
        background: "rgba(13,17,23,0.8)",
        border: `1px solid ${open ? accentColor + "44" : colors.border}`,
        borderRadius: 6,
        padding: "10px 12px",
        cursor: "pointer",
      }}
    >
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span style={{ fontSize: 12, fontFamily: "'Courier New', monospace", color: colors.textPrimary, fontWeight: 600 }}>{ch.name}</span>
        <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
          <Badge text={ch.perm} color={ch.perm === "None" ? colors.accent : colors.yellow} />
          <span style={{ color: colors.textSecondary, fontSize: 10 }}>{open ? "▲" : "▼"}</span>
        </div>
      </div>
      {open && (
        <div style={{ marginTop: 8 }}>
          <div style={{ fontSize: 10, color: colors.blue, fontFamily: "'Courier New', monospace", marginBottom: 4 }}>{ch.api}</div>
          <div style={{ fontSize: 11, color: colors.textSecondary, fontFamily: "'Courier New', monospace", lineHeight: 1.6 }}>{ch.note}</div>
        </div>
      )}
    </div>
  );
}

function LayerSection({ layer, index }) {
  const [open, setOpen] = useState(index === 0);

  const renderContent = () => {
    if (layer.screens) {
      return (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 8 }}>
          {layer.screens.map((s, i) => <ScreenCard key={i} screen={s} />)}
        </div>
      );
    }
    if (layer.methods) {
      return (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 8 }}>
          {layer.methods.map((m, i) => <MethodCard key={i} method={m} accentColor={layer.color} />)}
        </div>
      );
    }
    if (layer.modules) {
      return (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 8 }}>
          {layer.modules.map((m, i) => <ModuleCard key={i} module={m} accentColor={layer.color} />)}
        </div>
      );
    }
    if (layer.brands) {
      return (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 8 }}>
          {layer.brands.map((b, i) => <BrandCard key={i} brand={b} accentColor={layer.color} />)}
        </div>
      );
    }
    if (layer.features) {
      return (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 8 }}>
          {layer.features.map((f, i) => <ModuleCard key={i} module={f} accentColor={layer.color} />)}
        </div>
      );
    }
    if (layer.channels) {
      return (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 8 }}>
          {layer.channels.map((c, i) => <ChannelCard key={i} ch={c} accentColor={layer.color} />)}
        </div>
      );
    }
    return null;
  };

  return (
    <div style={{
      border: `1px solid ${open ? layer.border : colors.border}`,
      borderRadius: 10,
      background: open ? layer.glow : "transparent",
      marginBottom: 12,
      overflow: "hidden",
      transition: "all 0.3s",
    }}>
      <div
        onClick={() => setOpen(!open)}
        style={{
          padding: "14px 18px",
          cursor: "pointer",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          borderBottom: open ? `1px solid ${layer.border}` : "none",
          background: `${layer.color}08`,
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ fontSize: 18, color: layer.color }}>{layer.icon}</span>
          <div>
            <div style={{
              fontSize: 11,
              fontFamily: "'Courier New', monospace",
              fontWeight: 700,
              letterSpacing: "0.15em",
              color: layer.color,
            }}>
              {layer.label}
            </div>
            <div style={{
              fontSize: 10,
              fontFamily: "'Courier New', monospace",
              color: colors.textSecondary,
              marginTop: 1,
            }}>
              {layer.sublabel}
            </div>
          </div>
        </div>
        <div style={{
          width: 24,
          height: 24,
          border: `1px solid ${layer.color}44`,
          borderRadius: 4,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          color: layer.color,
          fontSize: 10,
        }}>
          {open ? "−" : "+"}
        </div>
      </div>
      {open && (
        <div style={{ padding: 14 }}>
          {renderContent()}
        </div>
      )}
    </div>
  );
}

const dataFlow = [
  { from: "Android Kernel", to: "ARP Reader", detail: "/proc/net/arp → MACs+IPs in <100ms" },
  { from: "TCP Scanner", to: "Device List", detail: "Parallel connect scan fills gaps" },
  { from: "mDNS+SSDP", to: "Device Enrichment", detail: "Hostnames, models, service types" },
  { from: "MAC OUI DB", to: "Vendor Labels", detail: "First 3 MAC bytes → brand name" },
  { from: "TTL Analysis", to: "OS Badge", detail: "64=Linux/iOS, 128=Windows, 255=Router" },
  { from: "UPnP IGD", to: "Router Data (No Login)", detail: "SOAP calls → client table, WAN info" },
  { from: "Ping Engine", to: "Health Score", detail: "3 targets, jitter, loss, DNS timing" },
  { from: "Response Profiler", to: "Hog Suspect List", detail: "Correlation: device latency vs lag spike" },
  { from: "TrafficStats API", to: "My Device Stats", detail: "Per-UID bytes diff → app usage rate" },
  { from: "Router Auth", to: "Real Bandwidth", detail: "Brand handler → actual MB/s per device" },
];

export default function App() {
  const [activeTab, setActiveTab] = useState("layers");

  return (
    <div style={{
      background: colors.bg,
      minHeight: "100vh",
      fontFamily: "'Courier New', monospace",
      color: colors.textPrimary,
    }}>
      {/* Header */}
      <div style={{
        borderBottom: `1px solid ${colors.border}`,
        padding: "20px 24px 16px",
        background: "rgba(0,212,170,0.03)",
      }}>
        <div style={{ display: "flex", alignItems: "baseline", gap: 12 }}>
          <span style={{ fontSize: 22, fontWeight: 700, color: colors.accent, letterSpacing: "0.05em" }}>
            NETWATCH
          </span>
          <span style={{ fontSize: 11, color: colors.textSecondary, letterSpacing: "0.1em" }}>
            v1.0 · SYSTEM BLUEPRINT
          </span>
        </div>
        <div style={{ fontSize: 11, color: colors.textSecondary, marginTop: 4, letterSpacing: "0.05em" }}>
          Complete architecture · 7 layers · Click any row to expand
        </div>

        {/* Layer legend */}
        <div style={{ display: "flex", gap: 16, marginTop: 14, flexWrap: "wrap" }}>
          {[
            { label: "UI Screens", color: colors.blue },
            { label: "Discovery", color: colors.accent },
            { label: "No-Login Router", color: colors.yellow },
            { label: "Intelligence", color: colors.purple },
            { label: "Auth Router", color: colors.orange },
            { label: "Security", color: colors.red },
            { label: "Native Android", color: colors.textSecondary },
          ].map(({ label, color }) => (
            <div key={label} style={{ display: "flex", alignItems: "center", gap: 5 }}>
              <div style={{ width: 8, height: 8, borderRadius: "50%", background: color }} />
              <span style={{ fontSize: 10, color: colors.textSecondary, letterSpacing: "0.08em" }}>{label}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Tab nav */}
      <div style={{
        display: "flex",
        gap: 0,
        borderBottom: `1px solid ${colors.border}`,
        padding: "0 24px",
      }}>
        {[
          { id: "layers", label: "SYSTEM LAYERS" },
          { id: "dataflow", label: "DATA FLOW" },
          { id: "permissions", label: "PERMISSIONS MAP" },
        ].map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            style={{
              background: "none",
              border: "none",
              borderBottom: activeTab === tab.id ? `2px solid ${colors.accent}` : "2px solid transparent",
              color: activeTab === tab.id ? colors.accent : colors.textSecondary,
              fontFamily: "'Courier New', monospace",
              fontSize: 10,
              letterSpacing: "0.12em",
              fontWeight: 700,
              padding: "12px 16px",
              cursor: "pointer",
              marginBottom: -1,
            }}
          >
            {tab.label}
          </button>
        ))}
      </div>

      <div style={{ padding: "20px 24px", maxWidth: 1100, margin: "0 auto" }}>

        {activeTab === "layers" && (
          <div>
            {layerConfig.map((layer, i) => (
              <LayerSection key={layer.id} layer={layer} index={i} />
            ))}
          </div>
        )}

        {activeTab === "dataflow" && (
          <div>
            <div style={{
              fontSize: 10,
              color: colors.textSecondary,
              letterSpacing: "0.1em",
              marginBottom: 16,
            }}>
              HOW DATA MOVES THROUGH THE SYSTEM — from raw hardware signals to UI output
            </div>
            <div style={{ display: "grid", gap: 6 }}>
              {dataFlow.map((flow, i) => (
                <div
                  key={i}
                  style={{
                    display: "grid",
                    gridTemplateColumns: "180px 20px 180px 1fr",
                    alignItems: "center",
                    gap: 10,
                    background: colors.surface,
                    border: `1px solid ${colors.border}`,
                    borderRadius: 6,
                    padding: "10px 14px",
                  }}
                >
                  <div style={{
                    fontSize: 11,
                    color: colors.blue,
                    fontWeight: 600,
                    textAlign: "right",
                  }}>{flow.from}</div>
                  <div style={{ color: colors.accent, textAlign: "center", fontSize: 12 }}>→</div>
                  <div style={{
                    fontSize: 11,
                    color: colors.accent,
                    fontWeight: 600,
                  }}>{flow.to}</div>
                  <div style={{
                    fontSize: 10,
                    color: colors.textSecondary,
                    borderLeft: `2px solid ${colors.border}`,
                    paddingLeft: 10,
                  }}>{flow.detail}</div>
                </div>
              ))}
            </div>

            {/* Decision tree for router access */}
            <div style={{
              marginTop: 24,
              border: `1px solid ${colors.yellow}33`,
              borderRadius: 8,
              padding: 16,
              background: "rgba(255,209,102,0.04)",
            }}>
              <div style={{ fontSize: 10, color: colors.yellow, letterSpacing: "0.12em", fontWeight: 700, marginBottom: 14 }}>
                ROUTER ACCESS DECISION TREE
              </div>
              {[
                { step: "1", check: "Read gateway IP from NetworkInterface", result: "Router IP found", color: colors.accent },
                { step: "2", check: "Send SSDP M-SEARCH → parse response XML", result: "Brand + model + UPnP URL identified", color: colors.accent },
                { step: "3", check: "UPnP IGD SOAP call to control URL", result: "No-login: client table, WAN stats", color: colors.yellow },
                { step: "4", check: "Probe TR-064 on port 49000", result: "No-login: management API (ISP routers)", color: colors.yellow },
                { step: "5", check: "HTTP GET / → parse login page fingerprint", result: "Brand confirmed, form fields mapped", color: colors.blue },
                { step: "6", check: "Try default credentials from DB silently", result: "Auto-login if default not changed", color: colors.orange },
                { step: "7", check: "User enters credentials manually", result: "Full dashboard: real bandwidth + block", color: colors.red },
              ].map(item => (
                <div key={item.step} style={{
                  display: "flex",
                  gap: 12,
                  marginBottom: 8,
                  alignItems: "flex-start",
                }}>
                  <div style={{
                    width: 22,
                    height: 22,
                    borderRadius: "50%",
                    background: `${item.color}22`,
                    border: `1px solid ${item.color}66`,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    fontSize: 9,
                    color: item.color,
                    fontWeight: 700,
                    flexShrink: 0,
                  }}>{item.step}</div>
                  <div>
                    <div style={{ fontSize: 11, color: colors.textPrimary }}>{item.check}</div>
                    <div style={{ fontSize: 10, color: item.color, marginTop: 2 }}>→ {item.result}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === "permissions" && (
          <div>
            <div style={{ fontSize: 10, color: colors.textSecondary, letterSpacing: "0.1em", marginBottom: 16 }}>
              ANDROID PERMISSION REQUIREMENTS — mapped to features. Request only what you need, when you need it.
            </div>
            <div style={{ display: "grid", gap: 6 }}>
              {[
                {
                  perm: "ACCESS_FINE_LOCATION",
                  type: "RUNTIME — must ask user",
                  typeColor: colors.orange,
                  unlocks: "WifiManager SSID/BSSID/RSSI · WiFi scan results · Channel info",
                  why: "Android 10+ requires location to prevent WiFi-based location tracking. Cannot scan WiFi without it.",
                  when: "On app first launch, before network scan",
                },
                {
                  perm: "INTERNET",
                  type: "INSTALL-TIME — auto granted",
                  typeColor: colors.accent,
                  unlocks: "TCP connect scan · ping · HTTP router requests · mDNS · SSDP",
                  why: "Standard network access. No user prompt needed.",
                  when: "Always available",
                },
                {
                  perm: "ACCESS_WIFI_STATE",
                  type: "INSTALL-TIME — auto granted",
                  typeColor: colors.accent,
                  unlocks: "WifiManager queries · connection state · frequency band",
                  why: "Read-only WiFi info. Auto granted.",
                  when: "Always available",
                },
                {
                  perm: "ACCESS_NETWORK_STATE",
                  type: "INSTALL-TIME — auto granted",
                  typeColor: colors.accent,
                  unlocks: "NetworkInterface enumeration · connectivity checks",
                  why: "Auto granted. Needed to get subnet mask for scan range.",
                  when: "Always available",
                },
                {
                  perm: "CHANGE_WIFI_MULTICAST_STATE",
                  type: "INSTALL-TIME — auto granted",
                  typeColor: colors.accent,
                  unlocks: "mDNS scanner · SSDP broadcast — both require MulticastLock",
                  why: "Android blocks multicast by default for battery. You must hold a MulticastLock during scan.",
                  when: "Acquire before scan, release after — don't hold permanently",
                },
                {
                  perm: "PACKAGE_USAGE_STATS",
                  type: "SPECIAL — user goes to Settings manually",
                  typeColor: colors.red,
                  unlocks: "UsageStatsManager → per-app time-based usage · background detection",
                  why: "Cannot prompt for this — must send user to Settings > Apps > Special App Access. Show clear explanation why.",
                  when: "Only for My Device screen. Check if granted, show setup guide if not.",
                },
                {
                  perm: "RECEIVE_BOOT_COMPLETED",
                  type: "INSTALL-TIME — auto granted",
                  typeColor: colors.accent,
                  unlocks: "Restart background monitoring service after reboot",
                  why: "Needed if you add persistent rogue device monitoring.",
                  when: "Optional — only if adding background service",
                },
                {
                  perm: "POST_NOTIFICATIONS (Android 13+)",
                  type: "RUNTIME — must ask user",
                  typeColor: colors.orange,
                  unlocks: "Rogue device alerts · security warning notifications",
                  why: "Android 13 requires explicit permission for notifications. Ask after user enables alerts.",
                  when: "When user enables New Device alerts in settings",
                },
              ].map((p, i) => (
                <div key={i} style={{
                  background: colors.surface,
                  border: `1px solid ${colors.border}`,
                  borderRadius: 6,
                  padding: "12px 14px",
                }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 8 }}>
                    <span style={{ fontSize: 12, color: colors.textPrimary, fontWeight: 700 }}>{p.perm}</span>
                    <Badge text={p.type} color={p.typeColor} />
                  </div>
                  <div style={{ display: "grid", gap: 4 }}>
                    {[
                      { label: "UNLOCKS", val: p.unlocks, color: colors.accent },
                      { label: "WHY", val: p.why, color: colors.textSecondary },
                      { label: "WHEN TO REQUEST", val: p.when, color: colors.blue },
                    ].map(({ label, val, color }) => (
                      <div key={label} style={{ display: "flex", gap: 8 }}>
                        <span style={{ fontSize: 9, color, fontWeight: 700, width: 100, flexShrink: 0, paddingTop: 1 }}>{label}</span>
                        <span style={{ fontSize: 10, color: colors.textSecondary, lineHeight: 1.5 }}>{val}</span>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>

            <div style={{
              marginTop: 16,
              padding: 14,
              background: "rgba(0,212,170,0.05)",
              border: `1px solid ${colors.accent}33`,
              borderRadius: 8,
              fontSize: 10,
              color: colors.textSecondary,
              lineHeight: 1.7,
            }}>
              <span style={{ color: colors.accent, fontWeight: 700 }}>ROOT NOT REQUIRED</span> — Every feature in this architecture works on a non-rooted Android device.
              /proc/net/arp is world-readable. TrafficStats is a public API. TCP connect scanning uses standard sockets.
              The only capability requiring root would be raw packet injection for ICMP — instead, use the dart_ping package
              which works through the system ping binary available on all Android versions.
            </div>
          </div>
        )}
      </div>

      {/* Footer */}
      <div style={{
        borderTop: `1px solid ${colors.border}`,
        padding: "12px 24px",
        display: "flex",
        justifyContent: "space-between",
        fontSize: 9,
        color: colors.textMuted,
        letterSpacing: "0.08em",
      }}>
        <span>NETWATCH SYSTEM BLUEPRINT · FLUTTER/ANDROID</span>
        <span>7 LAYERS · 40+ FEATURES · 0 ROOT REQUIRED</span>
      </div>
    </div>
  );
}

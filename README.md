<div align="center">
<img src="./Netwatch Showcase/Landing page.jpeg" width="200" alt="Landing Page">
<br/>Landing Page
<td align="center">
<img src="./Netwatch Showcase/Device Discovery.jpeg" width="200" alt="Device Discovery">
<br/>Device Discovery
</td>
<td align="center">
<img src="./Netwatch Showcase/benefits.jpeg" width="200" alt="Benefits">
<br/>Features Overview
</td>
</tr>
<tr>
  <h1>NetWatch </h1>
  <p>Next-Generation Local Network Intelligence</p>
</div>

---

**NetWatch** is a powerful network intelligence tool built with a beautifully responsive **Flutter** frontend and a hardened, low-level **Kotlin** discovery engine.

Instead of relying on standard Android network APIs—which are increasingly locked down—NetWatch aggressively maps the physical network layer using 64-thread parallel ping sweeps, TTL-based Operating System fingerprinting, and a cocktail of multicast probes including **mDNS, UPnP/SSDP, NetBIOS, and LLMNR**. 

For users, this translates to unparalleled, x-ray-like visibility into their Wi-Fi. It instantly cuts through modern MAC-randomization privacy shields to identify hidden smart devices, flags bandwidth hogs with deep-packet metrics, assesses real-time ping latency and packet loss, and provides a central dashboard for managing smart-home infrastructure.

## 🚀 Features

* **Advanced Device Fingerprinting:** Automatically guesses operating systems (Windows, Linux, iOS, Android, etc.) based on ICMP Time-To-Live (TTL) packet signatures.
* **Multicast Meta-Discovery:** Queries over 40+ mDNS service types (AirDrop, Chromecast, Spotify Connect, IPP), UPnP registries, and NetBIOS name services to extract exact device hostnames (e.g., `Daniyal's iPhone`, `Samsung Series 7 TV`).
* **Live Bandwidth Monitoring:** Polls native `TrafficStats` APIs to monitor your local device's Tx/Rx network load in real time.
* **Hogs Detection Engine:** Identifies heavy network consumers on your subnet and intelligently categorizes their bandwidth load and activity (e.g., *High-bitrate 4K streaming* vs *Background cloud sync*).
* **Router Vulnerability & Management:** Dedicated dashboard to authenticate with local gateways, scan common gateway vulnerabilities, and issue low-level reboot or port scan commands.
* **Modern Cross-Platform UI:** Fully styled using Riverpod reactive state management with dark mode support and micro-animations.

## 🛠️ Architecture

NetWatch breaks free from Flutter's native boundaries by leveraging a specialized **Platform Channels (`MethodChannel`)** implementation. 

1. **Native Discovery Backend (`MainActivity.kt`)**
   - Dispatches parallel `java.util.concurrent` thread pools.
   - Bypasses SELinux and MAC-isolation by constructing raw Datagram UDP queries for LLMNR and NBNS.
   - Listens on Multicast Socket `239.255.255.250:1900` for UPnP broadcasts.
2. **Flutter State Layer (`network_provider.dart`)**
   - Consumes and structures raw native `Map` returns.
   - Computes sorting priority (Routers > Self > Alpbabetical).
   - Generates and streams realtime bandwidth diffs.
3. **Flutter UI Layer (`overview_screen.dart`, etc.)**

## � Gallery

### App Screenshots

<div align="center">

<tr>
<td align="center">
<img src="./Netwatch Showcase/Screenshot_20260510-051513.jpg.jpeg" width="200" alt="Screenshot 1">
<br/>Live Scan
</td>
<td align="center">
<img src="./Netwatch Showcase/Screenshot_20260510-051521.jpg.jpeg" width="200" alt="Screenshot 2">
<br/>Device Details
</td>
<td align="center">
<img src="./Netwatch Showcase/Screenshot_20260510-051528.jpg.jpeg" width="200" alt="Screenshot 3">
<br/>Bandwidth Monitor
</td>
</tr>
</table>

</div>

## �📱 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.10.0+
- [Android Studio](https://developer.android.com/studio) (Android SDK 34)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/netwatch.git
   cd netwatch
   ```

2. **Fetch dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Riverpod providers**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🔐 Permissions

NetWatch requires the following Android permissions to execute its discovery engine effectively:
* `ACCESS_FINE_LOCATION` (Required for SSID extraction on Android 10+)
* `ACCESS_NETWORK_STATE` & `ACCESS_WIFI_STATE`
* `INTERNET`
* `NEARBY_WIFI_DEVICES` (Required for Android 13+ network discovery)
* `FOREGROUND_SERVICE` & `WAKE_LOCK` (For continuous packet monitoring)

---
*Built with ❤️ using Flutter & Kotlin.*

import { createBrowserRouter } from "react-router";
import { OnboardingScreen } from "./components/OnboardingScreen";
import { OverviewScreen } from "./components/OverviewScreen";
import { HealthScreen } from "./components/HealthScreen";
import { MyDeviceScreen } from "./components/MyDeviceScreen";
import { HogsScreen } from "./components/HogsScreen";
import { RouterScreen } from "./components/RouterScreen";
import { SettingsScreen } from "./components/SettingsScreen";
import { DeviceDetailScreen } from "./components/DeviceDetailScreen";
import { AppLayout } from "./components/AppLayout";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <OnboardingScreen />,
  },
  {
    path: "/app",
    element: <AppLayout />,
    children: [
      { index: true, element: <OverviewScreen /> },
      { path: "health", element: <HealthScreen /> },
      { path: "my-device", element: <MyDeviceScreen /> },
      { path: "hogs", element: <HogsScreen /> },
      { path: "router", element: <RouterScreen /> },
      { path: "settings", element: <SettingsScreen /> },
      { path: "device/:id", element: <DeviceDetailScreen /> },
    ],
  },
]);

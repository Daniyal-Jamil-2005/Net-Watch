export function NetworkBackground() {
  return (
    <div className="fixed inset-0 pointer-events-none opacity-30 dark:opacity-20">
      <svg className="absolute inset-0 w-full h-full" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <pattern id="network-pattern" x="0" y="0" width="100" height="100" patternUnits="userSpaceOnUse">
            <circle cx="50" cy="50" r="1.5" fill="currentColor" className="text-blue-500 dark:text-blue-400" />
            <circle cx="0" cy="0" r="1" fill="currentColor" className="text-blue-400 dark:text-blue-500" opacity="0.5" />
            <circle cx="100" cy="0" r="1" fill="currentColor" className="text-blue-400 dark:text-blue-500" opacity="0.5" />
            <circle cx="0" cy="100" r="1" fill="currentColor" className="text-blue-400 dark:text-blue-500" opacity="0.5" />
            <circle cx="100" cy="100" r="1" fill="currentColor" className="text-blue-400 dark:text-blue-500" opacity="0.5" />
            <line x1="50" y1="50" x2="0" y2="0" stroke="currentColor" strokeWidth="0.5" className="text-blue-300 dark:text-blue-600" opacity="0.3" />
            <line x1="50" y1="50" x2="100" y2="0" stroke="currentColor" strokeWidth="0.5" className="text-blue-300 dark:text-blue-600" opacity="0.3" />
            <line x1="50" y1="50" x2="0" y2="100" stroke="currentColor" strokeWidth="0.5" className="text-blue-300 dark:text-blue-600" opacity="0.3" />
            <line x1="50" y1="50" x2="100" y2="100" stroke="currentColor" strokeWidth="0.5" className="text-blue-300 dark:text-blue-600" opacity="0.3" />
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#network-pattern)" />
      </svg>
    </div>
  );
}

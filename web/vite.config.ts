import { defineConfig, optimizeDeps } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: './',
  build: {
    chunkSizeWarningLimit: 500,
    outDir: 'build',
  },
  esbuild: {
    logOverride: { 'this-is-undefined-in-esm': 'silent' },
  },
});

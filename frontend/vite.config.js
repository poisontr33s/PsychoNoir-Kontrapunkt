import { defineConfig } from 'vite'
import legacy from '@vitejs/plugin-legacy'

// Stalwart Observatory v3.0 - Vite Configuration
export default defineConfig({
  plugins: [
    legacy({
      targets: ['defaults', 'not IE 11']
    })
  ],
  
  // Build configuration
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    target: 'es2020',
    
    rollupOptions: {
      input: {
        main: './index.html'
      },
      output: {
        manualChunks: {
          // Psycho-Noir themed chunking
          'skyskraperen-core': ['./scripts/main.js'],
          'observatory-utils': ['./scripts/utils.js']
        }
      }
    },
    
    // Digital Necromancy: Extract maximum value from build process
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    }
  },
  
  // Development server
  server: {
    port: 3000,
    host: true,
    open: true,
    cors: true
  },
  
  // CSS Processing
  css: {
    postcss: './postcss.config.js',
    devSourcemap: true
  },
  
  // Resolve configuration
  resolve: {
    alias: {
      '@': './src',
      '@styles': './styles',
      '@scripts': './scripts'
    }
  },
  
  // Define global constants for Psycho-Noir themes
  define: {
    __SKYSKRAPEREN_MODE__: JSON.stringify(true),
    __OBSERVATORY_VERSION__: JSON.stringify('3.0.0'),
    __STALWART_BUILD__: JSON.stringify(true)
  }
})
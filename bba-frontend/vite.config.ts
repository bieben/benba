import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    watch: {
      usePolling: true, // 确保文件改动时正确触发 HMR
    },
    host: true, // 允许外部访问
    port: 5173, // 端口
    strictPort: true, // 确保使用指定端口
  },
});

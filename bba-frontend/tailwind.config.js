/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: "#11173f", // Clippers 蓝色
        secondary: "#c8102e", // Clippers 红色
        thirdary:"#4891ce",
        accent: "#000000", // 黑色强调
      },
    },
  },
  plugins: [],
};

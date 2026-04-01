# 技术方案设计：004-ui-theme v1

---
feature: ui-theme-adjustment
version: v1
createdBy: arch
createdAt: 2026-04-01
---

## 主题架构

```
src/
├── styles/
│   ├── themes/
│   │   ├── light.css.ts      # 明色主题
│   │   └── dark.css.ts       # 暗色主题
│   ├── tokens/
│   │   ├── colors.ts         # 颜色变量
│   │   ├── typography.ts     # 字体
│   │   ├── spacing.ts        # 间距
│   │   └── shadows.ts        # 阴影
│   └── index.less            # 主题入口
└── components/
    └── ThemeProvider.tsx     # 主题提供者
```

---

## 主题配置

### 颜色系统

```typescript
// 主色调
primary: {
  50: '#e6f7ff',
  100: '#bae7ff',
  200: '#91d5ff',
  300: '#69c0ff',
  400: '#40a9ff',
  500: '#1890ff', // 品牌色
  600: '#096dd9',
  700: '#0050b3',
  800: '#003a8c',
  900: '#002766'
}

// 功能色
success: '#52c41a'
warning: '#faad14'
error: '#f5222d'
```

### 暗色模式

使用 CSS Variables 实现动态切换：

```css
:root {
  --bg-color: #ffffff;
  --text-color: #000000;
}

[data-theme='dark'] {
  --bg-color: #141414;
  --text-color: #ffffff;
}
```

---

## 任务拆解

详见 `tasks.md`

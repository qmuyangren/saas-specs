# 任务清单：004-ui-theme v1

---
feature: ui-theme-adjustment
version: v1
createdBy: arch
createdAt: 2026-04-01
---

## 任务概览

| ID | 任务 | 负责人 | 状态 | 预计工时 |
|----|------|--------|------|----------|
| T1 | 创建主题配置文件 | @fe | [ ] pending | 1h |
| T2 | 实现主题切换组件 | @fe | [ ] pending | 2h |
| T3 | 调整全局样式 | @fe | [ ] pending | 2h |
| T4 | 优化暗色模式 | @fe | [ ] pending | 2h |

---

## 任务详情

### T1: 创建主题配置文件

**阅读文件**:
- `design.md` - 技术方案

**任务**:
- [ ] 创建 `src/styles/tokens/colors.ts`
- [ ] 创建 `src/styles/tokens/typography.ts`
- [ ] 创建 `src/styles/tokens/spacing.ts`
- [ ] 创建 `src/styles/tokens/shadows.ts`
- [ ] 创建 `src/styles/themes/light.ts`
- [ ] 创建 `src/styles/themes/dark.ts`
- [ ] 创建 `flags/fe-theme-config.done`

**验收标准**:
- 颜色系统完整（主色 + 功能色）
- 字体规范统一
- 间距使用 8px 基准
- 阴影层次清晰

---

### T2: 实现主题切换组件

**任务**:
- [ ] 创建 `ThemeProvider.tsx` 组件
- [ ] 实现 `useTheme()` Hook
- [ ] 添加主题切换按钮
- [ ] 支持系统自动检测（prefers-color-scheme）
- [ ] 主题持久化（localStorage）
- [ ] 创建 `flags/fe-theme-provider.done`

**验收标准**:
- 支持明/暗主题切换
- 切换流畅无闪烁
- 记住用户偏好
- 支持系统自动检测

---

### T3: 调整全局样式

**任务**:
- [ ] 更新 `src/styles/index.less`
- [ ] 应用 CSS Variables
- [ ] 统一按钮样式
- [ ] 统一卡片样式
- [ ] 统一表单样式
- [ ] 创建 `flags/fe-global-styles.done`

**验收标准**:
- 所有组件使用主题变量
- 样式一致
- 无硬编码颜色值

---

### T4: 优化暗色模式

**任务**:
- [ ] 定义暗色主题变量
- [ ] 调整对比度（WCAG 2.1 AA）
- [ ] 测试所有页面暗色模式
- [ ] 修复暗色模式下的显示问题
- [ ] 创建 `flags/fe-dark-mode.done`

**验收标准**:
- 暗色模式完整
- 对比度符合标准
- 无明显显示问题

---

## 完成标记

```bash
# T1: 主题配置
echo "completed at: $(date -Iseconds)" > flags/fe-theme-config.done

# T2: 主题切换
echo "completed at: $(date -Iseconds)" > flags/fe-theme-provider.done

# T3: 全局样式
echo "completed at: $(date -Iseconds)" > flags/fe-global-styles.done

# T4: 暗色模式
echo "completed at: $(date -Iseconds)" > flags/fe-dark-mode.done
```

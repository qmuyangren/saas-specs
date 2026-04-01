# 团队协作指南

---

## 📐 团队角色

| 角色 | 工作区 | 职责 | 完成标记 |
|------|--------|------|----------|
| **PM** | workspace-pm | 需求分析、任务派发、验收 | status.md |
| **Arch** | workspace-arch | 技术方案设计、任务拆解 | design.md + tasks.md |
| **BE** | workspace-be | 后端代码生成 | flags/be-*.done |
| **FE** | workspace-fe | 前端代码生成 | flags/fe-*.done |
| **Mobile** | workspace-mobile | 移动端代码生成 | flags/mobile.done |
| **Tester** | workspace-tester | 端到端测试、性能测试 | flags/tester.done |

---

## 🔄 完整协作流程

```
用户需求
   ↓
PM 创建 proposal.md
   ↓
Arch 创建设计文档（design.md + tasks.md + openapi.yaml）
   ↓
PM 派发任务（@be @fe @mobile）
   ↓
┌───────────┬───────────┬───────────┐
│  BE       │  FE       │  Mobile   │
│ 调用 Opencode        │ 调用 Opencode        │ 调用 Opencode        │
│ 生成代码             │ 生成代码             │ 生成代码             │
│ be.done              │ fe.done              │ mobile.done          │
└───────────┴───────────┴───────────┘
   ↓
Tester 进行测试
   ↓
┌───────────────────────────────────┐
│ - 端到端测试（Playwright）        │
│ - 性能测试（Lighthouse）          │
│ - 生成测试报告                    │
│ - tester.done                     │
└───────────────────────────────────┘
   ↓
PM 检查所有完成标记
   ↓
更新 status.md = completed
   ↓
回复用户：✅ 功能已完成
```

---

## 📋 任务派发格式

### PM 派发任务

```markdown
@be 请实现 003-password-reset 的 T1 和 T2 任务

规范位置：specs/openspec/changes/003-password-reset/v1/
- openapi.yaml - API 契约
- design.md - 技术方案
- tasks.md - 任务详情

请读取规范后调用 Opencode 生成代码，完成后创建 flags/be-send.done 和 flags/be-reset.done
```

```markdown
@fe 请实现 003-password-reset 的 T3 任务

规范位置：specs/openspec/changes/003-password-reset/v1/openapi.yaml

请读取规范后调用 Opencode 生成 Vue3 代码，完成后创建 flags/fe.done
```

```markdown
@tester 请对 003-password-reset 功能进行验收测试

测试范围：
- 端到端测试：完整密码重置流程
- 性能测试：重置密码页面
- 测试报告：workspace-tester/reports/003-password-reset/
```

---

## ✅ 完成标准

### 开发完成

- [ ] BE 创建 flags/be-*.done
- [ ] FE 创建 flags/fe-*.done
- [ ] Mobile 创建 flags/mobile.done
- [ ] tasks.md 中对应任务状态为 `[x] done`

### 测试完成

- [ ] Tester 创建 flags/tester.done
- [ ] 测试报告已生成
- [ ] 所有测试用例通过
- [ ] 性能指标达标（Performance ≥ 90）

### 交付完成

- [ ] status.md 更新为 `✅ 已完成`
- [ ] PM 确认验收
- [ ] 测试报告已归档

---

## 🐛 错误处理流程

### 错误分级

| 级别 | 类型 | 处理者 | 次数 |
|------|------|--------|------|
| Level 1 | 语法错误 | OpenCode | 3 次 |
| Level 2 | 逻辑错误 | 开发角色 | 2 次 |
| Level 3 | 设计缺陷 | Arch | 1 次 |
| Level 4 | 环境问题 | 人工 | ∞ |

### 错误记录

**位置**: `specs/openspec/changes/{功能}/errors/`

**格式**: `{SERVICE}-{YYYY}-{NNN}.md`

示例：
- `BE-2026-001.md` - 后端第 1 个错误
- `FE-2026-001.md` - 前端第 1 个错误
- `TE-2026-001.md` - 测试第 1 个错误

### 上报 PM 格式

```markdown
@pm 🚨 错误上报

**错误 ID**: BE-2026-001
**严重级别**: Level 2
**任务**: 实现密码重置 API

**错误信息**:
```
重置密码后没有返回 token
```

**已尝试修复**: 2 次（失败）

**建议**: 需要检查 AuthService 的 JWT 生成逻辑

**相关文件**:
- errors/BE-2026-001.md
- specs/changes/003-password-reset/v1/tasks.md
```

---

## 📊 测试流程

### Tester 工作流程

```
1. 接收 PM 测试任务
   ↓
2. 读取测试规范（proposal.md + tasks.md）
   ↓
3. 创建测试脚本
   ↓
4. 运行测试
   ├─ 端到端测试（Playwright）
   ├─ 性能测试（Lighthouse）
   └─ 兼容性测试
   ↓
5. 生成测试报告
   ↓
6. 更新 tasks.md（T7 = done）
   ↓
7. 创建 tester.done 标记
   ↓
8. 通知 PM
```

### 测试报告结构

```
workspace-tester/reports/{功能}/
├── test-report.md           # 测试报告
├── lighthouse-{页面}.html   # 性能报告
└── screenshots/             # 测试截图
    ├── success.png
    ├── error-wrong-code.png
    └── error-weak-password.png
```

---

## 🎯 快速参考

### 各角色常用命令

**PM**:
```bash
# 创建需求
mkdir -p specs/openspec/changes/005-new-feature/v1
cat > specs/openspec/changes/005-new-feature/v1/proposal.md

# 派发任务
@be @fe @mobile @tester

# 检查进度
ls specs/openspec/changes/{功能}/flags/
```

**Arch**:
```bash
# 创建设计文档
cat > specs/openspec/changes/{功能}/v1/design.md
cat > specs/openspec/changes/{功能}/v1/openapi.yaml
cat > specs/openspec/changes/{功能}/v1/tasks.md
```

**BE/FE/Mobile**:
```bash
# 读取规范
cat specs/openspec/changes/{功能}/v1/openapi.yaml

# 调用 Opencode
sessions_spawn --runtime subagent --label opencode-{端} \
  --cwd workspace-{端}/{目录} \
  --task "根据规范生成代码"

# 创建完成标记
echo "completed at: $(date -Iseconds)" > flags/{端}.done
```

**Tester**:
```bash
# 创建测试脚本
cat > tests/e2e/{功能}.spec.ts

# 运行测试
npx playwright test tests/e2e/{功能}.spec.ts

# 生成报告
npx playwright test --reporter=html

# 性能测试
lighthouse http://localhost:5173/{页面} --output=html
```

---

## 📁 目录约定

### 规范目录（Arch 管理）

```
workspace-arch/specs/openspec/
├── changes/
│   └── {功能}/v1/
│       ├── proposal.md      (PM)
│       ├── design.md        (Arch)
│       ├── openapi.yaml     (Arch)
│       ├── tasks.md         (Arch)
│       ├── status.md        (PM)
│       ├── errors/          (所有角色)
│       └── flags/           (开发角色 + Tester)
```

### 代码目录（各端管理）

```
workspace-{端}/{代码目录}/
├── src/
├── tests/
├── flags/                   (完成标记)
└── .git/
```

### 测试目录（Tester 管理）

```
workspace-tester/
├── tests/
│   ├── e2e/
│   ├── integration/
│   └── performance/
├── reports/
│   └── {功能}/
│       ├── test-report.md
│       └── screenshots/
└── flags/
    └── tester.done
```

---

_最后更新：2026-04-01_

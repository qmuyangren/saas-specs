# OpenClaw 完整开发流程指南

**版本**: v1.0  
**最后更新**: 2026-04-01  
**适用范围**: SaaS 平台开发团队

---

## 📐 团队角色

| 角色 | 工作区 | 职责 | 完成标记 |
|------|--------|------|----------|
| **PM** | workspace-pm | 需求分析、任务派发、验收交付 | status.md |
| **Arch** | workspace-arch | 技术方案设计、任务拆解、API 定义 | design.md + tasks.md |
| **BE** | workspace-be | 后端代码实现、单元测试 | flags/be-*.done |
| **FE** | workspace-fe | 前端代码实现、组件测试 | flags/fe-*.done |
| **Mobile** | workspace-mobile | 移动端代码实现 | flags/mobile.done |
| **Tester** | workspace-tester | E2E 测试、性能测试、缺陷报告 | flags/tester.done |

---

## 🔄 完整开发流程

```
用户需求
   ↓
1️⃣ PM 创建需求提案 (proposal.md)
   ↓
2️⃣ Arch 设计技术方案 (design.md + openapi.yaml + tasks.md)
   ↓
3️⃣ PM 派发任务 (@be @fe @mobile)
   ↓
┌───────────┬───────────┬───────────┐
│  BE       │  FE       │  Mobile   │
│ 调用 Opencode        │ 调用 Opencode        │ 调用 Opencode        │
│ 生成后端代码         │ 生成前端代码         │ 生成移动端代码       │
│ be.done              │ fe.done              │ mobile.done          │
└───────────┴───────────┴───────────┘
   ↓
4️⃣ Tester 进行测试 (E2E + 性能)
   ↓
┌───────────────────────────────────┐
│ - 端到端测试（Playwright）        │
│ - 性能测试（Lighthouse）          │
│ - 生成测试报告                    │
│ - tester.done                     │
└───────────────────────────────────┘
   ↓
5️⃣ PM 检查所有完成标记
   ↓
6️⃣ 更新 status.md = completed
   ↓
7️⃣ 回复用户：✅ 功能已完成
```

---

## 📋 详细步骤

### 步骤 1：PM 创建需求提案

**工作区**: `workspace-pm/`

**操作**:
```bash
cd ~/.openclaw/workspace-pm

# 创建需求目录
mkdir -p specs/openspec/changes/005-new-feature/v1

# 创建需求提案
cat > specs/openspec/changes/005-new-feature/v1/proposal.md << 'EOF'
# 变更提案：005-new-feature

## 背景
为什么做这个功能

## 目标
做什么，达到什么效果

## 用户故事
作为 XX 用户，我希望 XX，以便 XX

## 功能列表
- [ ] 功能点 1
- [ ] 功能点 2

## 验收标准
- [ ] 标准 1
- [ ] 标准 2

## 优先级
P0 / P1 / P2

## @arch 请设计技术方案
EOF
```

**输出**: `proposal.md`

---

### 步骤 2：Arch 设计技术方案

**工作区**: `workspace-arch/`

**操作**:
```bash
cd ~/.openclaw/workspace-arch

# 读取需求
cat specs/openspec/changes/005-new-feature/v1/proposal.md

# 创建技术方案
cat > specs/openspec/changes/005-new-feature/v1/design.md << 'EOF'
# 技术方案设计：005-new-feature v1

## 架构设计
（架构图 + 技术选型）

## API 设计
（API 端点定义）

## 数据模型
（数据库设计）

## 安全机制
（权限 + 加密）
EOF

# 创建 API 契约
cat > specs/openspec/changes/005-new-feature/v1/openapi.yaml << 'EOF'
openapi: 3.0.0
info:
  title: 新功能 API
  version: 1.0.0
paths:
  /api/v1/new-feature:
    post:
      summary: 新功能接口
      ...
EOF

# 创建数据模型
cat > specs/openspec/changes/005-new-feature/v1/schema.prisma << 'EOF'
model NewFeature {
  id Int @id @default(autoincrement())
  ...
}
EOF

# 创建任务清单
cat > specs/openspec/changes/005-new-feature/v1/tasks.md << 'EOF'
# 任务清单：005-new-feature v1

| ID | 任务 | 负责人 | 测试要求 | 状态 |
|----|------|--------|----------|------|
| T1 | 后端实现 | @be | 单元测试 + 集成测试 | [ ] pending |
| T2 | 前端实现 | @fe | 组件测试 + UI 自测 | [ ] pending |
| T3 | 移动端实现 | @mobile | 组件测试 | [ ] pending |
| T4 | E2E 测试 | @tester | Playwright | [ ] pending |
EOF
```

**输出**: `design.md` + `openapi.yaml` + `schema.prisma` + `tasks.md`

---

### 步骤 3：PM 派发任务

**操作**:
```bash
cd ~/.openclaw/workspace-pm

# 派发后端任务
@be 请实现 005-new-feature 的 T1 任务

规范位置：specs/openspec/changes/005-new-feature/v1/
- openapi.yaml - API 契约
- schema.prisma - 数据模型
- tasks.md - 任务详情

请读取规范后调用 Opencode 生成代码，完成后创建 flags/be.done
```

**派发格式**:
```markdown
@{角色} 请实现 {功能编号} 的 {任务 ID} 任务

规范位置：specs/openspec/changes/{功能}/v1/
- openapi.yaml - API 契约
- design.md - 技术方案
- tasks.md - 任务详情

请读取规范后调用 Opencode 生成代码，完成后创建 flags/{角色}.done
```

---

### 步骤 4：开发角色实现代码

#### BE 后端开发

**工作区**: `workspace-be/`

**操作**:
```bash
cd ~/.openclaw/workspace-be

# 1. 读取规范
cat specs/openspec/changes/005-new-feature/v1/openapi.yaml
cat specs/openspec/changes/005-new-feature/v1/schema.prisma

# 2. 调用 Opencode 生成代码
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  mode: "run",
  cwd: "~/.openclaw/workspace-be/server",
  task: `请根据以下规范生成 NestJS 代码：
  
  规范文件：
  - specs/openspec/changes/005-new-feature/v1/openapi.yaml
  - specs/openspec/changes/005-new-feature/v1/schema.prisma
  
  要求生成：
  1. Entity
  2. DTO
  3. Controller
  4. Service
  5. Module
  
  输出目录：src/modules/new-feature/`
})

# 3. 等待执行完成
sessions_yield({
  message: "等待 Opencode 生成后端代码..."
})

# 4. 验证生成的代码
ls -la server/src/modules/new-feature/

# 5. 运行测试
cd server && npm run test

# 6. 创建完成标记
echo "completed at: $(date -Iseconds)" > \
  ~/.openclaw/workspace-arch/specs/openspec/changes/005-new-feature/v1/flags/be.done

# 7. 更新 tasks.md 状态
# 将 T1 状态从 [ ] pending 改为 [x] done

# 8. 通知 PM
@pm T1 后端任务已完成，代码已由 Opencode 生成，验证通过。
```

#### FE 前端开发

**工作区**: `workspace-fe/`

**操作**:
```bash
cd ~/.openclaw/workspace-fe/web

# 1. 读取规范
cat ../specs/openspec/changes/005-new-feature/v1/openapi.yaml

# 2. 调用 Opencode 生成代码
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  mode: "run",
  cwd: "~/.openclaw/workspace-fe/web",
  task: `请根据以下规范生成 Vue3 代码：
  
  规范文件：
  - specs/openspec/changes/005-new-feature/v1/openapi.yaml
  
  要求生成：
  1. Vue 组件
  2. 表单验证
  3. API 调用
  4. 样式
  
  输出目录：src/pages/new-feature/`
})

# 3-8. 同上...
```

---

### 步骤 5：Tester 进行测试

**工作区**: `workspace-tester/`

**操作**:
```bash
cd ~/.openclaw/workspace-tester

# 1. 接收 PM 测试任务
# @tester 请对 005-new-feature 功能进行验收测试

# 2. 读取测试规范
cat ../workspace-arch/specs/openspec/changes/005-new-feature/v1/proposal.md
cat ../workspace-arch/specs/openspec/changes/005-new-feature/v1/tasks.md

# 3. 创建测试脚本
cat > tests/e2e/005-new-feature.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('新功能 - E2E 测试', () => {
  test('正常流程', async ({ page }) => {
    await page.goto('/new-feature');
    // 测试步骤...
  });
});
EOF

# 4. 启动前端应用（如果需要）
cd ../workspace-fe/web && npm run dev &

# 5. 运行测试
cd ../workspace-tester
BASE_URL=http://localhost:5173 npx playwright test tests/e2e/005-new-feature.spec.ts

# 6. 查看测试报告
npx playwright show-report

# 7. 如果测试通过，创建完成标记
echo "completed at: $(date -Iseconds)" > \
  ~/.openclaw/workspace-arch/specs/openspec/changes/005-new-feature/v1/flags/tester.done

# 8. 如果测试失败，自动上报
# Playwright 自动截图 + 录屏
# 错误记录保存到：errors/TE-2026-XXX.md
# PM 通知保存到：pm-notifications.json

# 9. 通知 PM
@pm 005-new-feature 测试完成，测试结果：通过/失败
```

---

### 步骤 6：PM 验收交付

**工作区**: `workspace-pm/`

**操作**:
```bash
cd ~/.openclaw/workspace-pm

# 1. 检查所有完成标记
ls specs/openspec/changes/005-new-feature/v1/flags/
# 应该看到：be.done, fe.done, mobile.done, tester.done

# 2. 查看测试报告
open ../workspace-tester/playwright-report/index.html

# 3. 更新 status.md
cat > specs/openspec/changes/005-new-feature/v1/status.md << 'EOF'
# 状态追踪：005-new-feature v1

## 整体状态
✅ 已完成

## 任务进度
| ID | 任务 | 负责人 | 状态 | 完成时间 |
|----|------|--------|------|----------|
| T1 | 后端实现 | @be | ✅ done | 2026-04-01 15:00 |
| T2 | 前端实现 | @fe | ✅ done | 2026-04-01 15:05 |
| T3 | 移动端实现 | @mobile | ✅ done | 2026-04-01 15:10 |
| T4 | E2E 测试 | @tester | ✅ done | 2026-04-01 15:15 |

## 测试报告
- E2E 测试：全部通过
- 性能测试：Performance 95 分

## 交付确认
- [x] 后端接口已完成
- [x] 前端页面已完成
- [x] 移动端页面已完成
- [x] 所有测试已通过
EOF

# 4. 回复用户
✅ 功能 005-new-feature 已完成，可以交付使用！
```

---

## 🐛 错误处理流程

### 错误分级

| 级别 | 类型 | 处理者 | 次数 | 失败后 |
|------|------|--------|------|--------|
| Level 1 | 语法错误 | OpenCode | 3 次 | 升级 Level 2 |
| Level 2 | 逻辑错误 | 开发角色 | 2 次 | 上报 PM |
| Level 3 | 设计缺陷 | Arch | 1 次 | PM 决定 |
| Level 4 | 环境问题 | 人工 | ∞ | 记录方案 |

### 错误记录格式

**位置**: `specs/openspec/changes/{功能}/errors/{SERVICE}-{YYYY}-{NNN}.md`

**模板**:
```markdown
# 错误记录：TE-2026-001

---
error_id: TE-2026-001
created_at: 2026-04-01T15:15:00.000Z
severity: Level 2
status: open
---

## 错误信息

**测试**: {测试名称}  
**浏览器**: chromium  
**耗时**: {时间}ms  
**发现时间**: {时间}  
**严重级别**: Level 2

### 错误内容

```
{错误堆栈}
```

---

## 错误分析

**类型**: {类型}

**原因**:
- 

**影响范围**:
- 

---

## 修复尝试

### 尝试 1
**时间**: {时间}  
**操作**: {做了什么}  
**结果**: ❌ 失败

---

## 最终状态

- [ ] 已修复
- [ ] 修复中
- [ ] 需要人工介入

**修复方案**:
```
待填写
```

---

## 预防措施

- [ ] 更新 tasks.md
- [ ] 更新 design.md
- [ ] 添加检查步骤

---

## 附件

### 截图
- 截图：test-results/.../test-failed-1.png

---

## 相关文件

- 测试文件：tests/e2e/*.spec.ts
- 错误模板：../../ERROR_TEMPLATE.md
- 处理指南：../../ERROR_HANDLING.md
```

### 上报 PM 格式

```markdown
@pm 🚨 错误上报

**错误 ID**: BE-2026-001
**严重级别**: Level 2
**任务**: 实现新功能 API

**错误信息**:
```
API 返回格式错误
```

**已尝试修复**: 2 次（失败）

**建议**: 需要检查 Service 层逻辑

**相关文件**:
- errors/BE-2026-001.md
- specs/changes/005-new-feature/v1/tasks.md
```

---

## 📊 测试体系

### 测试类型

| 类型 | 工具 | 执行者 | 时机 |
|------|------|--------|------|
| 单元测试 | Jest/Vitest | OpenCode | 代码生成时 |
| 集成测试 | Supertest | OpenCode | 代码完成后 |
| E2E 测试 | Playwright | Tester | 所有开发完成后 |
| 性能测试 | Lighthouse | Tester | E2E 测试后 |
| UI 自测 | Chrome DevTools | 开发角色 | 集成测试后 |

### 测试命令

```bash
cd ~/.openclaw/workspace-tester

# 运行所有测试
npm run test

# 运行特定功能测试
npm run test:003  # 密码重置
npm run test:004  # 主题调整

# 性能测试
npm run lighthouse

# 查看报告
npm run test:report
```

---

## 📁 目录结构

```
~/.openclaw/
├── workspace-arch/
│   └── specs/openspec/
│       ├── ERROR_TEMPLATE.md
│       ├── ERROR_HANDLING.md
│       ├── TEAM_GUIDE.md
│       └── changes/
│           └── {功能}/v1/
│               ├── proposal.md
│               ├── design.md
│               ├── openapi.yaml
│               ├── tasks.md
│               ├── status.md
│               └── errors/
│
├── workspace-pm/
│   └── specs/ → ../workspace-arch/specs
│
├── workspace-be/
│   ├── server/
│   ├── specs/ → ../workspace-arch/specs
│   └── flags/
│
├── workspace-fe/
│   ├── web/
│   ├── specs/ → ../workspace-arch/specs
│   └── flags/
│
└── workspace-tester/
    ├── tests/e2e/
    ├── scripts/
    ├── test-reports/
    └── screenshots/
```

---

## 🎯 快速参考

### 常用命令

```bash
# 查看规范
cat specs/openspec/changes/{功能}/v1/tasks.md

# 创建完成标记
echo "completed at: $(date -Iseconds)" > flags/{角色}.done

# 运行测试
cd workspace-tester && npm run test:003

# 查看测试报告
open workspace-tester/playwright-report/index.html

# 查看错误记录
cat specs/openspec/changes/{功能}/errors/*.md

# 查看 PM 通知
cat workspace-tester/pm-notifications.json
```

---

## 📚 相关文档

- [ERROR_TEMPLATE.md](./ERROR_TEMPLATE.md) - 错误记录模板
- [ERROR_HANDLING.md](./ERROR_HANDLING.md) - 错误分级处理指南
- [TEAM_GUIDE.md](./TEAM_GUIDE.md) - 团队协作指南
- [ACCESS_GUIDE.md](./ACCESS_GUIDE.md) - 规范访问指南

---

_最后更新：2026-04-01_

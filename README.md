# SaaS 平台规范仓库 (OpenSpec)

## 📐 项目说明

这是 SaaS 平台的**规范仓库**，所有功能开发的**施工蓝图**。

**核心理念**：
- ✅ 规范先行 - 先定义 API 和数据模型，再生成代码
- ✅ AI 驱动 - 通过 Opencode AI 自动生成代码
- ✅ 版本管理 - 每个功能有独立的版本号
- ✅ 可追溯 - 规范和代码版本绑定

---

## 📁 目录结构

```
openspec/
├── base/                    # 基础规范（所有项目共享）
│   ├── project.md           # 技术栈规范
│   └── api-style.md         # API 设计规范
│
├── changes/                 # 变更提案（活跃功能）
│   ├── 001-user-login/v1/
│   │   ├── proposal.md      # 需求提案
│   │   ├── design.md        # 技术方案
│   │   ├── openapi.yaml     # API 契约
│   │   ├── schema.prisma    # 数据模型
│   │   ├── tasks.md         # 任务清单
│   │   ├── status.md        # 状态追踪
│   │   └── flags/           # 完成标记
│   │       ├── be.done
│   │       ├── fe.done
│   │       └── mobile.done
│   └── 002-user-register/v1/
│
└── archive/                 # 归档的完成功能
    └── 2026-03-31-001-user-login/
```

---

## 🔄 完整工作流程

### 步骤 1：PM 创建需求提案

```bash
cd ~/.openclaw/workspace/saas-specs

# 创建变更目录
mkdir -p openspec/changes/003-new-feature/v1

# 创建 proposal.md
cat > openspec/changes/003-new-feature/v1/proposal.md << 'EOF'
# 变更提案：003-new-feature

## 背景
...

## 目标
...

## 验收标准
...

## @arch 请设计技术方案
EOF
```

---

### 步骤 2：Arch 设计技术方案

```bash
# 创建 openapi.yaml（API 契约）
cat > openspec/changes/003-new-feature/v1/openapi.yaml << 'EOF'
openapi: 3.0.0
info:
  title: 新功能 API
  version: 1.0.0
paths:
  /api/v1/new-feature:
    ...
EOF

# 创建 schema.prisma（数据模型）
cat > openspec/changes/003-new-feature/v1/schema.prisma << 'EOF'
model NewFeature {
  id Int @id @default(autoincrement())
  ...
}
EOF

# 创建 tasks.md（任务清单）
cat > openspec/changes/003-new-feature/v1/tasks.md << 'EOF'
# 任务清单：003-new-feature v1

| ID | 任务 | 负责人 | 状态 |
|----|------|--------|------|
| T1 | 后端实现 | @be | [ ] pending |
| T2 | 前端实现 | @fe | [ ] pending |
| T3 | 移动端实现 | @mobile | [ ] pending |
EOF

# 提交规范
git add .
git commit -m "feat: 创建 003-new-feature 规范"
git push origin main
```

---

### 步骤 3：BE/FE/Mobile 调用 Opencode 生成代码

```javascript
// BE Agent 示例
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  mode: "run",
  cwd: "~/.openclaw/workspace-be/server",
  task: `请读取以下 OpenSpec 规范文件并生成 NestJS 代码：

规范文件：
- ~/.openclaw/workspace/saas-specs/openspec/changes/003-new-feature/v1/openapi.yaml
- ~/.openclaw/workspace/saas-specs/openspec/changes/003-new-feature/v1/schema.prisma

要求生成完整的 NestJS 模块到 src/modules/new-feature/`
})
```

---

### 步骤 4：验证 + 更新状态

```bash
# 验证生成的代码
ls -la ~/.openclaw/workspace-be/server/src/modules/new-feature/

# 更新 tasks.md（将 [ ] 改为 [x]）
# 创建完成标记
echo "completed at: $(date -Iseconds)" > \
  openspec/changes/003-new-feature/v1/flags/be.done

# 提交代码
cd ~/.openclaw/workspace-be/server
git add .
git commit -m "feat: AI generated new-feature module from openspec #003-new-feature@v1"
git push origin main
```

---

### 步骤 5：PM 汇总 + 归档

```bash
# 检查所有 flags/
ls openspec/changes/003-new-feature/v1/flags/
# 应该看到：be.done, fe.done, mobile.done

# 更新 status.md
cat > openspec/changes/003-new-feature/v1/status.md << 'EOF'
# 状态追踪：003-new-feature v1

## 整体状态
✅ 已完成

## 任务进度
| ID | 任务 | 负责人 | 状态 |
|----|------|--------|------|
| T1 | 后端实现 | @be | ✅ done |
| T2 | 前端实现 | @fe | ✅ done |
| T3 | 移动端实现 | @mobile | ✅ done |
EOF

# 归档（可选）
mv openspec/changes/003-new-feature/v1 openspec/archive/2026-03-31-003-new-feature/
```

---

## 📊 规范文件说明

### proposal.md - 需求提案

```markdown
# 变更提案：<feature-name>

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
```

---

### openapi.yaml - API 契约

```yaml
openapi: 3.0.0
info:
  title: API 名称
  version: 1.0.0
paths:
  /api/v1/resource:
    get:
      summary: 获取资源
      responses:
        '200':
          description: 成功
```

**用途**：
- AI 生成代码的依据
- 前后端接口约定
- API 文档自动生成

---

### schema.prisma - 数据模型

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  password  String
  role      String   @default("user")
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

**用途**：
- AI 生成 Entity 的依据
- 数据库迁移脚本生成
- 数据字典文档

---

### tasks.md - 任务清单

```markdown
# 任务清单：<feature-name> v1

| ID | 任务 | 负责人 | 状态 | 预计工时 |
|----|------|--------|------|----------|
| T1 | 后端实现 | @be | [ ] pending | 2h |
| T2 | 前端实现 | @fe | [ ] pending | 1.5h |
| T3 | 移动端实现 | @mobile | [ ] pending | 2h |

## 任务详情

### T1: 后端实现
**阅读文件**:
- openapi.yaml
- schema.prisma

**任务**:
- [ ] 创建 Entity
- [ ] 创建 DTO
- [ ] 实现 Controller
- [ ] 实现 Service
```

---

## 🔧 软链接说明

### 各 Agent 工作区通过软链接访问规范

```
workspace-be/specs → ../saas-specs
workspace-fe/specs → ../saas-specs
workspace-mobile/specs → ../saas-specs
```

**注意**：
- ⚠️ **specs/ 目录是只读的** - Agent 只能读取，不能修改
- ⚠️ **不要删除软链接** - 否则 Agent 无法访问规范
- ✅ **更新规范** - 在 saas-specs 仓库中修改并推送

---

## 📦 版本管理

### 规范版本

```
001-user-login/
├── v1/    # 第一版
├── v2/    # 第二版（变更）
└── v3/    # 第三版（变更）
```

### Git Tag

```bash
# 创建版本标签
cd ~/.openclaw/workspace/saas-specs
git tag -a v1.0.0 -m "Release v1.0.0: user-login, user-register"
git push origin v1.0.0
```

### 代码提交引用规范版本

```bash
git commit -m "feat: AI generated auth module from openspec #001-user-login@v1"
```

---

## 🚀 快速开始

### 创建新功能

```bash
# 1. 创建变更目录
mkdir -p openspec/changes/003-new-feature/v1

# 2. 创建 proposal.md
# 3. 创建 openapi.yaml
# 4. 创建 schema.prisma
# 5. 创建 tasks.md

# 6. 提交规范
git add .
git commit -m "feat: 创建 003-new-feature 规范"
git push
```

### 调用 Opencode 生成代码

```javascript
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  mode: "run",
  cwd: "~/.openclaw/workspace-be/server",
  task: "根据 OpenSpec 规范生成代码"
})
```

---

## 📚 相关文档

- [OpenSpec 官方文档](https://github.com/Fission-AI/OpenSpec)
- [OpenCode 文档](https://opencode.ai)
- [OpenClaw 文档](https://docs.openclaw.ai)

---

## 📝 更新日志

### v1.0.0 (2026-03-31)

- ✅ 创建 user-login 功能规范
- ✅ 创建 user-register 功能规范
- ✅ 验证 ACP + OpenSpec 流程
- ✅ 生成后端 NestJS 代码
- ✅ 生成前端 Vue3 代码

---

## 🙏 贡献指南

### 提交规范变更

1. Fork 本仓库
2. 创建功能分支 `feature/xxx`
3. 提交变更 `git commit -m "feat: xxx"`
4. 推送到分支 `git push origin feature/xxx`
5. 创建 Pull Request

### 规范命名规则

- **变更目录**: `<序号>-<功能名称>/v<版本号>`
  - 示例：`001-user-login/v1`
- **文件命名**: 使用小写 + 连字符
  - 示例：`openapi.yaml`, `schema.prisma`

---

## 📧 联系方式

- GitHub Issues: [提交问题](https://github.com/qmuyangren/saas-specs/issues)
- 项目地址：[https://github.com/qmuyangren/saas-specs](https://github.com/qmuyangren/saas-specs)

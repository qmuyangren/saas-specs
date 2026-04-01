# GitHub 仓库配置指南

**版本**: v1.0  
**最后更新**: 2026-04-01

---

## 📦 仓库规划

### 推荐 6 个仓库

| 仓库 | 用途 | 管理者 | 分支策略 |
|------|------|--------|----------|
| **saas-specs** | OpenSpec 规范 | Arch | main + feature/* |
| **saas-server** | 后端 NestJS 代码 | BE | main + develop + feature/* |
| **saas-web** | 前端 Vue3 代码 | FE | main + develop + feature/* |
| **saas-mobile** | 移动端 uni-app 代码 | Mobile | main + develop |
| **saas-tester** | Playwright 测试脚本 | Tester | main |
| **saas-docs** | 项目文档 | PM | main |

---

## 🔧 GitHub CLI 配置

### 安装验证

```bash
# 检查 gh 是否安装
gh --version

# 登录 GitHub
gh auth login

# 验证登录
gh auth status
```

### 创建仓库

```bash
# 创建规范仓库
gh repo create saas-specs --public --description "SaaS 平台 OpenSpec 规范仓库" --source ~/.openclaw/workspace-arch/specs --push

# 创建后端仓库
gh repo create saas-server --public --description "SaaS 平台后端服务 (NestJS)" --source ~/.openclaw/workspace-be/server --push

# 创建前端仓库
gh repo create saas-web --public --description "SaaS 平台前端 (Vue3)" --source ~/.openclaw/workspace-fe/web --push

# 创建移动端仓库
gh repo create saas-mobile --public --description "SaaS 平台移动端 (uni-app)" --source ~/.openclaw/workspace-mobile/mobile --push

# 创建测试仓库
gh repo create saas-tester --public --description "SaaS 平台 E2E 测试 (Playwright)" --source ~/.openclaw/workspace-tester --push

# 创作文档仓库
gh repo create saas-docs --public --description "SaaS 平台项目文档" --source ~/.openclaw/workspace-pm/docs --push
```

---

## 📁 各角色与 OpenSpec 协同

### Arch 角色（规范管理）

**工作区**: `workspace-arch/`  
**仓库**: `saas-specs`

```bash
cd ~/.openclaw/workspace-arch/specs

# 初始化 Git
git init
git remote add origin git@github.com:你的用户名/saas-specs.git

# 提交规范
git add openspec/changes/005-new-feature/
git commit -m "feat: 创建 005-new-feature 规范"
git push origin main

# 创建功能分支
git checkout -b feature/005-new-feature
# ... 修改规范 ...
git commit -m "feat: 更新 005-new-feature API 设计"
git push origin feature/005-new-feature

# 合并到 main
gh pr create --title "feat: 005-new-feature 规范" --body "新增密码重置功能规范"
gh pr merge --merge --delete-branch
```

**规范更新流程**:
```
1. Arch 创建/修改规范
2. 提交到 feature 分支
3. 创建 Pull Request
4. PM 审核通过
5. 合并到 main
6. 通知各端拉取最新规范
```

---

### BE 角色（后端开发）

**工作区**: `workspace-be/`  
**仓库**: `saas-server`  
**规范来源**: 软链接 `specs/ → ../workspace-arch/specs`

```bash
cd ~/.openclaw/workspace-be/server

# 初始化 Git
git init
git remote add origin git@github.com:你的用户名/saas-server.git

# 拉取最新规范（通过软链接）
cd ../specs && git pull origin main

# 读取规范
cat openspec/changes/005-new-feature/v1/openapi.yaml

# 调用 Opencode 生成代码
# ... (见 FULL_WORKFLOW_GUIDE.md)

# 提交代码
git add src/modules/password-reset/
git commit -m "feat: AI generated password-reset module from openspec #005-new-feature"
git push origin develop

# 创建 PR
gh pr create --title "feat: 密码重置模块" --body "根据 OpenSpec 005-new-feature 生成"
```

**开发流程**:
```
1. 从 specs 软链接读取最新规范
2. 调用 Opencode 生成代码
3. 运行单元测试
4. 提交到 develop 分支
5. 创建 PR 到 main
6. Tester 验证后合并
```

---

### FE 角色（前端开发）

**工作区**: `workspace-fe/`  
**仓库**: `saas-web`  
**规范来源**: 软链接 `specs/ → ../workspace-arch/specs`

```bash
cd ~/.openclaw/workspace-fe/web

# 拉取最新规范
cd ../specs && git pull origin main

# 读取规范
cat openspec/changes/005-new-feature/v1/openapi.yaml

# 调用 Opencode 生成代码
# ...

# 提交代码
git add src/pages/reset-password/
git commit -m "feat: AI generated reset-password page from openspec #005-new-feature"
git push origin develop
```

---

### Mobile 角色（移动端开发）

**工作区**: `workspace-mobile/`  
**仓库**: `saas-mobile`  
**规范来源**: 软链接 `specs/ → ../workspace-arch/specs`

```bash
cd ~/.openclaw/workspace-mobile/mobile

# 拉取最新规范
cd ../specs && git pull origin main

# 读取规范
cat openspec/changes/005-new-feature/v1/openapi.yaml

# 调用 Opencode 生成代码
# ...

# 提交代码
git add src/pages/reset-password/
git commit -m "feat: AI generated mobile reset-password page from openspec #005-new-feature"
git push origin develop
```

---

### Tester 角色（测试）

**工作区**: `workspace-tester/`  
**仓库**: `saas-tester`  
**规范来源**: 软链接 `specs/ → ../workspace-arch/specs`

```bash
cd ~/.openclaw/workspace-tester

# 初始化 Git
git init
git remote add origin git@github.com:你的用户名/saas-tester.git

# 拉取最新规范
cd ../workspace-arch/specs && git pull origin main

# 创建测试脚本
cat > tests/e2e/005-new-feature.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';
// 测试代码...
EOF

# 提交测试
git add tests/e2e/005-new-feature.spec.ts
git commit -m "test: add E2E tests for 005-new-feature"
git push origin main

# 运行测试
BASE_URL=http://localhost:5173 npm run test:005
```

---

### PM 角色（项目管理）

**工作区**: `workspace-pm/`  
**仓库**: `saas-docs` (可选)

```bash
cd ~/.openclaw/workspace-pm

# 创建需求文档
mkdir -p docs/requirements/005-new-feature
cat > docs/requirements/005-new-feature/requirements.md << 'EOF'
# 需求文档：005-new-feature

## 背景
...

## 用户故事
...

## 验收标准
...
EOF

# 提交文档
git add docs/requirements/005-new-feature/
git commit -m "docs: add requirements for 005-new-feature"
git push origin main

# 追踪进度
gh issue list --repo 你的用户名/saas-server
gh issue list --repo 你的用户名/saas-web
```

---

## 🔄 完整协同流程

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. Arch 更新规范                                                │
│    cd workspace-arch/specs                                      │
│    git add openspec/changes/005/                                │
│    git commit -m "feat: 005-new-feature"                        │
│    git push origin main                                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 2. 各端拉取最新规范（通过软链接）                                │
│    cd workspace-be/specs && git pull origin main                │
│    cd workspace-fe/specs && git pull origin main                │
│    cd workspace-mobile/specs && git pull origin main            │
│    cd workspace-tester && cd ../workspace-arch/specs && pull    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 3. 各端调用 Opencode 生成代码                                     │
│    sessions_spawn({ runtime: "acp", agentId: "opencode", ... }) │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 4. 各端提交代码                                                 │
│    git add src/...                                              │
│    git commit -m "feat: AI generated xxx from openspec #005"    │
│    git push origin develop                                      │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 5. Tester 创建测试并运行                                        │
│    cat > tests/e2e/005.spec.ts                                  │
│    npm run test:005                                             │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ 6. PR 合并                                                       │
│    gh pr create                                                 │
│    gh pr merge                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Git 分支策略

### 三分支模型

```
main (生产)
  ↑
  └── develop (开发)
        ↑
        └── feature/xxx (功能)
```

### 分支用途

| 分支 | 用途 | 保护 |
|------|------|------|
| **main** | 生产环境，随时可部署 | ✅ 保护，需要 PR |
| **develop** | 开发集成分支 | ✅ 保护，需要 PR |
| **feature/*** | 功能开发 | ❌ 临时分支 |

### 分支命名

```
feature/005-password-reset    ← 功能开发
bugfix/login-error            ← Bug 修复
hotfix/security-patch         ← 紧急修复
release/v1.0.0                ← 发布分支
```

---

## 📝 Git 提交规范

### Commit Message 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 类型

| Type | 说明 |
|------|------|
| **feat** | 新功能 |
| **fix** | Bug 修复 |
| **docs** | 文档更新 |
| **style** | 代码格式（不影响功能） |
| **refactor** | 重构 |
| **test** | 测试相关 |
| **chore** | 构建/工具/配置 |

### 示例

```bash
# 规范提交
feat(005-password-reset): 创建密码重置功能规范

- 添加 openapi.yaml
- 添加 schema.prisma
- 添加 tasks.md

Refs: #005

# 后端提交
feat(password-reset): AI generated password-reset module from openspec #005

- Generated by Opencode
- Based on openspec/changes/005-password-reset/v1/openapi.yaml

Refs: #005

# 测试提交
test(005-password-reset): add E2E tests for password reset

- Add 14 test cases
- Include error scenarios and performance tests

Refs: #005
```

---

## 🔐 GitHub Actions CI/CD（可选）

### 后端 CI

```yaml
# .github/workflows/backend-ci.yml
name: Backend CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run test
      - run: npm run test:integration
```

### 前端 CI

```yaml
# .github/workflows/frontend-ci.yml
name: Frontend CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run test
      - run: npm run build
```

### 测试 CI

```yaml
# .github/workflows/tester-ci.yml
name: Tester CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run test:e2e
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
```

---

## 📋 快速命令参考

### 仓库管理

```bash
# 创建仓库
gh repo create <name> --public --description "<描述>" --source <路径> --push

# 查看仓库
gh repo view <name>

# 克隆仓库
gh repo clone <用户名>/<仓库名>
```

### PR 管理

```bash
# 创建 PR
gh pr create --title "<标题>" --body "<描述>"

# 查看 PR
gh pr list

# 合并 PR
gh pr merge --merge --delete-branch

# 查看 PR 状态
gh pr status
```

### Issue 管理

```bash
# 创建 Issue
gh issue create --title "<标题>" --body "<描述>"

# 查看 Issue
gh issue list

# 关闭 Issue
gh issue close <编号>
```

---

## 🎯 总结

### 核心原则

1. **规范独立仓库** - `saas-specs` 由 Arch 管理
2. **代码分离** - 各端独立仓库，独立部署
3. **软链接共享** - 通过软链接访问规范
4. **测试独立** - Tester 有独立仓库
5. **CI/CD 自动化** - GitHub Actions 自动测试

### 仓库关系

```
saas-specs (规范)
    ↓ (软链接)
saas-server    ← 读取规范 → 生成代码
saas-web       ← 读取规范 → 生成代码
saas-mobile    ← 读取规范 → 生成代码
    ↓
saas-tester    ← 读取规范 → 生成测试
```

---

_最后更新：2026-04-01_

# 访问指南 - 各 Agent 如何访问 specs

## 📍 specs 位置

```
specs 规范仓库位于：~/.openclaw/workspace-arch/specs/
```

---

## 🔗 软链接布局

所有 Agent 工作区通过软链接访问 specs：

```
~/.openclaw/
├── workspace-arch/
│   └── specs/               ← 真实目录
│
├── workspace-pm/
│   └── specs/ → ../workspace-arch/specs
│
├── workspace-be/
│   └── specs/ → ../workspace-arch/specs
│
├── workspace-fe/
│   └── specs/ → ../workspace-arch/specs
│
└── workspace-mobile/
    └── specs/ → ../workspace-arch/specs
```

---

## 🎯 各 Agent 访问方式

### PM (产品经理)

```bash
cd ~/.openclaw/workspace-pm

# 创建需求提案
mkdir -p specs/openspec/changes/003-new-feature/v1
cat > specs/openspec/changes/003-new-feature/v1/proposal.md << 'PROPOSAL'
# 变更提案：003-new-feature
## 背景
...
## @arch 请设计技术方案
PROPOSAL

# 验收完成后创建状态文件
cat > specs/openspec/changes/003-new-feature/v1/status.md << 'STATUS'
# 状态追踪：003-new-feature v1
## 整体状态
✅ 已完成
STATUS
```

---

### Arch (架构师)

```bash
cd ~/.openclaw/workspace-arch

# 设计技术方案
cat > specs/openspec/changes/003-new-feature/v1/openapi.yaml << 'YAML'
openapi: 3.0.0
info:
  title: 新功能 API
  version: 1.0.0
YAML

cat > specs/openspec/changes/003-new-feature/v1/schema.prisma << 'PRISMA'
model NewFeature {
  id Int @id @default(autoincrement())
}
PRISMA

cat > specs/openspec/changes/003-new-feature/v1/tasks.md << 'TASKS'
# 任务清单：003-new-feature v1

| ID | 任务 | 负责人 | 状态 |
|----|------|--------|------|
| T1 | 后端实现 | @be | [ ] pending |
| T2 | 前端实现 | @fe | [ ] pending |
| T3 | 移动端实现 | @mobile | [ ] pending |
TASKS
```

---

### BE (后端工程师)

```bash
cd ~/.openclaw/workspace-be

# 1. 读取规范
cat specs/openspec/changes/001-user-login/v1/openapi.yaml
cat specs/openspec/changes/001-user-login/v1/schema.prisma

# 2. 调用 Opencode 生成代码
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  cwd: "~/.openclaw/workspace-be/server",
  task: `请根据以下规范生成 NestJS 代码：
    - specs/openspec/changes/001-user-login/v1/openapi.yaml
    - specs/openspec/changes/001-user-login/v1/schema.prisma`
})

# 3. 完成后创建标记
echo "completed at: $(date -Iseconds)" > specs/openspec/changes/001-user-login/v1/flags/be.done
```

---

### FE (前端工程师)

```bash
cd ~/.openclaw/workspace-fe

# 1. 读取规范
cat specs/openspec/changes/001-user-login/v1/openapi.yaml

# 2. 调用 Opencode 生成代码
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  cwd: "~/.openclaw/workspace-fe/web",
  task: `请根据以下规范生成 Vue3 登录页面：
    - specs/openspec/changes/001-user-login/v1/openapi.yaml`
})

# 3. 完成后创建标记
echo "completed at: $(date -Iseconds)" > specs/openspec/changes/001-user-login/v1/flags/fe.done
```

---

### Mobile (移动端工程师)

```bash
cd ~/.openclaw/workspace-mobile

# 1. 读取规范
cat specs/openspec/changes/001-user-login/v1/openapi.yaml

# 2. 调用 Opencode 生成代码
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  cwd: "~/.openclaw/workspace-mobile/mobile",
  task: `请根据以下规范生成 uni-app 登录页面：
    - specs/openspec/changes/001-user-login/v1/openapi.yaml`
})

# 3. 完成后创建标记
echo "completed at: $(date -Iseconds)" > specs/openspec/changes/001-user-login/v1/flags/mobile.done
```

---

## ⚠️ 注意事项

1. **specs 是共享资源** - 所有 Agent 访问同一份规范
2. **通过软链接访问** - 不要直接修改 workspace-arch/specs/
3. **在各自工作区操作** - PM 在 workspace-pm/，BE 在 workspace-be/，以此类推
4. **路径使用相对路径** - 在代码中使用 `specs/openspec/...` 而不是绝对路径

---

## 📝 更新日志

- **2026-04-01** - specs 迁移至 Arch 工作区统一管理

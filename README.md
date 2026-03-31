# SaaS 规范仓库 (OpenSpec)

## 📐 作用

这是 SaaS 平台的**统一规范仓库**，所有开发工作都基于这里的规范进行。

---

## 📁 目录结构

```
openspec/
├── base/                    # 基础规范（稳定，少变）
│   ├── project.md           # 技术栈规范
│   └── api-style.md         # API 设计规范
│
├── changes/                 # 变更提案（按功能）
│   ├── 001-user-login/      # 变更编号 + 名称
│   │   └── v1/              # 版本号
│   │       ├── proposal.md  # 需求提案
│   │       ├── design.md    # 技术方案
│   │       ├── openapi.yaml # API 契约
│   │       ├── schema.prisma# 数据模型
│   │       ├── tasks.md     # 任务清单
│   │       └── status.md    # 状态追踪
│   └── 002-order-module/    # 下一个变更
│
└── releases/                # 发布版本快照
    └── v1.0.0/
```

---

## 🔄 使用流程

### 1. 产品经理 (pm)
- 创建变更提案：`changes/001-xxx/v1/proposal.md`
- @arch 设计技术方案

### 2. 架构师 (arch)
- 读取 `proposal.md`
- 创建 `design.md` + `openapi.yaml` + `schema.prisma` + `tasks.md`

### 3. 开发 Agent (be/fe/mobile)
- 读取 `openapi.yaml` + `tasks.md`
- 在各自工作区开发代码
- 完成后创建 `flags/*.done`

### 4. 产品经理 (pm)
- 检查所有 `flags/*.done`
- 更新 `status.md`
- 回复用户

---

## 📋 规范文件

| 文件 | 说明 |
|------|------|
| `base/project.md` | 技术栈规范（NestJS + React + uni-app） |
| `base/api-style.md` | API 设计规范（RESTful、错误码、响应格式） |

---

## ⚠️ 注意事项

1. **规范文件是只读的** — 开发 Agent 不要修改
2. **版本化管理** — 需求变更时创建新版本 (v1 → v2)
3. **保留历史** — 所有版本都保留，可追溯

---

## 🔗 相关仓库

- 后端代码：`workspace-be/server/`
- 前端代码：`workspace-fe/web/`
- 移动端代码：`workspace-mobile/mobile/`

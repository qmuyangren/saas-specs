# 错误分级处理指南

---

## 错误级别定义

### Level 1 - 语法/简单错误

**特征**:
- 语法错误（SyntaxError）
- 类型错误（TypeError）
- 缺失导入（Cannot find module）
- 拼写错误

**处理策略**:
```
执行者：OpenCode
修复次数：最多 3 次
处理流程：
  1. OpenCode 自动分析错误
  2. 调用 OpenCode 修复
  3. 重新运行测试
  4. 成功 → 继续，失败 → 尝试下一次
```

**示例**:
```
❌ TypeError: Cannot read property 'map' of undefined
✅ 修复：添加空值检查 array?.map()

❌ Cannot find module 'jsonwebtoken'
✅ 修复：npm install jsonwebtoken
```

---

### Level 2 - 逻辑/业务错误

**特征**:
- 业务逻辑错误
- API 返回格式错误
- 数据验证失败
- 功能不符合需求

**处理策略**:
```
执行者：开发角色（BackendDev/FrontendDev）
修复次数：最多 2 次
处理流程：
  1. 开发角色分析错误原因
  2. 调用 OpenCode 修复（提供详细上下文）
  3. 重新运行测试
  4. 成功 → 继续，失败 → 上报 PM
```

**示例**:
```
❌ 登录成功后没有返回 token
✅ 修复：在 AuthService 中添加 jwtService.sign()

❌ 表单验证没有触发
✅ 修复：添加 @blur 事件监听
```

---

### Level 3 - 设计/架构错误

**特征**:
- API 设计不合理
- 数据模型缺失字段
- 架构不符合需求
- 需要修改 design.md

**处理策略**:
```
执行者：Arch Agent
修复次数：1 次（需 PM 确认）
处理流程：
  1. 开发角色上报 PM
  2. PM 调用 Arch Agent
  3. Arch 修改 design.md + tasks.md
  4. PM 重新派发任务
```

**示例**:
```
❌ API 缺少邮箱验证字段
✅ 修复：Arch 更新 openapi.yaml，添加 emailVerified 字段

❌ 数据模型没有考虑多租户
✅ 修复：Arch 更新 schema.prisma，添加 tenantId 字段
```

---

### Level 4 - 环境/依赖错误

**特征**:
- 依赖版本冲突
- 系统依赖缺失（如 bcrypt 需要 node-gyp）
- 环境变量配置问题
- 网络/权限问题

**处理策略**:
```
执行者：人工介入
修复次数：∞
处理流程：
  1. 开发角色记录错误
  2. 上报 PM
  3. PM 通知用户
  4. 用户手动解决
  5. 记录解决方案到文档
```

**示例**:
```
❌ bcrypt 安装失败：node-gyp 编译错误
✅ 修复：xcode-select --install

❌ Redis 连接失败：Connection refused
✅ 修复：redis-server 启动服务

❌ 端口被占用：EADDRINUSE
✅ 修复：lsof -i :3000 找到并杀死进程
```

---

## 错误处理流程图

```
错误发生
   ↓
┌─────────────────┐
│ 分析错误类型     │
└────────┬────────┘
         ↓
    ┌────┴────┐
    │ 判断级别 │
    └────┬────┘
         ↓
   ┌─────┴─────┬─────────┬─────────┐
   │           │         │         │
 Level 1    Level 2   Level 3   Level 4
   │           │         │         │
   ↓           ↓         ↓         ↓
OpenCode   开发角色   Arch     人工介入
自动修复   修复      修改设计   手动解决
   │           │         │         │
   ↓           ↓         ↓         ↓
最多 3 次    最多 2 次   1 次      ∞
   │           │         │         │
   ↓           ↓         ↓         ↓
成功→继续   成功→继续  PM 确认   解决→继续
失败→升级   失败→PM   失败→PM   记录方案
```

---

## 错误记录规范

### 文件命名

```
errors/
├── BE-2026-001.md    # 后端第 1 个错误
├── BE-2026-002.md    # 后端第 2 个错误
├── FE-2026-001.md    # 前端第 1 个错误
└── MO-2026-001.md    # 移动端第 1 个错误
```

### 错误 ID 格式

```
{SERVICE}-{YYYY}-{NNN}

SERVICE:
- BE = Backend
- FE = Frontend
- MO = Mobile
- TE = Tester

YYYY: 年份
NNN: 序号（从 001 开始）
```

### 上报 PM 格式

```markdown
@pm 🚨 错误上报

**错误 ID**: BE-2026-001
**严重级别**: Level 3
**任务**: 实现登录 API

**错误信息**:
```
API 设计不合理，缺少邮箱验证字段
```

**已尝试修复**: 2 次（失败）

**建议**: 需要 Arch 修改 design.md

**相关文件**:
- errors/BE-2026-001.md
- specs/changes/001-login/v1/design.md
```

---

## 快速参考

| 级别 | 类型 | 执行者 | 次数 | 失败后 |
|------|------|--------|------|--------|
| Level 1 | 语法错误 | OpenCode | 3 | 升级 Level 2 |
| Level 2 | 逻辑错误 | 开发角色 | 2 | 上报 PM |
| Level 3 | 设计缺陷 | Arch | 1 | PM 决定 |
| Level 4 | 环境问题 | 人工 | ∞ | 记录方案 |

---

_最后更新：2026-04-01_

# 技术方案：001-user-login

---
feature: user-login
version: v1
createdBy: arch
createdAt: 2026-03-31
---

## 架构设计

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   前端       │      │   后端       │      │   数据库     │
│  (React)    │─────▶│  (NestJS)   │─────▶│ (PostgreSQL)│
│             │◀─────│             │◀─────│             │
└─────────────┘      └─────────────┘      └─────────────┘
                            │
                            ▼
                     ┌─────────────┐
                     │    Redis    │
                     │  (限流缓存)  │
                     └─────────────┘
```

## 技术选型

| 模块 | 技术 | 理由 |
|------|------|------|
| 后端框架 | NestJS | 模块化、TypeScript、易于维护 |
| 数据库 | PostgreSQL | 关系型、事务支持、稳定性高 |
| ORM | TypeORM | 与 NestJS 集成好、支持迁移 |
| 认证 | JWT | 无状态、跨域支持、成熟稳定 |
| 缓存 | Redis | 高性能、支持限流 |
| 加密 | bcrypt | 密码加密标准 |

## 安全设计

### 密码加密
- 使用 bcrypt 加密
- salt rounds: 10

### Token 设计
```typescript
interface JwtPayload {
  userId: number;
  email: string;
  rememberMe: boolean;
  iat: number;
  exp: number;  // 7 天或 2 小时
}
```

### 限流策略
- 登录失败 5 次 → 锁定 30 分钟
- 使用 Redis 记录失败次数
- Key: `login:fail:{email}`

## API 设计

见 `openapi.yaml`

## 数据模型

见 `schema.prisma`

## 风险评估

| 风险 | 影响 | 应对 |
|------|------|------|
| Token 泄露 | 高 | HTTPS、短有效期、刷新机制 |
| 暴力破解 | 中 | 限流、验证码 |
| SQL 注入 | 高 | ORM 参数化查询 |

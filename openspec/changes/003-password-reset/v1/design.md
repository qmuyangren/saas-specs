# 技术方案设计：003-password-reset v1

---
feature: password-reset
version: v1
createdBy: arch
createdAt: 2026-04-01
---

## 架构设计

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   用户端     │      │   后端       │      │   Redis     │
│             │      │             │      │             │
│ 1. 请求发送  │─────→│ 验证邮箱    │─────→│ 存储验证码  │
│    验证码    │      │    存在性    │      │   5 分钟     │
│             │      │             │      │             │
│ 2. 提交新    │─────→│ 验证验证码  │─────→│ 验证并删除  │
│    密码      │      │    重置密码  │      │   验证码    │
│             │      │             │      │             │
└─────────────┘      └─────────────┘      └─────────────┘
```

---

## API 设计

### POST /api/v1/auth/send-reset-code

发送密码重置验证码

**请求**:
```json
{
  "email": "user@example.com"
}
```

**响应**:
```json
{
  "code": 0,
  "message": "验证码已发送",
  "data": {
    "expireIn": 300
  }
}
```

**错误码**:
- `1001`: 邮箱格式错误
- `1003`: 该邮箱未注册
- `1004`: 发送频率过高

---

### POST /api/v1/auth/reset-password

重置密码

**请求**:
```json
{
  "email": "user@example.com",
  "code": "123456",
  "newPassword": "newpass123"
}
```

**响应**:
```json
{
  "code": 0,
  "message": "密码重置成功",
  "data": {
    "token": "eyJhbGc...",
    "userId": "123"
  }
}
```

**错误码**:
- `1005`: 验证码错误或已过期
- `1006`: 密码强度不足

---

## 数据模型

复用现有 `User` 模型，无需新增表。

验证码存储到 Redis：
- Key: `reset:code:{email}`
- Value: 6 位数字
- TTL: 300 秒

---

## 技术栈

| 组件 | 技术 |
|------|------|
| 后端 | NestJS + TypeScript |
| 数据库 | MySQL (User 表) |
| 缓存 | Redis (验证码) |
| 加密 | bcrypt (密码) |
| Token | JWT |

---

## 安全机制

1. **验证码**
   - 6 位随机数字
   - 5 分钟过期
   - 验证后立即删除

2. **频率限制**
   - 发送间隔：≥60 秒
   - 每日上限：5 次/邮箱

3. **密码强度**
   - 长度：6-20 位
   - 必须包含字母和数字

4. **Token 失效**
   - 重置成功后，该用户的所有旧 token 失效

---

## 任务拆解

详见 `tasks.md`

---

## 依赖

- ✅ 001-user-login (用户认证模块)
- ⏳ Redis 服务
- ⏳ 邮件发送服务（可用 Mock）

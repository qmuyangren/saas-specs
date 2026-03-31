# SaaS 平台统一技术规范

## 技术栈

| 模块 | 技术选型 | 版本 |
|------|----------|------|
| 后端 | NestJS + TypeORM + PostgreSQL | Latest |
| 后台管理 | Vue3 + Ant Design Vue | Latest |
| 业务前端 | Vue3 + Vite | Latest |
| 移动端 | Flutter | Latest |

## 统一 API 规范

### 基础路径
```
/api/v1
```

### 认证方式
```
Authorization: Bearer <JWT_TOKEN>
```

### 响应格式
```typescript
interface ApiResponse<T> {
  code: number;      // 0=成功，其他=错误码
  data: T;           // 业务数据
  message: string;   // 提示信息
}
```

## 错误码规范

| 范围 | 类型 | 示例 |
|------|------|------|
| 0 | 成功 | `{"code": 0, "message": "success"}` |
| 1001-1999 | 客户端错误 | 1001=参数错误，1002=认证失败 |
| 2001-2999 | 服务端错误 | 2001=数据库错误，2002=缓存错误 |
| 3001-3999 | 业务错误 | 3001=用户不存在，3002=密码错误 |

## 编码规范

### 后端 (NestJS)
- 使用 TypeScript 严格模式
- 遵循 NestJS 最佳实践
- 模块按业务功能划分

### 前端 (Vue3)
- 使用 Composition API
- 使用 TypeScript
- 组件单一职责

### 命名规范
- 文件：kebab-case (`user-login.vue`)
- 类/组件：PascalCase (`UserLogin`)
- 函数/变量：camelCase (`getUserInfo`)
- 常量：UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)

# API 设计规范

## RESTful 规范

### HTTP 方法
| 方法 | 用途 | 示例 |
|------|------|------|
| GET | 获取资源 | `GET /api/v1/users/123` |
| POST | 创建资源 | `POST /api/v1/users` |
| PUT | 更新资源（全量） | `PUT /api/v1/users/123` |
| PATCH | 更新资源（部分） | `PATCH /api/v1/users/123` |
| DELETE | 删除资源 | `DELETE /api/v1/users/123` |

### 请求参数

#### Path 参数
```
GET /api/v1/users/{userId}
```

#### Query 参数
```
GET /api/v1/users?page=1&pageSize=20&sort=createdAt,desc
```

#### Body 参数 (POST/PUT/PATCH)
```json
{
  "email": "user@example.com",
  "password": "secure123"
}
```

### 响应规范

#### 成功响应 (200/201)
```json
{
  "code": 0,
  "data": {
    "id": 123,
    "email": "user@example.com"
  },
  "message": "success"
}
```

#### 错误响应 (4xx/5xx)
```json
{
  "code": 1002,
  "data": null,
  "message": "认证失败：Token 已过期"
}
```

### 分页规范
```json
{
  "code": 0,
  "data": {
    "list": [...],
    "pagination": {
      "page": 1,
      "pageSize": 20,
      "total": 100,
      "totalPages": 5
    }
  },
  "message": "success"
}
```

### 认证流程

#### 1. 登录获取 Token
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "secure123"
}

Response:
{
  "code": 0,
  "data": {
    "token": "eyJhbGc...",
    "expiresIn": 604800
  }
}
```

#### 2. 使用 Token 访问
```http
GET /api/v1/users/me
Authorization: Bearer eyJhbGc...
```

#### 3. Token 刷新
```http
POST /api/v1/auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGc..."
}
```

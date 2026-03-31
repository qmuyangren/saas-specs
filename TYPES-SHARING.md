# 类型打通方案

## 🎯 目标

前后端移动端使用**统一的 TypeScript 类型**，确保：
- ✅ 类型安全
- ✅ 自动同步
- ✅ 编译时检查错误

---

## 📐 架构

```
openspec/changes/*/openapi.yaml  ← 唯一真理源
              ↓
    openapi-typescript (生成工具)
              ↓
       saas-types 仓库
       ├── src/types.ts      ← 生成的类型
       └── src/api.ts        ← API 客户端
              ↓
    ┌─────────┼─────────┐
    ↓         ↓         ↓
  后端      前端      移动端
 (复用)   (npm install) (npm install)
```

---

## 🔧 工作流程

### 1. 架构师更新 openapi.yaml

```yaml
# openspec/changes/001-user-login/v1/openapi.yaml
paths:
  /auth/login:
    post:
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                email: {type: string, format: email}
                password: {type: string, minLength: 6}
```

### 2. 运行类型生成脚本

```bash
cd saas-specs
./scripts/generate-types.sh
```

### 3. 发布到 npm（可选）

```bash
cd saas-types
npm version patch
npm publish
```

### 4. 前后端安装使用

```bash
# 前端
cd saas-web
npm install @qmuyangren/saas-types

# 后端
cd saas-server
npm install @qmuyangren/saas-types
```

---

## 📝 使用示例

### 前端使用

```typescript
import { AuthApi, type LoginRequest } from '@qmuyangren/saas-types';

// ✅ 类型安全，IDE 自动提示
const loginData: LoginRequest = {
  email: 'test@example.com',
  password: '123456',
  rememberMe: true,
};

// ✅ 编译时检查类型错误
const result = await AuthApi.login(loginData);
console.log(result.data.token); // ✅ 类型正确
```

### 后端使用

```typescript
import { LoginRequest, LoginResponse } from '@qmuyangren/saas-types';

@Controller('auth')
export class AuthController {
  @Post('login')
  async login(@Body() loginDto: LoginRequest): Promise<LoginResponse> {
    // ✅ 类型与前端一致
    return this.authService.login(loginDto);
  }
}
```

---

## ✅ 优势

| 优势 | 说明 |
|------|------|
| **单一真理源** | openapi.yaml 是唯一权威 |
| **自动同步** | 后端改 API，前端自动知道 |
| **类型安全** | 编译时检查，减少运行时错误 |
| **IDE 支持** | 自动补全、类型提示 |
| **文档即代码** | API 文档自动生成 |

---

## 📁 文件结构

```
saas-types/
├── src/
│   ├── types.ts          # 生成的类型定义
│   ├── api.ts            # API 客户端
│   └── index.ts          # 导出
├── package.json
└── README.md
```

---

## 🚀 下一步

1. ✅ 创建 saas-types 仓库
2. ✅ 创建类型生成脚本
3. ✅ 创建前端 API 客户端
4. ⏳ 配置 CI/CD 自动生成
5. ⏳ 发布到 npm
6. ⏳ 前后端集成

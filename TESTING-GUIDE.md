# 测试指南

## 🧪 测试能力总览

### 后端测试
- ✅ 单元测试（Jest）
- ✅ E2E 测试（Supertest）
- ✅ 集成测试（TypeORM）
- ✅ Chrome DevTools MCP 测试

### 前端测试
- ✅ 组件测试（Vitest + Vue Test Utils）
- ✅ E2E 测试（Playwright）
- ✅ Chrome DevTools MCP 测试

---

## 🔧 后端测试

### 运行测试

```bash
cd ~/.openclaw/workspace-be/server

# 单元测试
npm run test

# E2E 测试
npm run test:e2e

# 测试覆盖率
npm run test:cov

# 监听模式
npm run test:watch
```

### 测试文件位置

```
test/
├── auth.e2e-spec.ts          # 认证模块 E2E 测试
├── app.e2e-spec.ts           # 应用 E2E 测试
└── jest-e2e.json             # E2E 测试配置
```

### 测试用例说明

#### 认证模块测试

```typescript
// test/auth.e2e-spec.ts

describe('Authentication (e2e)', () => {
  // 注册测试
  describe('/auth/register (POST)', () => {
    it('should register a new user', () => {...});
    it('should fail with existing email', () => {...});
    it('should fail with weak password', () => {...});
  });

  // 登录测试
  describe('/auth/login (POST)', () => {
    it('should login with valid credentials', () => {...});
    it('should fail with invalid password', () => {...});
    it('should fail with invalid email', () => {...});
  });

  // 获取用户信息测试
  describe('/auth/me (GET)', () => {
    it('should get user profile with valid token', () => {...});
    it('should fail without token', () => {...});
  });
});
```

---

## 🎨 前端测试

### 运行测试

```bash
cd ~/.openclaw/workspace-fe/web

# 单元测试
npm run test

# 监听模式
npm run test:watch

# 测试覆盖率
npm run test -- --coverage
```

### 测试文件位置

```
src/
└── pages/
    ├── Login.test.ts        # 登录页面测试
    └── Register.test.ts     # 注册页面测试（待创建）
```

### 测试用例说明

#### 登录页面测试

```typescript
// src/pages/Login.test.ts

describe('Login.vue', () => {
  // 基础渲染测试
  it('should render login form', () => {...});
  it('should have email input field', () => {...});
  it('should have password input field', () => {...});

  // 表单验证测试
  describe('form validation', () => {
    it('should validate email format', () => {...});
    it('should validate password length', () => {...});
  });

  // 登录提交测试
  describe('login submission', () => {
    it('should call AuthApi.login on form submit', () => {...});
    it('should show error on login failure', () => {...});
    it('should redirect to home on success', () => {...});
  });

  // 密码强度测试
  describe('password strength', () => {
    it('should show weak password strength', () => {...});
    it('should show strong password strength', () => {...});
  });
});
```

---

## 🌐 Chrome DevTools MCP 测试

### 配置 Chrome DevTools MCP

1. **安装 Chrome DevTools MCP Server**

```bash
npm install -g @chrome-devtools/mcp-server
```

2. **配置 OpenClaw**

在 `~/.openclaw/openclaw.json` 中添加：

```json
{
  "mcp": {
    "chrome": {
      "enabled": true,
      "port": 9222,
      "headless": false
    }
  }
}
```

3. **启动 Chrome with DevTools**

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-dev-profile

# Linux
google-chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-dev-profile

# Windows
chrome.exe --remote-debugging-port=9222 --user-data-dir=C:\temp\chrome-dev-profile
```

---

### 使用 Chrome DevTools MCP 测试

#### 方式 1：通过 OpenClaw Agent 调用

```javascript
sessions_spawn({
  runtime: "acp",
  agentId: "opencode",
  mode: "run",
  task: `使用 Chrome DevTools MCP 测试登录功能：

1. 打开 http://localhost:5173/login
2. 填写邮箱：test@example.com
3. 填写密码：password
4. 点击登录按钮
5. 验证是否跳转到首页
6. 验证 localStorage 中是否有 token
7. 截图保存测试结果`
})
```

#### 方式 2：直接使用 MCP 命令

```bash
# 连接到 Chrome
chrome-mcp connect --port 9222

# 打开页面
chrome-mcp page navigate http://localhost:5173/login

# 填写表单
chrome-mcp input fill 'input[type="email"]' 'test@example.com'
chrome-mcp input fill 'input[type="password"]' 'password'

# 点击登录
chrome-mcp input click 'button[type="submit"]'

# 等待跳转
chrome-mcp page wait-for-navigation

# 验证 URL
chrome-mcp page get-url
# 应该返回：http://localhost:5173/

# 截图
chrome-mcp page screenshot --output /tmp/login-test.png

# 获取 localStorage
chrome-mcp runtime evaluate 'localStorage.getItem("auth_token")'
# 应该返回 token 值
```

---

### 测试脚本示例

#### 登录流程自动化测试

```bash
#!/bin/bash
# test-login-flow.sh

echo "=== 登录流程测试 ==="

# 1. 打开登录页面
chrome-mcp page navigate http://localhost:5173/login
echo "✓ 打开登录页面"

# 2. 填写邮箱
chrome-mcp input fill 'input[type="email"]' 'test@example.com'
echo "✓ 填写邮箱"

# 3. 填写密码
chrome-mcp input fill 'input[type="password"]' 'password'
echo "✓ 填写密码"

# 4. 勾选记住我
chrome-mcp input click 'input[type="checkbox"]'
echo "✓ 勾选记住我"

# 5. 点击登录
chrome-mcp input click 'button[type="submit"]'
echo "✓ 点击登录"

# 6. 等待跳转
chrome-mcp page wait-for-navigation
echo "✓ 等待跳转"

# 7. 验证 URL
URL=$(chrome-mcp page get-url)
if [[ "$URL" == *"home"* ]]; then
  echo "✓ 验证 URL 成功：$URL"
else
  echo "✗ 验证 URL 失败：$URL"
  exit 1
fi

# 8. 验证 token
TOKEN=$(chrome-mcp runtime evaluate 'localStorage.getItem("auth_token")')
if [[ -n "$TOKEN" ]]; then
  echo "✓ 验证 Token 成功：${TOKEN:0:20}..."
else
  echo "✗ 验证 Token 失败"
  exit 1
fi

# 9. 截图
chrome-mcp page screenshot --output /tmp/login-success.png
echo "✓ 截图保存：/tmp/login-success.png"

echo "=== 测试通过 ==="
```

---

### 性能测试

```bash
# 页面加载性能
chrome-mcp performance audit http://localhost:5173/login \
  --category performance \
  --output /tmp/login-performance.json

# Lighthouse 评分
chrome-mcp lighthouse run http://localhost:5173/login \
  --output json \
  --output-path /tmp/lighthouse-report.json
```

---

### 网络请求测试

```bash
# 监控网络请求
chrome-mcp network monitor --output /tmp/network-log.json

# 测试 API 响应时间
chrome-mcp network timing http://localhost:3001/auth/login

# 验证请求头
chrome-mcp network headers get http://localhost:3001/auth/login
```

---

## 📊 测试报告

### 生成测试报告

```bash
# 后端测试报告
cd ~/.openclaw/workspace-be/server
npm run test:cov
# 报告位置：coverage/index.html

# 前端测试报告
cd ~/.openclaw/workspace-fe/web
npm run test -- --coverage
# 报告位置：coverage/index.html

# Chrome DevTools 性能报告
chrome-mcp performance audit http://localhost:5173 \
  --output /tmp/performance-report.html
```

---

## 🚀 CI/CD 集成

### GitHub Actions 配置

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  backend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm install
      - run: npm run test:cov

  frontend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm install
      - run: npm run test

  e2e-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm install
      - uses: microsoft/playwright-github-action@v1
      - run: npx playwright test
```

---

## 📚 相关文档

- [Jest 官方文档](https://jestjs.io)
- [Supertest 文档](https://github.com/ladjs/supertest)
- [Vitest 官方文档](https://vitest.dev)
- [Vue Test Utils 文档](https://test-utils.vuejs.org)
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol)
- [Playwright 官方文档](https://playwright.dev)

---

## 📧 联系方式

- GitHub Issues: [提交问题](https://github.com/qmuyangren/saas-specs/issues)
- 项目地址：[https://github.com/qmuyangren/saas-specs](https://github.com/qmuyangren/saas-specs)

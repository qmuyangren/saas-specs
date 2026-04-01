# 任务清单：003-password-reset v1

---
feature: password-reset
version: v1
createdBy: arch
createdAt: 2026-04-01
---

## 任务概览

| ID | 任务 | 负责人 | 测试要求 | 状态 | 完成时间 |
|----|------|--------|----------|------|----------|
| T1 | 后端发送验证码接口 | @be | 单元测试 + 集成测试 | [x] done | 2026-04-01 13:44 |
| T2 | 后端重置密码接口 | @be | 单元测试 + 集成测试 | [x] done | 2026-04-01 13:44 |
| T3 | 前端重置密码页面 | @fe | 组件测试 + UI 自测 | [ ] pending | - |
| T4 | 移动端重置密码 | @mobile | 组件测试 | [ ] pending | - |
| T5 | API 自测 (BE) | @be | curl 测试端点 | [ ] pending | - |
| T6 | UI 自测 (FE) | @fe | Chrome DevTools | [ ] pending | - |
| T7 | 端到端测试 | @tester | Playwright | [ ] pending | - |

> 状态说明：`[ ]` pending | `[~]` doing | `[x]` done | `[!]` blocked

---

## 任务详情

### T1: 后端发送验证码接口

**阅读文件**:
- `openapi.yaml` - API 契约
- `design.md` - 技术方案

**任务**:
- [x] 创建 PasswordResetModule
- [x] 实现 POST /api/v1/auth/send-reset-code
- [x] 验证邮箱格式
- [x] 验证邮箱是否已注册
- [x] 生成 6 位随机验证码
- [x] 存储验证码到 Redis（5 分钟过期）
- [x] 实现发送频率限制（1 分钟 1 次，每天 5 次）
- [x] 模拟邮件发送（日志输出）
- [x] 创建 `flags/be-send.done`

**测试**:
- [ ] 单元测试：验证码生成逻辑
- [ ] 集成测试：发送频率限制
- [ ] API 自测：`curl -X POST http://localhost:3000/api/v1/auth/send-reset-code`

**验收标准**:
- API 符合 openapi.yaml 规范
- 未注册邮箱返回 code=1003
- 频率过高返回 code=1004
- 验证码存储到 Redis，TTL=300 秒

---

### T2: 后端重置密码接口

**阅读文件**:
- `openapi.yaml` - API 契约
- `design.md` - 技术方案

**任务**:
- [x] 实现 POST /api/v1/auth/reset-password
- [x] 验证验证码（从 Redis 读取并删除）
- [x] 验证密码强度（6-20 位，含字母和数字）
- [x] 使用 bcrypt 加密新密码
- [x] 更新数据库密码
- [x] 生成新 JWT Token
- [x] 记录操作日志
- [x] 创建 `flags/be-reset.done`

**测试**:
- [ ] 单元测试：密码强度验证
- [ ] 集成测试：重置密码完整流程
- [ ] API 自测：`curl -X POST http://localhost:3000/api/v1/auth/reset-password`

**验收标准**:
- API 符合 openapi.yaml 规范
- 验证码错误/过期返回 code=1005
- 密码强度不足返回 code=1006
- 重置成功后返回新 token

---

### T3: 前端重置密码页面

**阅读文件**:
- `openapi.yaml` - API 契约

**任务**:
- [ ] 创建 ResetPassword.vue 页面
- [ ] 步骤 1：输入邮箱 + 发送验证码
- [ ] 步骤 2：输入验证码 + 新密码
- [ ] 实现表单验证
- [ ] 对接发送验证码 API
- [ ] 对接重置密码 API
- [ ] 处理错误提示
- [ ] 重置成功跳转首页
- [ ] 创建 `flags/fe.done`

**测试**:
- [ ] 组件测试：表单验证逻辑
- [ ] UI 自测：Chrome DevTools 验证完整流程

**验收标准**:
- 表单验证完整
- 错误提示友好
- 支持验证码倒计时（60 秒）
- 密码强度指示器

---

### T4: 移动端重置密码

**阅读文件**:
- `openapi.yaml` - API 契约

**任务**:
- [ ] 创建 uni-app 重置密码页面
- [ ] 实现邮箱输入 + 发送验证码
- [ ] 实现验证码 + 新密码输入
- [ ] 对接后端 API
- [ ] Token 持久化存储
- [ ] 创建 `flags/mobile.done`

**测试**:
- [ ] 组件测试：表单验证
- [ ] 模拟器测试：完整流程

**验收标准**:
- 表单验证完整
- API 调用正确
- 支持移动端交互

---

### T5: API 自测 (BE)

**任务**:
- [ ] 测试发送验证码接口
- [ ] 测试重置密码接口
- [ ] 测试错误场景
- [ ] 记录测试结果

**测试脚本**:
```bash
# 1. 发送验证码
curl -X POST http://localhost:3000/api/v1/auth/send-reset-code \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'

# 2. 重置密码
curl -X POST http://localhost:3000/api/v1/auth/reset-password \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","code":"123456","newPassword":"newpass123"}'
```

---

### T6: UI 自测 (FE)

**任务**:
- [ ] 使用 Chrome DevTools 打开页面
- [ ] 测试表单验证
- [ ] 测试发送验证码
- [ ] 测试重置密码
- [ ] 测试错误提示
- [ ] 截图保存测试证据

**测试工具**:
- Chrome DevTools MCP
- 浏览器：http://localhost:5173/reset-password

---

### T7: 端到端测试 (Tester)

**任务**:
- [ ] 创建 Playwright 测试脚本
- [ ] 测试完整重置流程
- [ ] 测试错误场景
- [ ] 生成测试报告

**测试脚本**:
```typescript
// e2e/password-reset.spec.ts
import { test, expect } from '@playwright/test';

test.describe('密码重置流程', () => {
  test('完整的重置流程', async ({ page }) => {
    // 导航到重置密码页面
    await page.goto('/reset-password');
    
    // 输入邮箱并发送验证码
    await page.fill('#email', 'test@example.com');
    await page.click('#send-code-btn');
    
    // 输入验证码和新密码
    await page.fill('#code', '123456');
    await page.fill('#newPassword', 'newpass123');
    await page.click('#submit-btn');
    
    // 验证跳转
    await expect(page).toHaveURL('/dashboard');
  });
});
```

---

## 完成标记

各 Agent 完成任务后，在 `flags/` 目录创建标记文件：

```bash
# 后端 - 发送验证码
echo "completed at: $(date -Iseconds)" > flags/be-send.done

# 后端 - 重置密码
echo "completed at: $(date -Iseconds)" > flags/be-reset.done

# 前端
echo "completed at: $(date -Iseconds)" > flags/fe.done

# 移动端
echo "completed at: $(date -Iseconds)" > flags/mobile.done
```

---

## 错误记录

如遇到错误，记录到：`errors/{SERVICE}-{YYYY}-{NNN}.md`

示例：
- `errors/BE-2026-001.md` - 后端第 1 个错误
- `errors/FE-2026-001.md` - 前端第 1 个错误

详见：`../../ERROR_HANDLING.md`

---

## 依赖检查

- [ ] Redis 服务可用
- [ ] User 模块已实现（001-user-login）
- [ ] JWT 认证已实现（001-user-login）

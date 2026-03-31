# 任务清单：002-user-register v1

---
feature: user-register
version: v1
createdBy: arch
createdAt: 2026-03-31
---

## 任务概览

| ID | 任务 | 负责人 | 状态 | 预计工时 |
|----|------|--------|------|----------|
| T1 | 后端注册接口 | @be | [ ] pending | 3h |
| T2 | 前端注册页面 | @fe | [ ] pending | 2h |
| T3 | 移动端注册 | @mobile | [ ] pending | 2.5h |

> 状态说明：`[ ]` pending | `[~]` doing | `[x]` done | `[!]` blocked

---

## 任务详情

### T1: 后端注册接口

**阅读文件**:
- `openapi.yaml` - API 契约
- `design.md` - 技术方案

**任务**:
- [ ] 创建 NestJS Auth 模块（复用 001-user-login）
- [ ] 实现 POST /api/v1/auth/register/send-code 接口
- [ ] 实现 POST /api/v1/auth/register 接口
- [ ] 实现邮箱验证码发送（nodemailer + Redis）
- [ ] 实现验证码验证逻辑
- [ ] 实现密码强度验证
- [ ] 实现邮箱唯一性检查
- [ ] 实现注册后自动登录（JWT）
- [ ] 实现 IP 限流（Redis）
- [ ] 编写单元测试
- [ ] 创建 `flags/be.done`

**验收标准**:
- API 符合 openapi.yaml 规范
- 验证码有效期 5 分钟
- 密码强度验证正确
- 邮箱唯一性检查正确
- 注册后自动登录
- 单元测试通过率 100%

---

### T2: 前端注册页面

**阅读文件**:
- `openapi.yaml` - API 契约

**任务**:
- [ ] 创建 Vue3 注册组件
- [ ] 实现注册表单（邮箱、密码、确认密码、验证码）
- [ ] 实现表单验证（邮箱格式、密码强度）
- [ ] 实现发送验证码功能（倒计时 60 秒）
- [ ] 实现验证码输入
- [ ] 对接后端注册 API
- [ ] 处理错误提示
- [ ] 注册成功自动登录并跳转首页
- [ ] 创建 `flags/fe.done`

**验收标准**:
- 表单验证完整
- 验证码倒计时正确
- 错误提示友好
- API 调用正确
- 注册成功自动登录

---

### T3: 移动端注册

**阅读文件**:
- `openapi.yaml` - API 契约

**任务**:
- [ ] 创建 uni-app 注册页面
- [ ] 实现注册表单
- [ ] 实现表单验证
- [ ] 实现发送验证码功能
- [ ] 对接后端注册 API
- [ ] Token 持久化存储
- [ ] 创建 `flags/mobile.done`

**验收标准**:
- 表单验证完整
- API 调用正确
- Token 存储安全

---

## 完成标记

各 Agent 完成任务后，在 `flags/` 目录创建标记文件：

```bash
# 后端
echo "completed at: $(date -Iseconds)" > flags/be.done

# 前端
echo "completed at: $(date -Iseconds)" > flags/fe.done

# 移动端
echo "completed at: $(date -Iseconds)" > flags/mobile.done
```

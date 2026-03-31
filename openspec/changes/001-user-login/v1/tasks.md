# 任务清单：001-user-login v1

---
feature: user-login
version: v1
createdBy: arch
createdAt: 2026-03-31
---

## 任务概览

| ID | 任务 | 负责人 | 状态 | 预计工时 |
|----|------|--------|------|----------|
| T1 | 后端登录接口 | @be | [ ] pending | 2h |
| T2 | 前端登录页面 | @fe | [ ] pending | 1.5h |
| T3 | 移动端登录 | @mobile | [ ] pending | 2h |

> 状态说明：`[ ]` pending | `[~]` doing | `[x]` done | `[!]` blocked

---

## 任务详情

### T1: 后端登录接口

**阅读文件**:
- `openapi.yaml` - API 契约
- `schema.prisma` - 数据模型

**任务**:
- [ ] 创建 NestJS Auth 模块
- [ ] 实现 POST /api/v1/auth/login 接口
- [ ] 实现密码验证（bcrypt）
- [ ] 实现 JWT Token 生成
- [ ] 实现登录失败限流（Redis）
- [ ] 编写单元测试
- [ ] 创建 `flags/be.done`

**验收标准**:
- API 符合 openapi.yaml 规范
- 密码错误返回 code=1002
- 连续 5 次失败锁定账户
- 单元测试通过率 100%

---

### T2: 前端登录页面

**阅读文件**:
- `openapi.yaml` - API 契约

**任务**:
- [ ] 创建 React 登录组件
- [ ] 实现表单验证（邮箱、密码）
- [ ] 实现"记住我"选项
- [ ] 对接后端登录 API
- [ ] 处理错误提示
- [ ] 登录成功跳转首页
- [ ] 创建 `flags/fe.done`

**验收标准**:
- 表单验证完整
- 错误提示友好
- API 调用正确
- 支持记住我功能

---

### T3: 移动端登录

**阅读文件**:
- `openapi.yaml` - API 契约

**任务**:
- [ ] 创建 uni-app 登录页面
- [ ] 实现表单验证
- [ ] 实现"记住我"选项
- [ ] 对接后端登录 API
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

#!/bin/bash
# 从 openapi.yaml 生成 TypeScript 类型

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CHANGES_DIR="$ROOT_DIR/openspec/changes"
OUTPUT_DIR="$ROOT_DIR/../saas-types"

echo "🔧 从 openapi.yaml 生成 TypeScript 类型..."

# 创建输出目录
mkdir -p "$OUTPUT_DIR/src"

# 合并所有 openapi.yaml
echo "📝 合并 API 定义..."
cat > "$OUTPUT_DIR/src/api.yaml" << EOF
# 合并的 API 定义
openapi: 3.0.0
info:
  title: SaaS Platform API
  version: 1.0.0
servers:
  - url: /api/v1
paths:
EOF

# 遍历所有变更提案
for change_dir in "$CHANGES_DIR"/*/; do
  change_name=$(basename "$change_dir")
  for version_dir in "$change_dir"v*/; do
    if [ -f "$version_dir/openapi.yaml" ]; then
      echo "  - 处理 $change_name..."
      # 提取 paths 部分并追加
      tail -n +10 "$version_dir/openapi.yaml" | sed 's/^/  /' >> "$OUTPUT_DIR/src/api.yaml"
    fi
  done
done

# 使用 openapi-typescript 生成类型
echo "🚀 生成 TypeScript 类型..."
cd "$OUTPUT_DIR"

# 初始化 package.json (如果不存在)
if [ ! -f "package.json" ]; then
  npm init -y
  npm install openapi-typescript typescript --save-dev
fi

# 生成类型
npx openapi-typescript src/api.yaml --output src/types.ts

echo "✅ 类型生成完成！"
echo ""
echo "📁 输出文件："
ls -la "$OUTPUT_DIR/src/"

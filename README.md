# ying-ollama-script

Ollama / Open WebUI / ComfyUI 本地工作流脚本集合。

本仓库只包含脚本与配置；`prompts/`、`images/`、`open-webui/`、`comfyui/`、`archive/` 等目录为本地数据，已在 `.gitignore` 中忽略，不会提交到 Git。

## 目录结构

**仓库内（git 跟踪）**

```
.
├── ai-script/           # Open WebUI / ComfyUI shell 脚本
│   ├── ow-install.sh
│   ├── ow-start.sh
│   ├── ow-uninstall.sh
│   └── comfy-start.sh
├── script/              # 生图 JS 脚本（type: module）
│   ├── flux.js          # 交互式生图（radio + checkbox + 文件名输入）
│   ├── flux-run.js      # 命令行直跑
│   └── lib/
├── results/             # 生图输出（时间戳命名）
└── package.json         # pnpm 快捷命令
```

**本地目录（.gitignore，需自行创建或由脚本生成）**

```
.
├── prompts/             # 生图 prompt，自行创建
├── images/              # 参考图，自行创建
├── open-webui/          # Open WebUI 安装目录（ow-install.sh 生成）
├── comfyui/             # ComfyUI 安装目录
└── archive/             # 本地归档
```

## 首次准备

克隆仓库后，先创建生图所需的本地目录，并放入自己的 prompt 与参考图：

```bash
pnpm install
mkdir -p prompts images results
# 示例：创建 prompts/image.md，按需放入 images/*.jpg
```

Open WebUI 与 ComfyUI 的安装目录会在执行对应安装/启动脚本后自动生成，无需手动创建。

## 前置依赖

| 工具 | 用途 | 安装 |
|------|------|------|
| [Ollama](https://ollama.com) | 本地模型推理 / 生图 | `brew install ollama` |
| [uv](https://github.com/astral-sh/uv) | Open WebUI Python 环境 | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Python 3.12 | Open WebUI 运行环境 | `brew install python@3.12` |

下载模型较慢时，可先开代理再安装：

```bash
proxy
./ai-script/ow-install.sh 0.10.2
noproxy
```

## pnpm 快捷命令

```bash
pnpm ow:install          # 安装 Open WebUI
pnpm ow:start            # 启动 Open WebUI
pnpm ow:uninstall        # 卸载 Open WebUI
pnpm comfy:start         # 启动 ComfyUI
pnpm flux                # 交互选择 prompt（radio）+ 参考图（checkbox）
pnpm flux:run            # 直接用 prompts/image.md 生图
pnpm flux:loop           # 交互式循环生图
```

---

## Open WebUI

基于 Ollama 的 Web 聊天界面，默认端口 **8080**。

### 安装

```bash
./ai-script/ow-install.sh
./ai-script/ow-install.sh 0.10.2
./ai-script/ow-install.sh --force
```

### 启动

```bash
./ai-script/ow-start.sh
```

等到终端出现 `Ready: http://localhost:8080` 再打开浏览器。首次启动约需 **2–5 分钟**。

### 更新

```bash
./ai-script/ow-install.sh 0.10.2
./ai-script/ow-start.sh
```

若 Web 界面版本未变，浏览器 **强制刷新**（`Cmd+Shift+R`）。

### 卸载

```bash
./ai-script/ow-uninstall.sh
./ai-script/ow-uninstall.sh --backup
./ai-script/ow-uninstall.sh --keep-data
./ai-script/ow-uninstall.sh --venv-only
./ai-script/ow-uninstall.sh -y --backup
```

### 配置

配置文件：本地 `open-webui/.env`（安装 Open WebUI 后生成）

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `OLLAMA_BASE_URL` | `http://127.0.0.1:11434` | Ollama API 地址 |
| `PORT` | `8080` | Web 端口 |
| `OFFLINE_MODE` | `true` | 离线模式 |
| `DEFAULT_MODEL_PARAMS` | `{"num_ctx":16384}` | 全局默认模型参数 |

---

## ComfyUI

节点式工作流生图，默认端口 **8188**。

```bash
./ai-script/comfy-start.sh
# → http://localhost:8188
```

- 程序：本地 `comfyui/ComfyUI/`
- 模型：本地 `comfyui/ComfyUI/models/`

---

## Ollama 生图（flux2-klein）

```bash
ollama pull x/flux2-klein:9b
```

默认读取本地 `prompts/image.md`（需自行创建），输出保存到 `results/<时间戳>.png`。

### 交互式生图（推荐）

```bash
pnpm flux
```

- **Prompt**：radio 单选（本地 `prompts/` 目录）
- **参考图**：checkbox 多选，最多 2 张（本地 `images/` 目录，可不选）
- **输出名**：输入框，留空则使用时间戳（如 `20260715-100512.png`）

### 命令行直跑

```bash
pnpm flux:run
node script/flux-run.js prompts/image.md
node script/flux-run.js -o my-shot prompts/1.md
node script/flux-run.js -i images/ref.jpg -o test prompts/1.md
```

输出示例：`results/20260715-093812.png`

### 限制

- 图像生成目前仅 **macOS** 支持
- `x/flux2-klein:9b` 是生图模型，不能用于聊天
- 参考图编辑功能仍偏实验性

---

## Ollama 管理

```bash
brew update && brew upgrade ollama   # Homebrew 更新
ollama list
ollama pull <model>
ollama rm <model>
```

---

## 快速上手

```bash
pnpm install
mkdir -p prompts images results
ollama pull x/flux2-klein:9b
./ai-script/ow-install.sh 0.10.2
./ai-script/ow-start.sh          # → http://localhost:8080
pnpm flux                        # → results/<timestamp>.png
./ai-script/comfy-start.sh       # → http://localhost:8188
```

---

## 常见问题

### Open WebUI 连接被拒绝

等到终端出现 `Ready: http://localhost:8080`（约 2–5 分钟）。

### 发 `hello` 报 context 超限

本地 `open-webui/.env` 中已设 `DEFAULT_MODEL_PARAMS={"num_ctx":16384}`，重启 `./ai-script/ow-start.sh`。

### 连续生图

用 `pnpm flux:loop`，每次可用 radio/checkbox 重新选择。

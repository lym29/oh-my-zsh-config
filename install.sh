#!/bin/bash

# Oh My Zsh 配置一键安装脚本
# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Oh My Zsh 配置一键安装脚本${NC}"
echo -e "${GREEN}========================================${NC}\n"

# 检查 Oh My Zsh 是否已安装
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${RED}错误: 请先安装 Oh My Zsh!${NC}"
    echo -e "运行: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    exit 1
fi

# 定义插件和主题目录
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
THEMES_DIR="$ZSH_CUSTOM/themes"

# 备份现有配置
if [ -f "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}备份现有 .zshrc 到 .zshrc.backup...${NC}"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi

# 安装 zsh-autosuggestions
echo -e "\n${GREEN}[1/3] 安装 zsh-autosuggestions...${NC}"
if [ -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo -e "${YELLOW}  已存在，跳过${NC}"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 安装成功${NC}"
    else
        echo -e "${YELLOW}  GitHub 访问失败，尝试使用 Gitee 镜像...${NC}"
        git clone https://gitee.com/phpxxo/zsh-autosuggestions.git "$PLUGINS_DIR/zsh-autosuggestions"
    fi
fi

# 安装 zsh-syntax-highlighting
echo -e "\n${GREEN}[2/3] 安装 zsh-syntax-highlighting...${NC}"
if [ -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo -e "${YELLOW}  已存在，跳过${NC}"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 安装成功${NC}"
    else
        echo -e "${YELLOW}  GitHub 访问失败，尝试使用 Gitee 镜像...${NC}"
        git clone https://gitee.com/Annihilater/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
    fi
fi

# 安装 Powerlevel10k 主题
echo -e "\n${GREEN}[3/3] 安装 Powerlevel10k 主题...${NC}"
if [ -d "$THEMES_DIR/powerlevel10k" ]; then
    echo -e "${YELLOW}  已存在，跳过${NC}"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 安装成功${NC}"
    else
        echo -e "${YELLOW}  GitHub 访问失败，尝试使用 Gitee 镜像...${NC}"
        git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"
    fi
fi

# 复制配置文件
echo -e "\n${GREEN}复制配置文件...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
echo -e "${GREEN}  ✓ .zshrc 已更新${NC}"

# 如果有 .p10k.zsh 配置文件也复制
if [ -f "$SCRIPT_DIR/.p10k.zsh" ]; then
    cp "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    echo -e "${GREEN}  ✓ .p10k.zsh 已更新${NC}"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${YELLOW}请执行以下命令使配置生效：${NC}"
echo -e "  ${GREEN}source ~/.zshrc${NC}"
echo -e "\n${YELLOW}或者重新打开终端${NC}\n"

# 询问是否立即生效
read -p "是否立即重新加载配置？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    exec zsh
fi

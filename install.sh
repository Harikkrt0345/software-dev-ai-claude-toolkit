#!/usr/bin/env bash
set -euo pipefail

# software-dev-ai-claude-toolkit installer (Mac/Linux)
# Copies rules, commands, agents, skills, hooks, and MCP config to ~/.claude/

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Software Dev AI Claude Toolkit - Installer ==="
echo ""
echo "This will install Claude Code configurations to: $CLAUDE_DIR"
echo ""

# Check if ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Creating $CLAUDE_DIR..."
    mkdir -p "$CLAUDE_DIR"
fi

# Function to copy a directory with backup
copy_dir() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [ ! -d "$src" ]; then
        echo "  SKIP: $name (source not found)"
        return
    fi

    if [ -d "$dest" ]; then
        echo "  MERGE: $name (directory exists, merging files)"
    else
        mkdir -p "$dest"
    fi

    cp -r "$src"/* "$dest"/ 2>/dev/null || true
    echo "  OK: $name"
}

# Function to copy a file with backup
copy_file() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [ ! -f "$src" ]; then
        echo "  SKIP: $name (source not found)"
        return
    fi

    if [ -f "$dest" ]; then
        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        cp "$dest" "$backup"
        echo "  BACKUP: $name -> $(basename "$backup")"
    fi

    cp "$src" "$dest"
    echo "  OK: $name"
}

echo "Installing components..."
echo ""

# Rules
copy_dir "$SCRIPT_DIR/rules" "$CLAUDE_DIR/rules" "rules (9 files)"

# Commands
copy_dir "$SCRIPT_DIR/commands" "$CLAUDE_DIR/commands" "commands (8 slash commands)"

# Agents
copy_dir "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents" "agents (5 agents)"

# Skills
copy_dir "$SCRIPT_DIR/skills" "$CLAUDE_DIR/skills" "skills (13 skill packs)"

# Hooks — merge into existing settings.json
if [ -f "$SCRIPT_DIR/hooks/settings.json" ]; then
    if command -v node &>/dev/null; then
        node -e "
const fs = require('fs');
const src = JSON.parse(fs.readFileSync('$SCRIPT_DIR/hooks/settings.json', 'utf8'));
const destPath = '$CLAUDE_DIR/settings.json';
let dest = {};
if (fs.existsSync(destPath)) {
    dest = JSON.parse(fs.readFileSync(destPath, 'utf8'));
    fs.copyFileSync(destPath, destPath + '.backup.' + Date.now());
}
dest.hooks = src.hooks;
fs.writeFileSync(destPath, JSON.stringify(dest, null, 2));
"
        echo "  OK: hooks (merged into settings.json)"
    else
        echo "  WARN: Node.js not found. Copying hooks/settings.json manually."
        copy_file "$SCRIPT_DIR/hooks/settings.json" "$CLAUDE_DIR/settings.json" "settings.json"
    fi
fi

# MCP servers
if [ -f "$SCRIPT_DIR/mcp/mcp-servers.json" ]; then
    mkdir -p "$CLAUDE_DIR"
    if [ -f "$CLAUDE_DIR/.mcp.json" ]; then
        cp "$CLAUDE_DIR/.mcp.json" "$CLAUDE_DIR/.mcp.json.backup.$(date +%Y%m%d%H%M%S)"
        echo "  BACKUP: .mcp.json"
    fi
    cp "$SCRIPT_DIR/mcp/mcp-servers.json" "$CLAUDE_DIR/.mcp.json"
    echo "  OK: MCP servers (4 servers configured)"
    echo ""
    echo "  NOTE: Edit ~/.claude/.mcp.json and replace <YOUR_GITHUB_TOKEN>"
    echo "        with your GitHub personal access token."
fi

# CLAUDE.md — only install if not present
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    if [ -f "$SCRIPT_DIR/examples/CLAUDE.md" ]; then
        cp "$SCRIPT_DIR/examples/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
        echo "  OK: CLAUDE.md (installed example — customize it!)"
    fi
else
    echo "  SKIP: CLAUDE.md (already exists, not overwriting)"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "What was installed:"
echo "  - 9 coding rules (coding style, Java, Python, JS, DBs, infra, git, testing, security)"
echo "  - 8 slash commands (/plan, /code-review, /tdd, /build-fix, /api-design, /docker-setup, /system-design, /db-schema)"
echo "  - 5 specialized agents (planner, code-reviewer, security-reviewer, architect, tdd-guide)"
echo "  - 13 skill packs (Spring Boot, Python, React, MYSQL, JPA, security, and more)"
echo "  - 4 code quality hooks (block dangerous commands, warn on print/console.log/System.out)"
echo "  - 4 MCP servers (context7, memory, sequential-thinking, github)"
echo ""
echo "Next steps:"
echo "  1. Customize ~/.claude/CLAUDE.md with your personal preferences"
echo "  2. Add your GitHub token to ~/.claude/.mcp.json"
echo "  3. Start Claude Code in any project and enjoy!"

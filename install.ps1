# software-dev-ai-claude-toolkit installer (Windows PowerShell)
# Copies rules, commands, agents, skills, hooks, and MCP config to ~/.claude/

$ErrorActionPreference = "Stop"

$ClaudeDir = "$env:USERPROFILE\.claude"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== Software Dev AI Claude Toolkit - Installer ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will install Claude Code configurations to: $ClaudeDir"
Write-Host ""

# Create ~/.claude if needed
if (-not (Test-Path $ClaudeDir)) {
    Write-Host "Creating $ClaudeDir..."
    New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
}

function Copy-DirectoryMerge {
    param([string]$Source, [string]$Destination, [string]$Name)

    if (-not (Test-Path $Source)) {
        Write-Host "  SKIP: $Name (source not found)" -ForegroundColor Yellow
        return
    }

    if (Test-Path $Destination) {
        Write-Host "  MERGE: $Name (directory exists, merging files)" -ForegroundColor Yellow
    } else {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    Copy-Item -Path "$Source\*" -Destination $Destination -Recurse -Force
    Write-Host "  OK: $Name" -ForegroundColor Green
}

function Copy-FileWithBackup {
    param([string]$Source, [string]$Destination, [string]$Name)

    if (-not (Test-Path $Source)) {
        Write-Host "  SKIP: $Name (source not found)" -ForegroundColor Yellow
        return
    }

    if (Test-Path $Destination) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backup = "$Destination.backup.$timestamp"
        Copy-Item -Path $Destination -Destination $backup
        Write-Host "  BACKUP: $Name -> $(Split-Path -Leaf $backup)" -ForegroundColor Yellow
    }

    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Host "  OK: $Name" -ForegroundColor Green
}

Write-Host "Installing components..."
Write-Host ""

# Rules
Copy-DirectoryMerge "$ScriptDir\rules" "$ClaudeDir\rules" "rules (9 files)"

# Commands
Copy-DirectoryMerge "$ScriptDir\commands" "$ClaudeDir\commands" "commands (8 slash commands)"

# Agents
Copy-DirectoryMerge "$ScriptDir\agents" "$ClaudeDir\agents" "agents (5 agents)"

# Skills
Copy-DirectoryMerge "$ScriptDir\skills" "$ClaudeDir\skills" "skills (13 skill packs)"

# Hooks - merge into existing settings.json
$hooksSource = "$ScriptDir\hooks\settings.json"
if (Test-Path $hooksSource) {
    $settingsPath = "$ClaudeDir\settings.json"
    $srcContent = Get-Content $hooksSource -Raw | ConvertFrom-Json

    if (Test-Path $settingsPath) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        Copy-Item -Path $settingsPath -Destination "$settingsPath.backup.$timestamp"
        $destContent = Get-Content $settingsPath -Raw | ConvertFrom-Json
    } else {
        $destContent = [PSCustomObject]@{}
    }

    # Merge hooks
    if ($destContent.PSObject.Properties["hooks"]) {
        $destContent.hooks = $srcContent.hooks
    } else {
        $destContent | Add-Member -NotePropertyName "hooks" -NotePropertyValue $srcContent.hooks
    }

    $destContent | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
    Write-Host "  OK: hooks (merged into settings.json)" -ForegroundColor Green
}

# MCP servers
$mcpSource = "$ScriptDir\mcp\mcp-servers.json"
if (Test-Path $mcpSource) {
    $mcpDest = "$ClaudeDir\.mcp.json"
    if (Test-Path $mcpDest) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        Copy-Item -Path $mcpDest -Destination "$mcpDest.backup.$timestamp"
        Write-Host "  BACKUP: .mcp.json" -ForegroundColor Yellow
    }
    Copy-Item -Path $mcpSource -Destination $mcpDest -Force
    Write-Host "  OK: MCP servers (4 servers configured)" -ForegroundColor Green
    Write-Host ""
    Write-Host "  NOTE: Edit $ClaudeDir\.mcp.json and replace <YOUR_GITHUB_TOKEN>" -ForegroundColor Yellow
    Write-Host "        with your GitHub personal access token." -ForegroundColor Yellow
}

# CLAUDE.md - only install if not present
$claudeMdDest = "$ClaudeDir\CLAUDE.md"
if (-not (Test-Path $claudeMdDest)) {
    $claudeMdSrc = "$ScriptDir\examples\CLAUDE.md"
    if (Test-Path $claudeMdSrc) {
        Copy-Item -Path $claudeMdSrc -Destination $claudeMdDest -Force
        Write-Host "  OK: CLAUDE.md (installed example - customize it!)" -ForegroundColor Green
    }
} else {
    Write-Host "  SKIP: CLAUDE.md (already exists, not overwriting)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "What was installed:"
Write-Host "  - 9 coding rules (coding style, Java, Python, JS, DBs, infra, git, testing, security)"
Write-Host "  - 8 slash commands (/plan, /code-review, /tdd, /build-fix, /api-design, /docker-setup, /system-design, /db-schema)"
Write-Host "  - 5 specialized agents (planner, code-reviewer, security-reviewer, architect, tdd-guide)"
Write-Host "  - 13 skill packs (Spring Boot, Python, React, PostgreSQL, JPA, security, and more)"
Write-Host "  - 4 code quality hooks (block dangerous commands, warn on print/console.log/System.out)"
Write-Host "  - 4 MCP servers (context7, memory, sequential-thinking, github)"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Customize $ClaudeDir\CLAUDE.md with your personal preferences"
Write-Host "  2. Add your GitHub token to $ClaudeDir\.mcp.json"
Write-Host "  3. Start Claude Code in any project and enjoy!"

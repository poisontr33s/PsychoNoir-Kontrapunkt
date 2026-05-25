#!/usr/bin/env pwsh

# 🎭💬 PsychoNoir Mobile Chat Auto-Startup (PowerShell)
Write-Host "🎭💬 Initializing PsychoNoir Mobile Chat Integration..." -ForegroundColor Magenta

# Set environment variables
$env:PSYCHONOIR_MOBILE_CHAT_ACTIVE = "true"
$env:PSYCHONOIR_CHAT_URL = "https://fictional-parakeet-wrggxgxq949w35gq4.app.github.dev/static_mobile_chat/mobile_chat.html"
$env:PSYCHONOIR_MIDDLEWARE_URL = "https://fictional-parakeet-wrggxgxq949w35gq4.app.github.dev/vscode_chat_middleware/vscode_chat_overlay.js"

Write-Host "✅ PsychoNoir Mobile Chat URLs:" -ForegroundColor Green
Write-Host "📱 Standalone Chat: $env:PSYCHONOIR_CHAT_URL" -ForegroundColor Cyan
Write-Host "🔧 Middleware: $env:PSYCHONOIR_MIDDLEWARE_URL" -ForegroundColor Cyan
Write-Host "🎯 Press Ctrl+Shift+C in VS Code for overlay" -ForegroundColor Yellow
Write-Host "🎯 Press Ctrl+Alt+M for standalone mobile chat" -ForegroundColor Yellow

Write-Host "🎭✅ PsychoNoir Mobile Chat Integration Ready!" -ForegroundColor Green
        
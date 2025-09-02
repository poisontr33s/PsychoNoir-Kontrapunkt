
#!/usr/bin/env node
// 🎭💬 PsychoNoir Auto-Injection Script
// Automatically injects chat middleware into VS Code session

const fs = require('fs');
const path = require('path');

console.log('🎭💬 PsychoNoir Auto-Injection Starting...');

// Middleware JavaScript payload
const middlewarePayload = `
// 🎭💬 PsychoNoir VS Code Chat Overlay - Auto-Injected
(function() {
    'use strict';
    
    console.log('🎭💬 PsychoNoir Chat Overlay Auto-Loading...');
    
    // Check if already loaded
    if (window.psychonoirChatLoaded) {
        console.log('🎭 Chat overlay already active');
        return;
    }
    
    window.psychonoirChatLoaded = true;
    
    // Load external middleware script
    const script = document.createElement('script');
    script.src = 'https://fictional-parakeet-wrggxgxq949w35gq4.app.github.dev/vscode_chat_middleware/vscode_chat_overlay.js';
    script.onload = () => {
        console.log('✅ PsychoNoir Chat Middleware Loaded!');
        
        // Auto-show floating button
        setTimeout(() => {
            console.log('🎯 Chat overlay ready - Click 🎭💬 or press Ctrl+Shift+C');
        }, 1000);
    };
    script.onerror = () => {
        console.error('❌ Failed to load external middleware, using fallback...');
        createFallbackOverlay();
    };
    
    document.head.appendChild(script);
    
    // Fallback overlay for offline use
    function createFallbackOverlay() {
        const btn = document.createElement('button');
        btn.innerHTML = '🎭💬';
        btn.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff6b6b, #ff5252);
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            z-index: 9999;
            box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
        `;
        
        btn.addEventListener('click', () => {
            window.open('https://fictional-parakeet-wrggxgxq949w35gq4.app.github.dev/static_mobile_chat/mobile_chat.html', '_blank');
        });
        
        document.body.appendChild(btn);
        console.log('🎭 Fallback chat button created');
    }
})();
`;

// Inject into current page if in browser context
if (typeof window !== 'undefined') {
    eval(middlewarePayload);
} else {
    // Node.js context - save injection script
    const injectionPath = path.join(__dirname, 'browser_injection.js');
    fs.writeFileSync(injectionPath, middlewarePayload);
    console.log('✅ Browser injection script saved:', injectionPath);
    
    // Also try to inject via puppeteer or similar if available
    try {
        console.log('🎯 To manually inject in browser:');
        console.log('1. Open VS Code in browser');
        console.log('2. Press F12 (Developer Tools)');
        console.log('3. Copy and paste the browser_injection.js content');
        console.log('4. Press Enter');
    } catch (e) {
        console.log('💡 Manual injection instructions above');
    }
}

console.log('🎭✅ Auto-injection script ready!');
        
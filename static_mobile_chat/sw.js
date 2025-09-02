// 🎭💬 PsychoNoir Mobile Chat Service Worker
const CACHE_NAME = 'psychonoir-mobile-chat-v2';
const JULES_CACHE = 'jules-micro-ide-v2';
const IMPA_CACHE = 'impa-iphone-ide-v2';
const urlsToCache = [
    './',
    './mobile_chat.html',
    './manifest.json'
];

self.addEventListener('install', event => {
    console.log('🎭 PsychoNoir Chat SW installing...');
    self.skipWaiting();
    event.waitUntil(
        Promise.all([
            caches.open(CACHE_NAME).then(cache => cache.addAll(urlsToCache)),
            caches.open(JULES_CACHE).then(cache => cache.addAll(['./jules_micro_ide.html']).catch(()=>{})),
            caches.open(IMPA_CACHE).then(cache => cache.addAll(['./impa_iphone_ide.html']))
        ])
    );
});

self.addEventListener('fetch', event => {
    event.respondWith(
        caches.match(event.request)
            .then(response => {
                return response || fetch(event.request);
            }
        )
    );
});

self.addEventListener('activate', event => {
    console.log('🎭✅ PsychoNoir Chat SW activated');
    const keep = new Set([CACHE_NAME, JULES_CACHE, IMPA_CACHE]);
    event.waitUntil((async () => {
        const names = await caches.keys();
        await Promise.all(names.filter(n => !keep.has(n)).map(n => caches.delete(n)));
        await self.clients.claim();
    })());
});

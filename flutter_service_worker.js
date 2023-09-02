'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "5e287300ef068dccfe894994bcf6ae36",
"index.html": "f9531c07ea7bcfaecf06ec2234c79f81",
"/": "f9531c07ea7bcfaecf06ec2234c79f81",
"images/circle_logo.svg": "d7224ad40675885473fc7722efdd52cb",
"main.dart.js": "f2b019353b4f9179260c45214a1306e3",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"styles/styles.min.css": "705b608ff4fbbef090855dd8ecc1acd8",
"icons/favicon-192.png": "7a1b020b7b3e140229f361e11a63e15a",
"icons/favicon-16.png": "216fd4487eec7eba93bbb7c14e86ff24",
"icons/Icon-192.png": "7a1b020b7b3e140229f361e11a63e15a",
"icons/Icon-maskable-192.png": "09a7208d2ed42d74f5578852d501c33a",
"icons/favicon-32.png": "a05e00488d84a24c21081df740b7f983",
"icons/favicon-96.png": "4282551cc44db50b35ded11da8b7d309",
"icons/Icon-maskable-512.png": "1d86f607cda264edf734f5a71eed06df",
"icons/Icon-512.png": "b97573c473f7ba95109550fb4d9d35c5",
"manifest.json": "b107215b12b7c0dbd92b0d497030f1c6",
"assets/AssetManifest.json": "28c51fd4955892625a62c90374fefbe3",
"assets/NOTICES": "eb1ed9ddb4c0d333b594535d3dfa73f6",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "cd5678a6d072e77bb3315ed17e67b06c",
"assets/fonts/MaterialIcons-Regular.otf": "1177b4a11ed9db6ffdc4b5d7d9b6bccc",
"assets/assets/svg/plot_opacity.svg": "ae885887c66598abecedcf643a7476ab",
"assets/assets/svg/matrix.svg": "deaefb96faf27a9d9f31998f49260413",
"assets/assets/svg/tools_imaginary.svg": "aeccd0cfe2a7e53b45eded21bf64c84e",
"assets/assets/svg/url_error.svg": "90f034de0721f4dcf0e9955900035080",
"assets/assets/svg/square_matrix.svg": "2105ecc26cc48bbe372a7b272105bdb9",
"assets/assets/svg/function.svg": "ffd41cdee3b2c846a904ddbb8ff8827f",
"assets/assets/svg/angle.svg": "87ed2b1709c38959cc559f68a9b42ee5",
"assets/assets/svg/square-root-simple.svg": "6500716552d6f4c94f7bf7a02c6b9616",
"assets/assets/svg/polynomial.svg": "791fa37dc7f34c6c9332102ce53fb251",
"assets/assets/svg/axis.svg": "a3be5181e8709339181b2f3be10eb0df",
"assets/assets/svg/solutions.svg": "ee217bc0f893e1d8868a9d939d9f3cdb",
"assets/assets/svg/atoms.svg": "7d0c4ab2c088694c60d3b48fbaf36a00",
"assets/assets/svg/wrench.svg": "7823d5d1e976bb87ba8660b36c730e34",
"assets/assets/svg/plot.svg": "c6bb4c8a10249ce46356b7138681c6db",
"assets/assets/svg/logo.svg": "d7224ad40675885473fc7722efdd52cb",
"assets/assets/svg/tools_matrix.svg": "7cd769bbe03322efc0371bf818a965b3",
"assets/assets/svg/integral.svg": "03c561a062b3a1f73a6a114c33e1d509",
"messages.js": "71f2de0c9f78f1cc40dd90f274cd8706",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

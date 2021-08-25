'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/assets/matrix.svg": "deaefb96faf27a9d9f31998f49260413",
"assets/assets/function.svg": "ffd41cdee3b2c846a904ddbb8ff8827f",
"assets/assets/tools.svg": "7823d5d1e976bb87ba8660b36c730e34",
"assets/assets/integral.svg": "03c561a062b3a1f73a6a114c33e1d509",
"assets/assets/logo.png": "a674e6bcb067fa81d36d47f907ad20d2",
"assets/assets/polynomial.svg": "791fa37dc7f34c6c9332102ce53fb251",
"assets/assets/plot.svg": "c6bb4c8a10249ce46356b7138681c6db",
"assets/assets/plot_opacity.svg": "ae885887c66598abecedcf643a7476ab",
"assets/assets/axis.svg": "a3be5181e8709339181b2f3be10eb0df",
"assets/assets/solutions.svg": "ee217bc0f893e1d8868a9d939d9f3cdb",
"assets/assets/arrow_up.svg": "d506772739a24c7ca2f4e716e5f84d13",
"assets/AssetManifest.json": "dc9d187197390d5c89404462eccdea82",
"assets/FontManifest.json": "6f5744f40eb3064f030b4e03a74f67a5",
"assets/google_fonts/OFL.txt": "39591640d6982378c43eba1db4b68e12",
"assets/google_fonts/Lato-Italic.ttf": "7582e823ef0d702969ea0cce9afb326d",
"assets/google_fonts/Lato-Bold.ttf": "85d339d916479f729938d2911b85bf1f",
"assets/google_fonts/Lato-BoldItalic.ttf": "f98d18040a766b7bc4884b8fcc154550",
"assets/google_fonts/Lato-Light.ttf": "2fe27d9d10cdfccb1baef28a45d5ba90",
"assets/google_fonts/Lato-Regular.ttf": "2d36b1a925432bae7f3c53a340868c6e",
"assets/google_fonts/Lato-LightItalic.ttf": "4d80ac573c53d192dafd99fdd6aa01e9",
"assets/google_fonts/Lato-Black.ttf": "e631d2735799aa943d93d301abf423d2",
"assets/google_fonts/Lato-Thin.ttf": "9a77fbaa85fa42b73e3b96399daf49c5",
"assets/google_fonts/Lato-BlackItalic.ttf": "2e26a9163cb4974dcba1bea5107d4492",
"assets/google_fonts/Lato-ThinItalic.ttf": "4ac7208bbe0e3593ce9464f013607751",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/packages/golden_toolkit/fonts/Roboto-Regular.ttf": "ac3f799d5bbaf5196fab15ab8de8431c",
"assets/NOTICES": "107a7cdb1c340bc5331f73a05ac7638b",
"icons/Icon-192.png": "7a1b020b7b3e140229f361e11a63e15a",
"icons/Icon-512.png": "b97573c473f7ba95109550fb4d9d35c5",
"favicon.png": "216fd4487eec7eba93bbb7c14e86ff24",
"styles/styles.min.css": "20ea8623f4962f1e234ad074896905a0",
"manifest.json": "892b6d2b5761303cc51d5b4293b1eeef",
"images/circle_logo.svg": "d7224ad40675885473fc7722efdd52cb",
"version.json": "3eaa6f825b5a51212cd1169bc07618e4",
"main.dart.js": "f0f5d6e667afc0c170681885001e35df",
"index.html": "52639d2ae64cbadcf739cfba0e6a0b9f",
"/": "52639d2ae64cbadcf739cfba0e6a0b9f"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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

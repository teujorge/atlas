'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"index.html": "7872e1d71df4d29a3507aefb065d1f4f",
"/": "7872e1d71df4d29a3507aefb065d1f4f",
"main.dart.js": "3bc4602d4dab5237a9f3cb612676cebf",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "a03e44f3749ba340111d4834f72db274",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "05217e3e3f3e5407e53977f2f25c5562",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/FontManifest.json": "5dc76d7855d157d234a1dc36e7ca30fc",
"assets/NOTICES": "712d43376e6cde5a7c078216750ae8be",
"assets/AssetManifest.json": "30bc8a2baf8bcb085afc7c08991b3901",
"assets/assets/tiles/arena.tmx": "180b858b264a011a44f6b8e262a77dd6",
"assets/assets/tiles/scene3.tmx": "c1baf387c0edd94d25b1fcfc61697cc9",
"assets/assets/tiles/scene4.tmx": "e63bbd63a233de3a1a2894eab0142432",
"assets/assets/tiles/happy_map.tmx": "a73955cf0ae078e455d03e763ec75066",
"assets/assets/tiles/map.tmx": "da5cadffe6c2a561bccbe030918c5d1d",
"assets/assets/fonts/VT323-Regular.ttf": "034de38c65e202c1cc838e7d014385fd",
"assets/assets/fonts/ARCADE_I.TTF": "3e1048ebd1c6e4f9752ae0b3cfe1a7fb",
"assets/assets/fonts/Baba.otf": "e1dbbad762cc97340ebc5dfb48df98be",
"assets/assets/images/collectables/potion.png": "c254eeb97c57d7ade3166459e9284870",
"assets/assets/images/collectables/energy.png": "dfda2dc9c8238bb2e59fce11ec808312",
"assets/assets/images/background_castle.png": "5792b51805d2b09f0e19bf0885d7519c",
"assets/assets/images/enemies/goblin.png": "68e48620d019f404ca3dc1b4e458e833",
"assets/assets/images/enemies/skelet.png": "481d7c6c6d7b2afe4a83f777dab9c9de",
"assets/assets/images/enemies/enemy.png": "a6d127e108f31d97a7a36d454c071551",
"assets/assets/images/enemies/necro.png": "4f315314f5ddc86d146af0c884d474ec",
"assets/assets/images/terrain.png": "a61b3151c6c237b26448aa64206f65be",
"assets/assets/images/arena.png": "db9c58e55433e247667d5c82679834bf",
"assets/assets/images/atlas/knight_right.png": "1e99eaf1593cfb94767f7920ca5d88c2",
"assets/assets/images/atlas/archer_left.png": "b3893f3c8060188e174965bc657941a6",
"assets/assets/images/atlas/knight_down.png": "c38875321af28255fbdc4ebbddb0d5f0",
"assets/assets/images/atlas/archer_right.png": "0b06618b1e66f9df014e101342840e50",
"assets/assets/images/atlas/archer_up.png": "7a7f5a9cc327757641c48951f82dfcf8",
"assets/assets/images/atlas/knight_idle.gif": "953e77a15b520802473d807c0d8130bb",
"assets/assets/images/atlas/mage_up.png": "bd92ee066cf0dc48c12fd68808673cdb",
"assets/assets/images/atlas/mage_down.png": "61bcaca2ed626d6f2f1a9707bbf70f3f",
"assets/assets/images/atlas/knight_idle.png": "2862319b12cf3cd9359757d637f773e6",
"assets/assets/images/atlas/mage_left.png": "2a72167edc7b2efdcdffd544087c189c",
"assets/assets/images/atlas/mage_right.png": "1e52cdd5b9079d68da6811cdb8f324aa",
"assets/assets/images/atlas/archer_idle.gif": "0704b4acb298fb9ac71f0a230e4c42bc",
"assets/assets/images/atlas/mage_idle.gif": "fb1492c332176ed136aae460ba048c47",
"assets/assets/images/atlas/mage_idle.png": "d09526f037a4a620113fe8deb1dbcec5",
"assets/assets/images/atlas/archer_down.png": "fbea6476913529dcb96e4b8c76bbecfe",
"assets/assets/images/atlas/archer_idle.png": "050ed5bcc270241c7e9daf642d5550dd",
"assets/assets/images/atlas/knight_up.png": "8324d47a9888150fd79891715d88bd83",
"assets/assets/images/atlas/knight_left.png": "acc1d2ae234d44ba1878fb7ecaa98f79",
"assets/assets/images/abilities/dash.gif": "edaee6006fcb8130083dc9eb9b2a519e",
"assets/assets/images/abilities/teleport.gif": "130006c62029dcfc69178866c66ea9c6",
"assets/assets/images/abilities/arrow_cluster.gif": "cbb6754d4fd2bbd3e7f82c6fe8c2cf66",
"assets/assets/images/abilities/beam.gif": "95d4d31e61823c10674127a89dd5b5d4",
"assets/assets/images/abilities/fireball.gif": "aaffe639d052ab2a46151895b957a1be",
"assets/assets/images/abilities/whirlwind.png": "6d3c616807524279fae9bbdb0cf6b27c",
"assets/assets/images/abilities/arrow.gif": "8e6a120484d23bf24475b4b114854ab9",
"assets/assets/images/abilities/dash.png": "e10a38c302e7db9d02d7287314707681",
"assets/assets/images/abilities/whirlwind.gif": "51921e89dcace1adc52100017fd91847",
"assets/assets/images/abilities/sword.gif": "58aeb96075009eab5b4cbb015d71a423",
"assets/assets/images/abilities/fireball.png": "072a0e9372fda2ea02cd6ab129a76956",
"assets/assets/images/abilities/impact.gif": "d0941a34f973d544370d03003281b51c",
"assets/assets/images/abilities/beam.png": "bbab7ca670d826c8a66fcfbd2d4cf5eb",
"assets/assets/images/abilities/sword.png": "44b50c01ea3aaa42e7478a247857d164",
"assets/assets/images/abilities/iceball.gif": "de16bf273edd17de017d01c8c9548a6c",
"assets/assets/images/abilities/arrow_cluster.png": "03be05b178a45e7f7cb384908e31b5ca",
"assets/assets/images/abilities/impact.png": "9db2e4d8883d6a4c3702277a98900eb5",
"assets/assets/images/abilities/rapier_stab.gif": "5f01453b93cd810d49a56711d427451f",
"assets/assets/images/abilities/teleport.png": "2ace30c933c9b3dee3eb1c207691a9aa",
"assets/assets/images/abilities/rapier_stab.png": "7f7688a259d34fe37f22cc156a9c368b",
"assets/assets/images/abilities/arrow.png": "f48b181e9e44d02c5dc5ea60aead3b99",
"assets/assets/images/abilities/iceball.png": "7744a321c2779e8ab42d67c9af76890b",
"assets/assets/images/arena.tsx": "406ca068c96a3c910c26b80d53bb1340"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
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

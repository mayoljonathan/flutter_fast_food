'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "ba55f633f26761c17dcb06b4860bedd7",
"assets/assets/animations/checkmark.json": "f7d6c75656526a71619a4185f53cfc4b",
"assets/assets/fonts/Manrope-Medium.ttf": "6196e0dab83345b15290ee22620358c1",
"assets/assets/fonts/Manrope-Regular.ttf": "0b726174d2b7e161b9e5e8125bf7751a",
"assets/assets/fonts/Manrope-Bold.ttf": "656753569aef606dd528cc6bdf672cdc",
"assets/assets/images/shake_shack.png": "ea151c3a4d279a3578e43e1e4ccee747",
"assets/assets/images/dominos_pizza_hero.png": "ca030c6ed06fd23cba078f7cb58ba944",
"assets/assets/images/ingredient3.png": "409b5fbb9287abd4fb5135614786eecd",
"assets/assets/images/starbucks.png": "db7efa6abc86bec4468ddac34d418919",
"assets/assets/images/value_meal1.png": "ed3e2f5f35bbe172c8dc7b4338891ad2",
"assets/assets/images/dominos_pizza.png": "22c29f1e272b92e26a0d71cec978c45d",
"assets/assets/images/breakfast2.png": "177619f1d47d38c73449c103aaa00fd3",
"assets/assets/images/ingredient5.png": "374ff9e4e4d378a2dc601eb89dbda61c",
"assets/assets/images/desert1.png": "6859805ae00b336d20faedc16af22c67",
"assets/assets/images/burger1.png": "e5e1926e9c7bf2384f6166f56166f3ec",
"assets/assets/images/kfc_hero.png": "4d6898a555fe04275928a503b1de6385",
"assets/assets/images/ingredient2.png": "138ec3eecbe8edc33651e2c2d0736875",
"assets/assets/images/breakfast1.png": "c97b34ad981a4c5b75f24399e2d3839c",
"assets/assets/images/drink1.png": "da5c75916c414b107e3cce2971984ba8",
"assets/assets/images/ice_tea.png": "1e561230a1f5d2b2095549e5780ed542",
"assets/assets/images/subway.png": "3bc2fbf628d5021e5ae87015818fd435",
"assets/assets/images/mcdo_hero.png": "a400b7653bb88684687c7f272da58d5b",
"assets/assets/images/ingredient1.png": "a51c10f838a8e6411d3c0146638bab13",
"assets/assets/images/mcdo.png": "e9bb30802bcbb7f2ddbfe78c97bf1a0f",
"assets/assets/images/subway_hero.png": "f2f3afba2cc82483a499b2968319c119",
"assets/assets/images/ingredient6.png": "a564e7d72a7152c203e374addf5e1d61",
"assets/assets/images/kfc.png": "b037df7bccd52a250f44c19125805bf2",
"assets/assets/images/smiley.png": "e621af47bdd71be99f1ba6af1e0dde42",
"assets/assets/images/breakfast3.png": "c0cf2aa1a9f8e6c245e4fc4d304a8f3c",
"assets/assets/images/burger3.png": "1cff47e51c124b7fbaeea94000dc23f6",
"assets/assets/images/burger2.png": "0a65909e3af44b5ad947b2bec53b91ba",
"assets/assets/images/apple_pay.png": "8bc95dacfef8def71a99bde89a3d6dce",
"assets/assets/images/sprite.png": "b9fcf6a94f8884f7fcde554ec3837fa7",
"assets/assets/images/starbucks_hero.png": "1913747c7b79314f153330a9cee57f74",
"assets/assets/images/shake_shack_hero.png": "bb67bfb1f414553d0635f5050ef29826",
"assets/assets/images/snacks1.png": "cd9ad8705195bcccb0423104e664730c",
"assets/assets/images/ingredient4.png": "33ab30a97c63187af72eedc0fcb56897",
"assets/assets/images/breakfast4.png": "8a22a78499ce7b91c3067630af45aa1d",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/AssetManifest.json": "b848427e8b671b6992d058a65b77c496",
"assets/FontManifest.json": "8ef464323c09820e05edc2e5225a68c4",
"assets/NOTICES": "a417afe6e56f4aae7ac7c38f4a747145",
"assets/packages/eva_icons_flutter/lib/fonts/evaicons.ttf": "b600c99b39c9837f405131463e91f61a",
"main.dart.js": "d41e07e1a1a87f9cee6ec579899c30c3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "ad4c2e8a8cf16e2a222ba23195b9a1c8",
"/": "ad4c2e8a8cf16e2a222ba23195b9a1c8",
"manifest.json": "45bcb90702c2c7e14e6f8969e87ceee4",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1"
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
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
  for (var resourceKey in Object.keys(RESOURCES)) {
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

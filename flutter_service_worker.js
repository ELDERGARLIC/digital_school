'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "90fe1973dbeb22fba2068803d23f1fba",
"icons/Icon-maskable-512.png": "90fe1973dbeb22fba2068803d23f1fba",
"icons/Icon-192.png": "516cce43377436d2bc231ae8c8135012",
"icons/Icon-maskable-192.png": "516cce43377436d2bc231ae8c8135012",
"manifest.json": "1e0298a33a1fadba5259e186bdbf79e4",
"index.html": "74b8ef935255a3e9aa879f927729b55c",
"/": "74b8ef935255a3e9aa879f927729b55c",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "2263083a67cf1895dd9f759df564e3f7",
"assets/assets/icons/%25D8%25AF%25D8%25B3%25D8%25AA%25DB%258C%25D8%25A7%25D8%25B1.svg": "3214293b62a0bad3ba1af6d6524ac061",
"assets/assets/icons/quiz.svg": "01da1c4b1ae98d01fb3a86a2d7cd05c9",
"assets/assets/icons/face%2520id.svg": "ab79b11d6ed2aafe46ee8bd1735469c0",
"assets/assets/icons/%25D8%25A7%25D8%25B2%25D9%2585%25D8%25A7%25DB%258C%25D8%25B4.svg": "167e9d8197c893c9a7512d48c1ce5eee",
"assets/assets/icons/calender.svg": "9bc36fa3ce34099372058792191ba1e3",
"assets/assets/icons/%25D8%25AA%25D8%25A7%25D8%25AE%25DB%258C%25D8%25B1.svg": "d48429dbdcf48eb50d3c117e89bcfe16",
"assets/assets/icons/Start%2520play.svg": "8606692fb94e2c89f5c798ae9d5aa224",
"assets/assets/icons/Start%2520Class.svg": "eca0da2b0814370d998c8e286b1a173b",
"assets/assets/icons/%25D8%25BA%25DB%258C%25D8%25A8%25D8%25AA%2520%25D8%25AC%25D9%2584%25D8%25B3%25D9%2587.svg": "610e69579598368bea25082746b3d643",
"assets/assets/icons/Class.svg": "a5ec12ddc500b73b154f59be9fd193be",
"assets/assets/icons/%25D8%25BA%25D8%25A7%25DB%258C%25D8%25A8.svg": "02b0387b76ac8b85a019b0f6beeb93aa",
"assets/assets/icons/%25D8%25AD%25D8%25B6%25D9%2588%25D8%25B1%2520%25D8%25AC%25D9%2584%25D8%25B3%25D9%2587.svg": "fdef1e65ff1ff30e5f11faec19892de6",
"assets/assets/icons/profile.svg": "b818943c771d72279ce93714a27bec39",
"assets/assets/icons/clock%25203d.svg": "9193fa78891d120781f0e90908bff192",
"assets/assets/icons/mobile.svg": "4d878d7d0454d9084bd427266852ba4c",
"assets/assets/icons/setting.svg": "a456c2ab36b1f9dd9bceb5738e7687cf",
"assets/assets/icons/clock.svg": "9bc9ea3dfa71e1e1c38f6a4562ce0f71",
"assets/assets/icons/%25D8%25AA%25D8%25A7%25D8%25AE%25DB%258C%25D8%25B1%2520%25D8%25AC%25D9%2584%25D8%25B3%25D9%2587.svg": "8eecc9dfeb5dea3bb224be35091d9311",
"assets/assets/icons/tick%2520circle.svg": "2c19f56e30a830aa2c4bb2435d70d86e",
"assets/assets/icons/video%2520class.svg": "c925a1b579bfcbb55dcfde818b5856df",
"assets/assets/icons/people.svg": "cc05be3f85f2cb84de6d73ba631c4d31",
"assets/assets/icons/right%2520arrow.svg": "b42a7a02818b083597dcaad4f56b8f2b",
"assets/assets/icons/done%25203d.svg": "a7c04e01038411c3c0977c8ad66259e4",
"assets/assets/icons/left%2520arrow.svg": "b1870460bf3661dcea3932e540733828",
"assets/assets/icons/log%2520out.svg": "918a7d5efd745c0af1cb72a38907b2ee",
"assets/assets/icons/files.svg": "6ccae34ed1908aff4c631ee93a72b130",
"assets/assets/icons/back.svg": "de52aa0e7b0015f6be0b77a4bfeed812",
"assets/assets/icons/%25D8%25AD%25D8%25A7%25D8%25B6%25D8%25B1.svg": "942036c5acf8b1efe0034de80ec28229",
"assets/assets/icons/log%2520in.svg": "06fc2f6b1b6f75f05ad1b3a2d9a97cad",
"assets/assets/icons/voice.svg": "234c01a0933a47f41cb1030c80df58b0",
"assets/assets/icons/Plus.svg": "da32bb424ee8868003ce145681b52cfb",
"assets/assets/icons/Home.svg": "5b2f87db5aac99ad7b47f9246f3ec8bf",
"assets/assets/icons/Video.svg": "965be5e0568eb255d9bd100e4b4e0aac",
"assets/assets/icons/%25D8%25B3%25D8%25B1%25D9%2581%25D8%25B5%25D9%2584.svg": "eaa32aed9983e8c1f1d0adebd300d2b5",
"assets/assets/images/video%25206.png": "e1ab2a8616548ed8370d913775aa6f1f",
"assets/assets/images/background.png": "6a84b32104be915e3af7ad5c031a2061",
"assets/assets/images/%25D8%25B7%25D8%25B1%25D8%25AD%2520%25D8%25AF%25D8%25B1%25D8%25B3.png": "a5e0db53dafae6061eac45c25d11a604",
"assets/assets/images/video%25202.png": "914a48d311338338a5c226b9e204975c",
"assets/assets/images/mohsen.png": "db02cad4b9911bf9ad5f646843bfe6d3",
"assets/assets/images/Profile%25202.png": "6c9942e1c7c63f85460d3eff9d399e58",
"assets/assets/images/%25D8%25A8%25D8%25B1%25D8%25B1%25D8%25B3%25DB%258C%2520%25D8%25AA%25DA%25A9%25D8%25A7%25D9%2584%25DB%258C%25D9%2581%2520(2).png": "81295570412e92ab1fd7088e32039e5d",
"assets/assets/images/%25D8%25B4%25DB%258C%25D9%2585%25DB%258C.png": "415f6a115f65c138f4c71d6c8b1ea2ec",
"assets/assets/images/%25D8%25A8%25D8%25B1%25D9%2586%25D8%25A7%25D9%2585%25D9%2587%2520%25D9%2586%25D9%2588%25DB%258C%25D8%25B3%25DB%258C.png": "122b85cd6b6fdbf54682c9b05963a875",
"assets/assets/images/%25D8%25B2%25DB%258C%25D8%25B3%25D8%25AA%2520%25D8%25B4%25D9%2586%25D8%25A7%25D8%25B3%25DB%258C.png": "0c1e412349f69aef519aa4bd1d4beb93",
"assets/assets/images/%25D9%2581%25D8%25A7%25DB%258C%25D9%2584.png": "0d5c3653ca3e83928702a3f1a6f02fc8",
"assets/assets/images/%25D9%2581%25D9%2584%25D8%25B3%25D9%2581%25D9%2587.png": "bbd28fd6c2fda69d1cbc9d2494d44efe",
"assets/assets/images/Profile%25204.png": "e78db6dc47dd6b7f4a7b60f23d1f6fba",
"assets/assets/images/%25D8%25A7%25D8%25AF%25D8%25A8%25DB%258C%25D8%25A7%25D8%25AA.png": "affd4862d090e209536a85721e98c8b2",
"assets/assets/images/Profile%25201.png": "543e790a854dbc42cbd3db9cde075515",
"assets/assets/images/%25D8%25B1%25DB%258C%25D8%25A7%25D8%25B6%25DB%258C.png": "fd19fbe281330468b94a820d281c07eb",
"assets/assets/images/video%252010.png": "a5bbc0ce528bc8c69bc0c263d51b007b",
"assets/assets/images/%25D8%25AC%25D8%25BA%25D8%25B1%25D8%25A7%25D9%2581%25DB%258C%25D8%25A7.png": "638936b9ef246c864aed17f0211bd023",
"assets/assets/images/Search%2520result.png": "ca588dc9d9f0142de04f8cc23afaac6f",
"assets/assets/images/video%25207.png": "49a9411af604e97a0ff2c27e1ab9f8f6",
"assets/assets/images/%25D8%25B7%25D8%25B1%25D8%25AD%2520%25D8%25AF%25D8%25B1%25D8%25B3%2520%25D8%25AC%25D9%2584%25D8%25B3%25D9%2587%2520%25D8%25A8%25D8%25B9%25D8%25AF.png": "59842194a0545ed48b2910fa7cf5e62f",
"assets/assets/images/video%25209.png": "831930b389bad9c77af786fe3627390e",
"assets/assets/images/%25D8%25AA%25DA%25A9%25D9%2584%25DB%258C%25D9%2581%2520%25D8%25AC%25D9%2584%25D8%25B3%25D9%2587%2520%25D8%25A8%25D8%25B9%25D8%25AF.png": "42b030828e3fc0a0ba1ab276b97154f5",
"assets/assets/images/video%25204.png": "da1bf2a11292eea237b3214adb9d5e7e",
"assets/assets/images/logo.png": "be2ca98ef4e3e588f7036135502af80a",
"assets/assets/images/%25D9%25BE%25D8%25B2%25D8%25B4%25DA%25A9%25DB%258C%25D8%25A7%25D9%2586.png": "07571b20ea4a848856e19d67658887c6",
"assets/assets/images/%25D9%2587%25D9%2586%25D8%25B1.png": "0145aa0ea65dd81fe47f1fa724c253e4",
"assets/assets/images/%25D8%25AA%25D8%25A7%25D8%25B1%25DB%258C%25D8%25AE.png": "dad6c843cdbdbabb43e7059907a24b89",
"assets/assets/images/video%25203.png": "66bb587c190869eab46f409341080eb6",
"assets/assets/images/tv%2520light.png": "0e7dba660a6e510bbd3821310c53e793",
"assets/assets/images/%25D8%25A7%25D9%2585%25D8%25AA%25D8%25AD%25D8%25A7%25D9%2586%2520%25DA%25A9%25D9%2584%25D8%25A7%25D8%25B3%25DB%258C.png": "c65a0a28467522ddab1142ba7576d3c7",
"assets/assets/images/Profile%25203.png": "feb7cfe2111ac52e9ffd305272ea47f3",
"assets/assets/images/%25D8%25B2%25D8%25A8%25D8%25A7%25D9%2586%2520%25D8%25A7%25D9%2586%25DA%25AF%25D9%2584%25DB%258C%25D8%25B3%25DB%258C.png": "9d22f2c408a98accafd8afb713b119f6",
"assets/assets/images/video%25205.png": "b0185101a55fd9e7b2992e341674a521",
"assets/assets/images/video%25201.png": "9e041aaacc156d37084ed779d9cca43e",
"assets/assets/images/%25D8%25B9%25DA%25A9%25D8%25B3%2520%25D8%25AF%25D8%25B1%25D8%25B3.png": "f645a21acbba7f95bf523940b9e8f1ff",
"assets/assets/images/tv%2520dark.png": "8423d6b10ace08f5acea51137d4a7fcf",
"assets/assets/images/kasra.png": "94c776fab6650fc2827031ee3db667b4",
"assets/assets/images/%25D8%25A8%25D8%25B1%25D8%25B1%25D8%25B3%25DB%258C%2520%25D8%25AA%25DA%25A9%25D8%25A7%25D9%2584%25DB%258C%25D9%2581%2520(1).png": "488a95ac505c13a57e3c5289582c6da1",
"assets/assets/images/video%25208.png": "4b68bb2d675daea25752eab640ab941a",
"assets/assets/fonts/XM%2520Yekan%2520Regular.ttf": "f4174d07481222d1266de3b4645b176e",
"assets/assets/fonts/Yekan%2520Bakh%2520Regular.ttf": "18064b489d239946176a191b7241fbce",
"assets/assets/fonts/B%2520Yekan%2520Regular.ttf": "e72cb2ea2800aa2d613a09777aa4a6ed",
"assets/fonts/MaterialIcons-Regular.otf": "8d131b145cae2038f7620e954ab82e3b",
"assets/NOTICES": "b74e21553ab59a4e292a6f3a02161b1c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "b9d62bb20ce8ae66faec767ce7336b51",
"assets/AssetManifest.bin": "01636f3c484d84c4d3931396d86d416b",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "ae6c872ff619f967dd2b9153cd5b5fee",
"flutter_bootstrap.js": "7e68696c395df332179c0e701c3f017d",
"version.json": "d0fad9b38609ebbfd9b08f8df8a3d6ec",
"main.dart.js": "fb7c1a6e198fb873e4044328330fb1b3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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

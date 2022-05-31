#!/usr/bin/env node
var prerender = require('./lib');

var server = prerender({
  followRedirects: true,
  logRequests: true,
  pageLoadTimeout: 120 * 1000,
  chromeFlags: [
    '--no-sandbox', 
    '--disable-dev-shm-usage',
    '--headless', 
    '--disable-gpu', 
    '--remote-debugging-port=9222', 
    '--hide-scrollbars'
  ]
});

server.use(prerender.sendPrerenderHeader());
server.use(prerender.browserForceRestart());
// server.use(prerender.blockResources());
server.use(prerender.removeScriptTags());
server.use(prerender.httpHeaders());

server.start();

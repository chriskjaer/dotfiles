/* global slate */

// Config
slate.configAll({
  defaultToCurrentScreen: true
});

// Operations
var pushRight = slate.operation('push', {
  direction: 'right',
  style:     'bar-resize:screenSizeX/2'
});

var pushLeft = slate.operation('push', {
  direction: 'left',
  style:     'bar-resize:screenSizeX/2'
});

var fullscreen = slate.operation('move', {
  x: 'screenOriginX',
  y: 'screenOriginY',
  width: 'screenSizeX',
  height: 'screenSizeY'
});

slate.bindAll({
  'right:cmd,alt': pushRight,
  'left:cmd,alt': pushLeft,
  'm:cmd,alt': fullscreen
});

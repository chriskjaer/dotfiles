// Config
slate.configAll({
  defaultToCurrentScreen: true
});

// Operations
var pushRight = slate.operation('push', {
  direction: 'right',
  style: 'bar-resize:screenSizeX/2'
});

var pushLeft = slate.operation('push', {
  direction: 'left',
  style: 'bar-resize:screenSizeX/2'
});

slate.bind('right:cmd,alt', pushRight);
slate.bind('left:cmd,alt', pushLeft);

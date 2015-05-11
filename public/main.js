window.onload = (function(){
  var show = function(msg){
    el = document.getElementById('msgs');
    el.innerHTML = msg + '<br />' + el.innerHTML;
  };

  var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
  ws.onopen    = function()  { show('websocket opened'); };
  ws.onclose   = function()  { show('websocket closed'); };
  ws.onmessage = function(m) { show('websocket message: ' +  m.data); };

  $('.play').click(function(f){
    tg = f.target.getAttribute('data-track');
    ws.send(tg);
      show('played ' + tg);
  });
});

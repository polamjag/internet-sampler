window.onload = (function(){
  var show = function(msg){
    el = document.getElementById('msgs');
    el.innerHTML = msg + '<br />' + el.innerHTML;
  };

  var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
  ws.onopen    = function()  { show('WebSocket opened'); };
  ws.onclose   = function()  { show('WebSocket closed'); };

  ws.onmessage = function(m) {
    var data = m.data;
    show('WebSocket msg: ' +  data);
    if (data.match(/^play:/) && document.getElementById('checkbox-play-on-device').checked) {
      target = $(".play[data-track=" + data.replace(/^play:/, '') + "] audio")[0];
      target.currentTime = 0;
      target.play();
    }
  };

  $('.play').click(function(f){
    tg = f.target.getAttribute('data-track');
    ws.send(tg);
    show('Sent event: ' + tg);
  });
});

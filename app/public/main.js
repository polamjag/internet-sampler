window.onload = (function(){
  var show = function(msg){
    var el = document.getElementById('msgs');
    el.innerHTML = msg + '<br>' + el.innerHTML;
  };

  var ws       = new WebSocket(ws_url);

  var play = function(slug, count) {
    if (document.getElementById('checkbox-play-on-device').checked) {
      var target = $(".play[data-track=" + slug + "] audio")[0];
      if (document.getElementById('checkbox-rewind-on-play').checked) {
        target.currentTime = 0;
      }
      target.play();
      if (typeof(window.navigator.vibrate) === "function") { window.navigator.vibrate(70); }
    }

    var $play = $(".play[data-track=" + slug + "] .count");
    if (count != null) {
      $play.text(count);
    } else {
      $play.text(~~($play.text()) + 1);
    }
  };

  ws.onopen    = function()  { show('WebSocket opened'); };
  ws.onclose   = function()  {
    show('WebSocket closed');
    document.getElementById("number").firstChild.nodeValue = "X";
  };

  ws.onmessage = function(m) {
    var data = $.parseJSON(m.data);

    if (data["type"] == "play") {
      show("Play: " + data["slug"] + " in RTT " + (Date.now() - data["msec"]) + "ms");
      play(data["slug"], data["count"]);
    } else if (data["type"] == "num") {
      show("Client number update: " + data["count"]);
      document.getElementById("number").firstChild.nodeValue = data["count"];
    } else if (data["type"] == "msg") {
      show("msg: " + data["msg"]);
    } else {
      console.log(data);
    }
  };

  var evname = ('ontouchstart' in document) ? 'touchstart' : 'click';
  $('.play').on(evname, function(f){
    var tg = f.currentTarget.getAttribute('data-track');
    ws.send(
      JSON.stringify({
        slug: tg,
        msec: Date.now()
      })
    );
    show('Sent: ' + tg);
    play(tg, null);
  });
});

window.onload = (function(){
  var show = function(msg){
    el = document.getElementById('msgs');
    el.innerHTML = msg + '<br>' + el.innerHTML;
  };

  var ws       = new WebSocket(ws_url);
  ws.onopen    = function()  { show('WebSocket opened'); };
  ws.onclose   = function()  {
    show('WebSocket closed');
    document.getElementById("number").firstChild.nodeValue = "X";
  };

  ws.onmessage = function(m) {
    var data = $.parseJSON(m.data);

    if (data["type"] == "play") {
      show("Play: " + data["slug"] + " in latency " + (Date.now() - data["msec"]) + "msec");
      if (document.getElementById('checkbox-rewind-on-play').checked) {
        target = $(".play[data-track=" + data["slug"] + "] audio")[0];
        target.currentTime = 0;
        target.play();
      }
      $(".play[data-track=" + data["slug"] + "] .count")[0].innerHTML = data["count"];
    } else if (data["type"] == "num") {
      show("Client number update: " + data["count"]);
      document.getElementById("number").firstChild.nodeValue = data["count"];
    } else if (data["type"] == "msg") {
      show("msg: " + data["msg"]);
    } else {
      console.log(data);
    }
  };

  $('.play').mousedown(function(f){
    tg = f.currentTarget.getAttribute('data-track');
    ws.send(
      JSON.stringify({
        slug: tg,
        msec: Date.now()
      })
    );
    show('Sent: ' + tg);
  });
});

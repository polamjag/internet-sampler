window.onload = (function(){
  var show = function(msg){
    el = document.getElementById('msgs');
    el.innerHTML = msg + '<br>' + el.innerHTML;
  };

  var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
  ws.onopen    = function()  { show('WebSocket opened'); };
  ws.onclose   = function()  {
    show('WebSocket closed');
    document.getElementById("number").firstChild.nodeValue = "X";
  };

  ws.onmessage = function(m) {
    var data = $.parseJSON(m.data);

    if (data["type"] == "play") {
      show("Play: " + data["slug"]);
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

  $('.play').click(function(f){
    tg = f.currentTarget.getAttribute('data-track');
    ws.send(tg);
    show('Sent: ' + tg);
  });
});

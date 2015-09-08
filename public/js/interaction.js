window.onload = function(){

  var frm = document.getElementById("picster"),
      btn = document.getElementById("send");

  if (frm) {
    frm.onsubmit = function(){
      btn.disabled = true;
      btn.value = "Sending..."
    };
  }

};

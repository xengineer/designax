
$(function () {
  var clicked = 0
  var gid     = -1
  $(".grouptbl_td_edit").click(function() {
    if(clicked == 0) {
      var gname = $(this).html();
      gid   = $(this).attr("gid");
      var htmltext = "<input id=\"user_group_name\" name=\"user_group[name]\" type=\"text\" value=" + gname + " gid=" + gid + " />";
      $(this).html(htmltext);
      clicked = 1
    }  else if(gid > 0) {
      gidnow   = $(this).attr("gid");

      if(gid != gidnow) {
        selTd = ".grouptbl_td_edit[gid=" + gid + "]";
        selInput = "#user_group_name[gid=" + gid + "]";
        var gname = $(selInput).val();
        $(selTd).html(gname);
        clicked = 0
      }
    }
  });

  $("td").on("enterKey", "input#user_group_name",function(e) {
    alert($(this).val());
  });

  $("td").on("keydown", "input#user_group_name", function(e) {
    if(e.which == 13) {
      $(this).trigger("enterKey");
      return false;
    }
  });
  //$(":not(td.grouptbl_td_edit)").click(function() {
  //  if(clicked == 1) {
  //  if(gid > 0) {
  //    selTd = ".grouptbl_td_edit[gid=" + gid + "]";
  //    selInput = "#user_group_name[gid=" + gid + "]";
  //    var gname = $(selInput).val();
  //    $(selTd).html(gname);
  //  }
  //  clicked = 0
  //  }
  //});
});

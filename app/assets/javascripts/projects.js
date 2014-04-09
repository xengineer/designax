
$(function () {
  var clicked = 0
  var gid     = -1

  $(".grouptbl_td_edit").click(function() {
    if(clicked == 0) {
      var prjname = $(this).html();
      var url     = $(this).attr("url");
      prjid       = $(this).attr("prjid");
      var htmltext = "<input id=\"project_name\" name=\"project[name]\" type=\"text\" value=" + prjname + " prjid=" + prjid + " url=" + url + "/>";
      $(this).html(htmltext);
      clicked = 1
    }  else if(prjid > 0) {
      var prjidnow   = $(this).attr("prjid");

      if(gid != gidnow) {
        var selTd = ".grouptbl_td_edit[gid=" + gid + "]";
        var selInput = "#user_group_name[gid=" + gid + "]";
        var gname = $(selInput).val();
        $(selTd).html(gname);
        clicked = 0
      }
    }
  });

  //$("td,input#user_group_name").on("enterKey", function(e) {
  $("td").on("enterKey", "input#user_group_name", function(e) {
    var gid   = $(this).attr("gid");
    var url   = $(this).attr("url");
    var gname = $(this).val();
    var update = url + "user_groups/" + gid
    var data  = "user_group=" + gname
    var selTd = ".grouptbl_td_edit[gid=" + gid + "]";

    alert(update)

    jQuery.ajax({
      type: "PUT",
      url: update,
      data: data,
      datatype: "text",
    }).done(function(mydata) {
      $(selTd).html(gname);
      clicked = 0;
    //}).fail(function(XMLHttpRequest, textStatus, errorThrown) {
    }).fail(function(errorThrown) {
      //alert("Error updating user group. Try again.");
      $(selTd).html(gname);
      clicked = 0;
    }).always(function(mydata) {
      //alert("Done");
      clicked = 0;
    });
  });

  $("td").on("keyup", "input#user_group_name", function(e) {
  //$("td,input#user_group_name").on("keydown", function(e) {
    if(e.which == '13') {
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

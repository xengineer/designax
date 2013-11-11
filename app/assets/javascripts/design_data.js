
//ul.ad-thumb-listにgetImagesByFileNameの画像をappendしてからダイアログ表示

$(function () {
  $(".imagetile .divleftimage img").click(function() {
    var url        = $(this).attr("url")
    var thumburl   = url + $(this).attr("thumb")
    var id         = $(this).attr("id")
    //var updateDlg  = url + "/image_data/get_updateDlg/" + id + ".json"
    var imgs       = url + "/image_data/get_imagefiles/" + id + ".text"
    var crtIdURL   = url + "/image_data/get_currentId/" + id + ".text"
    var designData = url + "/design_data/" + id + ".json"

    var currentId = 0
    var galleries = "";

    jQuery.ajax({
      type: "GET",
      url: imgs,
      datatype: "text",
      success: function(mydata) {
        $("ul.ad-thumb-list").html(mydata);
        galleries = $('.ad-gallery').adGallery();
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        alert("Error. Try again.");
      },
      complete: function(mydata) {
        //alert("complete");
      }
    });

    jQuery.ajax({
      type: "GET",
      url: crtIdURL,
      datatype: "text",
      success: function(mydata) {
        $("#imageid").html(
          "<input type=\'hidden\' name=\"image_data_id\" value=\'" + mydata + "\'>\n"
         );
        $("input#updateData").prop('disabled', false);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        alert("Error. Try again.");
      },
      complete: function(mydata) {
        //alert("complete");
      }
    });

    jQuery.ajax({
      type: "GET",
      url: designData,
      datatype: "text",
      success: function(mydata) {

        if(mydata.design_comment) {
          var designComment = mydata.design_comment
        } else {
          var designComment = ""
        }
  
        if(mydata.corp_comment) {
          var corpComment   = mydata.corp_comment
        } else {
          var corpComment   = ""
        }
  
        if(mydata.deadline) {
          var deadline = mydata.deadline.split("-")
          var year  = deadline[0];
          var month = deadline[1];
          var day   = deadline[2];
        }
        else {
          var today = new Date();
          var year  = today.getFullYear();
          var month = today.getMonth() + 1;
          var day   = today.getDate();
        }
  
        var yearhtml  = "<select id=\"design_datum_deadline_1i\" name=\"design_datum[deadline(1i)]\" style=\"width: 30%\">\n";
        var monthhtml = "<select id=\"design_datum_deadline_2i\" name=\"design_datum[deadline(2i)]\" style=\"width: 30%\">\n";
        var dayhtml   = "<select id=\"design_datum_deadline_3i\" name=\"design_datum[deadline(3i)]\" style=\"width: 30%\">\n";
        for(var i = year; i <= year + 6; i++) {
          if(i == year) {
            yearhtml += "<option selected=\"selected\" value=\"" + i + "\">" + i + "</option>\n"
          }
          else {
            yearhtml += "<option value=\"" + i + "\">" + i + "</option>\n"
          }
        }
        yearhtml += "</select>\n"
  
        for(var i = 1; i <= 12; i++) {
          if(i == month) {
            monthhtml += "<option selected=\"selected\" value=\"" + i + "\">" + i + "</option>\\n"
          }
          else {
            monthhtml += "<option value=\"" + i + "\">" + i + "</option>\n"
          }
        }
        monthhtml += "</select>\n"
        for(var i = 1; i <= 31; i++) {
          if(i == day) {
            dayhtml += "<option selected=\"selected\" value=\"" + i + "\">" + i + "</option>\n"
          }
          else {
            dayhtml += "<option value=\"" + i + "\">" + i + "</option>\n"
          }
        }
        dayhtml += "</select>\n"
        var deadlinehtml = "納期:" + yearhtml + monthhtml+ dayhtml;
  
        if(mydata.file_name) {
          var file_name = "value=\"" + mydata.file_name + "\""
        } else {
          var file_name = ""
        }
  
        if(mydata.state_id == 1) {
          $("button#outline").addClass("active btn-primary");
          $("#design_state").val(1);
        }
        else if(mydata.state_id == 2) {
          $("button#rough").addClass("active btn-primary");
          $("#design_state").val(2);
        }
        else if(mydata.state_id == 3) {
          $("button#line").addClass("active btn-primary");
          $("#design_state").val(3);
        }
        else if(mydata.state_id == 4) {
          $("button#color").addClass("active btn-primary");
          $("#design_state").val(4);
        }
        else if(mydata.state_id == 5) {
          $("button#uppergrade").addClass("active btn-primary");
          $("#design_state").val(5);
        }
        else if(mydata.state_id == 6) {
          $("button#flip").addClass("active btn-primary");
          $("#design_state").val(6);
        }
        else if(mydata.state_id == 7) {
          $("button#others").addClass("active btn-primary");
          $("#design_state").val(7);
        }
  
        if(mydata.corp_state_id == 1) {
          $("button#notchecked").addClass("active btn-primary");
          $("#corp_state").val(1);
        }
        else if(mydata.corp_state_id == 2) {
          $("button#ok").addClass("active btn-primary");
          $("#corp_state").val(2);
        }
        else if(mydata.corp_state_id == 3) {
          $("button#retake").addClass("active btn-primary");
          $("#corp_state").val(3);
        }
  
        if ($("#bkg").css('visibility') == 'hidden') {
          $("#form_update").wrapInner(
            "<form accept-charset=\"UTF-8\" action=\"/design_data/" +id + "\"" +
            " class=\"edit_design_data\" enctype=\"multipart/form-data\" id=\"edit_design_data_" + id + "\"" + " method=\"post\" />\n"
           );
  
          $("#gallery_imgs").html(
            "      <a href=\"" + thumburl + "\"><img src=\"" + thumburl + "\" height=\"120px\"></a>\n"
           );
  
          $("#input_filename").html(
            "      <input class=\'input-medium\' name=\"design_datum[file_name]\"  placeholder=\'ファイル名\'" + file_name  + ">\n"
           );
  
          $('input[name=authenticity_token]').val($('meta[name=csrf-token]').attr('content'));
  
  
          $("span#input_deadline").html(deadlinehtml);
  
          $("#input_designcomment").html(
            "      <textarea class=\'design_txtarea\' name=\"design_datum[design_comment]\" placeholder=\'デザイナーコメント欄\'>" + designComment + "</textarea>\n"
           );
  
          if(mydata['role'] == 'artist') {
            $("#input_corpcomment").html(
              "      <textarea readonly class=\'design_txtarea\' name=\'design_datum[corp_comment]\' placeholder=\'企業側コメント欄\' height=\"140px\">" + corpComment + "</textarea>\n"
             );
          } else {
            $("#input_corpcomment").html(
              "      <textarea class=\'design_txtarea\' name=\'design_datum[corp_comment]\' placeholder=\'企業側コメント欄\' height=\"140px\">" + corpComment + "</textarea>\n"
             );
          }
  
          $("#input_comment").html(
            "      <input class=\'input-medium\' name=\'design_datum[memo]\' placeholder=\'コメント\'>\n"
           );
  
          $("#bkg").css("visibility", "");
          $("#bkg").hide();
        }
  
        $(".design_state .btn#outline").click(function() {
          colorSelectedButton(".design_state .btn#outline", ".design_state .btn", "#design_state");
        });
        $(".design_state .btn#rough").click(function() {
          colorSelectedButton(".design_state .btn#rough", ".design_state .btn", "#design_state");
        });
        $(".design_state .btn#line").click(function() {
          colorSelectedButton(".design_state .btn#line", ".design_state .btn", "#design_state");
        });
        $(".design_state .btn#color").click(function() {
          colorSelectedButton(".design_state .btn#color", ".design_state .btn", "#design_state");
        });
        $(".design_state .btn#uppergrade").click(function() {
          colorSelectedButton(".design_state .btn#uppergrade", ".design_state .btn", "#design_state");
        });
        $(".design_state .btn#flip").click(function() {
          colorSelectedButton(".design_state .btn#flip", ".design_state .btn", "#design_state");
        });
        $(".design_state .btn#others").click(function() {
          colorSelectedButton(".design_state .btn#others", ".design_state .btn", "#design_state");
        });
  
        $(".check .btn#notchecked").click(function() {
          colorSelectedButton(".check .btn#notchecked", ".check .btn", "#corp_state");
        });
        $(".check .btn#retake").click(function() {
          colorSelectedButton(".check .btn#retake", ".check .btn", "#corp_state");
        });
        $(".check .btn#ok").click(function() {
          colorSelectedButton(".check .btn#ok", ".check .btn", "#corp_state");
        });
  
        if ($("#dlg").css("visibility") == 'hidden') {
          $("#dlg").css("visibility", "");
          $("#dlg").hide();
        }
        $("#bkg").fadeIn(100, "linear", function () { $("#dlg").show(100, "swing"); });
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        alert("Error. Try again.");
      },
      complete: function(mydata) {
        //alert("complete");
      }
    });

    $("ul.ad-thumb-list").css("width", "600px");
  });
});

$(function () {
  $("select#user_user_id").change(function() {
    openFilteredIndex();
  });
  $("select#corp_state_corp_state_id").change(function() {
    openFilteredIndex();
  });
  $("select#state_state_id").change(function() {
    openFilteredIndex();
  });
  $("select#project_project_id").change(function() {
    openFilteredIndex();
  });
  $("input#delflag").change(function() {
    openFilteredIndex();
  });
});

$(document).ready(function () {
  $("#xbutton").click(function () {
    $("#dlg").hide('100', "swing", function () { $("#bkg").fadeOut("100"); });
    $("#bkg").attr('style', 'visibility: hidden')
    $("#dlg").attr('style', 'visibility: hidden')
    location.reload();
  });
});

$(function () {
  $("button.removeImages").click(function() {
    var id  = $(this).attr("id")
    var url = "http://designax.nubee.jp/image_data/get_removeImages/" + id

    jQuery.get(url, function (mydata, mystatus){
      $("#delimages").html(mydata);
    });

    if ($("#bkg.deleteblk").css('visibility') == 'hidden') {
        $("#form_delete").wrapInner(
          "<form accept-charset=\"UTF-8\" action=\"/image_data/" +id + "\"" +
          " class=\"delete_image_data\" enctype=\"multipart/form-data\" id=\"delete_image_data_" + id + "\"" + " method=\"POST\" />\n"
         );

        $('input[name=authenticity_token]').val($('meta[name=csrf-token]').attr('content'));

      $("#bkg.deleteblk").css("visibility", "");
      $("#bkg.deleteblk").hide();
    }

    if ($("#dlg.deletelists").css("visibility") == 'hidden') {
      $("#dlg.deletelists").css("visibility", "");
      $("#dlg.deletelists").hide();
    }
    $("#bkg.deleteblk").fadeIn(100, "linear", function () { $("#dlg.deletelists").show(100, "swing"); });
  });

});

$(document).ready(function () {
  $("#xbtndel").click(function () {
    $("#dlg.deletelists").hide('100', "swing", function () { $("#deleteblk").fadeOut("100"); });
    $("#bkg.deleteblk").attr('style', 'visibility: hidden')
    $("#dlg.deletelists").attr('style', 'visibility: hidden')
    location.reload();
  });
});

$(document).ready(function () {
  $("#xbutton").click(function () {
    $("#dlg").hide('100', "swing", function () { $("#bkg").fadeOut("100"); });
    $("#bkg").attr('style', 'visibility: hidden')
    $("#dlg").attr('style', 'visibility: hidden')
    location.reload();
  });
});

$(document).ready(function () {
  $("#closebtn").click(function () {
    $("#dlg").hide('100', "swing", function () { $("#bkg").fadeOut("100"); });
  });
});

function openFilteredIndex() {
  var project   = $("select#project_project_id").val();
  var userid    = $("select#user_user_id").val();
  var corpstate = $("select#corp_state_corp_state_id").val();
  var state     = $("select#state_state_id").val();
  var delflag   = $("input#delflag").is(':checked');
  var protocol  = window.location.protocol;
  var host      = window.location.host;
  var url       = protocol + "//" + host + "?";
  var notFirst  = false;

  if(project) {
    url = url + "filterProject="   + project + "&";
  }
  if(state) {
    url = url + "filterState="     + state + "&";
  }
  if(corpstate) {
    url = url + "filterCorpState=" + corpstate + "&";
  }
  if(userid) {
    url = url + "filterArtist="    + userid + "&";
  }
  if(delflag) {
    url = url + "filterDelete="    + delflag + "&";
  }
  url = url.replace(/&$/, "")
  location.href = url
}

function colorSelectedButton(clickedBtn, otherBtns, hidden) {
  $(clickedBtn).addClass("btn-primary");
  $(otherBtns).not(clickedBtn).removeClass("btn-primary");
  var checkval = $(clickedBtn).val();
  $(hidden).val(checkval);
}

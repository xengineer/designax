
$(function () {
  $.fn.editable.defaults.mode = 'inline';
  $('.project_name').editable();
  $('.new_project').editable();

  $('.project_name').click(function() {
    $.fn.editable.defaults.ajaxOptions = {type: "PUT"};
    var dtype  = $(this).attr("data-type")
    var dpk    = $(this).attr("data-pk")
    //var tmpurl = $(this).attr("data-url")
    //alert(tmpurl)
    var durl = "/projects/" + dpk
    
    //alert(durl)

    $(this).editable({
      type: dtype,
      pk: dpk,
      url: durl
    });
  });

  $('.new_project').click(function() {
    $.fn.editable.defaults.ajaxOptions = {type: "POST"};
    var dtype  = $(this).attr("data-type")
    //var tmpurl = $(this).attr("data-url")
    //alert(tmpurl)
    var durl = "/projects"
    
    //alert(durl)

    $(this).editable({
      type: dtype,
      pk: "new",
      url: durl
    });
  });

});


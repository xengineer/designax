
$(function () {
  $.fn.editable.defaults.mode = 'inline';
  $('.project_name').each(function() {
    var dtype  = $(this).attr("data-type")
    var dpk    = $(this).attr("data-pk")
    var dname  = $(this).attr("data-name")
    var tmpurl = $(this).attr("data-url")
    var durl   = tmpurl + "/projects/" + dpk + ".json"

    $(this).editable({
      ajaxOptions: {
        dataType: 'json',
        type: 'PUT'
      },
      error: function(response, newValue) {
        var msg = response.responseText
        return msg;
      }
    });

  });

  $('.new_project').editable({
    ajaxOptions: {
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      dataType: 'json',
      type: 'POST'
    },
    success: function(response, newValue) {
      var url = response.url
      location.href = url
    },
    error: function(response, newValue) {
      var url = response.responseText
      alert("Could not create new project. Try again.")
    }
  });

});

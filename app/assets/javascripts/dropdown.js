$(document).ready(function() {
  $(".notif").on('show.bs.dropdown', function() {
    notifElement = $(this);

    $.post("/users/view_notifications", { _method: "PUT" }, function (response) {
      notifElement.find(".notif-num").text(response);         
    });
  });
});

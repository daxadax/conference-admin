$(document).ready(function() {
  // log the screen width on resize
  window.onresize = function(event) {
    console.log("window width: "+$(window).width()+"px");
  };

  // track clicks of any element with ga-track class
  $('.ga-track').on('click', function() {
    var name = this.getAttribute('data-tracker') || $(this).text() || this.value

    gtag('event', 'click', {
      'event_category': 'engagement',
      'event_label': 'click-'+name
    });
  });
});

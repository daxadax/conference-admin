$(document).ready(function() {
  // move to the next section
  $('#proposal-form-content .form-group .btn-next').on('click', function(){
    var section = $(this).parent('.form-group')
    if ( !section.find(":input").valid() ) {
      $('label.error').addClass('text-warning');
      return
    }

    var nextSection = parseInt(section.data(('position')) + 1)

    $('#proposal-form-content .form-group').addClass('hidden');
    $('.form-group[data-position='+ nextSection +']').removeClass('hidden');
  });

  // move to the previous section
  $('#proposal-form-content .form-group .btn-prev').on('click', function(){
    var section = $(this).parent('.form-group').data('position');
    var prevSection = parseInt(section) - 1

    $('#proposal-form-content .form-group').addClass('hidden');
    $('.form-group[data-position='+ prevSection +']').removeClass('hidden');
  });

  // trigger change event on range input
  $('input[type=range]').on('input', function () {
    console.log(this)
    $(this).trigger('change');
  });
});


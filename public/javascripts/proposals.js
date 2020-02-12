$(document).ready(function() {
  // move to the next section
  $('#proposal-form-content .form-stage .btn-next').on('click', function(){
    var section = $(this).parent('.form-stage')
        position = section.data('position')

    if ( position != 1 && !section.find(":input").valid() ) {
      $('label.error').addClass('text-warning');
      return
    }

    var nextSection = parseInt(position) + 1

    $('#proposal-form-content .form-stage').addClass('hidden');
    $('.form-stage[data-position='+ nextSection +']').removeClass('hidden');
  });

  // move to the previous section
  $('#proposal-form-content .form-stage .btn-prev').on('click', function(){
    var section = $(this).parent('.form-stage').data('position');
    var prevSection = parseInt(section) - 1

    $('#proposal-form-content .form-stage').addClass('hidden');
    $('.form-stage[data-position='+ prevSection +']').removeClass('hidden');
  });

  // trigger change event on range input
  $('input[type=range]').on('input', function () {
    console.log(this)
    $(this).trigger('change');
  });
});


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

function updateProposalType(value) {
  $('.experience-variant').addClass('hidden');

  if ( $.inArray(value, ['lecture', 'workshop']) != -1 ) {
    var headingText = 'Previous experience';
        previousExperienceText = 'How experienced of a public speaker are you?';
        portfoloText = 'Please link to any podcasts, conference videos or other media which demonstrates your presentation skills'

    $('#previous-experience-wrapper').removeClass('hidden');
    $('label#previous-experience').html(previousExperienceText);
  } else if ( $.inArray(value, ['ritual', 'performance']) != -1 ) {
    var headingText = 'Previous experience';
        action = (value == 'ritual') ? 'conducting rituals' : 'putting on this performance'
        previousExperienceText = 'How experienced are you in '+action+'?'
        portfoloText = 'Please link to any media which can help us understand your work'

    $('#previous-experience-wrapper').removeClass('hidden');
    $('label#previous-experience').html(previousExperienceText);
  } else if ( value == 'other' ) {
    var headingText = 'More information'
        portfoloText = 'Please link to any media which can help us understand your work'

    $('#portfolio-description').removeClass('hidden');
  } else {
    var headingText = 'Portfolio';
        portfoloText = 'Please provide links to your portfolio'

    $('#previous-experience-wrapper').addClass('hidden');
    $('#portfolio-description').removeClass('hidden');
  }

  $('#conditional-information').html(headingText);
  $('label#portfolio').html(portfoloText);
}

// TODO: set to an env variable
function characterizeExperience(value) {
  var experienceMap = {
    1: "I've never done this before",
    2: 'I have a bit of experience',
    3: "I feel totally comfortable, but I'm not a pro",
    4: 'I have a lot of experience',
    5: 'I consider this my main occupation'
  }

  $('#experience-output').html(experienceMap[value]);
}

function submitProposal() {
  var form = $('#proposal-form-content form')

  form.validate();
  $.post( "/proposal", form.serialize(), function() {
    window.location = '/proposal_submitted'
  });

  return false;
}


$(document).ready(function() {
  var formNextButton = $('#proposal-form-content .form-stage .btn-next');
      formPrevButton = $('#proposal-form-content .form-stage .btn-prev');
      birthdayInputField = $('#proposal-form-content input[name="birthday"]');
      avatarInputField = $('#proposal #proposal-form-content input[name="avatar_url"]');

  // move to the next section
  formNextButton.on('click', function(){
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
  formPrevButton.on('click', function(){
    var section = $(this).parent('.form-stage').data('position');
    var prevSection = parseInt(section) - 1

    $('#proposal-form-content .form-stage').addClass('hidden');
    $('.form-stage[data-position='+ prevSection +']').removeClass('hidden');
  });

  // HACK: show placeholder for birthday field
  birthdayInputField.on('focus', function() {
    this.type = 'date';
  });

  // show avatar help on form input focus
  avatarInputField.on('focus', function(){
    $(this).parent().find('.form-text').removeClass('hidden');
  });

  // trigger change event on range input
  $('input[type=range]').on('input', function () {
    $(this).trigger('change');
  });
});

function updateProposalType(value) {
  // reset defaults
  $('#proposal-form-content .experience-variant').addClass('hidden');
  $('#proposal-form-content input[name=title]').attr('placeholder', 'Title')
  $('#proposal-form-content textarea[name=abstract]').attr('placeholder', 'Abstract')
  $('#proposal-form-content #other-interests .opt-in-merch').removeClass('hidden');
  $('#proposal-form-content #other-interests .opt-in-electricity').addClass('hidden');

  if ( $.inArray(value, ['lecture', 'workshop']) != -1 ) {
    var headingText = 'Previous experience';
        previousExperienceText = 'How experienced of a public speaker are you?';
        portfoloText = 'Please link to any podcasts, conference videos or other media which demonstrates your presentation skills'

    $('#proposal-form-content #previous-experience-wrapper').removeClass('hidden');
    $('#proposal-form-content label#previous-experience').html(previousExperienceText);
  } else if ( $.inArray(value, ['ritual', 'performance']) != -1 ) {
    var headingText = 'Previous experience';
        action = (value == 'ritual') ? 'conducting rituals' : 'putting on this performance'
        previousExperienceText = 'How experienced are you in '+action+'?'
        portfoloText = 'Please link to any media which can help us understand your work'

    $('#proposal-form-content #previous-experience-wrapper').removeClass('hidden');
    $('#proposal-form-content label#previous-experience').html(previousExperienceText);
  } else if ( value == 'other' ) {
    var headingText = 'Additional details'
        portfoloText = 'Please link to any media which can help us understand your work'

    $('#proposal-form-content #portfolio-description').removeClass('hidden');
  } else if ( value == 'vendor' ) {
    var headingText = 'Additional details'
        portfoloText = 'Please link to your store page, Instagram, or other visual media'

    // 'shop name' rather than 'title'
    $('#proposal-form-content input[name=title]').attr('placeholder', 'Shop name')
    $('#proposal-form-content textarea[name=abstract]').attr('placeholder', 'Shop description')
    $('#proposal-form-content input[name=tradition]').addClass('hidden');

    // don't show "i want to sell merch" to someone applying as a vendor
    $('#proposal-form-content #other-interests .opt-in-merch').addClass('hidden');
    $('#proposal-form-content #other-interests .opt-in-electricity').removeClass('hidden');

    $('#proposal-form-content #portfolio-description').removeClass('hidden');
  } else {
    var headingText = 'Portfolio';
        portfoloText = 'Please provide links to your portfolio'

    $('#proposal-form-content #previous-experience-wrapper').addClass('hidden');
    $('#proposal-form-content #portfolio-description').removeClass('hidden');
  }

  $('#proposal-form-content #conditional-information').html(headingText);
  $('#proposal-form-content label#portfolio').html(portfoloText);
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

  $('#proposal-form-content #experience-output').html(experienceMap[value]);
}

function submitProposal() {
  var form = $('#proposal-form-content form')

  form.validate();

  var request = $.ajax({
    url: "/proposal",
    method: "POST",
    data: form.serialize(),
    dataType: "html",
    complete: function(xhr, textStatus) {
      console.log(xhr.status);
      if ( xhr.status == 201 ) {
        window.location.replace('/proposal/submitted');
      } else {
        window.location.replace('/proposal/new');
      }
    }
  });
}


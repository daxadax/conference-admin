$(document).ready(function() {

  // NAV
  $('#dashboard #proposals nav .nav-item').on('click', function() {
    var selector = $(this).attr('id');

    if( selector == 'all' ) {
      $('#dashboard #proposals table tbody tr.primary').
        removeClass('hidden').
        removeClass('selected-row');
      $('#dashboard #proposals table tbody tr.details-wrap').
        addClass('hidden');
    } else {
      $('#dashboard #proposals table tbody tr').
        addClass('hidden').
        removeClass('selected-row');
      $('#dashboard #proposals tr.primary[data-type="'+ selector +'"]').
        removeClass('hidden');
    };
  });

  // selecting rows for more information
  $('#dashboard #proposals table tbody td').
    not('td.actions').
    not('td.details').
    on('click', function() {
      var proposalId = $(this).parent('tr').attr('data-id');
          allInfoPanes = $('#dashboard #proposals table .details-wrap');
          thisInfoPane = $('.details-wrap[data-id="'+ proposalId +'"]');

      // de-select all rows
      // $('#dashboard #proposals table tbody tr').removeClass('selected-row');

      if ( thisInfoPane.hasClass('hidden') ) {
        thisInfoPane.removeClass('hidden');
        // allInfoPanes.not(thisInfoPane).addClass('hidden');
        $(this).parent('tr').addClass('selected-row');
      } else {
        thisInfoPane.addClass('hidden');
        $(this).parent('tr').removeClass('selected-row');
      }

    // use this for update
    // $.ajax({
    //   url: 'proposal/' + proposalId,
    //   dataType: 'html',
    //   success: function(result) {
    //     $('#more-info').html(result);
    //   }
    // })
  });
});

function upvote(el) {
  var proposalId = $(el).parents('tr').data('id');
      dootCount = $(el).parent().siblings('.doot-count')[0]
      doots = parseInt(dootCount.textContent)

  if (el.classList.contains('upvoted')) {
    $.ajax({
      url: 'proposal/removeVote/' + proposalId,
      type: 'patch',
      data: {},
      success: function(result) {
        dootCount.textContent = doots - 1;
        el.classList.remove('upvoted');
      }
    })
  } else {
    $.ajax({
      url: 'proposal/upvote/' + proposalId,
      type: 'patch',
      data: {},
      success: function(result) {
        dootCount.textContent = doots + 1;
        el.classList.remove('downvoted');
        el.classList.add('upvoted');
      }
    })
  }
}

function downvote(el) {
  var proposalId = $(el).parents('tr').data('id');
      dootCount = $(el).parent().siblings('.doot-count')[0]
      doots = parseInt(dootCount.textContent)

  if (el.classList.contains('downvoted')) {
    $.ajax({
      url: 'proposal/removeVote/' + proposalId,
      type: 'patch',
      data: {},
      success: function(result) {
        dootCount.textContent = doots + 1;
        el.classList.remove('downvoted');
      }
    })
  } else {
    $.ajax({
      url: 'proposal/downvote/' + proposalId,
      type: 'patch',
      data: {},
      success: function(result) {
        dootCount.textContent = doots - 1;
        el.classList.remove('upvoted');
        el.classList.add('downvoted');
      }
    })
  }
}

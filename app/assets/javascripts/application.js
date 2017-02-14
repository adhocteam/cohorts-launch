// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.

// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require fastclick/fastclick
//= require best_in_place
//= require twitter/bootstrap
//= require twitter/typeahead.min
//= require holder
//= require datepicker/bootstrap-datepicker.min
//= require tokenfield/bootstrap-tokenfield.js
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require moment/moment.min
//= require fullcalendar/fullcalendar.min
//= require jquery-touchswipe/jquery.touchSwipe.min
//= require semantic_ui/semantic_ui
//= require_tree .
//= require maskedinput

$(document).on('ready page:load',function() {
  FastClick.attach(document.body);
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();


  var show_ajax_message = function(msg, type) {
    var cssClass = type === 'error' ? 'alert-error' : 'alert-success'
    var html ='<div class="alert ' + cssClass + '">';
    html +='<button type="button" class="close" data-dismiss="alert">&times;</button>';
    html += msg +'</div>';
    //fade_flash();
    $("#notifications").html(html);
  };

  $(document).ajaxComplete(function(event, request) {
    var msg = request.getResponseHeader('X-Message');
    var type = request.getResponseHeader('X-Message-Type');

    if (type !== null) {
      show_ajax_message(msg, type);
    }
  });

  // Add active class to active menu items
  $('.ui.top.menu > a.item').each( function(index) {
    if ($(this).attr('href') == location.pathname && !$(this).hasClass('logo')) {
      $(this).addClass('active green');
      $(this).find('.label').addClass('green');
    }
  });
  $('.ui.tabular.menu > a.item').each( function(index) {
    if ($(this).attr('href') == location.pathname) {
      $(this).addClass('active');
    }
  });

  // Initialize Semantic elements
  $('.ui.dropdown').dropdown({
    selectOnKeydown: false,
    forceSelection: false,
    onChange: function(value) {
      var target = $(this).parent();
      if(value) {
  	    target.find('.dropdown.icon').removeClass('dropdown').addClass('delete').on('click', function() {
          target.dropdown('clear');
          $(this).removeClass('delete').addClass('dropdown');
        });
      }
    }
  });
  $('.ui.menu .ui.dropdown').dropdown();
  $('.ui.checkbox').checkbox();
  $('.ui.calendar').calendar({
    type: 'date'
  });
  $('.ui.calendar').calendar('clear');
  $('.ui.modal').modal();
  $('.sortable.table').tablesort();
  $('.tooltippy').popup();

  // Allow additions to some dropdowns
  $('.ui.dropdown.allow-addition').dropdown({
    selectOnKeydown: false,
    forceSelection: false,
    allowAdditions: true,
    hideAdditions: false,
    onChange: function(value) {
      var target = $(this);
      if(value) {
  	    target.find('.dropdown.icon').removeClass('dropdown').addClass('delete').on('click', function() {
          target.dropdown('clear');
          $(this).removeClass('delete').addClass('dropdown');
        });
      }
    }
  });

  // Turn file input into a button
  $('.hidden-file-field').hide();
  $('.fake-file-field').click(function(e) {
    $("input[type='file']").click();
  });
  $('.hidden-file-field').change(function() {
    $('.button-text').text(
      $('input[type=file]').val().split('\\').pop()
    );
  });

  // Close alerts
  $('.ui.message .close').click(function() {
    $(this)
      .closest('.message')
      .transition('slide down');
  });

  // Submit button hack
  $('.ui.submit.button').click(function() {
    $(this).parents('form').submit();
  });
  $('.search.link.icon').click(function() {
    $(this).parents('form').submit();
  });
});

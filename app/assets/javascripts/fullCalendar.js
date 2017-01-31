$(document).on('ready page:load', function () {

  // users won't have a token.
  var token_param = '';
  if (typeof(token) != "undefined") { token_param = "?token="+ token; }
  // this is to be able to change to the right date on the calendar.
  // also timecop
  if (typeof(defaultDate) === "undefined") { defaultDate = moment(); }

  var event_sources = {
    reservations: {
      url: "/calendar/reservations.json" + token_param,
      lazyFetching: false,
      displayed: false
    },
    event_slots: {
      url: '/calendar/event_slots.json' + token_param,
      lazyFetching: false,
      displayed: false
    }
  }

  var toggle_event_source = function(event_type){
    source = event_sources[event_type]
    $('.fc-' + event_type + '-button').toggleClass('fc-state-active');
    $('#calendar').fullCalendar('removeEventSource',source);
    if (!source['displayed']) {
      $('#calendar').fullCalendar('addEventSource',source);
      source['displayed'] = true;

    }else{
      source['displayed'] = false;
    }
  }

  // simple mobile detection
  var isMobile = window.matchMedia("only screen and (max-width: 760px)");
  var buttons = '';
  if (token_param !== '') { buttons = ' event_slots,reservations'; }
  $('#calendar').fullCalendar({
    customButtons: {
        event_slots: {
            text: 'invitations',
            click: function() {
              toggle_event_source('event_slots');
            }
        },
        reservations: {
            text: 'reservations',
            click: function() {
              toggle_event_source('reservations');
            }
        }
    },
    header: {
      right: 'prev,next today',
      center: 'title' + buttons,
      left: 'month,agendaWeek,agendaDay'
    },
    eventClick:  function(event, jsEvent, view) {
      // https://coderwall.com/p/kqb3xq/rails-4-how-to-partials-ajax-dead-easy
      // and
      // https://coderwall.com/p/ej0mhg/open-a-rails-form-with-twitter-bootstrap-modals
      $.getScript(event.modal_url);
    },
    eventRender: function(event, element){
      if(event.rendering == 'background'){
        element.append('<div class="fc-title">' + event.title + '</div>');
      }

      if (event.type === 'Reservation') {
        var icon = '';
        switch(event.status){
          case 'Unconfirmed':
            icon = 'icon-question';
            break;
          case 'Confirmed':
            icon = 'icon-check';
            break;
          case 'Rescheduling':
            icon = 'icon-random';
            break;
          case 'Cancelled':
            icon = 'icon-times'
            break;
          default:
            icon = 'icon-calendar'
        }
        element.find('.fc-time').append('<span class="'+ icon +' pull-right icon-border icon-large" style="margin:1px; background:blue" aria-hidden="true"></span>');
      }
    },
    defaultView: isMobile.matches ? 'agendaDay' : 'agendaWeek',
    aspectRatio: isMobile.matches ? 0.7 : 1.35 ,
    defaultDate: defaultDate,
    //eventLimit: true, // allow "more" link when too many events
    editable: false,
    nowIndicator: true,
    businessHours:{
      start:'9:00',
      end: '20:00'
    },
    eventSources: [],
    slotDuration: isMobile.matches ? '00:15:00' : '00:10:00',
    scrollTime: '09:00:00',
    minTime: isMobile.matches ? '08:30:00' : '07:00:00',
    maxTime: isMobile.matches ? '20:00:00' : '21:00:00',
    allDaySlot: false
  });

  if ($('#calendar').length) { // rails?
    toggle_event_source('reservations');
    if (token !== 'false') { toggle_event_source('event_slots'); }
  }


  if (isMobile.matches) {
    $("#calendar").swipe( {
      tap:function(event, target) {

          msg(target);
      },
      doubleTap:function(event, target) {

          msg(target);
      },
      longTap:function(event, target) {

          msg(target);
      },
      swipe:function(event, direction, distance, duration, fingerCount, fingerData) {
        if (direction == 'right') { $('#calendar').fullCalendar('prev'); }
        if (direction == 'left') { $('#calendar').fullCalendar('next'); }
      },
      threshold:50,
      fingers:'all',
      allowPageScroll:"vertical"
    });
  }


});

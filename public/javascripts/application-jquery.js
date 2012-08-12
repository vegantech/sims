// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//

$(function() {
  $('.toggler').click(function() {
    return $("#" + $(this).data().toggleId).toggle();
  });
  $('a.plus_minus').click(function() {
    return $(this).parent('li').toggleClass('minus');
  });
  $('.help-question').mouseover(function() {
    return overlib($(this).data().help);
  });
  $('.help-question').mouseout(function() {
    return nd();
  });
  return $('.dbl_toggler').dblclick(function() {
    return $("#" + $(this).data().toggleId).toggle();
  });
});

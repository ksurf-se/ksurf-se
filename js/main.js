$(function(){

    $('.parallax-header').parallax();

    $('#dateInput').datepicker({
        container: $('.modal-body'),
        autoclose: true,
        calendarWeeks: true,
        format: 'yyyy-mm-dd (DD)',
        weekStart: 1,
        startDate: 'today'
    });

    $('.btn-booking-request-activity').click(function(){
        $('#lessonsInput').val($(this).data('hours'))
    });

    $('.btn-booking-request-camp').click(function(){
        $('#packageInput').val($(this).data('package'))
    });


});

formden.success = function(data, form_dom){
    $(form_dom).fadeOut(1000, function(){
        $('.form-alert-success').hide().removeClass('hidden').fadeIn(1000);
    });
};

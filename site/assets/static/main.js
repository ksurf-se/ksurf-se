$(function(){

    $('#contact-me-form').validator().submit(function(event){
        var form = $(this);
        event.preventDefault();

        $.ajax({
            url: "https://formspree.io/jt@ordolabs.io",
            method: "POST",
            data: {
                _subject: "Please contact me",
                email: form.find('#emailInput').val(),
                name: form.find('#nameInput').val(),
                phone: form.find('#phoneInput').val(),
                via: form.find("input[type='radio']:checked").val()
            },
            dataType: "json"
        });
        form.fadeOut(1000, function(){
            $('#contact-me-form-alert').hide().removeClass('hidden').fadeIn(1000);
        })
    })

});
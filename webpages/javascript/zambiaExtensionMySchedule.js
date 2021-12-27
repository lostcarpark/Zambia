$(function() {

    $.zambia.mySchedule = {

        sendConfirmation: (sessionId, participantSessionid, value) => {
            $('.alert-danger').remove();

            $.ajax({ 
                url: 'api/confirm_session_assignment.php',
                method: 'POST',
                dataType: "json",
                data: JSON.stringify({
                    sessionId: sessionId,
                    participantSessionId: participantSessionid,
                    value: value
                }),
                success: function(data) {
                    // nothing required
                },
                error: function(err) {
                    if (err.status < 300) {
                        // this isn't an error. Why am I in the error function? Bad jQuery; no biscuit.
                    } else if (err.status == 401) {
                        $.zambia.redirectToLogin();
                    } else {
                        $.zambia.simpleAlert('danger', 'There was a problem contacting the server. Your changes might not have been saved. Try again later?');
                    }
                }
            });
        }
    }

    $(".confirmation-select").change((e) => {
        let $select = $(e.target);
        let sessionId = $select.data("sessionid");
        let participantSessionid = $select.data("participantonsessionid");
        $.zambia.mySchedule.sendConfirmation(sessionId, participantSessionid, $select.val());
    });

});
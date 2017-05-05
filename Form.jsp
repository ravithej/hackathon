<html lang="en-US">
<head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"><link href="./css/index.css" rel="stylesheet">

<link href='http://fonts.googleapis.com/css?family=Droid+Serif|Open+Sans:400,700' rel='stylesheet' type='text/css'>

</head>
<body >
	<div class="container" >
            <form class="form-horizontal" role="form" id="step1Form">
                <h2>SMARTIFHIR</h2>
                <div class="form-group">
                    <label for="firstName" class="col-sm-3 control-label">Practice ID</label>
                    <div class="col-sm-9">
                        <input type="text" id="practiceId" placeholder="Practice ID" class="form-control" autofocus>
                        <span class="help-block"> eg.: 2908343</span>
                    </div>
                </div>
                <div class="form-group">
                    <label for="departmentId" class="col-sm-3 control-label">Department ID</label>
                    <div class="col-sm-9">
                        <input type="text" id="departmentId" placeholder="Department ID" class="form-control" autofocus>
                        <span class="help-block"> eg.: 1</span>
                    </div>
                </div>
                              
                <div class="form-group">
                    <label for="birthDate" class="col-sm-3 control-label">Start Date</label>
                    <div class="col-sm-9">
                        <input type="date" id="startDate" class="form-control">
                    </div>
                </div>
                <div class="form-group">
                    <label for="birthDate" class="col-sm-3 control-label">End Date</label>
                    <div class="col-sm-9">
                        <input type="date" id="endDate" class="form-control">
                    </div>
                </div>          
                <div class="form-group">
                    <div class="col-sm-9 col-sm-offset-3">
                        <button id="step1Submit" type="submit" class="btn btn-primary btn-block">Register</button>
                    </div>
                </div>
            </form> <!-- /form -->
        </div> <!-- ./container -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<script>
$(document).ready(function() {
	$( "#step1Form" ).submit(function( event ) {
		var practiceId = $('#practiceId').val();
		var departmentId = $('#departmentId').val();
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();

		  alert(startDate);
		  alert(departmentId);
		    getBookedAppointments();

		  event.preventDefault();
		  
		});
});

var authorization = "hyqajh3jeq4enh7gr4h4xws9";

var originatingIP = "162.208.26.229";

var departmentID = 1;

var endDate = "04/30/2017";

var startDate = "01/01/2017"; 





function getBookedAppointments() {

    $("body").css("cursor", "wait");

    $.ajax({            

        type: "GET",            

        url: 'https://api.athenahealth.com/preview1/195900/appointments/booked',

        dataType: 'json',            

        beforeSend: function(xhr){

            xhr.setRequestHeader('ContentType', 'application/x-www-form-urlencoded');

            xhr.setRequestHeader('Authorization', 'Bearer ' + authorization);

            xhr.setRequestHeader('X-Originating-Ip', originatingIP);

        },            

        data: {

            'departmentid': departmentID,

            'enddate': endDate,

            'ignorerestrictions': false,

            'showcancelled': false,

            'showclaimdetail': false,

            'showcopay': true,

            'showinsurance': false,

            'showpatientdetail': false,

            'showremindercalldetail': false,

            'startdate': startDate

        },            

        success: appointmentSuccess,

        failure: logFailure,

        complete: function() {

            $("body").css("cursor", "default");

        }    

    })

}



function appointmentSuccess(response) {

    // showResponse(response);

    var appointments = 

        $.map(response.appointments, function(value) {

            if (value.encounterid != null) {

                return value;

            }

        });



    var filteredAppointments = [];



    $(appointments).each(function(index, value) {

        filteredAppointments.push({

            "appointmentid": value.appointmentid,

            "patientid": value.patientid,

            "encounterid": value.encounterid

        })

    });



    getEncounterOrders(filteredAppointments);



    showResponse(filteredAppointments);

}



function logFailure(error) {

    $("#container").html("<pre>" + JSON.stringify(error, "", 2) + "</pre>");

    console.error(JSON.stringify(error, "", 2));

}



var encounterOrders = [];



function getEncounterOrders(appointments) {

    var currentCount = 0;

    callAPI(appointments, currentCount);

}



function callAPI(appointments, currentCount) {

    var stopCount = appointments.length;

    $.ajax({            

        type: "GET",            

        url: 'https://api.athenahealth.com/preview1/195900/chart/encounter/' + appointments[currentCount].encounterid + "/orders",

        dataType: 'json',            

        beforeSend: function(xhr){

            xhr.setRequestHeader('ContentType', 'application/x-www-form-urlencoded');

            xhr.setRequestHeader('Authorization', 'Bearer ' + authorization);

            xhr.setRequestHeader('X-Originating-Ip', originatingIP);

        },            

        data: {

            "showexternalcodes": true

        },            

        success: function(result) {

            console.log(result);

            ++currentCount;

            $(encounterOrders).add(result);

            if (currentCount = stopCount) {

                appendResponse(encounterOrders);

            } else {

                callAPI(appointments, currentCount);

            }

        },

        failure: logFailure,

        complete: function() {

            $("body").css("cursor", "default");

        }    

    });

}



function showResponse(response) {

    $("#container").html("<pre>" + JSON.stringify(response, "", 2) + "</pre>");

    console.log(JSON.stringify(response, "", 2));

}



function appendResponse(response) {

    $("#container pre").append("<br>" + JSON.stringify(response, "", 2));

    console.log(JSON.stringify(response, "", 2));

}



$(document).ready(function() {

    getBookedAppointments();

});
 

</script>
</body>
</html>

jQuery(function ($) {
    document.getElementById('installmentTable').style.visibility = "hidden";
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var yyyy = today.getFullYear();

    if (dd < 10) {
        dd = '0' + dd
    }

    if (mm < 10) {
        mm = '0' + mm
    }

    today = dd + '/' + mm + '/' + yyyy;
    $('#datepicker').val(today);
    $('#datepicker2').val(today);
    getSchemeDetails();

})(jQuery);
function getSchemeDetails() {

    $.ajax({
        type: "POST",
        url: "webService.asmx/getSchemeList",
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            var select = document.getElementById('scheme');
            $('#scheme').empty().append('<option value="#">&nbsp;</option>');
            $.each(response.d, function (key, value) {

                var option = document.createElement('option');
                option.value = value.SCHEMEID;
                option.text = value.SCHEMEName;
                select.add(option);

            });

        },
        error: function (response) {
            alert('error');
        }
    });

}

function getSchemeDetailOnSelect(schemeid)
{

    var schemeobj = {};
    schemeobj.schemeid = schemeid;

    $.ajax({
        type: "POST",
        url: "webService.asmx/GetSchemeDetailsById",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $('#instamt').val(response.d.InstAmt);
            $('#noofinst').val(response.d.NoOfInst);
        },
        error: function (response) {
            alert('error');
        }

    });
}

function saveSchemeOpening()
{

    var schemeobj = {};
    schemeobj.custid = $('#customerid').val();
    schemeobj.schemeid = $('#scheme').val();
    schemeobj.SCDate = dateformateChange($('#datepicker').val());
    schemeobj.StartDate = dateformateChange($('#datepicker2').val());
    schemeobj.noofinst = $('#noofinst').val();
    schemeobj.instamt = $('#instamt').val();
    schemeobj.remarks = $('#remarks').val();
    


    $.ajax({
        type: "POST",
        url: "webService.asmx/newOpeningScheme",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {

            swal({
                title: "Saved!!",
                type: "success",
                showCancelButton: false,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "OK",
                closeOnConfirm: false
            }, function () {
                window.location.reload();
            });
           
        },
        error: function (response) {
            alert('error');
        }

    });
}

function dateformateChange(date)
{
    var datepart = date.split("/");
    return datepart[2] + "-" + datepart[1] + "-" + datepart[0];
}

function createInstallmentTable()
{
    var i = 0;
    var nextdate = 0;
    var amount = $('#instamt').val();
    var noofinst = $('#noofinst').val();
    var startdate = $('#datepicker2').val();
    document.getElementById('installmentTable').style.visibility = "visible";
    $("#loadinstallmentDatesTable tbody").empty();
    var dateParts = startdate.split("/");
    startdate =  dateParts[0];
    nextdate = dateParts;
    var newDate = $('#datepicker2').val();
    for (i = 1; i <= noofinst; i++)
    {
        if (i > 1)
        {
             newDate = getInstallmentsDates(nextdate, startdate);
            nextdate = newDate.split("/");
        }
        $("#loadinstallmentDatesTable tbody").append("<tr><td>" + i + "</td><td>" + newDate + "</td><td>" + amount + "</td><td>P</td></tr>");
    }
    
}

function getInstallmentsDates(currentDate,selectedDate)
{
   
    var nextDate = 0;

    if (parseInt(currentDate[1]) + 1 === 2) {
        if ((parseInt(currentDate[2])) % 4 === 0)
        {
            if (parseInt(currentDate[0]) > 29) {
                nextDate = 29;
            }
            else {
                nextDate = selectedDate;
            }
        }
        else {
            if (parseInt(currentDate[0]) > 28) {
                nextDate = 28;
            }
            else {
                nextDate = selectedDate;
            }
        }

        
        
        return nextDate + "/" + (parseInt(currentDate[1]) + 1) + "/" + parseInt(currentDate[2]);
    }
    else {
        if (parseInt(currentDate[1]) + 1 === 4 || parseInt(currentDate[1]) + 1 === 6 || parseInt(currentDate[1]) + 1 === 9 || parseInt(currentDate[1]) + 1 === 11) {
            if (parseInt(currentDate[0]) > 30) {
                nextDate = 30;
            }
            else {
                nextDate = selectedDate;
            }
        }
        else {
            nextDate = selectedDate;
        }

       
        if (parseInt(currentDate[1]) === 12) {
            if ((parseInt(currentDate[1]) + 1) === 13) {
                currentDate[1] = 0;
            }
            return nextDate + "/" + (parseInt(currentDate[1]) + 1) + "/" + (parseInt(currentDate[2]) + 1);
        }
        else {
           
            return nextDate + "/" + (parseInt(currentDate[1]) + 1) + "/" + parseInt(currentDate[2]);
        }
    }
   
    
}
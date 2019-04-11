

function getCustomerSchemeClosingInfo(SCNo) {
    var schemeobj = {};
    schemeobj.SCNo = SCNo;

    $.ajax({
        type: "POST",
        url: "webService.asmx/getCustomerSchemeClosingInfo",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $('#schemeno').val(response.d.SCNo);
            $('#totalschemeamt').val(response.d.TotalAmt);
            $('#totalreceivedamt').val(response.d.PaidTotalInstAmt);
            $('#installmentspaid').val(response.d.PaidNoOfInst);
        },
        error: function (response) {
            alert('error');
        }

    });

    return false;
}

function saveSchemeClosingDetails(evt)
{
    if (!$('#closecheckbox').is(':checked')) {
        swal({
            title: "Select Close CheckBox",
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "OK",
            closeOnConfirm: false
        });
        
    } else {

        var schemeobj = {};
        schemeobj.SCNo = $('#scheme').val();
        schemeobj.CustID = $('#customerid').val();;
        schemeobj.ClosedDt = dateformateChange($('#datepicker').val());
        schemeobj.ClosureRmks = $('#closeremarks').val();

        $.ajax({
            type: "POST",
            url: "webService.asmx/saveSchemeClosingDetails",
            data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
            contentType: "application/json",
            dataType: "json",
            success: function (response) {
                swal({
                    title: "Scheme Closed!!",
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
                alert("error");
            }

        });
    }

}

function cleardata()
{
    $('#schemeno').val("");
    $('#totalschemeamt').val("");
    $('#totalreceivedamt').val("");
    $('#installmentspaid').val("");
    $('#customerid').val("");
    $('#customername').val("");
    $('#customercode').val("");
    $('#schemeno').val("");
    $('#datepicker').val("");
    $('#closeremarks').val("");
    document.getElementById('closecheckbox').checked = false;
}

function dateformateChange(date) {
    var datepart = date.split("/");
    return datepart[2] + "-" + datepart[1] + "-" + datepart[0];
}
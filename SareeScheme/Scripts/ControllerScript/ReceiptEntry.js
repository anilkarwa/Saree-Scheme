jQuery(function ($) {


})(jQuery);

function getCustomerReceiptEntryDetails(SCNo)
{
    var schemeobj = {};
    schemeobj.SCNo = SCNo;

   

    $.ajax({
        type: "POST",
        url: "webService.asmx/getCustomerReceiptEntryDetails",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $('#schemecode').val(response.d.SCNo);
            $('#schemename').val(response.d.SchemeName);
            $('#noofinst').val(response.d.NoOfInst);
            $('#instamt').val(response.d.InstAmt);
            $('#totalamount').val(response.d.TotalAmt);
            $('#noofinsttobepaid').val(response.d.PaidNoOfInst);
            $('#totalpaidamount').val(response.d.PaidTotalInstAmt);
            $('#balancenoofinst').val(response.d.balanceNoOfInst);
            $('#balanceamount').val(response.d.balanceAmt);
            getInstallmentOfCustomer(SCNo);
        },
        error: function (response) {
            alert('error');
        }

    });
}

function getInstallmentOfCustomer(SCNo)
{
    var schemeobj = {};
    schemeobj.SCNo = SCNo;

    $('#tblbody').empty();
 
   
    $.ajax({
        type: "POST",
        url: "webService.asmx/getTranscationDetails",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {

            $.each(response.d, function (key, value) {
                if (value.Status === "R") {
                    $("#transcationTable tbody").append('<tr><td><input type="checkbox" name="chkinst[]" value=' + value.InstNo + ' checked></td><td>' + value.InstNo + '</td><td>' + value.InstDate + '</td><td>' + value.InstAmt + '</td><td>' + value.RcptNo + '</td><td>' + value.RcptDate + '</td><td>' + value.Status + '</td></tr>');
                }
                else {
                    $("#transcationTable tbody").append('<tr><td><input type="checkbox" name="chkinst[]" value=' + value.InstNo + '></td><td>' + value.InstNo + '</td><td>' + value.InstDate + '</td><td>' + value.InstAmt + '</td><td>' + value.RcptNo + '</td><td>' + value.RcptDate + '</td><td>' + value.Status + '</td></tr>');
                }
            });
           
        },
        error: function (response) {
            alert('error');
        }

    });
}

function saveNewTranscatonDetails()
{
    var chckValues = new Array();
    $.each($("input[name='chkinst[]']:checked"), function () {
        chckValues.push($(this).val());
    });

    var trnsobj = {};
    trnsobj.CustID = $('#customerid').val();
    trnsobj.SCNo = $('#schemecode').val();
    trnsobj.RcptDate = dateformateChange($('#datepicker').val());
    trnsobj.RcvdAmt = $('#amtreceived').val();
    trnsobj.PaymentMode = $('#paymentmode').val();
    trnsobj.Remarks = $('#remarks').val();
    trnsobj.TrnsInstIds = chckValues;

    $.ajax({
        type: "POST",
        url: "webService.asmx/saveTranscationDetails",
        data: '{trnsobj: ' + JSON.stringify(trnsobj) + '}',
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
            alert("error");
        }

    });

  
}

function dateformateChange(date) {
    var datepart = date.split("/");
    return datepart[2] + "-" + datepart[1] + "-" + datepart[0];
}
jQuery(function ($) {

    getSchemeList();

})(jQuery);

function getSchemeList()
{
    $.ajax({
        type: "POST",
        url: "webService.asmx/getSchemeList",
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $('#con-close-modal').modal("hide");
            var table = $("#datatable-buttons").DataTable();
            table.clear().draw();
            $.each(response.d, function (key, value) {
                
                table.row.add($('<tr><td>' + value.SCHEMEName + '</td><td>' + value.InstAmt + '</td><td>' + value.NoOfInst + '</td><td>' + value.Rmks + '</td><td class="actions"> <a href="#" onclick="getSchemeById(this.id);" id=' + value.SCHEMEID + ' class="on-default edit-row" data-toggle="modal" data-target="#con-close-modal"><i class="fa fa-pencil"></i></a><a href="javascript:deleteScheme(' + value.SCHEMEID + ');" id=' + value.SCHEMEID + ' class="on-default remove-row"><i class="fa fa-trash-o"></i></a></td></tr>')).draw(false);
            });

        },
        error: function (response) {
            alert('error');
        }

    });
}

function saveNewScheme()
{
    var schemeobj = {};
    schemeobj.schemename = $('#scheme_name').val();
    schemeobj.instamt = $('#scheme_installment_amount').val();
    schemeobj.noofinst = $('#scheme_installment_number').val();
    schemeobj.rmks = $('#scheme_remarks').val();

    $.ajax({
        type: "POST",
        url: "webService.asmx/saveNewScheme",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $.Notification.autoHideNotify('success', 'bottom right', 'Scheme Created!!', 'Loading fresh data, Please wait....')
            getSchemeList();
        },
        error: function (response) {
            $.Notification.autoHideNotify('error', 'bottom right', 'Error Creating Scheme ', 'Try Aagin...')
        }

    });
}

function updateSchemeDetails()
{
    var schemeobj = {};
    schemeobj.schemeid = $('#editscheme_id').val();
    schemeobj.schemename = $('#editscheme_name').val();
    schemeobj.instamt = $('#editscheme_installment_amount').val();
    schemeobj.noofinst = $('#editscheme_installment_number').val();
    schemeobj.rmks = $('#editscheme_remarks').val();
    schemeobj.inactive = $('#editscheme_status').val();

    $.ajax({
        type: "POST",
        url: "webService.asmx/updateSchemeDetails",
        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $.Notification.autoHideNotify('success', 'bottom right', 'Scheme Updated!!', 'Loading fresh data, Please wait....')
            getSchemeList();

        },
        error: function (response) {
            $.Notification.autoHideNotify('error', 'bottom right', 'Error Saving  Details', 'Try Aagin...')
        }

    });
}
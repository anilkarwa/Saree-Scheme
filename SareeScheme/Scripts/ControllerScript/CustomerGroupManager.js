jQuery(function ($) {

    getGroupList();

})(jQuery);


function saveNewCustomerGroup()
{
    var groupobj = {};
  
    groupobj.custgroupname = $('#group_name').val();
    groupobj.custgroupcode = $('#group_code').val();


    $.ajax({
        type: "POST",
        url: "webService.asmx/saveNewCustomerGroup",
        data: '{groupobj: ' + JSON.stringify(groupobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $.Notification.autoHideNotify('success', 'bottom right', 'Group Updated!!', 'Loading fresh data, Please wait....')
            getGroupList();

        },
        error: function (response) {
            $.Notification.autoHideNotify('error', 'bottom right', 'Error Saving  Details', 'Try Aagin...')
        }

    });
}

function getGroupList() {
    $.ajax({
        type: "POST",
        url: "webService.asmx/getCustomerGroupList",
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $('#con-close-modal').modal("hide");
            var table = $("#datatable-buttons").DataTable();
            table.clear().draw();
            $.each(response.d, function (key, value) {

                table.row.add($('<tr><td>' + value.CustGroupID + '</td><td>' + value.CustGroupCode + '</td><td>' + value.CustGroupName + '</td><td class="actions"> <a href="#" onclick="getGroupById(this.id);" id=' + value.CustGroupID + ' class="on-default edit-row" data-toggle="modal" data-target="#con-close-modal"><i class="fa fa-pencil"></i></a><a href="javascript:deleteCustomerGroup(' + value.CustGroupID + ');" id=' + value.CustGroupID + ' class="on-default remove-row"><i class="fa fa-trash-o"></i></a></td></tr>')).draw(false);
            });

        },
        error: function (response) {
            alert('error');
        }

    });
}

function updateCustomerGroupDetails() {
    var groupobj = {};
    groupobj.custgroupid = $('#editgroup_id').val();
    groupobj.custgroupname = $('#editgroup_name').val();
    groupobj.custgroupcode = $('#editgroup_code').val();
   

    $.ajax({
        type: "POST",
        url: "webService.asmx/updateCustomerGroupDetails",
        data: '{groupobj: ' + JSON.stringify(groupobj) + '}',
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $.Notification.autoHideNotify('success', 'bottom right', 'Group Updated!!', 'Loading fresh data, Please wait....')
            getGroupList();

        },
        error: function (response) {
            $.Notification.autoHideNotify('error', 'bottom right', 'Error Saving  Details', 'Try Aagin...')
        }

    });
}
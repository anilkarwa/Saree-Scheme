jQuery(function ($) {

    getCustomerList();
    
})(jQuery);
function saveNewCustomer()
{
    var c_name = $('#c_name').val();
    var c_phone = $('#c_phone').val();
    var get_c_group = document.getElementById('c_group');
    var c_group = get_c_group.options[get_c_group.selectedIndex].value;
    var c_address1 = $('#c_addressline1').val();
    var c_address2 = $('#c_addressline2').val();
    var c_address3 = $('#c_addressline3').val();
    var c_address4 = $('#c_addressline4').val();
    var c_gst = $('#c_gst').val();
    var c_remarks = $('#c_remarks').val();
   
     
   
    var newCustomerData = new FormData();

    newCustomerData.append('c_name' ,c_name);
    newCustomerData.append('c_phone' ,c_phone);
    newCustomerData.append('c_group' ,c_group);
    newCustomerData.append('c_address1' ,c_address1);
    newCustomerData.append('c_address2' ,c_address2);
    newCustomerData.append('c_address3' ,c_address3);
    newCustomerData.append('c_address4' ,c_address4);
    newCustomerData.append('c_gst' ,c_gst);
    newCustomerData.append('c_remarks' ,c_remarks);
    newCustomerData.append('c_profile', $('#c_profile')[0].files[0]);

   

    $.ajax({
        type: "POST",
        url: "webService.asmx/newCustomerSave",
        data: newCustomerData,
        contentType: false,
        processData: false,
        success: function (response) {
            $.Notification.autoHideNotify('success', 'bottom right', 'Customer Added!!', 'Loading fresh data, Please wait....')
            getCustomerList();
           
        }
    });
}


function updateCustomer() {

    var c_number = $('#editc_number').val();
    var c_name = $('#editc_name').val();
    var c_phone = $('#editc_phone').val();
    var get_c_group = document.getElementById('editc_group');
    var c_group = get_c_group.options[get_c_group.selectedIndex].value;
    var c_address1 = $('#editc_addressline1').val();
    var c_address2 = $('#editc_addressline2').val();
    var c_address3 = $('#editc_addressline3').val();
    var c_address4 = $('#editc_addressline4').val();
    var c_gst = $('#editc_gst').val();
    var c_remarks = $('#editc_remarks').val();


    var newCustomerData = new FormData();
    newCustomerData.append('c_number', c_number);
    newCustomerData.append('c_name', c_name);
    newCustomerData.append('c_phone', c_phone);
    newCustomerData.append('c_group', c_group);
    newCustomerData.append('c_address1', c_address1);
    newCustomerData.append('c_address2', c_address2);
    newCustomerData.append('c_address3', c_address3);
    newCustomerData.append('c_address4', c_address4);
    newCustomerData.append('c_gst', c_gst);
    newCustomerData.append('c_remarks', c_remarks);
    newCustomerData.append('c_profile', $('#editc_profile')[0].files[0]);

    $.ajax({
        type: "POST",
        url: "webService.asmx/updateCustomer",
        data: newCustomerData,
        contentType: false,
        processData: false,
        success: function (response) {
            $.Notification.autoHideNotify('success', 'bottom right', 'Customer Details Saved!!', 'Loading fresh data, Please wait....')
            getCustomerList();
        },
        error: function (response) {
            $.Notification.autoHideNotify('error', 'bottom right', 'Error Saving Customer Details', 'Try Aagin...')
        }
    });
    
}


function getCustomerList()
{

    $.ajax({
        type: "POST",
        url: "webService.asmx/GetAllCustomerDetails",
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            $('#con-close-modal').modal("hide");
            getCustomerGroup();
            var table = $("#datatable-buttons").DataTable();
            table.clear().draw();
            $.each(response.d, function (key, value) {
                table.row.add($('<tr> <td><img src="Uploads/Images/'+value.CustProfileImg+'" class="img-circle" alt="User Image" width="50" height="50"> </td><td>' + value.CustCode + '</td><td>' + value.CustName + '</td><td>' + value.PHNO + '</td><td>' + value.CustGroupName + '</td><td class="actions"> <a href="#" onclick="editCustomer(this.id); return false;" id=' + value.CustID + ' class="on-default edit-row" data-toggle="modal" data-target="#con-close-modal"><i class="fa fa-pencil"></i></a><a href="javascript:deleteCustomer(' + value.CustID + ');" id=' + value.CustID + ' class="on-default remove-row"><i class="fa fa-trash-o"></i></a></td></tr>')).draw(false);
                
              });
           
        },
        error: function (response) {
            alert('error');
        }

    });

}

function getCustomerGroup()
{
    $.ajax({
        type: "POST",
        url: "webService.asmx/getCustomerGroup",
        contentType: "application/json",
        dataType: "json",
        success: function (response) {
            var select = document.getElementById('editc_group');
            $('#editc_group').empty().append('<option value="">&nbsp;</option>');

            var select2 = document.getElementById('c_group');
            $('#c_group').empty().append('<option value="">&nbsp;</option>');
            $.each(response.d, function (key, value) {

                var option = document.createElement('option');
                option.value = value.CustGroupID;
                option.text = value.CustGroupName;
                select.add(option);

                var option2 = document.createElement('option');
                option2.value = value.CustGroupID;
                option2.text = value.CustGroupName;
                select2.add(option2);
            });

        },
        error: function (response) {
            alert('error');
        }

    });
}







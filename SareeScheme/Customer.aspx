
<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="SareeScheme.Customer" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Plugins css -->
<link href="assets/plugins/notifications/notification.css" rel="stylesheet">
 <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
 <link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
<script src="Scripts/ControllerScript/Customer.js"></script>
 <script src="Scripts/jquery-1.10.2.js"></script>
    <script>
        function deleteCustomer(id)
        {

            swal({
                title: "Are you sure?",
                text: "You will not be able to recover the customer!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, delete it!",
                cancelButtonText: "No, cancel plx!",
                closeOnConfirm: false,
                closeOnCancel: false
            }, function (isConfirm) {
                if (isConfirm) {

                    var userobj = {};
                    userobj.CustID = id;

                    $.ajax({
                        type: "POST",
                        url: "webService.asmx/deleteCustomer",
                        data: '{userobj: ' + JSON.stringify(userobj) + '}',
                        contentType: "application/json",
                        dataType: "json",
                        success: function (response) {
                            swal("Deleted!", "Customer has been removed.", "success");
                            getCustomerList()
                        },
                        error: function (response) {
                            alert('error');
                        }

                    });
                    
                } else {
                    swal("Cancelled", "Your customer is safe :)", "error");
                }
            });
        }

        function editCustomer(custid)
        {
            var userobj = {};
            userobj.custid = custid;
            $.ajax({
                type: "POST",
                url: "webService.asmx/GetCustomerDetailsById",
                data: '{userobj: ' + JSON.stringify(userobj) + '}',
                contentType: "application/json",
                dataType: "json",
                success: function (response) {
                    $('#editc_number').val(response.d.CustCode);
                    $('#editc_name').val(response.d.CustName);
                    $('#editc_phone').val(response.d.PHNO);
                    $('#editc_addressline1').val(response.d.BAdd1);
                    $('#editc_addressline2').val(response.d.BAdd2);
                    $('#editc_addressline3').val(response.d.BAdd3);
                    $('#editc_addressline4').val(response.d.BAdd4);
                    $('#editc_gst').val(response.d.GSTNO);
                    $('#editc_remarks').val(response.d.Remarks);
                    document.getElementById('editc_group').value = response.d.CustGroupID;

                },
                error: function (response) {
                    alert('error');
                }

            });
        }

        $(document).ready(function () {

            if (Session.get("Session_User") === '' || Session.get("Session_User") === undefined) {

                window.location = 'Login.aspx';
                return false;
            } 

            $("#c_profile").change(function () {

                previewImage(this);
            });

            function previewImage(input) {

               

                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    if (!input.files[0].type.match('image.*')) {
                        alert('Please upload only image file !!');
                        $('#c_profile').val('');
                        return false;
                    }


                    if (input.files[0].size > 3000000) {
                        alert('Image size should be less in 3 MB');
                        $('#c_profile').val('');
                        return false;
                    }
                    reader.onload = function (e) {
                        $('#previewimage0').attr('src', e.target.result);
                        $('#previewimage0').attr('width', '150');
                        $('#previewimage0').attr('height', '120');
                    }

                    reader.readAsDataURL(input.files[0]);
                }
            }

        });

    </script>
<div class="row">
        <!-- Basic example -->
        <div class="col-md-4">
            <div class="panel panel-default">
                <div class="panel-heading"><h3 class="panel-title">New Customer</h3></div>
                <div class="panel-body">
                    <form role="form" id="newcustomer" method="post" onsubmit="saveNewCustomer(); return false;" enctype="multipart/form-data">
                        
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Name*</label>
                            <input type="text" class="form-control" name="c_name" id="c_name"  placeholder="Enter customer name" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Phone*</label>
                            <input type="tel" class="form-control" name="c_phone" id="c_phone"  placeholder="Enter customer phone number" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Group*</label>
                            <select name="c_group" id="c_group" required="required" class="select2 form-control" data-placeholder="Choose a Country...">
                            <option value=" ">&nbsp;</option>
                           
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Address Line 1*</label>
                            <input type="text" class="form-control"  name="c_addressline1" id="c_addressline1" placeholder="Address Line 1" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Address Line 2</label>
                            <input type="text" class="form-control" name="c_addressline2" id="c_addressline2" placeholder="Address Line 2">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Address Line 3</label>
                            <input type="text" class="form-control" name="c_addressline3" id="c_addressline3" placeholder="Address Line 3">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer Address Line 4</label>
                            <input type="text" class="form-control" name="c_addressline4" id="c_addressline4"  placeholder="Address Line 4">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Customer GST No</label>
                            <input type="text" class="form-control" name="c_gst" id="c_gst"  placeholder="Enter customer name">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Remarks</label>
                                <textarea class="form-control" name="c_remarks" id="c_remarks" rows="2"></textarea>
                        </div>
                            <div class="form-group">
                            <label for="exampleInputEmail1">Customer Image</label>
                            <input type="file" class="form-control" name="c_profile" id="c_profile" >
                        </div>
                         <img id="previewimage0" src="" />
                            <button type="submit" class="btn btn-success waves-effect waves-light m-l-10 pull-right" >Save Customer</button>
                    </form>
                </div><!-- panel-body -->
            </div> <!-- panel -->
        </div> <!-- col-->
           
        <div class="col-md-8">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Customer List</h3>
                </div>
                <div class="panel-body" id="customerlisttable">
                    <table id="datatable-buttons" class="table table-striped table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>Photo</th>
                                <th>Customer Numer</th>
                                <th>Name</th>
                                <th>Phone</th>
                                <th>Group</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                         <tbody>
      
                         </tbody>
                    </table>

                </div>
            </div>
        </div>

    </div> <!-- End Row -->

    <!-- Edit Customer Model -->
      <div id="con-close-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none">
            <div class="modal-dialog"> 
                <div class="modal-content"> 
                    <div class="modal-header"> 
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button> 
                        <h4 class="modal-title">Edit Customer</h4> 
                    </div> 
                    <form role="form" id="editcustomer"  method="post" onsubmit="updateCustomer(); return false;" enctype="multipart/form-data">
                    <div class="modal-body"> 
                          
                        <div class="row"> 
                          <input type="hidden" name="editc_number" id="editc_number"/>
                            <div class="col-md-6"> 
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Customer Name*</label>
                                    <input type="text" class="form-control" name="editc_name" id="editc_name"  placeholder="Enter customer name" required="required">
                                </div>
                            </div> 
                        </div> 
                        <div class="row"> 
                            <div class="col-md-6"> 
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Customer Phone*</label>
                                    <input type="tel" class="form-control" name="editc_phone" id="editc_phone"  placeholder="Enter customer phone number" required="required">
                                </div>
                            </div> 
                            <div class="col-md-6"> 
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Customer Group*</label>
                                    <select name="editc_group" id="editc_group" class="select2 form-control" data-placeholder="Choose a Country..."  required>
                                    <option value="">&nbsp;</option>
                                    </select>
                                </div>
                            </div>
                        </div> 
                        <div class="row"> 
                            <div class="col-md-12"> 
                                <div class="form-group">
                                <label for="exampleInputEmail1">Customer Address Line 1*</label>
                                <input type="text" class="form-control" name="editc_addressline1" id="editc_addressline1"  placeholder="Address Line 1" required="required">
                            </div> 
                            </div> 
                                                            
                        </div> 

                            <div class="row"> 
                            <div class="col-md-12"> 
                                <div class="form-group">
                                <label for="exampleInputEmail1">Customer Address Line 2</label>
                                <input type="text" class="form-control" name="editc_addressline2" id="editc_addressline2" placeholder="Address Line 2" >
                            </div> 
                            </div> 
                                                            
                        </div> 
                            <div class="row"> 
                            <div class="col-md-12"> 
                                <div class="form-group">
                                <label for="exampleInputEmail1">Customer Address Line 3</label>
                                <input type="text" class="form-control" name="editc_addressline3" id="editc_addressline3" placeholder="Address Line 3" >
                            </div> 
                            </div> 
                                                            
                        </div> 
                            <div class="row"> 
                            <div class="col-md-12"> 
                                <div class="form-group">
                                <label for="exampleInputEmail1">Customer Address Line 4</label>
                                <input type="text" class="form-control" name="editc_addressline4" id="editc_addressline4" placeholder="Address Line 4" >
                            </div> 
                            </div> 
                                                            
                        </div> 

                        <div class="row"> 
                            <div class="col-md-6"> 
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Customer GST No</label>
                                    <input type="text" class="form-control" name="editc_gst" id="editc_gst"  placeholder="Enter customer name">
                                </div>
                            </div> 
                            <div class="col-md-6"> 
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Remarks</label>
                                        <textarea class="form-control" name="editc_remarks" id="editc_remarks"  rows="2"></textarea>
                                </div>
                            </div> 
                        </div> 

                        <div class="row">

                            <div class="col-md-12">

                                <div class="form-group">
                                    <label for="exampleInputEmail1">Customer Image</label>
                                    <input type="file" class="form-control" name="editc_profile" id="editc_profile" >
                                </div>

                            </div>

                        </div>

                    </div> 
                    <div class="modal-footer"> 
                        <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button> 
                        <button type="submit" class="btn btn-info waves-effect waves-light pull-right">Save changes</button> 
                    </div> 
                    </form>
                </div> 
            </div>
        </div><!-- /.modal -->


    
        <script src="assets/plugins/notifyjs/dist/notify.min.js"></script>
        <script src="assets/plugins/notifications/notify-metro.js"></script>
        <script src="assets/plugins/notifications/notifications.js"></script>

   
</asp:Content>

<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerGroupManager.aspx.cs" Inherits="SareeScheme.CustomerGroupManager" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="assets/plugins/notifications/notification.css" rel="stylesheet">
     <link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
 <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="Scripts/ControllerScript/CustomerGroupManager.js"></script>
<script>
    $(document).ready(function () {
        if (Session.get("Session_User") === '' || Session.get("Session_User") === undefined) {

            window.location = 'Login.aspx';
            return false;
        }
    });

        function deleteCustomerGroup(id)
        {
            swal({
                title: "Are you sure?",
                text: "You are going to delete this group!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, delete it!",
                cancelButtonText: "No, cancel plx!",
                closeOnConfirm: false,
                closeOnCancel: false
            }, function (isConfirm) {
                if (isConfirm) {

                    var groupobj = {};
                    groupobj.custgroupid = id;

                    $.ajax({
                        type: "POST",
                        url: "webService.asmx/deleteCustomerGroup",
                        data: '{groupobj: ' + JSON.stringify(groupobj) + '}',
                        contentType: "application/json",
                        dataType: "json",
                        success: function (response) {
                            swal("Deleted!", "Group has been removed.", "success");
                            getSchemeList()
                        },
                        error: function (response) {
                            alert('error');
                        }

                    });
                } else {
                    swal("Cancelled", "Your imaginary file is safe :)", "error");
                }
            });
        }

    function getGroupById(sid)
    {
        var groupobj = {};
        groupobj.CustGroupID = sid;
        $.ajax({
            type: "POST",
            url: "webService.asmx/getCustomerGroupById",
            data: '{groupobj: ' + JSON.stringify(groupobj) + '}',
            contentType: "application/json",
            dataType: "json",
            success: function (response) {
                $('#editgroup_id').val(response.d.CustGroupID);
                $('#editgroup_name').val(response.d.CustGroupName);
                $('#editgroup_code').val(response.d.CustGroupCode);

            },
            error: function (response) {
                alert('error');
            }

        });
    }
</script>

     <div class="row">

          <div class="col-md-4">
            <div class="panel panel-default">
                <div class="panel-heading"><h3 class="panel-title">New Customer Group</h3></div>
                <div class="panel-body">
                    <form role="form" id="newscheme" method="post" onsubmit="saveNewCustomerGroup();return false;">
                        <div class="form-group">
                            <label for="exampleInputEmail1">Group Code *</label>
                            <input type="text" class="form-control"  name="group_code" id="group_code" placeholder="Group Code" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Group Name *</label>
                            <input type="text" class="form-control"  name="group_name" id="group_name" placeholder="Group Name"  required="required">
                        </div>
                    
                            <button type="submit" class="btn btn-success waves-effect waves-light m-l-10" >Save</button>
                    </form>
                </div><!-- panel-body -->
            </div> <!-- panel -->
        </div> <!-- col-->

            <div class="col-md-8">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Groups</h3>
                    </div>
                    <div class="panel-body">

                        <table id="datatable-buttons" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Group ID</th>
                                    <th>Group Code</th>
                                    <th>Group Name</th>
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



     <!-- Edit Scheme Model -->
      <div id="con-close-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none">
            <div class="modal-dialog"> 
                <div class="modal-content"> 
                    <div class="modal-header"> 
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button> 
                        <h4 class="modal-title">Edit Group</h4> 
                    </div> 
                    <form role="form" id="updatescheme"  onsubmit="updateCustomerGroupDetails();return false;" method="post">
                    <div class="modal-body"> 
                        <div class="row"> 
                         <input type="hidden" name="editgroup_id" id="editscheme_id" />
                        <div class="form-group">
                            <label for="exampleInputEmail1">Group Code *</label>
                            <input type="text" class="form-control"  name="group_code" id="editgroup_code" placeholder="Group Code" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Group Name *</label>
                            <input type="text" class="form-control"  name="group_name" id="editgroup_name" placeholder="Group Name"  required="required">
                        </div>     
                 
                        </div>

                    </div> 
                    <div class="modal-footer"> 
                        <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button> 
                        <button type="submit" class="btn btn-info waves-effect waves-light">Save changes</button> 
                    </div>
                  </form>
                </div> 
            </div>
        </div><!-- /.modal -->

   
    
        <script src="assets/plugins/notifyjs/dist/notify.min.js"></script>
        <script src="assets/plugins/notifications/notify-metro.js"></script>
        <script src="assets/plugins/notifications/notifications.js"></script>
</asp:Content>

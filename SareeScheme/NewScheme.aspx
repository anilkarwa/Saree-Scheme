<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewScheme.aspx.cs" Inherits="SareeScheme.NewScheme" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="assets/plugins/notifications/notification.css" rel="stylesheet">
     <link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
 <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="Scripts/ControllerScript/Scheme.js"></script>
<script>
    $(document).ready(function () {
        if (Session.get("Session_User") === '' || Session.get("Session_User") === undefined) {

            window.location = 'Login.aspx';
            return false;
        }
    });


        function deleteScheme(id)
        {
            swal({
                title: "Are you sure?",
                text: "You will not be able to recover this imaginary file!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, delete it!",
                cancelButtonText: "No, cancel plx!",
                closeOnConfirm: false,
                closeOnCancel: false
            }, function (isConfirm) {
                if (isConfirm) {

                    var schemeobj = {};
                    schemeobj.SCHEMEID = id;

                    $.ajax({
                        type: "POST",
                        url: "webService.asmx/deleteScheme",
                        data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
                        contentType: "application/json",
                        dataType: "json",
                        success: function (response) {
                            swal("Deleted!", "Scheme has been removed.", "success");
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

    function getSchemeById(sid)
    {
        var schemeobj = {};
        schemeobj.schemeid = sid;
        $.ajax({
            type: "POST",
            url: "webService.asmx/GetSchemeDetailsById",
            data: '{schemeobj: ' + JSON.stringify(schemeobj) + '}',
            contentType: "application/json",
            dataType: "json",
            success: function (response) {
                $('#editscheme_id').val(response.d.SCHEMEID);
                $('#editscheme_name').val(response.d.SCHEMEName);
                $('#editscheme_installment_amount').val(response.d.InstAmt);
                $('#editscheme_installment_number').val(response.d.NoOfInst);
                $('#editscheme_remarks').val(response.d.Rmks);
                document.getElementById('editscheme_status').value = response.d.InActive;

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
                <div class="panel-heading"><h3 class="panel-title">New Scheme</h3></div>
                <div class="panel-body">
                    <form role="form" id="newscheme" method="post" onsubmit="saveNewScheme();return false;">
                        <div class="form-group">
                            <label for="exampleInputEmail1">Scheme Name</label>
                            <input type="text" class="form-control"  name="scheme_name" id="scheme_name" placeholder="Scheme Name" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Installment Amount</label>
                            <input type="number" class="form-control"  name="scheme_installment_amount" id="scheme_installment_amount"  required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Number of installments</label>
                            <input type="number" class="form-control" name="scheme_installment_number" id="scheme_installment_number"  required="required">
                        </div>
                       
                        <div class="form-group">
                            <label for="exampleInputEmail1">Remarks</label>
                                <textarea class="form-control" name="scheme_remarks" id="scheme_remarks" rows="2" ></textarea>
                      </div>
                            <button type="submit" class="btn btn-success waves-effect waves-light m-l-10" >Save</button>
                    </form>
                </div><!-- panel-body -->
            </div> <!-- panel -->
        </div> <!-- col-->

            <div class="col-md-8">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Schemes</h3>
                    </div>
                    <div class="panel-body">

                        <table id="datatable-buttons" class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Scheme Name</th>
                                    <th>Installment Amount</th>
                                    <th>Number of Installments</th>
                                    <th>Remarks</th>
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
                        <h4 class="modal-title">Edit Scheme</h4> 
                    </div> 
                    <form role="form" id="updatescheme"  onsubmit="updateSchemeDetails();return false;" method="post">
                    <div class="modal-body"> 
                        <div class="row"> 
                         <input type="hidden" name="editscheme_id" id="editscheme_id" />
                        <div class="form-group">
                            <label for="exampleInputEmail1">Scheme Name</label>
                            <input type="text" class="form-control"  name="editscheme_name" id="editscheme_name" placeholder="Scheme Name" required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Installment Amount</label>
                            <input type="number" class="form-control"  name="editscheme_installment_amount" id="editscheme_installment_amount"  required="required">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Number of installments</label>
                            <input type="number" class="form-control" name="editscheme_installment_number" id="editscheme_installment_number"  required="required">
                        </div>
                       
                        <div class="form-group">
                            <label for="exampleInputEmail1">Remarks</label>
                                <textarea class="form-control" name="editscheme_remarks" id="editscheme_remarks" rows="2" ></textarea>
                      </div>
                       <div class="form-group">
                            <label for="exampleInputEmail1">Scheme Status</label>
                            <select name="editscheme_status" id="editscheme_status" required="required" class="select2 form-control" data-placeholder="Choose Status..">
                            <option value="#">&nbsp;</option>
                            <option value="N">Enable</option>
                            <option value="Y">Disable</option>
                            </select>
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
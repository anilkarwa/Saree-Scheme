<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SchemeOpening.aspx.cs" Inherits="SareeScheme.NewScheme" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
 <link href="assets/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css" rel="stylesheet">
<link href="assets/css/jquery-ui.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="Scripts/ControllerScript/SchemeOpening.js"></script>
<script src="Scripts/jquery-1.10.2.js"></script>
<script src="Scripts/jquery-ui-1.10.3.js"></script>


    <script>
        $(document).ready(function () {
            if (Session.get("Session_User") === '' || Session.get("Session_User") === undefined) {

                window.location = 'Login.aspx';
                return false;
            }
        });
    </script>


    <!-- Wizard with Validation -->
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-default">
                <div class="panel-heading"> 
                    <h3 class="panel-title">Scheme Opening</h3> 
                </div> 
                <div class="panel-body"> 
                  <form id="wizard-validation-form" onsubmit="saveSchemeOpening();">
                        <div>

                            <h3>Step 1</h3>

                            <section>
                                <input type="hidden" name="customerid" id="customerid" />
                                 <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="userName">Opening Date *</label>
                                    <div class="col-lg-6  input-group">
                                         <input type="text" class="form-control" placeholder="dd/mm/yyyy" name="receiveddate" id="datepicker" required="required" >
                                        <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                    </div>
                                </div>
                                <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="userName">Customer Name *</label>
                                    <div class="col-lg-6">
                                        <input class="form-control required" id="customername" name="customername" type="text" placeholder="Type to search customer..." required="required">
                                    </div>
                                </div>
                                <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="password"> Customer Code *</label>
                                    <div class="col-lg-6">
                                        <input id="customercode" name="customercode" type="text" class="required form-control" required="required">

                                    </div>
                                </div>
                                <div class="form-group clearfix">
                                    <label class="col-lg-12 control-label">(*) Mandatory</label>
                                </div>
                            </section>
                            <h3>Step 2</h3>
                            <section>

                                <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="name2"> Scheme *</label>
                                    <div class="col-lg-6">
                                       <select name="scheme" id="scheme" required="required" class="select2 form-control" onchange="getSchemeDetailOnSelect(this.value);">
                                       <option value="#">&nbsp;</option>
                           
                                       </select>
                                    </div>
                                </div>
                                <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="surname2"> Installment Amount *</label>
                                    <div class="col-lg-6">
                                        <input id="instamt" name="instamt" type="text" class="required form-control">

                                    </div>
                                </div>

                                <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="surname2">No of Installment *</label>
                                    <div class="col-lg-6">
                                        <input id="noofinst" name="noofinst" type="text" class="required form-control">

                                    </div>
                                </div>

                                <div class="form-group clearfix">
                                    <label class="col-lg-12 control-label">(*) Mandatory</label>
                                </div>

                            </section>
                           
                            <h3>Step Final</h3>
                            <section>
                                <div class="form-group clearfix">
                                    <div class="col-lg-12">
                                         <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="surname2"> Installment Start Date *</label>
                                    <div class="col-lg-6">
                                        <div class="input-group">
                                          <input type="text" class="form-control" placeholder="dd/mm/yyyy" name="startdate" id="datepicker2" required="required" >
                                          <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                      </div>

                                    </div>
                                </div>

                                <div class="form-group clearfix">
                                    <label class="col-lg-2 control-label" for="email2">Remarks *</label>
                                    <div class="col-lg-6">
                                        <textarea id="remarks" name="remarks" class="form-control"></textarea>
                                    </div>
                                </div>
                                   <button type="button" class="btn btn-primary waves-effect waves-light m-b-5  col-xs-4 col-md-2 col-md-push-3 "  onclick="createInstallmentTable();"> <span>Load Installments</span> <i class="fa fa-plane"></i> </button> 

                                    </div>
                                </div>

                            </section>
                        </div>
                    </form>
                </div>  <!-- End panel-body -->
            </div> <!-- End panel -->
            <div id="installmentTable">
            <table class="table table-hover" id="loadinstallmentDatesTable" >
                            <thead>
                                <tr>
                                    <th>SL No</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                
                            </tbody>
                        </table>
            </div>
        </div> <!-- end col -->

    </div> <!-- End row -->

    <script>
    $(function () {
    var loadcontact = {
        minLength: 2,
        source: function (request, response) {
            $.ajax({

                url: 'webService.asmx/getCustomerByName',
                data: '{term: ' + JSON.stringify(request.term) + '}',
                method: 'POST',
                contentType: "application/json",
                dataType: "json",
                success: function (data) {
                    response($.map(data.d, function (item) {
                        return {label:item.CustName, id: item.CustCode, code: item.CustID}
                    }))                 
                }
            });

        },
        select: function (event, ui) {
            $(this).val(ui.item.label);
            $('#customercode').val(ui.item.id);
            $('#customerid').val(ui.item.code);
        }
    };
    $('#customername').autocomplete(loadcontact);
 });
</script>             

 
   <!--Form Wizard-->
        <script src="assets/plugins/jquery.steps/build/jquery.steps.min.js" type="text/javascript"></script>
        <script type="text/javascript" src="assets/plugins/jquery-validation/dist/jquery.validate.min.js"></script>

        <!--wizard initialization-->
        <script src="assets/pages/jquery.wizard-init.js" type="text/javascript"></script>	
    
        <!-- Sweet-Alert  -->
        <script src="assets/plugins/sweetalert/dist/sweetalert.min.js"></script>
     
</asp:Content>
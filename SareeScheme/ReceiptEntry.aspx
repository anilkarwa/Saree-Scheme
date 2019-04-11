<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReceiptEntry.aspx.cs" Inherits="SareeScheme.NewScheme" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
<link href="assets/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css" rel="stylesheet">
<link href="assets/css/jquery-ui.css" rel="stylesheet" type="text/css">
<script src="Scripts/ControllerScript/ReceiptEntry.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
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

        <!-- Page-Title -->
    

          <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default panel-border">
                    <div class="panel-heading"> 
                        <h3 class="panel-title">Customer</h3> 
                    </div> 
                  <div class="panel-body"> 
                                 <input type="hidden" id="customerid" name="customerid" />
                                <div class="form-group ">
                                    <label class="col-lg-2 control-label" for="userName">Customer Name *</label>
                                    <div class="col-lg-3">
                                        <input class="form-control required" id="customername" name="customername" type="text" required="required" placeholder="Type to search customer..">
                                    </div>
                                </div>
                                <div class="form-group ">
                                    <label class="col-lg-2 control-label" for="password"> Customer Code *</label>
                                    <div class="col-lg-4">
                                        <input id="customercode" name="customercode" type="text" class="required form-control" required="required" disabled="disabled">

                                    </div>
                                </div>
                               <div class="form-group ">
                                    <label class="col-lg-2 control-label" for="name2"> Scheme *</label>
                                    <div class="col-lg-4">
                                       <select name="scheme" id="scheme" required="required" class="select2 form-control" onchange="getCustomerReceiptEntryDetails(this.value); return false;">
                                       <option value="#">&nbsp;</option>
                           
                                       </select>
                                    </div>
                                </div>

                                <div class="form-group ">
                                    <label class="col-lg-3 control-label" for="password"> Scheme Code *</label>
                                    <div class="col-lg-4">
                                        <input id="schemecode" name="schemecode" type="text" class="required form-control" required="required" disabled="disabled">

                                    </div>
                                </div>

                            </div>  
                        </div>
                    </div>
            
        </div>
        <!-- end row -->


         <div class="row">

            <div class="col-lg-5">
                <div class="panel panel-default panel-border">
                    <div class="panel-heading"> 
                        <h3 class="panel-title">Installments</h3> 
                    </div> 
                    <div class="panel-body"> 
                       <table class="table table-hover" id="transcationTable" style="text-align:center;">
                            <thead>
                                <tr>
                                    <th>Select</th>
                                    <th>Inst No</th>
                                    <th>Inst Date</th>
                                    <th>Inst Amt</th>
                                    <th>Rcpt No</th>
                                    <th>Rcpt Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="tblbody">
                               
                            </tbody>
                        </table>
                    </div> 
                </div>
            </div>


            <div class="col-lg-4">
                <div class="panel panel-border panel-primary">
                    <div class="panel-heading"> 
                        <h3 class="panel-title">Current Payment</h3> 
                    </div> 
                     <form role="form" id="newcustomer"  method="post" onsubmit="saveNewTranscatonDetails();return false;">
                    <div class="panel-body"> 
                       
                         <div class="form-row">
                            <div class="form-group col-md-6">
                              <label for="inputEmail4">Amount Received *</label>
                              <input type="text" class="form-control" name="amtreceived"  id="amtreceived" placeholder="Amount" required="required" >
                            </div>
                            <div class="form-group col-md-6">
                              <label for="inputPassword4">Date *</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="mm/dd/yyyy" name="receiveddate" id="datepicker" required="required" >
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
                                </div><!-- input-group -->
                            </div>
                          </div>
                         
                          <div class="form-row">
                            <div class="form-group col-md-6">
                            <label for="inputCity">Remarks</label>
                            <textarea class="form-control" rows="2" name="remarks" id="remarks" ></textarea>
                           </div>
                            <div class="form-group col-md-6">
                              <label for="inputState">Payment Mode *</label>
                              <select name="paymentmode" id="paymentmode" class="form-control" required="required">
                                <option ></option>
                                <option>Walkin</option>
                                <option>NEFT</option>
                              </select>
                            </div>

                          </div>
                          <button type="submit"  class="btn btn-primary waves-effect waves-light btn-md m-b-5  pull-right ">Save Installment</button> 
                         
                        </div>  
                      </form>
                    </div> 
                </div>
          


            <div class="col-lg-3">
                <div class="panel panel-border panel-success">
                    <div class="panel-heading"> 
                        <h3 class="panel-title">Scheme</h3> 
                    </div> 
                    <div class="panel-body"> 
                         <div class="form-group clearfix">
                            <label class="col-lg-5 control-label" for="userName">Scheme Name :</label>
                            <div class="col-lg-6">
                                <input class="form-control required" id="schemename" name="schemename" type="text" disabled="disabled">
                            </div>
                        </div>
                        <div class="form-group clearfix">
                            <label class="col-lg-5 control-label" for="userName">No Of Inst :</label>
                            <div class="col-lg-5">
                                <input class="form-control required" id="noofinst" name="noofinst" type="text" disabled="disabled">
                            </div>
                        </div>
                        <div class="form-group clearfix">
                            <label class="col-lg-5 control-label" for="userName">Inst Amount :</label>
                            <div class="col-lg-5">
                                <input class="form-control required" id="instamt" name="instamt" type="text" disabled="disabled">
                            </div>
                        </div>
                         <div class="form-group clearfix">
                            <label class="col-lg-5 control-label" for="userName">Total Amount :</label>
                            <div class="col-lg-5">
                                <input class="form-control required" id="totalamount" name="totalamount" type="text" disabled="disabled">
                            </div>
                        </div>
                    </div> 
                </div>
            </div>



              <div class="col-lg-4">
                <div class="panel panel-border panel-info">
                    <div class="panel-heading"> 
                        <h3 class="panel-title">Paid Info</h3> 
                    </div> 
                    <div class="panel-body"> 
                        <div class="form-group clearfix">
                            <label class="col-lg-4 control-label" for="userName">No of Installments :</label>
                            <div class="col-lg-6">
                                <input class="form-control required" id="noofinsttobepaid" name="noofinsttobepaid" type="text" disabled="disabled">
                            </div>
                        </div>
                        <div class="form-group clearfix">
                            <label class="col-lg-4 control-label" for="userName">Total Paid :</label>
                            <div class="col-lg-6">
                                <input class="form-control required" id="totalpaidamount" name="totalpaidamount" type="text" disabled="disabled">
                            </div>
                        </div>
                       
                    </div> 
                </div>
            </div>


            <div class="col-lg-3">
                <div class="panel panel-border panel-warning">
                    <div class="panel-heading"> 
                        <h3 class="panel-title">Balance Info</h3> 
                    </div> 
                    <div class="panel-body"> 
                       <div class="form-group clearfix">
                            <label class="col-lg-5 control-label" for="userName">Balance Installments :</label>
                            <div class="col-lg-6">
                                <input class="form-control required" id="balancenoofinst" name="balancenoofinst" type="text" disabled="disabled">
                            </div>
                        </div>
                        <div class="form-group clearfix">
                            <label class="col-lg-5 control-label" for="userName">Balance Amount :</label>
                            <div class="col-lg-6">
                                <input class="form-control required" id="balanceamount" name="balanceamount" type="text" disabled="disabled">
                            </div>
                        </div>
                    </div> 
                </div>
            </div>


          
        </div>
                        <!-- end row -->

                    

     
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
                            return { label: item.CustName, id: item.CustCode, code: item.CustID }
                        }))
                    }
                });

            },
            select: function (event, ui) {
                $(this).val(ui.item.label);
                $('#customercode').val(ui.item.id);
                $('#customerid').val(ui.item.code);
                var userobj = {};
                 userobj.custid = ui.item.code;

                $.ajax({

                    url: 'webService.asmx/getCustomerSchemesById',
                    data: '{userobj: ' + JSON.stringify(userobj) + '}',
                    method: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        var select = document.getElementById('scheme');
                        $('#scheme').empty().append('<option value="#">&nbsp;</option>');

                        $.each(response.d, function (key, value) {

                            var option = document.createElement('option');
                            option.value = value.SCNo;
                            option.text = value.SchemeName;
                            select.add(option);
                            
                        });
                    }
                });

            }
        };
        $('#customername').autocomplete(loadcontact);
    });
</script>  


<!-- Sweet-Alert  -->
<script src="assets/plugins/sweetalert/dist/sweetalert.min.js"></script>


</asp:Content>
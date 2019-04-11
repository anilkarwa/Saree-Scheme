<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClosureEntry.aspx.cs" Inherits="SareeScheme.NewScheme" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
<link href="assets/css/jquery-ui.css" rel="stylesheet" type="text/css">
<script src="Scripts/ControllerScript/ClosingEntry.js"></script>
 <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
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

<form id="closingform" role="form" method="Post" onsubmit="saveSchemeClosingDetails(); return false;">
<div class="row">
<div class="col-lg-4">
 <input type="hidden" id="customerid" name="customerid" />
<div class="form-group">
<label for="exampleInputEmail1">Customer Name</label>
<input type="text" class="form-control"  name="customername" id="customername" placeholder="Type to search customer...">
</div>
<div class="form-group">
    <label for="exampleInputPassword1">Customer Code</label>
    <input type="text" class="form-control" name="customercode" id="customercode" disabled="disabled">
</div>
<div class="form-group ">
  <label for="exampleInputPassword1">Scheme *</label>

    <select name="scheme" id="scheme" required="required" class="select2 form-control" onchange="getCustomerSchemeClosingInfo(this.value);">
    <option value="#">&nbsp;</option>                           
    </select>
</div>

<div class="form-group">
    <label for="exampleInputPassword1">Scheme No</label>
    <input type="text" class="form-control" id="schemeno" name="schemeno" disabled="disabled">
</div>
    <div class="form-group">
<label for="exampleInputEmail1">Total Scheme Amont</label>
<input type="email" class="form-control" id="totalschemeamt" name="totalschemeamt" disabled="disabled">
</div>
<div class="form-group">
    <label for="exampleInputPassword1">Total Received Amount</label>
    <input type="text" class="form-control" id="totalreceivedamt" name="totalschemeamt" disabled="disabled">
</div>


    <div class="form-group">
        <label for="exampleInputEmail1">Installments Paid</label>
        <input type="text" class="form-control" id="installmentspaid" name="installmentspaid" disabled="disabled">
    </div>

<div class="form-group">
    <div class="checkbox checkbox-primary">
        <input id="closecheckbox" type="checkbox" name="closecheckbox">
        <label for="checkbox1">
            Close 
        </label>
    </div>
    </div>
    <div class="form-group">
     <label for="exampleInputPassword1">Close Remarks</label>
     <textarea class="form-control" id="closeremarks" name="closeremarks" placeholder="Closure Remarks"></textarea>
    </div>
     <div class="form-group">
     <label for="exampleInputPassword1">Closed on Date *</label>
     <div class="input-group">
        <input type="text" class="form-control" placeholder="mm/dd/yyyy" id="datepicker" required="required">
        <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
    </div>
    </div>
    <button type="submit" class="btn btn-primary waves-effect waves-light pull-right">Submit</button>


   </div>
</div>
</form>

<script>

    $(document).ready(function () {
        cleardata();
    });

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
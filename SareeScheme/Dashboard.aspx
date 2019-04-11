
<%@ Page  Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SareeScheme.Dashboard" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

 <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
 <script src="Scripts/ControllerScript/SessionFile.js"></script>
<link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
    <script>

        $(document).ready(function () {
            if (Session.get("Session_User") === '' || Session.get("Session_User") === undefined) {
               
                window.location = 'Login.aspx';
                return false;
            } 


            $.ajax({
                type: "POST",
                url: "webService.asmx/getStatistics",
                contentType: "application/json",
                dataType: "json",
                success: function (response) {

                    $('#totalschemes').append('  <span class="counter text-dark" >' + response.d.TotalSchemes + '</span>');
                    $('#runningschemes').append('  <span class="counter text-dark" >' + response.d.RunningSchemes + '</span>');
                    $('#opennedschemes').append('  <span class="counter text-dark" >' + response.d.SchemeThisMonth + '</span>');
                    $('#totalcustomer').append('  <span class="counter text-dark" >' + response.d.TotalCustomer + '</span>');

                },
                error: function (response) {
                    alert('error');
                }

            });

            //Pending installment customer list for current month
            $.ajax({
                type: "POST",
                url: "webService.asmx/currentMonthPendingInstCustomer",
                contentType: "application/json",
                dataType: "json",
                success: function (response) {
                    var size = response.d.length;
                    for ( var i=0; i < size; i++)
                   {
                    $('#customerlistInst').append(' <div class="col-sm-6 col-lg-3"><div class="panel"> <div class="panel-body"> <div class="media-main"> <a class="pull-left" href=""><img class="thumb-lg img-circle" src="Uploads/Images/' + response.d[0].CustProfileImg + '" alt=""></a><div class="info"><h4>' + response.d[0].CustName + '</h4><p class="text-muted">Phone - ' + response.d[0].PHNO + '</p></div></div><div class="clearfix"></div><hr><ul class="social-links list-inline"> <li>Installment Date - ' + response.d[0].InstDate+'</li></ul></div> </div> </div> ');

                    }
                },
                error: function (response) {
                    alert('error');
                }

            });


        });

    </script>
    
                      
     <!-- Start Widget -->
                        <!--Widget-4 -->
                        <div class="row">
                            <div class="col-sm-6 col-lg-3">
                                <div class="mini-stat clearfix bx-shadow bg-white">
                                    <span class="mini-stat-icon bg-info"><i class="ion-social-usd"></i></span>
                                    <div class="mini-stat-info text-right text-dark" id="totalschemes">
                                       
                                        Total Schemes
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="mini-stat clearfix bx-shadow bg-white">
                                    <span class="mini-stat-icon bg-purple"><i class="ion-ios7-cart"></i></span>
                                    <div class="mini-stat-info text-right text-dark" id="opennedschemes">

                                       Scheme Openned this month
                                    </div>
                                   
                                </div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="mini-stat clearfix bx-shadow bg-white">
                                    <span class="mini-stat-icon bg-success"><i class="ion-android-contacts"></i></span>
                                    <div class="mini-stat-info text-right text-dark" id="runningschemes">
                                       
                                        Running Schemes
                                    </div>
                                   
                                </div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="mini-stat clearfix bx-shadow bg-white">
                                    <span class="mini-stat-icon bg-primary"><i class="ion-eye"></i></span>
                                    <div class="mini-stat-info text-right text-dark" id="totalcustomer">
                                        
                                        Total Customer
                                    </div>
                                    
                                </div>
                            </div>
                        </div> <!-- End row-->

                       

                    <div class="container">

                        <!-- Page-Title -->
                        <div class="row">
                            <div class="col-sm-12">
                                <h4 class="pull-left page-title">Pending Installments this month</h4>
                               
                            </div>
                        </div>


                        <div class="row" id="customerlistInst">
                            
                            
                        </div> <!-- End row -->

                      
                    </div> <!-- container -->
                               

    
   
</asp:Content>
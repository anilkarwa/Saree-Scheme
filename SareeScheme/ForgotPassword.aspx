<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="SareeScheme.ForgotPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css" />
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet">
    <link rel='stylesheet prefetch' href='https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900' />
    <link rel='stylesheet prefetch' href='https://fonts.googleapis.com/icon?family=Material+Icons' />
     <link href="assets/plugins/sweetalert/dist/sweetalert.css" rel="stylesheet" type="text/css">
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <link href="assets/css/style.css" rel="stylesheet" />
    <link href="assets/css/style2.css" rel="stylesheet" />
    <style>
   
    </style>
</head>
<body>

    <div class="row" style="margin-top:10%;" id="signIndiv">

        <div class="col-lg-5" style="padding-left:50%">
            <div class="signin">
                <div class="form-title">ForgotPassword</div>
                <div class="input-field">
                    <input type="text" id="email" autocomplete="off" required="required" />
                    <i class="material-icons">phone_iphone</i>
                    <label for="email" id="loginEmail">Mobile Number</label>
                </div>
                <button id="btnotpsend" class="login">Submit</button>
                <div class="check">
                    <i class="material-icons">check</i>
                </div>
            </div>
        </div>
    </div>

    <div class="row" style="margin-top:6%;" id="registerdiv" hidden="hidden">
        <div class="col-lg-5" style="padding-left:50%">
            <div id="registration">
        <div class="form-title">OTP</div>

        <div class="input-field">
            <input type="text" id="rPassword" />
            <i class="material-icons">lock</i>
            <label for="rPassword" id="lrPassword">Enter OTP</label>
        </div>
        <button onclick="PostotpData()" class="login">Submit</button>
        <div class="check">
            <i class="material-icons">check</i>
        </div>
    </div>
        </div>
    </div>

     
    



    <script src="assets/js/jquery-2.2.4.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/index.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-sweetalert/1.0.1/sweetalert.js"></script>
    <script type="text/javascript">
        var otp = 0;
        var userid = 0;
        $(function () {
            $("[id*=btnotpsend]").bind("click", function () {

                var otpobj = {};
                otpobj.mobile = $("[id*=email]").val();
                
                if (otpobj.mobile === "" || otpobj.mobile.len < 10) {
                    document.getElementById("loginEmail").style.color = "red";
                    swal({
                        title: "Invalid Number",
                        text: "Enter 10 digit mobile number",
                        imageUrl: 'assets/images/sadEmoji.gif'
                    });
                    return false;
                }
                
                $.ajax({
                    type: "POST",
                    url: "webService.asmx/sendOTP",
                    data: '{otpobj: ' + JSON.stringify(otpobj) + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        otp = response.d.otpcode;
                        userid = response.d.userid;
                        if (userid > 0)
                        {
                            RegistrationForm();
                        }
                        else {
                            swal({
                                title: "User Not Found",
                                text: "No user found with this number",
                                imageUrl: 'assets/images/sadEmoji.gif'
                            });
                            return false;
                        }
                        
                    }
                });
                return false;
            });
        });
        function RegistrationForm() {
            var x = document.getElementById("registerdiv");
            var y = document.getElementById("signIndiv");
          
            if (y.style.display === "none") {
                x.style.display = "none";
                y.style.display = "block";
              
            } else {
                x.style.display = "block";
                y.style.display = "none";
            }
        }

        function PostotpData() {
            var userotp = $("[id*=rPassword]").val();
          
            if (userotp == "" || userotp.len < 5) {
                document.getElementById("lrPassword").style.color = "red";
                swal({
                    title: "Invalid OTP",
                    text: "OTP should be of 5 digit",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            
            if (userotp === otp) {
                $(this).animate({
                    fontSize: 0
                }, 300, function () {
                    $(".check").addClass('in');
                });
                $(this).animate({
                    fontSize: 0
                }, 1500, function () {
                    $(".check").removeClass('in');
                    RegistrationForm();
                });
                $("[id*=rPassword]").val("");
                $("[id*=email]").val("");
            } else {
                swal({
                    title: "Invalid OTP",
                    text: "OTP should be of 5 digit",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
        }
    </script>
</body>
</html>



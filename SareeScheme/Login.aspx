<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SareeScheme.Ligin" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css" />
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet" />
    <link rel='stylesheet prefetch' href='https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900' />
    <link rel='stylesheet prefetch' href='https://fonts.googleapis.com/icon?family=Material+Icons' />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-sweetalert/1.0.1/sweetalert.css" />
    <script src="Scripts/ControllerScript/SessionFile.js"></script>
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <link href="assets/css/style.css" rel="stylesheet" />
    <link href="assets/css/style2.css" rel="stylesheet" />
    <script src="Scripts/json-serialization.js"></script>
    <script src="Scripts/session.js"></script>

</head>
<body>

    <div class="row" style="margin-top:10%;" id="signIndiv">
        <div class="col-lg-5" style="padding-left:50%">
            <div class="signin">
                <div class="form-title">Sign in</div>
                <div class="input-field">
                    <input type="text" id="email" autocomplete="off" required="required" />
                    <i class="material-icons">phone_iphone</i>
                    <label for="email" id="loginEmail">Email/Mobile Number</label>
                </div>
                <div class="input-field">
                    <input type="password" id="password" />
                    <i class="material-icons">lock</i>
                    <label for="password" id="loginPassword">Password</label>
                </div>
               
                <a onclick="RegistrationForm();" class="forgot-pw" style="cursor: pointer;">Registration</a>
                  <a href="ForgotPassword.aspx" class="forgot-pw" style="cursor: pointer;">Forgot Password?</a>
                <button id="btnlogin" class="login">Login</button>
                <div class="check">
                    <i class="material-icons">check</i>
                </div>
            </div>
        </div>
    </div>

    <div class="row" style="margin-top:6%;" id="registerdiv" hidden="hidden">
        <div class="col-lg-5" style="padding-left:50%">
            <div id="registration">
        <div class="form-title">Registration</div>
        <div class="input-field">
            <input type="text" id="rName" autocomplete="off" />
            <i class="material-icons">person</i>
            <label for="rName" id="lrName">Name</label>
        </div>
        <div class="input-field">
            <input type="text" id="rMobile" autocomplete="off" />
            <i class="material-icons">phone_iphone</i>
            <label for="rMobile" id="lrMobile">Phone</label>
        </div>
        <div class="input-field">
            <input type="text" id="rEmail" autocomplete="off" />
            <i class="material-icons">email</i>
            <label for="rEmail" id="lrEmail">Email</label>
        </div>
        <div class="input-field">
            <input type="password" id="rPassword" />
            <i class="material-icons">lock</i>
            <label for="rPassword" id="lrPassword">Password</label>
        </div>
        <a onclick="RegistrationForm();" class="forgot-pw" style="cursor: pointer;">Login</a>
        <button onclick="PostRegisterData()" class="login">Register</button>
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
        $(function () {
            $("[id*=btnlogin]").bind("click", function () {

                var user = {};
                user.mobile = $("[id*=email]").val();
                user.password = $("[id*=password]").val();

                if (user.mobile === "" || user.password === "") {
                    document.getElementById("loginEmail").style.color = "red";
                    document.getElementById("loginPassword").style.color = "red";
                    swal({
                        title: "Enter Credentials!",
                        text: "Enter your login credentials to sign in",
                        imageUrl: 'assets/images/sadEmoji.gif'
                    });
                    return false;
                }
                
                $.ajax({
                    type: "POST",
                    url: "webService.asmx/ValidateUser",
                    data: '{user: ' + JSON.stringify(user) + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                      
                        if (response.d == 'valid') {

                            Session.set("Session_User", 'true');
                            $(this).animate({
                                fontSize: 0
                            }, 300, function () {
                                $(".check").addClass('in');
                            });
                            $(this).animate({
                                fontSize: 0
                            }, 1500, function () {
                                $(".check").removeClass('in');
                                window.location = "Dashboard.aspx";
                            }); 
                        } else {
                            swal({
                                title: "Invalid Credentials!",
                                text: "Enter your Valid login credentials to sign in",
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

        function PostRegisterData() {
            var user = {};
            user.name = $("[id*=rName]").val();
            user.email = $("[id*=rEmail]").val();
            user.mobile = $("[id*=rMobile]").val();
            user.password = $("[id*=rPassword]").val();
            if (user.name == "") {
                document.getElementById("lrName").style.color = "red";
                swal({
                    title: "Enter Name!",
                    text: "Please Enter your Name to Register",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            
            if (user.mobile == "") {
                document.getElementById("lrMobile").style.color = "red";
                swal({
                    title: "Enter Mobile Number!",
                    text: "Please Enter your Mobile Number to Register",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            if (!user.mobile.match(/^\d{10}$/)) {
                document.getElementById("lrMobile").style.color = "red";
                swal({
                    title: "Enter Valid Mobile Number!",
                    text: "Enter enter 10 digit mobile number without country code",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            if (user.email == "") {
                document.getElementById("lrEmail").style.color = "red";
                swal({
                    title: "Enter Email ID!",
                    text: "Please Enter your Email Id to Register",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(user.email)) {
            } else {
                document.getElementById("lrEmail").style.color = "red";
                swal({
                    title: "Enter Valid Email ID!",
                    text: "Enter check your email before registration",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            if (user.password == "") {
                document.getElementById("lrPassword").style.color = "red";
                swal({
                    title: "Enter Password!",
                    text: "Please Enter your Password Register",
                    imageUrl: 'assets/images/sadEmoji.gif'
                });
                return false;
            }
            $.ajax({
                type: "POST",
                url: "webService.asmx/RegisterUser",
                data: '{user: ' + JSON.stringify(user) + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    alert(response.d);
                    if (response.d == 'valid') {
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
                    } else {
                        swal({
                            title: "Facing some issue!",
                            text: "Try after some time",
                            imageUrl: 'assets/images/sadEmoji.gif'
                        });
                        return false;
                    }
                }
            });
            return false;
        }
    </script>
</body>
</html>


using SareeScheme.BusinessLogic;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Xml;

namespace SareeScheme
{
    /// <summary>
    /// Summary description for webService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class webService : System.Web.Services.WebService
    {

        string smsgatewayurl = "http://trans.profuseservices.com/sendsms.jsp?";
        string smsgatewayUser = "user=ganesh";
        string smsgatewayPassword = "password=ganesh";
        string smsgatewaySendid = "senderid=BGUBGU";
        string connectionString = ConfigurationManager.ConnectionStrings["DBConStr"].ConnectionString;
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        [WebMethod]
        public Statistics getStatistics()
        {
            var stats = new Statistics();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select Count(*) as TotalSchemes ,( select Count(*) from TrnHdrSC  as ss where ss.SCStatus='N') as RunningSchemes,(select Count(*) from TrnHdrSC as sss where sss.SCDate between DATEADD(dd,0,DATEADD(mm,DATEDIFF(mm,0,GetDate()),0)) and DATEADD(dd,-1,DATEADD(mm,DATEDIFF(mm,0,GetDate())+1,0)) ) as SchemeThisMonth,(select count(*) from MstCust ) as TotalCustomer from TrnHdrSC as s", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                stats.TotalSchemes = rdr.GetInt32(0);
                stats.RunningSchemes = rdr.GetInt32(1);
                stats.SchemeThisMonth = rdr.GetInt32(2);
                stats.TotalCustomer = rdr.GetInt32(3);
            }
            connection.Close();

            return stats;
        }

        [WebMethod]
        public string changeConnectionString(ServerDetails serverobj)
        {
            var IsValid = "false";

            bool isNew = false;
            string path = Server.MapPath("~/Web.Config");
            XmlDocument doc = new XmlDocument();
            doc.Load(path);
            XmlNodeList list = doc.DocumentElement.SelectNodes(string.Format("connectionStrings/add[@name='{0}']", "DBConStr"));
            XmlNode node;
            isNew = list.Count == 0;
            if (isNew)
            {
                node = doc.CreateNode(XmlNodeType.Element, "add", null);
                XmlAttribute attribute = doc.CreateAttribute("name");
                attribute.Value = "DBConStr";
                node.Attributes.Append(attribute);

                attribute = doc.CreateAttribute("connectionString");
                attribute.Value = "";
                node.Attributes.Append(attribute);

                attribute = doc.CreateAttribute("providerName");
                attribute.Value = "System.Data.SqlClient";
                node.Attributes.Append(attribute);
            }
            else
            {
                node = list[0];
            }
            string conString = node.Attributes["connectionString"].Value;
            SqlConnectionStringBuilder conStringBuilder = new SqlConnectionStringBuilder(conString);
            conStringBuilder.InitialCatalog = serverobj.database;
            conStringBuilder.DataSource = serverobj.servername;
            conStringBuilder.IntegratedSecurity = false;
            conStringBuilder.UserID = serverobj.username;
            conStringBuilder.Password = serverobj.password;
            conStringBuilder.MaxPoolSize = 99;
            conStringBuilder.ConnectTimeout = 10000000;
            node.Attributes["connectionString"].Value = conStringBuilder.ConnectionString;
            if (isNew)
            {
                doc.DocumentElement.SelectNodes("connectionStrings")[0].AppendChild(node);
            }
            doc.Save(path);
           
            // string connectionstring = "data source = "+ serverobj.servername + "; Initial Catalog = "+ serverobj.database+ "; User ID ="+ serverobj.username + "; Password = "+ serverobj.password + "; Max Pool Size = 99; Connection Timeout = 1000000";

            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                
                
                connection.Open();
                IsValid = "true";
                
            }
            catch(SqlException ex)
            {
                IsValid ="false";
            }
            finally
            {
                connection.Close();
            }
            return IsValid;
        }

        [WebMethod]
        public UserInformation newCustomerSave()
        {

            var customerid = new UserInformation();
            
            string c_name = HttpContext.Current.Request.Form.Get("c_name");
            string c_phone = HttpContext.Current.Request.Form.Get("c_phone");
            string c_group = HttpContext.Current.Request.Form.Get("c_group");
            string c_address1 = HttpContext.Current.Request.Form.Get("c_address1");
            string c_address2 = HttpContext.Current.Request.Form.Get("c_address2");
            string c_address3 = HttpContext.Current.Request.Form.Get("c_address3");
            string c_address4 = HttpContext.Current.Request.Form.Get("c_address4");
            string c_gst = HttpContext.Current.Request.Form.Get("c_gst");
            string c_remarks = HttpContext.Current.Request.Form.Get("c_remarks");
            string profileimgname = "";
            int curid = 0,tempcurcode=0;
            string tempcuscode = null,curcode= null;
            HttpPostedFile profileimg = HttpContext.Current.Request.Files["c_profile"];

            if (profileimg != null && profileimg.ContentLength > 0)
            {
                profileimgname = Path.GetFileName(profileimg.FileName);
                profileimg.SaveAs(Server.MapPath(Path.Combine("~/Uploads/Images", profileimgname)));
            }
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select Top 1 * from MstCust order by CustID DESC",connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                curid = rdr.GetInt32(0) + 1;
                tempcuscode = rdr.GetString(1);
                tempcurcode = int.Parse(tempcuscode) + 1;
                curcode = tempcurcode.ToString("D6");
            }
            connection.Close();
            customerid.CustID = curid;
            SqlCommand command = connection.CreateCommand();
            try
            {
                connection.Open();
                command.CommandText = ("insert into MstCust (CustID,CustCode,CustName,TallyAlias,CurID,CustGroupId,InActive,Remarks,BAdd1,BAdd2,BAdd3,BAdd4,BlnCreditLimit,CreditLimit,CRLmtWrng,BillWiseTrack,AllowAddressChange,LOADDEFAULT,GSTNO,CustCodePfx,CustNo,PHNO) " +
                    " values('" + curid + "','" + curcode + "','" + c_name+"','-', 1,'"+c_group+"','N','"+c_remarks+"','"+c_address1+ "','" + c_address2 + "','" + c_address3 + "','" + c_address4 + "','N',0,'N','N','N','N','"+c_gst+"',0,'"+curid+"','"+c_phone+"') ");
                command.ExecuteNonQuery();

            }
            finally
            {
                connection.Close();
            }

            //Save profileImage in database
            SqlCommand command2 = connection.CreateCommand();
            try
            {
                connection.Open();
                command2.CommandText = ("insert into MstCustFileUploads (CustID,CustProfileImg)  values('" + curid + "','"+ profileimgname + "') ");
                command2.ExecuteNonQuery();

            }
            finally
            {
                connection.Close();
            }

            return customerid ;

        }
        [WebMethod]
        public String updateCustomer()
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";
            string custid = HttpContext.Current.Request.Form.Get("c_number");
            string c_name = HttpContext.Current.Request.Form.Get("c_name");
            string c_phone = HttpContext.Current.Request.Form.Get("c_phone");
            string c_group = HttpContext.Current.Request.Form.Get("c_group");
            string c_address1 = HttpContext.Current.Request.Form.Get("c_address1");
            string c_address2 = HttpContext.Current.Request.Form.Get("c_address2");
            string c_address3 = HttpContext.Current.Request.Form.Get("c_address3");
            string c_address4 = HttpContext.Current.Request.Form.Get("c_address4");
            string c_gst = HttpContext.Current.Request.Form.Get("c_gst");
            string c_remarks = HttpContext.Current.Request.Form.Get("c_remarks");
            string profileimgname = "";

            HttpPostedFile profileimg = HttpContext.Current.Request.Files["c_profile"];

            if (profileimg != null && profileimg.ContentLength > 0)
            {
                profileimgname = Path.GetFileName(profileimg.FileName);
                profileimg.SaveAs(Server.MapPath(Path.Combine("~/Uploads/Images", profileimgname)));
            }
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstCust set CustName=@CustName,PHNO=@PHNO,CustGroupID=@CustGroupID,BAdd1=@BAdd1,BAdd2=@BAdd2,BAdd3=@BAdd3,BAdd4=@BAdd4,GSTNO=@GSTNO,Remarks=@Remarks where CustID=@CustID", connection);
                command.Parameters.AddWithValue("@CustName",c_name );
                command.Parameters.AddWithValue("@PHNO", c_phone);
                command.Parameters.AddWithValue("@CustGroupID", c_group);
                command.Parameters.AddWithValue("@BAdd1", c_address1);
                command.Parameters.AddWithValue("@BAdd2", c_address2);
                command.Parameters.AddWithValue("@BAdd3", c_address3);
                command.Parameters.AddWithValue("@BAdd4", c_address4);
                command.Parameters.AddWithValue("@GSTNO", c_gst);
                command.Parameters.AddWithValue("@Remarks", c_remarks);
                command.Parameters.AddWithValue("@CustID", custid);

                command.ExecuteNonQuery();

            }
            catch(SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }
             //Update profile Image of customer
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstCustFileUploads set CustProfileImg=@CustProfileImg where CustID=@CustID", connection);
                command.Parameters.AddWithValue("@CustProfileImg", profileimgname);
                command.Parameters.AddWithValue("@CustID", custid);

                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }


            return IsValidate;

        }

        [WebMethod]
        public string deleteCustomer(UserInformation userobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";


            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstCust set InActive='Y' where CustID=@CustID ", connection);
                command.Parameters.AddWithValue("@CustID", userobj.CustID);

                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }


        [WebMethod]
        public List<UserInformation> GetAllCustomerDetails()
        {
            var userlist = new List<UserInformation>();
          
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select c.*,ci.CustProfileImg,g.CustGroupName from MstCustGroup as g, MstCust as c left join MstCustFileUploads as ci on c.CustID =ci.CustID  where c.CustID > 0 and   c.CustGroupID =g.CustGroupID and c.InActive='N'", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new UserInformation();
                userdata.CustID = rdr.GetInt32(0);
                userdata.CustCode = rdr.GetString(1);
                userdata.CustName = rdr.GetString(2);
                userdata.CustGroupID = rdr.GetInt32(5);
                userdata.InAcitve = rdr.GetString(6);
                userdata.Remarks = rdr.GetString(7);
                userdata.BAdd1 = rdr.GetString(8);
                userdata.BAdd2 = rdr.GetString(9);
                userdata.BAdd3 = rdr.GetString(10);
                userdata.BAdd4 = rdr.GetString(11);
                userdata.GSTNO = rdr.GetString(19);
                userdata.PHNO = rdr.GetString(22);
                if (!rdr.IsDBNull(rdr.GetOrdinal("CustProfileImg"))) { userdata.CustProfileImg = rdr.GetString(23); } else { userdata.CustProfileImg = ""; }
                userdata.CustGroupName = rdr.GetString(24);
                userlist.Add(userdata);
            }

            connection.Close();

           return userlist;
            
        }

        [WebMethod]
        public UserInformation GetCustomerDetailsById(UserInformation userobj)
        {
            var userdata = new UserInformation();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select c.*,ci.CustProfileImg,g.CustGroupName from MstCustGroup as g, MstCust as c left join MstCustFileUploads as ci on c.CustID =ci.CustID  where c.CustID =@customerid and c.CustGroupID =g.CustGroupID ", connection);
            readcommand.Parameters.AddWithValue("@customerid", userobj.CustID);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                userdata.CustID = rdr.GetInt32(0);
                userdata.CustCode = rdr.GetString(1);
                userdata.CustName = rdr.GetString(2);
                userdata.CustGroupID = rdr.GetInt32(5);
                userdata.InAcitve = rdr.GetString(6);
                userdata.Remarks = rdr.GetString(7);
                userdata.BAdd1 = rdr.GetString(8);
                userdata.BAdd2 = rdr.GetString(9);
                userdata.BAdd3 = rdr.GetString(10);
                userdata.BAdd4 = rdr.GetString(11);
                userdata.GSTNO = rdr.GetString(19);
                userdata.PHNO = rdr.GetString(22);
                if (!rdr.IsDBNull(rdr.GetOrdinal("CustProfileImg"))) { userdata.CustProfileImg = rdr.GetString(23); } else { userdata.CustProfileImg = ""; }
                userdata.CustGroupName = rdr.GetString(24);
            }

            connection.Close();
            
            return userdata;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public List<UserInformation> getCustomerByName(string term)
        {
            var userlist = new List<UserInformation>();
           

            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select * from MstCust  where CustName like '%"+term+"%'", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                 var userdata = new UserInformation();
                 userdata.CustID = rdr.GetInt32(0);
                 userdata.CustCode = rdr.GetString(1);
                 userdata.CustName = rdr.GetString(2);
                 userlist.Add(userdata);
            
            }

            connection.Close();

            return userlist ;

        }

        [WebMethod]

        public List<UserInformation> getCustomerGroup()
        {
            var userlist = new List<UserInformation>();

            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select * from MstCustGroup where CustGroupID>0", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new UserInformation();
                userdata.CustGroupID = rdr.GetInt32(0);
                userdata.CustGroupName = rdr.GetString(1);
                userlist.Add(userdata);
            }

            connection.Close();

            return userlist;

        }

        [WebMethod]

        public ReceiptEntryInformation getCustomerReceiptEntryDetails(SchemeOpeningInfo schemeobj)
        {
            var receiptdata = new ReceiptEntryInformation();

            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand readcommand = new SqlCommand("select s.SCNo,se.SCHEMEName,s.NoOfInst,s.InstAmt,(s.NoOfInst * s.InstAmt) as totalamt, COUNT(r.SCNo) as paidNoOfInst,SUM(r.RcvdInstAmt) as paidInstAmt,(s.NoOfInst - COUNT(r.SCNo)) as balanceNoOfInst,((s.NoOfInst * s.InstAmt) - SUM(r.RcvdInstAmt)) as balanceAmt from MstSCHEME as se, TrnHdrSC as s left join TrnDtlRcpt as r on r.SCNo = s.SCNo where s.SCNo = @SCNo  and s.SchemeID=se.SCHEMEID group by  r.SCNo,s.SCNo,s.NoOfInst,s.InstAmt,se.SCHEMEName", connection);
                readcommand.Parameters.AddWithValue("@SCNo", schemeobj.SCNo);
                SqlDataReader rdr = readcommand.ExecuteReader();
                if (rdr.Read())
                {
                    receiptdata.SCNo = rdr.GetString(0);
                    receiptdata.SchemeName = rdr["SCHEMEName"].ToString();
                    receiptdata.InstAmt = rdr.GetDecimal(3);
                    receiptdata.NoOfInst = int.Parse(rdr["NoOfInst"].ToString());
                    receiptdata.TotalAmt = rdr.GetDecimal(4);
                    receiptdata.PaidNoOfInst = int.Parse(rdr["paidNoOfInst"].ToString());
                    receiptdata.PaidTotalInstAmt = rdr.GetDecimal(6);
                    receiptdata.balanceNoOfInst = int.Parse(rdr["balanceNoOfInst"].ToString());
                    receiptdata.balanceAmt = rdr.GetDecimal(8);
                }

            }
            catch (SqlException ex)
            {
               
            }
            finally
            {
                connection.Close();
            }

            return receiptdata;
        }
        

        [WebMethod]
        public List<TranscationDetailInfo> getTranscationDetails(SchemeOpeningInfo schemeobj)
        {
            var trndata = new List<TranscationDetailInfo>();


            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();

            SqlCommand readcommand = new SqlCommand("select * from TrndtlSC where SCNO=@SCNo", connection);
            readcommand.Parameters.AddWithValue("@SCNo", schemeobj.SCNo);
         
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new TranscationDetailInfo();
                userdata.SCNo = rdr.GetString(0);
                userdata.InstNo = rdr.GetInt32(1);
                userdata.InstDate = rdr.GetDateTime(2).ToString("dd/MM/yyyy");
                userdata.InstAmt = rdr.GetDecimal(3);
                userdata.RcptNo = rdr.GetString(4);
                if (!rdr.IsDBNull(rdr.GetOrdinal("RcptDate"))) { userdata.RcptDate = rdr.GetDateTime(5).ToString("dd/MM/yyyy"); } else { userdata.RcptDate = ""; }
                userdata.Status = rdr.GetString(6);
                trndata.Add(userdata);
            }

            connection.Close();
            
            return trndata;
        }

        [WebMethod]
        public string assakfasd()
        {
            return "{output:true}";
        }

        [WebMethod]
        public string saveTranscationDetails(TranscationDetailInfo trnsobj)
        {
             string IsValidate = string.Empty;
             IsValidate = "{output:true}";
             DateTime datenow = DateTime.Now;
             string newRCPTNO = "";
             string currentyear = datenow.ToString("yy");
             int tempSCNO = 0;
             SqlConnection connection = new SqlConnection(connectionString);
             // Read CURID and customerCode from database
             SqlCommand readcommand = new SqlCommand("select Top 1 * from TrnHdrRCPT order by RCPTNO DESC", connection);
             connection.Open();
             SqlDataReader rdr = readcommand.ExecuteReader();
             if (rdr.Read())
             {
                 string oldSCNo = rdr["RCPTNO"].ToString();
                 oldSCNo = oldSCNo.Remove(0, 3);
                 tempSCNO = int.Parse(oldSCNo) + 1;
                 newRCPTNO = currentyear + '/' + tempSCNO.ToString("D5");
             }
             connection.Close();
             try
             {
                 connection.Open();
                SqlCommand command = new SqlCommand("insert into TrnHdrRCPT(RCPTNO,PrintRCPTNO,RCPTDate,Cancelled,SCNo,CustID,SchemeID,TotalAmtRcvd,Remarks,RCVDDate,PaymentMode) values(@RCPTNO,@PrintRCPTNO,@RCPTDate,@Cancelled,@SCNo,@CustID,@SchemeID,@TotalAmtRcvd,@Remarks,@RCVDate,@PaymentMode) ", connection);
                 command.Parameters.AddWithValue("@RCPTNO", newRCPTNO);
                 command.Parameters.AddWithValue("@PrintRCPTNO", newRCPTNO);
                 command.Parameters.AddWithValue("@RCPTDate", trnsobj.RcptDate);
                 command.Parameters.AddWithValue("@Cancelled", 'N');
                 command.Parameters.AddWithValue("@SCNo", trnsobj.SCNo);
                 command.Parameters.AddWithValue("@CustID", trnsobj.CustID);
                 command.Parameters.AddWithValue("@TotalAmtRcvd", trnsobj.RcvdAmt);
                 command.Parameters.AddWithValue("@Remarks", trnsobj.Remarks);
                 command.Parameters.AddWithValue("@RCVDate", trnsobj.RcptDate);
                 command.Parameters.AddWithValue("@PaymentMode", trnsobj.PaymentMode);
                 command.Parameters.AddWithValue("@SchemeID", 0);
                 command.ExecuteNonQuery();

             }
             catch (SqlException ex)
             {
                 IsValidate = "{output:false}";
             }
             finally
             {
                 connection.Close();
             }

              for (int i = 0; i < trnsobj.TrnsInstIds.Length; i++)
              {


                  try
                  {
                      connection.Open();
                      SqlCommand command = new SqlCommand("if not exists (select * from TrnDtlRcpt where SCNo=@SCNo and InstNo=@InstNo) begin insert into TrnDtlRcpt(RcptNo,SCNo,InstNo,RcvdInstAmt) values(@RcptNo,@SCNo,@InstNo,@RcvdInstAmt) end ", connection);
                      command.Parameters.AddWithValue("@RcptNo", newRCPTNO);
                      command.Parameters.AddWithValue("@SCNo", trnsobj.SCNo);
                      command.Parameters.AddWithValue("@InstNo", trnsobj.TrnsInstIds[i]);
                      command.Parameters.AddWithValue("@RcvdInstAmt", trnsobj.RcvdAmt);

                      command.ExecuteNonQuery();

                  }
                  catch (SqlException ex)
                  {
                      IsValidate = "{output:false}";
                  }
                  finally
                  {
                      connection.Close();
                  }

                  try
                  {
                      connection.Open();
                      SqlCommand command = new SqlCommand("update TrnDtlSC set RcptNo=@RcptNo,RcptDate=@RcptDate,Status=@Status where SCNO=@SCNO and InstNo=@InstNo", connection);
                      command.Parameters.AddWithValue("@RcptNo", newRCPTNO);
                      command.Parameters.AddWithValue("@SCNo", trnsobj.SCNo);
                      command.Parameters.AddWithValue("@InstNo", trnsobj.TrnsInstIds[i]);
                      command.Parameters.AddWithValue("@RcptDate", trnsobj.RcptDate);
                      command.Parameters.AddWithValue("@Status", 'R');

                      command.ExecuteNonQuery();

                  }
                  catch (SqlException ex)
                  {
                      IsValidate = "{output:false}";
                  }
                  finally
                  {
                      connection.Close();
                  }

              }


            return IsValidate;
          

        }

        [WebMethod]
        public ReceiptEntryInformation getCustomerSchemeClosingInfo(SchemeOpeningInfo schemeobj)
        {
            var userdata = new ReceiptEntryInformation();

            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select s.SCNo,se.SCHEMEName,(s.NoOfInst * s.InstAmt) as totalamt, COUNT(r.SCNo) as paidNoOfInst,SUM(r.RcvdInstAmt) as paidInstAmt from TrnHdrSC as s, TrnDtlRcpt as r,MstSCHEME as se where s.SCNo =@SCNo and r.SCNo = s.SCNo and s.SchemeID=se.SCHEMEID group by s.SCNo,se.SCHEMEName,s.NoOfInst,s.InstAmt", connection);
            readcommand.Parameters.AddWithValue("@SCNo", schemeobj.SCNo);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                
                userdata.SCNo = rdr.GetString(0);
                userdata.PaidTotalInstAmt = rdr.GetDecimal(4);
                userdata.PaidNoOfInst = rdr.GetInt32(3);
                userdata.TotalAmt = rdr.GetDecimal(2);
               
            }

            connection.Close();

            return userdata;
        }

        [WebMethod]
        public string saveSchemeClosingDetails(SchemeOpeningInfo schemeobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";
            

            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update TrnHdrSC set ClosedDt= @ClosedDt,ClosureRmks= @ClosureRmks, SCStatus='Y' where SCNo=@SCNo and CustID=@CustID ", connection);
                command.Parameters.AddWithValue("@ClosedDt", schemeobj.ClosedDt);
                command.Parameters.AddWithValue("@ClosureRmks", schemeobj.ClosureRmks);
                command.Parameters.AddWithValue("@SCNo", schemeobj.SCNo);
                command.Parameters.AddWithValue("@CustID", schemeobj.CustID);


                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }


        [WebMethod]
        public String saveNewScheme(SchemeInformatoin schemeobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";
            string schemename = schemeobj.SCHEMEName;
            decimal instamt = schemeobj.InstAmt;
            decimal noofinst = schemeobj.NoOfInst;
            string rmks = schemeobj.Rmks;
            int newschemeid = 0;
           
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select Top 1 * from MstSCHEME order by SCHEMEID DESC", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                newschemeid = rdr.GetInt32(0) + 1;
            }

            connection.Close();
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("insert into MstSCHEME(SCHEMEID,SCHEMEName,InstAmt,NoOfInst,Rmks,InActive,SchemeDate) values(@SCHEMEID,@SCHEMEName,@InstAmt,@NoOfInst,@Rmks,@InActive,@SchemeDate) ", connection);
                command.Parameters.AddWithValue("@SCHEMEName", schemename);
                command.Parameters.AddWithValue("@InstAmt", instamt);
                command.Parameters.AddWithValue("@NoOfInst", noofinst);
                command.Parameters.AddWithValue("@Rmks", rmks);
                command.Parameters.AddWithValue("@InActive", 'N');
                command.Parameters.AddWithValue("@SCHEMEID", newschemeid);
                command.Parameters.AddWithValue("@SchemeDate", DateTime.Now);
                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }

        [WebMethod]
        public string deleteScheme(SchemeInformatoin schemeobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";


            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstSCHEME set InActive='Y' where SCHEMEID=@SCHEMEID ", connection);
                command.Parameters.AddWithValue("@SCHEMEID", schemeobj.SCHEMEID);

                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }


        [WebMethod]
        public List<SchemeInformatoin> getSchemeList()
        {
            var userlist = new List<SchemeInformatoin>();

            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select * from MstSCHEME where SCHEMEID>0 and InActive='N'", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new SchemeInformatoin();
                userdata.SCHEMEID = rdr.GetInt32(0);
                userdata.SCHEMEName = rdr.GetString(1);
                userdata.InActive = rdr.GetString(2);
                userdata.InstAmt = rdr.GetDecimal(4);
                userdata.NoOfInst = rdr.GetDecimal(5);
                userdata.Rmks = rdr.GetString(6);
                userdata.SchemeDate = rdr.GetDateTime(7);
                userlist.Add(userdata);
            }

            connection.Close();

            return userlist;

        }


        [WebMethod]
        public SchemeInformatoin GetSchemeDetailsById(SchemeInformatoin schemeobj)
        {
            var userdata = new SchemeInformatoin();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select * from MstSCHEME where SCHEMEID=@SCHEMEID ", connection);
            readcommand.Parameters.AddWithValue("@SCHEMEID", schemeobj.SCHEMEID);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                userdata.SCHEMEID = rdr.GetInt32(0);
                userdata.SCHEMEName = rdr.GetString(1);
                userdata.InActive = rdr.GetString(2);
                userdata.InstAmt = rdr.GetDecimal(4);
                userdata.NoOfInst = rdr.GetDecimal(5);
                userdata.Rmks = rdr.GetString(6);
                userdata.SchemeDate = rdr.GetDateTime(7);
            }

            connection.Close();

            return userdata;
        }

        [WebMethod]
        public List<SchemeOpeningInfo> getCustomerSchemesById(UserInformation userobj)
        {
            var schemedata = new List<SchemeOpeningInfo>();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select sc.*,s.SCHEMEName from TrnHdrSC as sc, MstSCHEME as s where CustID=@CustID and s.SCHEMEID = sc.SchemeID ", connection);
            readcommand.Parameters.AddWithValue("@CustID", userobj.CustID);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new SchemeOpeningInfo();
                userdata.SCNo = rdr["SCNO"].ToString();
                userdata.SchemeName = rdr["SCHEMEName"].ToString();
                schemedata.Add(userdata);
            }

            connection.Close();

            return schemedata;
        }

        [WebMethod]
        public String updateSchemeDetails(SchemeInformatoin schemeobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";
            int schemeid = schemeobj.SCHEMEID;
            string schemename = schemeobj.SCHEMEName;
            decimal instamt = schemeobj.InstAmt;
            decimal noofinst = schemeobj.NoOfInst;
            string rmks = schemeobj.Rmks;
            string inactive = schemeobj.InActive;

            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstSCHEME set SCHEMEName=@SCHEMEName,InstAmt=@InstAmt,NoOfInst=@NoOfInst,Rmks=@Rmks,InActive=@InActive where SCHEMEID=@SCHEMEID", connection);
                command.Parameters.AddWithValue("@SCHEMEName", schemename);
                command.Parameters.AddWithValue("@InstAmt", instamt);
                command.Parameters.AddWithValue("@NoOfInst", noofinst);
                command.Parameters.AddWithValue("@Rmks", rmks);
                command.Parameters.AddWithValue("@InActive", inactive);
                command.Parameters.AddWithValue("@SCHEMEID", schemeid);

                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }

        [WebMethod]

        public string newOpeningScheme(SchemeOpeningInfo schemeobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";
            DateTime datenow = DateTime.Now;
            string newSCID = "";
            string currentyear = datenow.ToString("yy");
            int tempSCNO = 0;
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select Top 1 * from TrnHdrSC order by SCNo DESC", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                string oldSCNo = rdr["SCNo"].ToString();
                oldSCNo = oldSCNo.Remove(0, 3);
                tempSCNO = int.Parse(oldSCNo) + 1;
                newSCID = currentyear + '/' + tempSCNO.ToString("D5");
            }
            connection.Close();


            
           string openingdate = schemeobj.StartDate.ToString("yyyy-MM-dd");
            string[] dateParts = openingdate.Split('-');
            string startdate = dateParts[2];
           string [] nextdate = dateParts;
            string newDate = openingdate;
            // Calculate installment dates to save in database
            for (int i = 1; i <= schemeobj.NoofInst; i++)
            {
                if(i > 1)
                {
                     newDate = installmentDate(nextdate, startdate);
                    nextdate = newDate.Split('-');
                }

                try
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand("insert into TrnDtlSC(SCNo,InstNo,InstDate,InstAmt,Status) values(@SCNo,@InstNo,@InstDate,@InstAmt,@Status) ", connection);
                    command.Parameters.AddWithValue("@SCNo", newSCID);
                    command.Parameters.AddWithValue("@InstNo", i);
                    command.Parameters.AddWithValue("@InstDate", newDate);
                    command.Parameters.AddWithValue("@InstAmt", schemeobj.InstAmt);
                    command.Parameters.AddWithValue("@Status", 'P');
                    command.ExecuteNonQuery();

                }
                catch (SqlException ex)
                {
                    IsValidate = "{output:false}";
                }
                finally
                {
                    connection.Close();
                }
            }

            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("insert into TrnHdrSC(SCNo,Prefix,PrintSCNO,SCDate,Cancelled,CustID,SchemeID,InstAmt,NoOfInst,Remarks,SCStatus,StartDate) values(@SCNo,@Prefix,@PrintSCNO,@SCDate,@Cancelled,@CustID,@SchemeID,@InstAmt,@NoOfInst,@Remarks,@SCStatus,@StartDate) ", connection);
                command.Parameters.AddWithValue("@SCNo", newSCID);
                command.Parameters.AddWithValue("@Prefix", '-');
                command.Parameters.AddWithValue("@PrintSCNO", newSCID);
                command.Parameters.AddWithValue("@SCDate", schemeobj.SCDate);
                command.Parameters.AddWithValue("@Cancelled", 'N');
                command.Parameters.AddWithValue("@CustID", schemeobj.CustID);
                command.Parameters.AddWithValue("@SchemeID", schemeobj.SchemeID);
                command.Parameters.AddWithValue("@InstAmt", schemeobj.InstAmt);
                command.Parameters.AddWithValue("@NoOfInst", schemeobj.NoofInst);
                command.Parameters.AddWithValue("@Remarks", schemeobj.Remarks);
                command.Parameters.AddWithValue("@SCStatus", 'N');
                command.Parameters.AddWithValue("@StartDate", schemeobj.StartDate);
                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }

        private string installmentDate(string[] currentDate,string selectedDate)
        {
            string nextDate = "";
            if (int.Parse(currentDate[1]) + 1 == 2)
            {
                if ((int.Parse(currentDate[0])) % 4 == 0)
                {
                    if (int.Parse(currentDate[2]) > 29)
                    {
                        nextDate = "29";
                    }
                    else
                    {
                        nextDate = selectedDate;
                    }
                }
                else
                {
                    if (int.Parse(currentDate[2]) > 28)
                    {
                        nextDate = "28";
                    }
                    else
                    {
                        nextDate = selectedDate;
                    }
                }



                return  int.Parse(currentDate[0]) + "-" + (int.Parse(currentDate[1]) + 1) + "-"+ nextDate;
            }
            else
            {
                if (int.Parse(currentDate[1]) + 1 == 4 || int.Parse(currentDate[1]) + 1 == 6 || int.Parse(currentDate[1]) + 1 == 9 || int.Parse(currentDate[1]) + 1 == 11)
                {
                    if (int.Parse(currentDate[2]) > 30)
                    {
                        nextDate = "30";
                    }
                    else
                    {
                        nextDate = selectedDate;
                    }
                }
                else
                {
                    nextDate = selectedDate;
                }


                if (int.Parse(currentDate[1]) == 12)
                {
                    if ((int.Parse(currentDate[1]) + 1) == 13)
                    {
                        currentDate[1] = "0";
                    }
                    return (int.Parse(currentDate[0]) +1 )+ "-" + (int.Parse(currentDate[1]) + 1) + "-" + nextDate;
                }
                else
                {

                    return int.Parse(currentDate[0]) + "-" + (int.Parse(currentDate[1]) + 1) + "-" + nextDate;
                }
            }
        }

        [WebMethod]
        public string saveNewCustomerGroup(CustomerGroupManageInfo groupobj)
        {
            string IsValidate = string.Empty;
            IsValidate = "{output:true}";
            int newcustomergroupid = 0;

            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select Top 1 * from MstCustGroup order by CustGroupID DESC", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {
                newcustomergroupid = rdr.GetInt32(0) + 1;
            }

            connection.Close();
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("insert into MstCustGroup(CustGroupID,CustGroupCode,CustGroupName) values(@CustGroupID,@CustGroupCode,@CustGroupName) ", connection);
                command.Parameters.AddWithValue("@CustGroupID", newcustomergroupid);
                command.Parameters.AddWithValue("@CustGroupCode", groupobj.CustGroupCode);
                command.Parameters.AddWithValue("@CustGroupName",groupobj.CustGroupName);
                
                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;
        }

        [WebMethod]

        public List<CustomerGroupManageInfo> getCustomerGroupList()
        {
            var group = new List<CustomerGroupManageInfo>();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select * from MstCustGroup where CustGroupID > 0 ", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new CustomerGroupManageInfo();
                userdata.CustGroupID = rdr.GetInt32(0);
                userdata.CustGroupCode = rdr.GetString(1);
                userdata.CustGroupName = rdr.GetString(2);
                group.Add(userdata);
            }

            connection.Close();

            return group;

        }

        [WebMethod]
        public CustomerGroupManageInfo getCustomerGroupById(CustomerGroupManageInfo groupobj)
        {
            var groupdata = new CustomerGroupManageInfo();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select * from MstCustGroup where CustGroupID =@CustGroupID", connection);
            readcommand.Parameters.AddWithValue("@CustGroupID", groupobj.CustGroupID);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            if (rdr.Read())
            {

                groupdata.CustGroupID = rdr.GetInt32(0);
                groupdata.CustGroupCode = rdr.GetString(1);
                groupdata.CustGroupName = rdr.GetString(2);
            }

            connection.Close();
            return groupdata;
        }

        [WebMethod]
        public string updateCustomerGroupDetails(CustomerGroupManageInfo groupobj)
        {
           string IsValidate = "{output:true}";
           

            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstCustGroup set CustGroupCode=@CustGroupCode,CustGroupName=@CustGroupName where CustGroupID=@CustGroupID", connection);
                command.Parameters.AddWithValue("@CustGroupCode", groupobj.CustGroupCode);
                command.Parameters.AddWithValue("@CustGroupName", groupobj.CustGroupName);
                command.Parameters.AddWithValue("@CustGroupID", groupobj.CustGroupID);
              
                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }

            return IsValidate;

        }

        [WebMethod]
        public string deleteCustomerGroup(CustomerGroupManageInfo groupobj)
        {
            string IsValidate = "{output:true}";


           /* SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("update MstCustGroup set CustGroupCode=@CustGroupCode,CustGroupName=@CustGroupName where CustGroupID=@CustGroupID", connection);
                command.Parameters.AddWithValue("@CustGroupCode", groupobj.CustGroupCode);
                command.Parameters.AddWithValue("@CustGroupName", groupobj.CustGroupName);
                command.Parameters.AddWithValue("@CustGroupID", groupobj.CustGroupID);

                command.ExecuteNonQuery();

            }
            catch (SqlException ex)
            {
                IsValidate = "{output:false}";
            }
            finally
            {
                connection.Close();
            }*/

            return IsValidate;
        }

        [WebMethod]
        public List<UserInformation> currentMonthPendingInstCustomer()
        {
            var userlist = new List<UserInformation>();
            SqlConnection connection = new SqlConnection(connectionString);
            // Read CURID and customerCode from database
            SqlCommand readcommand = new SqlCommand("select c.CustName,c.PHNO,up.CustProfileImg,sc.InstDate  from MstCust as c ,MstCustFileUploads as up,TrnHdrSC as s left join TrnDtlSC sc on s.SCNo = sc.SCNo where s.CustID = c.CustID and up.CustID = c.CustID and sc.Status = 'P' and sc.InstDate between dateadd(dd, -day(getdate()) + 1, getdate()) and dateadd(dd, -day(dateadd(mm, 1, getdate())), dateadd(mm, 1, getdate())) ", connection);
            connection.Open();
            SqlDataReader rdr = readcommand.ExecuteReader();
            while (rdr.Read())
            {
                var userdata = new UserInformation();
                userdata.CustName = rdr.GetString(0);
                userdata.PHNO = rdr.GetString(1);
                if (!rdr.IsDBNull(rdr.GetOrdinal("CustProfileImg"))) { userdata.CustProfileImg = rdr.GetString(2); } else { userdata.CustProfileImg = ""; }
                userdata.InstDate = rdr.GetDateTime(3).ToString("dd-MM-yyyy");
                userlist.Add(userdata);
            }

            connection.Close();
            return userlist;
        }

        [WebMethod]
        public  String ValidateUser(Users user)
        {
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            SqlCommand cmd = new SqlCommand("select * from MstUser where EmailID=@phone AND Pwd=@password", connection);
            cmd.Parameters.AddWithValue("@phone", user.mobile);
            cmd.Parameters.AddWithValue("@password", user.password);
            SqlDataReader dr = cmd.ExecuteReader();
            string IsValidate = string.Empty;
            if (dr.HasRows)
            {
               
                IsValidate = "valid";
               
            }
            else
            {
                IsValidate = "Invalid";
            }
            return IsValidate;
        }

        [WebMethod]
        public  String RegisterUser(Users user)
        {
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO tbl_users (name, email, phone, pass) VALUES ( @name, @email, @mobile, @password)", connection);
            cmd.Parameters.AddWithValue("@name", user.mobile);
            cmd.Parameters.AddWithValue("@email", user.mobile);
            cmd.Parameters.AddWithValue("@mobile", user.mobile);
            cmd.Parameters.AddWithValue("@password", user.password);
            SqlDataReader dr = cmd.ExecuteReader();
            string IsValidate = "valid";
            return IsValidate;
        }

        [WebMethod]
        public OTP sendOTP(OTP otpobj)
        {
            var otpdata = new OTP();
            string numbers = "1234567890";

            string characters = numbers;

            int length = 5;
            string otp = string.Empty;
            for (int i = 0; i < length; i++)
            {
                string character = string.Empty;
                do
                {
                    int index = new Random().Next(0, characters.Length);
                    character = characters.ToCharArray()[index].ToString();
                } while (otp.IndexOf(character) != -1);
                otp += character;
            }
            otpdata.otpcode = otp;



            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            SqlCommand cmd = new SqlCommand("select * from MstUser where PHNO=@PHNO ", connection);
            cmd.Parameters.AddWithValue("@PHNO", otpobj.mobile);
            SqlDataReader dr = cmd.ExecuteReader();
            string IsValidate = string.Empty;
            if (dr.Read())
            {
                otpdata.userid = long.Parse(dr["PHNO"].ToString());
            }
 
            return otpdata;
            
        }

        public class Users
        {
            public string name { get; set; }
            public string email { get; set; }
            public string mobile { get; set; }
            public string password { get; set; }
        }

        public class OTP
        {
            public string mobile { get; set; }
            public string otpcode { get; set; }
            public long userid { get; set; }
        }

        public class ServerDetails
        {
            public string servername { get; set; }
            public string database { get; set; }
            public string username { get; set; }
            public string password { get; set; }
        }


      

    }


}

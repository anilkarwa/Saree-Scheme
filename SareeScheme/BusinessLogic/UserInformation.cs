using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SareeScheme.BusinessLogic
{
    public class UserInformation
    {

        public int CustID  { get; set; }

        public string CustName { get; set; }
        public string CustCode { get; set; }
        public int CustGroupID { get; set; }
        public string InAcitve { get; set; }
        public string Remarks { get; set; }
        public string BAdd1 { get; set; }
        public string BAdd2 { get; set; }
        public string BAdd3 { get; set; }
        public string BAdd4 { get; set; }
        public string GSTNO { get; set; }
        public  string PHNO { get; set; }

        public string CustGroupName { get; set; }

        public string CustProfileImg { get; set; }

        public string InstDate { get; set; }

    }
}
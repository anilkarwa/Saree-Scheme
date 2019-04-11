using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SareeScheme.BusinessLogic
{
    public class SchemeOpeningInfo
    {
        public string  SCNo { get; set; } 
        public DateTime SCDate { get; set; }
        public DateTime StartDate { get; set; }
        public string Cancelled { get; set; }
        public int CustID { get; set; }
        public string CustName { get; set; }
        public int SchemeID { get; set; }
        public int NoofInst { get; set; }
        public int InstAmt { get; set; }
        public string Remarks { get; set; }
        public string SCStatus { get; set; }
        public DateTime ClosedDt { get; set; }
        public string ClosureRmks { get; set; }
        public string SchemeName { get; set; }
    }
}
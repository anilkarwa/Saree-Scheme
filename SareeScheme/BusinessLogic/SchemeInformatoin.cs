using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SareeScheme.BusinessLogic
{
    public class SchemeInformatoin
    {
        public int SCHEMEID { get; set; }
        public string SCHEMEName { get; set; }
        public string InActive { get; set; }
        public decimal InstAmt { get; set; }
        public decimal NoOfInst { get; set; }
        public string Rmks { get; set; }
        public DateTime SchemeDate { get; set; }

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SareeScheme.BusinessLogic
{
    public class TranscationDetailInfo
    {
        public string SCNo { get; set; }
        public int InstNo { get; set; }
        public string InstDate { get; set; }
        public Decimal InstAmt { get; set; }
        public string RcptNo { get; set; }
        public string RcptDate { get; set; }
        public string Status { get; set; }
        public Decimal RcvdAmt { get; set; }
        public string Remarks { get; set; }
        public string PaymentMode { get; set; }
        public string[] TrnsInstIds { get; set; }
        public int CustID { get; set; }

    }
}
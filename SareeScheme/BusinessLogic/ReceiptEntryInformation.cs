using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SareeScheme.BusinessLogic
{
    public class ReceiptEntryInformation
    {
        public string SCNo { get; set; }
        public Decimal InstAmt { get; set; }
        public int NoOfInst { get; set; }
        public Decimal TotalAmt { get; set; }
        public DateTime InstDate { get; set; }
        public string SchemeID { get; set; }
        public string SchemeName { get; set; }
        public int PaidNoOfInst { get; set; }
        public Decimal PaidTotalInstAmt { get; set; }
        public Decimal installmentAmountRcvd { get; set; }
        public DateTime installmetnRcvdDate { get; set; }
        public string paymentMode { get; set; }
        public string paymentRemarks { get; set; }
        public int balanceNoOfInst { get; set; }
        public Decimal balanceAmt { get; set; }



    }
}
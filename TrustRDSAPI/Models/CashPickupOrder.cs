using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrustRDSAPI.Models
{
    public class CashPickupOrder
    {
        public string OrderID { get; set; }
       
        public string SenderName { get; set; }
        public string SenderCountryCode { get; set; }
        public string SenderEmail { get; set; }
        public string SenderMobile { get; set; }
        public string SenderCurrencyCode { get; set; }
        public decimal SenderAmount { get; set; }
        public string ReceiverName { get; set; }
        public string ReceiverAddress { get; set; }
        public string ReceiverMobile { get; set; }
        public string ReceiverEmail { get; set; }

        public string PIN { get; set; }
        public string ReceiverCurrencyCode { get; set; }
        public decimal? ReceiverAmount { get; set; }
        public string ReceiverIDType { get; set; }
        public string ReceiverIDNumber { get; set; }
        public string Purpose { get; set; }

        public string ApiCallID { get; set; }


    }
}
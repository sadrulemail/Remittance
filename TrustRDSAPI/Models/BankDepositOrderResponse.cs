using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrustRDSAPI.Models
{
    public class BankDepositOrderResponse
    {
        public string RefID { get; set; }
        public string OrderID { get; set; }
        public string StatusCode { get; set; }
        public string StatusDesc { get; set; }
        public string ExHouseCode { get; set; }
        public string ReceiverCurrencyCode { get; set; }
        public double ReceiverAmount { get; set; }
        //public string ReceiverName { get; set; }
        //public string RoutingCode { get; set; }
        //public string AccountNumber { get; set; }
    }
}
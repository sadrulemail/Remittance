using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrustRDSAPI.Models
{
    public class OrdersCancelResponse
    {
        public string CancelRefID { get; set; }
        public string RefID { get; set; }
        public string OrderID { get; set; }
        public string StatusCode { get; set; }
        public string StatusDesc { get; set; }
        public string ExHouseCode { get; set; }
        //public string Comments { get; set; }
    }
}
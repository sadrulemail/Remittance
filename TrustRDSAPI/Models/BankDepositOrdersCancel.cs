using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace TrustRDSAPI.Models
{
    public class BankDepositOrdersCancel
    {
        [DataMember]
        public string RefID { get; set; }
        [DataMember]
        public string OrderID { get; set; }
        public string ApiCallID { get; set; }
    }
}
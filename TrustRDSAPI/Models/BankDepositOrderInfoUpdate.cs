namespace TrustRDSAPI.Models
{
    public class BankDepositOrderInfoUpdate
    {
       public string RefID { get; set; }
        public string OrderID { get; set; }
        public string ReceiverName { get; set; }
        public string AccNo { get; set; }
        public string RoutingCode { get; set; }
        public string ApiCallID { get; set; }
    }


}
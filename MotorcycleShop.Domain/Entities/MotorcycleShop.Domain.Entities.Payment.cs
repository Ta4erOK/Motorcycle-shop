using MotorcycleShop.Domain.Enums;
using System;

namespace MotorcycleShop.Domain.Entities
{
    public class Payment
    {
        public int Id { get; set; }                  
        public int OrderId { get; set; }             
        public DateTime PaymentDate { get; set; }    
        public decimal Amount { get; set; }          
        public string PaymentMethod { get; set; } = "Карта"; 
        public string CardLastFour { get; set; } = "";       
        public string? TransactionId { get; set; }          
        public PaymentStatus Status { get; set; }            

        public Order Order { get; set; } = null!; 

        public Payment()
        {
            PaymentDate = DateTime.Now;
            Status = PaymentStatus.Pending; 
        }
    }
}

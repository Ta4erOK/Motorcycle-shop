using MotorcycleShop.Domain.Enums;
using System;
using System.Collections.Generic;

namespace MotorcycleShop.Domain.Entities
{
    public class Order
    {
        public int Id { get; set; }                           
        public string OrderNumber { get; set; } = "";         
        public string CustomerName { get; set; } = "";        
        public string CustomerEmail { get; set; } = "";      
        public string CustomerPhone { get; set; } = "";       
        public string DeliveryAddress { get; set; } = "";     
        public DateTime OrderDate { get; set; }               
        public decimal TotalAmount { get; set; }              
        public OrderStatus Status { get; set; }               
        public string? Comments { get; set; }                 

  
        public List<OrderItem> OrderItems { get; set; } = new();  
        public Payment? Payment { get; set; }                     

        public Order()
        {
            OrderDate = DateTime.Now;
            Status = OrderStatus.PendingPayment; 
            OrderNumber = GenerateOrderNumber(); 
        }

        private string GenerateOrderNumber()
        {
            return $"ORD-{DateTime.Now:yyyyMMdd-HHmmss}";
        }
    }
}
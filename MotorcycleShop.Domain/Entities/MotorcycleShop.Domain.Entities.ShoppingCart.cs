using System;
using System.Collections.Generic;

namespace MotorcycleShop.Domain.Entities
{
    public class ShoppingCart
    {
        public int Id { get; set; }                     
        public string SessionId { get; set; } = "";     
        public DateTime CreatedDate { get; set; }       
        public DateTime LastModified { get; set; }      
        public decimal TotalAmount { get; set; }        

        public List<ShoppingCartItem> Items { get; set; } = new();

        public ShoppingCart()
        {
            CreatedDate = DateTime.Now;
            LastModified = DateTime.Now;
        }

        public void CalculateTotal()
        {
            TotalAmount = 0;
            foreach (var item in Items)
            {
                TotalAmount += item.Motorcycle.Price * item.Quantity;
            }
        }
    }
}
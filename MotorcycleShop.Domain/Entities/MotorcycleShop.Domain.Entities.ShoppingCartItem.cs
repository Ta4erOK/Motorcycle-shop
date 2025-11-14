using System;

namespace MotorcycleShop.Domain.Entities
{
    public class ShoppingCartItem
    {
        public int Id { get; set; }                     
        public int ShoppingCartId { get; set; }         
        public int MotorcycleId { get; set; }           
        public int Quantity { get; set; }               
        public DateTime AddedDate { get; set; }         

        public ShoppingCart ShoppingCart { get; set; } = null!;     
        public Motorcycle Motorcycle { get; set; } = null!;         

        public ShoppingCartItem()
        {
            AddedDate = DateTime.Now;
            Quantity = 1; 
        }
    }
}
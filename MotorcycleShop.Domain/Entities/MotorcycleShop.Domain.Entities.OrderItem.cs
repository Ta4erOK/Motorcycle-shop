namespace MotorcycleShop.Domain.Entities
{
    public class OrderItem
    {
        public int Id { get; set; }              
        public int OrderId { get; set; }         
        public int MotorcycleId { get; set; }    
        public int Quantity { get; set; }        
        public decimal UnitPrice { get; set; }   

 
        public Order Order { get; set; } = null!;           
        public Motorcycle Motorcycle { get; set; } = null!; 

      
        public OrderItem()
        {
            Quantity = 1; 
        }
    }
}
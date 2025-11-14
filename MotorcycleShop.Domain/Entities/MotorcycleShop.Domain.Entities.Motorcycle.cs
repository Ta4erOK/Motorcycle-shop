using System;

namespace MotorcycleShop.Domain.Entities
{
    public class Motorcycle
    {
        public int Id { get; set; }                    
        public string Brand { get; set; } = "";        
        public string Model { get; set; } = "";        
        public int Year { get; set; }                  
        public string Color { get; set; } = "";        
        public decimal EngineVolume { get; set; }      
        public int Mileage { get; set; }              
        public decimal Price { get; set; }            
        public string? Description { get; set; }       
        public string? ImageUrl { get; set; }          
        public bool InStock { get; set; }             
        public DateTime CreatedAt { get; set; }        

        public Motorcycle()
        {
            CreatedAt = DateTime.Now; 
        }

        public override string ToString()
        {
            return $"{Brand} {Model} ({Year}) - {Price:C}";
        }
    }
}
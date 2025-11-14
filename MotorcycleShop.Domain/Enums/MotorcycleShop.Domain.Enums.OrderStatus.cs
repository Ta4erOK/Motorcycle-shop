namespace MotorcycleShop.Domain.Enums
{
    public enum OrderStatus
    {
        PendingPayment,    
        Paid,              
        Processing,        
        Delivering,        
        Completed          
    }

    public enum PaymentStatus
    {
        Pending,   
        Success,   
        Error      
    }
}
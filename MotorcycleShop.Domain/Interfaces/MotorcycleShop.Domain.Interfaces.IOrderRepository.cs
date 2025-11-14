using MotorcycleShop.Domain.Entities;
using System.Collections.Generic;

namespace MotorcycleShop.Domain.Interfaces
{
    public interface IOrderRepository : IRepository<Order>
    {
        Order? GetByOrderNumber(string orderNumber);

        List<Order> GetByCustomerEmail(string email);

        List<Order> GetByStatus(string status);

        void UpdateOrderStatus(int orderId, string newStatus);
    }
}
using MotorcycleShop.Domain.Entities;
using MotorcycleShop.Domain.Interfaces;
using System.Collections.Generic;
using System.Linq;

namespace MotorcycleShop.Domain.Repositories
{
    public class OrderRepository : BaseRepository<Order>, IOrderRepository
    {
        protected override int GetId(Order entity)
        {
            return entity.Id;
        }

        protected override void SetId(Order entity, int id)
        {
            entity.Id = id;
        }

        public Order? GetByOrderNumber(string orderNumber)
        {
            return _items.FirstOrDefault(o => o.OrderNumber == orderNumber);
        }

        public List<Order> GetByCustomerEmail(string email)
        {
            return _items.Where(o => o.CustomerEmail.ToLower() == email.ToLower()).ToList();
        }

        public List<Order> GetByStatus(string status)
        {
            return _items.Where(o => o.Status.ToString() == status).ToList();
        }

        public void UpdateOrderStatus(int orderId, string newStatus)
        {
            var order = GetById(orderId);
            if (order != null)
            {
                if (System.Enum.TryParse<Domain.Enums.OrderStatus>(newStatus, out var status))
                {
                    order.Status = status;
                    Update(order);
                }
            }
        }
    }
}
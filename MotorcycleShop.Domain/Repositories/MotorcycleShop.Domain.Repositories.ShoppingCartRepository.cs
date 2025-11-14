using MotorcycleShop.Domain.Entities;
using MotorcycleShop.Domain.Interfaces;
using System;
using System.Linq;

namespace MotorcycleShop.Domain.Repositories
{
    public class ShoppingCartRepository : BaseRepository<ShoppingCart>, IShoppingCartRepository
    {
        protected override int GetId(ShoppingCart entity)
        {
            return entity.Id;
        }

        protected override void SetId(ShoppingCart entity, int id)
        {
            entity.Id = id;
        }

        public ShoppingCart? GetBySessionId(string sessionId)
        {
            return _items.FirstOrDefault(cart => cart.SessionId == sessionId);
        }

        public void AddItemToCart(string sessionId, int motorcycleId, int quantity = 1)
        {
            var cart = GetBySessionId(sessionId);
            if (cart == null)
            {
                cart = new ShoppingCart { SessionId = sessionId };
                Add(cart);
            }

            var motorcycleRepo = new MotorcycleRepository();
            var motorcycle = motorcycleRepo.GetById(motorcycleId);

            if (motorcycle == null)
                throw new ArgumentException($"Мотоцикл с ID {motorcycleId} не найден");

            var existingItem = cart.Items.FirstOrDefault(item => item.MotorcycleId == motorcycleId);
            if (existingItem != null)
            {
                existingItem.Quantity += quantity;
            }
            else
            {
                var newItem = new ShoppingCartItem
                {
                    ShoppingCartId = cart.Id,
                    MotorcycleId = motorcycleId,
                    Quantity = quantity,
                    Motorcycle = motorcycle
                };
                cart.Items.Add(newItem);
            }

            cart.CalculateTotal();
            cart.LastModified = DateTime.Now;

            Update(cart);
        }

        public void RemoveItemFromCart(string sessionId, int motorcycleId)
        {
            var cart = GetBySessionId(sessionId);
            if (cart == null) return;

            var itemToRemove = cart.Items.FirstOrDefault(item => item.MotorcycleId == motorcycleId);
            if (itemToRemove != null)
            {
                cart.Items.Remove(itemToRemove);
                cart.CalculateTotal();
                cart.LastModified = DateTime.Now;
                Update(cart);
            }
        }

        public void ClearCart(string sessionId)
        {
            var cart = GetBySessionId(sessionId);
            if (cart != null)
            {
                cart.Items.Clear();
                cart.TotalAmount = 0;
                cart.LastModified = DateTime.Now;
                Update(cart);
            }
        }

        public void UpdateItemQuantity(string sessionId, int motorcycleId, int newQuantity)
        {
            var cart = GetBySessionId(sessionId);
            if (cart == null) return;

            var item = cart.Items.FirstOrDefault(i => i.MotorcycleId == motorcycleId);
            if (item != null)
            {
                item.Quantity = newQuantity;
                cart.CalculateTotal();
                cart.LastModified = DateTime.Now;
                Update(cart);
            }
        }
    }
}
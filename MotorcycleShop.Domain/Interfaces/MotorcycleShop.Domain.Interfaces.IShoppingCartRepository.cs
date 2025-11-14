using MotorcycleShop.Domain.Entities;

namespace MotorcycleShop.Domain.Interfaces
{
    public interface IShoppingCartRepository : IRepository<ShoppingCart>
    {
        ShoppingCart? GetBySessionId(string sessionId);

        void AddItemToCart(string sessionId, int motorcycleId, int quantity = 1);

        void RemoveItemFromCart(string sessionId, int motorcycleId);

        void ClearCart(string sessionId);

        void UpdateItemQuantity(string sessionId, int motorcycleId, int newQuantity);
    }
}
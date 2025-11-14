using System.Collections.Generic;

namespace MotorcycleShop.Domain.Interfaces
{
    public interface IRepository<T> where T : class      // T - тип сущности (Motorcycle, Order и т.д.)
    {
        List<T> GetAll();

        T? GetById(int id);

        void Add(T entity);

        void Update(T entity);

        void Delete(int id);

        void Save();
    }
}
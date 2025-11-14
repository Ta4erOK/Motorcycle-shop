using MotorcycleShop.Domain.Interfaces;
using System.Collections.Generic;

namespace MotorcycleShop.Domain.Repositories
{

    public abstract class BaseRepository<T> : IRepository<T> where T : class     // T - тип сущности (Motorcycle, Order и т.д.)
    {
        protected List<T> _items = new List<T>();

        protected int _nextId = 1;

        public virtual List<T> GetAll()
        {
            return new List<T>(_items);
        }

        public virtual T? GetById(int id)
        {

            var item = _items.Find(i => GetId(i) == id);
            return item;
        }

        public virtual void Add(T entity)
        {
            SetId(entity, _nextId++);
            _items.Add(entity);
        }

        public virtual void Update(T entity)
        {
            var id = GetId(entity);
            var index = _items.FindIndex(i => GetId(i) == id);

            if (index >= 0)
            {
                _items[index] = entity;
            }
        }

        public virtual void Delete(int id)
        {
            var item = GetById(id);
            if (item != null)
            {
                _items.Remove(item);
            }
        }

        public virtual void Save()
        {
            // В репозиториях с базой данных здесь была бы логика сохранения
        }

        protected abstract int GetId(T entity);
        protected abstract void SetId(T entity, int id);
    }
}
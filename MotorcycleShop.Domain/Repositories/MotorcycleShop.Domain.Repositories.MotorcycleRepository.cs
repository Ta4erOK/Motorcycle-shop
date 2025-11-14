using MotorcycleShop.Domain.Entities;
using MotorcycleShop.Domain.Interfaces;
using System.Collections.Generic;
using System.Linq;

namespace MotorcycleShop.Domain.Repositories
{
    public class MotorcycleRepository : BaseRepository<Motorcycle>, IMotorcycleRepository
    {
        public MotorcycleRepository()
        {
            AddTestData();
        }

        protected override int GetId(Motorcycle entity)
        {
            return entity.Id;
        }

        protected override void SetId(Motorcycle entity, int id)
        {
            entity.Id = id;
        }

        public List<Motorcycle> GetByBrand(string brand)
        {
            return _items.Where(m => m.Brand.ToLower() == brand.ToLower()).ToList();
        }

        public List<Motorcycle> GetByPriceRange(decimal minPrice, decimal maxPrice)
        {
            return _items.Where(m => m.Price >= minPrice && m.Price <= maxPrice).ToList();
        }

        public List<Motorcycle> GetByYear(int year)
        {
            return _items.Where(m => m.Year == year).ToList();
        }

        public List<Motorcycle> GetByEngineVolume(decimal minVolume, decimal maxVolume)
        {
            return _items.Where(m => m.EngineVolume >= minVolume && m.EngineVolume <= maxVolume).ToList();
        }

        public List<Motorcycle> Search(string searchTerm)
        {
            if (string.IsNullOrWhiteSpace(searchTerm))
                return GetAll();

            var term = searchTerm.ToLower();
            return _items.Where(m =>
                m.Brand.ToLower().Contains(term) ||
                m.Model.ToLower().Contains(term) ||
                m.Description?.ToLower().Contains(term) == true
            ).ToList();
        }

        public List<string> GetAllBrands()
        {
            return _items.Select(m => m.Brand).Distinct().OrderBy(b => b).ToList();
        }

        public List<int> GetAllYears()
        {
            return _items.Select(m => m.Year).Distinct().OrderByDescending(y => y).ToList();
        }

        private void AddTestData()
        {
            var motorcycles = new List<Motorcycle>
            {
                new Motorcycle
                {
                    Brand = "Yamaha",
                    Model = "YZF-R6",
                    Year = 2022,
                    Color = "Синий",
                    EngineVolume = 599,
                    Mileage = 0,
                    Price = 850000,
                    Description = "Спортивный мотоцикл для трека и города",
                    ImageUrl = "https://example.com/yamaha_r6.jpg",
                    InStock = true
                },
                new Motorcycle
                {
                    Brand = "Honda",
                    Model = "CBR600RR",
                    Year = 2023,
                    Color = "Красный",
                    EngineVolume = 599,
                    Mileage = 0,
                    Price = 820000,
                    Description = "Надежный спортивный мотоцикл",
                    ImageUrl = "https://example.com/honda_cbr.jpg",
                    InStock = true
                },
                new Motorcycle
                {
                    Brand = "Kawasaki",
                    Model = "Ninja 650",
                    Year = 2021,
                    Color = "Зеленый",
                    EngineVolume = 649,
                    Mileage = 5000,
                    Price = 650000,
                    Description = "Универсальный спортивно-туристический мотоцикл",
                    ImageUrl = "https://example.com/kawasaki_ninja.jpg",
                    InStock = true
                },
                new Motorcycle
                {
                    Brand = "Suzuki",
                    Model = "GSX-R750",
                    Year = 2020,
                    Color = "Серебристый",
                    EngineVolume = 750,
                    Mileage = 12000,
                    Price = 780000,
                    Description = "Мощный спортивный мотоцикл",
                    ImageUrl = "https://example.com/suzuki_gsxr.jpg",
                    InStock = false
                },
                new Motorcycle
                {
                    Brand = "Ducati",
                    Model = "Panigale V4",
                    Year = 2023,
                    Color = "Красный",
                    EngineVolume = 1103,
                    Mileage = 0,
                    Price = 2500000,
                    Description = "Элитный спортивный мотоцикл",
                    ImageUrl = "https://example.com/ducati_panigale.jpg",
                    InStock = true
                }
            };

            foreach (var motorcycle in motorcycles)
            {
                Add(motorcycle);
            }
        }
    }
}
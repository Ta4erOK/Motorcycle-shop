using MotorcycleShop.Domain.Entities;
using System.Collections.Generic;

namespace MotorcycleShop.Domain.Interfaces
{
    public interface IMotorcycleRepository : IRepository<Motorcycle>
    {
        List<Motorcycle> GetByBrand(string brand);

        List<Motorcycle> GetByPriceRange(decimal minPrice, decimal maxPrice);

        List<Motorcycle> GetByYear(int year);

        List<Motorcycle> GetByEngineVolume(decimal minVolume, decimal maxVolume);

        List<Motorcycle> Search(string searchTerm);

        List<string> GetAllBrands();

        List<int> GetAllYears();
    }
}
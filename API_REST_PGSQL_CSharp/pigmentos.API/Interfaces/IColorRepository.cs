using pigmentos.API.Models;

namespace pigmentos.API.Interfaces
{
    public interface IColorRepository
    {
        Task<IEnumerable<Color>> GetAllAsync();
        Task<Color> GetByIdAsync(Guid id);
        Task<Color> GetByDetailsAsync(Color color);
        Task<Color> AddAsync(Color color);
        Task<Color> UpdateAsync(Color color);
        Task<bool> DeleteAsync(Guid id);
    }
}

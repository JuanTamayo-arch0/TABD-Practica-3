using pigmentos.API.Models;

namespace pigmentos.API.Interfaces
{
    public interface IFamiliaRepository
    {
        Task<IEnumerable<Familia>> GetAllAsync();
        Task<Familia> GetByIdAsync(Guid id);
    }
}

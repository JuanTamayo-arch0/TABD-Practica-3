using pigmentos.API.Models;

namespace pigmentos.API.Interfaces
{
    public interface IPigmentoRepository
    {
        Task<IEnumerable<Pigmento>> GetAllAsync();
        Task<Pigmento> GetByIdAsync(Guid id);
        Task<IEnumerable<Pigmento>> GetByFamiliaIdAsync(Guid familiaId);
        Task<List<Pigmento>> GetByColorIdAsync(Guid colorId);
        Task<Pigmento> AddAsync(Pigmento pigmento);
        Task<Pigmento> UpdateAsync(Pigmento pigmento);
        Task<bool> DeleteAsync(Guid id);
    }
}

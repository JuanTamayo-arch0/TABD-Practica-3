using pigmentos.API.Interfaces;
using pigmentos.API.Models;

namespace pigmentos.API.Services
{
    public class FamiliaService
    {
        private readonly IFamiliaRepository _familiaRepository;

        public FamiliaService(IFamiliaRepository familiaRepository)
        {
            _familiaRepository = familiaRepository;
        }

        public async Task<IEnumerable<Familia>> GetAllAsync()
        {
            return await _familiaRepository.GetAllAsync();
        }

        public async Task<Familia> GetByIdAsync(Guid id)
        {
            return await _familiaRepository.GetByIdAsync(id);
        }
    }
}

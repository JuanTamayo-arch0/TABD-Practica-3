using Dapper;
using pigmentos.API.DbContexts;
using pigmentos.API.Interfaces;
using pigmentos.API.Models;
using System.Data;

namespace pigmentos.API.Repositories
{
    public class FamiliaRepository : IFamiliaRepository
    {
        private readonly PgsqlDbContext _context;

        public FamiliaRepository(PgsqlDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Familia>> GetAllAsync()
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre, descripcion FROM core.familias_quimicas ORDER BY nombre";
            return await connection.QueryAsync<Familia>(sql);
        }

        public async Task<Familia> GetByIdAsync(Guid id)
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre, descripcion FROM core.familias_quimicas WHERE id = @Id";
            var result = await connection.QuerySingleOrDefaultAsync<Familia>(sql, new { Id = id });
            return result;
        }
    }
}

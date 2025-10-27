using Dapper;
using pigmentos.API.DbContexts;
using pigmentos.API.Interfaces;
using pigmentos.API.Models;
using System.Data;
using Npgsql;
using pigmentos.API.Exceptions;

namespace pigmentos.API.Repositories
{
    public class PigmentoRepository : IPigmentoRepository
    {
        private readonly PgsqlDbContext _context;

        public PigmentoRepository(PgsqlDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Pigmento>> GetAllAsync()
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre_comercial as NombreComercial, formula_quimica as FormulaQuimica, numero_ci as NumeroCi, familia_quimica_id as FamiliaQuimicaId, color_principal_id as ColorPrincipalId FROM core.pigmentos ORDER BY nombre_comercial";
            return await connection.QueryAsync<Pigmento>(sql);
        }

        public async Task<Pigmento> GetByIdAsync(Guid id)
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre_comercial as NombreComercial, formula_quimica as FormulaQuimica, numero_ci as NumeroCi, familia_quimica_id as FamiliaQuimicaId, color_principal_id as ColorPrincipalId FROM core.pigmentos WHERE id = @Id";
            var result = await connection.QuerySingleOrDefaultAsync<Pigmento>(sql, new { Id = id });
            return result;
        }

        public async Task<IEnumerable<Pigmento>> GetByFamiliaIdAsync(Guid familiaId)
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre_comercial as NombreComercial, formula_quimica as FormulaQuimica, numero_ci as NumeroCi, familia_quimica_id as FamiliaQuimicaId, color_principal_id as ColorPrincipalId FROM core.pigmentos WHERE familia_quimica_id = @FamiliaId ORDER BY nombre_comercial";
            return await connection.QueryAsync<Pigmento>(sql, new { FamiliaId = familiaId });
        }

        public async Task<List<Pigmento>> GetByColorIdAsync(Guid colorId)
        {
            using var connection = _context.CreateConnection();
            
            DynamicParameters parametrosSentencia = new();
            parametrosSentencia.Add("@colorId", colorId,
                DbType.Guid, ParameterDirection.Input);
            
            var sql = "SELECT id, nombre_comercial as NombreComercial, formula_quimica as FormulaQuimica, numero_ci as NumeroCi, familia_quimica_id as FamiliaQuimicaId, color_principal_id as ColorPrincipalId FROM core.pigmentos WHERE color_principal_id = @ColorId ORDER BY nombre_comercial";
            var resultadoProduccion = await connection
                .QueryAsync<Pigmento>(sql, parametrosSentencia);

            return [.. resultadoProduccion];
        }
        

        public async Task<Pigmento> AddAsync(Pigmento pigmento)
        {
            try
            {
                using var connection = _context.CreateConnection();
                string procedimiento = "core.p_insertar_pigmento";
                var parametros = new
                {
                    p_nombre_comercial = pigmento.NombreComercial,
                    p_formula_quimica = pigmento.FormulaQuimica,
                    p_numero_ci = pigmento.NumeroCi,
                    p_familia_id = pigmento.FamiliaQuimicaId,
                    p_color_id = pigmento.ColorPrincipalId
                };
            
                var filasAfectadas = await connection.ExecuteAsync(
                    procedimiento,
                    parametros,
                    commandType: CommandType.StoredProcedure);
                
                if (filasAfectadas == 0)
                {
                    throw new DbOperationException("No se pudo insertar el pigmento");
                }
                
                return pigmento; 
            }
            catch (NpgsqlException error)
            {
                throw new DbOperationException(error.Message);
            }
        }

        public async Task<Pigmento> UpdateAsync(Pigmento pigmento)
        {
            try
            {
                using var connection = _context.CreateConnection();
                string procedimiento = "core.p_actualizar_pigmento";
                var parametros = new
                {
                    p_id = pigmento.Id,
                    p_nombre_comercial = pigmento.NombreComercial,
                    p_formula_quimica = pigmento.FormulaQuimica,
                    p_numero_ci = pigmento.NumeroCi,
                    p_familia_id = pigmento.FamiliaQuimicaId,
                    p_color_id = pigmento.ColorPrincipalId
                };
            
                var filasAfectadas = await connection.ExecuteAsync(
                    procedimiento,
                    parametros,
                    commandType: CommandType.StoredProcedure);
                
                if (filasAfectadas == 0)
                {
                    throw new DbOperationException("No se pudo actualizar el pigmento");
                }
                
                return pigmento; 
            }
            catch (NpgsqlException error)
            {
                throw new DbOperationException(error.Message);
            }
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            try
            {
                using var connection = _context.CreateConnection();
                string procedimiento = "core.p_eliminar_pigmento";
                var parametros = new
                {
                    p_id = id
                };
            
                var filasAfectadas = await connection.ExecuteAsync(
                    procedimiento,
                    parametros,
                    commandType: CommandType.StoredProcedure);
                
                if (filasAfectadas == 0)
                {
                    throw new DbOperationException("No se pudo eliminar el pigmento");
                }
                
                return (filasAfectadas != 0); 
                
            }
            catch (NpgsqlException error)
            {
                throw new DbOperationException(error.Message);
            }
        }

     
    }
}

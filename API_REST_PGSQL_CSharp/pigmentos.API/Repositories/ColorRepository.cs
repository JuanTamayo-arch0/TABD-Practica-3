using Dapper;
using pigmentos.API.DbContexts;
using pigmentos.API.Interfaces;
using pigmentos.API.Models;
using System.Data;
using Npgsql;
using pigmentos.API.Exceptions;

namespace pigmentos.API.Repositories
{
    public class ColorRepository : IColorRepository
    {
        private readonly PgsqlDbContext _context;

        public ColorRepository(PgsqlDbContext context)
        {
            _context = context;
        }
        

        public async Task<IEnumerable<Color>> GetAllAsync()
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre, codigo_hexadecimal as CodigoHexadecimal FROM core.colores ORDER BY nombre";
            return await connection.QueryAsync<Color>(sql);
        }

        public async Task<Color> GetByIdAsync(Guid id)
        {
            using var connection = _context.CreateConnection();
            var sql = "SELECT id, nombre, codigo_hexadecimal as CodigoHexadecimal FROM core.colores WHERE id = @Id";
            var result = await connection.QuerySingleOrDefaultAsync<Color>(sql, new { Id = id });
            return result;
        }
        
        public async Task<Color> GetByDetailsAsync(Color color)
        {
            using var connection = _context.CreateConnection();

            var sql = @"
                        SELECT DISTINCT
                            id AS Id,
                            nombre AS Nombre,
                            codigo_hexadecimal AS CodigoHexadecimal
                        FROM core.colores
                        WHERE LOWER(nombre) = LOWER(@colorNombre)
                          AND UPPER(codigo_hexadecimal) = UPPER(@colorHexadecimal)
    ";

            var parameters = new DynamicParameters();
            parameters.Add("colorNombre", color.Nombre, DbType.String, ParameterDirection.Input);
            parameters.Add("colorHexadecimal", color.CodigoHexadecimal, DbType.String, ParameterDirection.Input);

            var resultado = await connection.QueryFirstOrDefaultAsync<Color>(sql, parameters);
            return resultado ?? new Color();
        }

        public async Task<Color> AddAsync(Color color)
        {
            try
            {
                using var connection = _context.CreateConnection();
                string procedimiento = "core.p_insertar_color";
                var parametros = new
                {
                    p_nombre = color.Nombre,
                    p_codigo_hexadecimal = color.CodigoHexadecimal
                };
            
                var filasAfectadas = await connection.ExecuteAsync(
                    procedimiento,
                    parametros,
                    commandType: CommandType.StoredProcedure);
                
                if (filasAfectadas == 0)
                {
                    throw new DbOperationException("No se pudo insertar el color");
                }
                
                return color; 
            }
            catch (NpgsqlException error)
            {
                throw new DbOperationException(error.Message);
            }
        }
        

        public async Task<Color> UpdateAsync(Color color)
        {
            try
            {
                using var connection = _context.CreateConnection();
                string procedimiento = "core.p_actualizar_color";
                var parametros = new
                {
                    p_id = color.Id,
                    p_nombre = color.Nombre,
                    p_codigo_hexadecimal = color.CodigoHexadecimal
                };
            
                var filasAfectadas = await connection.ExecuteAsync(
                    procedimiento,
                    parametros,
                    commandType: CommandType.StoredProcedure);
                
                if (filasAfectadas == 0)
                {
                    throw new DbOperationException("No se pudo actualizar el color");
                }
                
                return color; 
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
                string procedimiento = "core.p_eliminar_color";
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
                    throw new DbOperationException("No se pudo eliminar el color");
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



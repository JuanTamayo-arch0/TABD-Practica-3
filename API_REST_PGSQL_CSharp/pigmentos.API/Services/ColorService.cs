using pigmentos.API.Exceptions;
using pigmentos.API.Interfaces;
using pigmentos.API.Models;
using System.Text.RegularExpressions;
using pigmentos.API.Repositories;

namespace pigmentos.API.Services
{
    public class ColorService
    {
        private readonly IColorRepository _colorRepository;
        private readonly IPigmentoRepository _pigmentoRepository;

        public ColorService(IColorRepository colorRepository, IPigmentoRepository pigmentoRepository)
        {
            _colorRepository = colorRepository;
            _pigmentoRepository = pigmentoRepository;
        }

        public async Task<IEnumerable<Color>> GetAllAsync()
        {
            return await _colorRepository.GetAllAsync();
        }

        public async Task<Color> GetByIdAsync(Guid id)
        {
            return await _colorRepository.GetByIdAsync(id);
        }

        public async Task<Color> AddAsync(Color color)
        {
            
            color.Nombre = color.Nombre!.Trim();
            color.CodigoHexadecimal = color.CodigoHexadecimal!.Trim();

            string resultadoValidacion = EvaluateColorDetailsAsync(color);

            if (!string.IsNullOrEmpty(resultadoValidacion))
                throw new AppValidationException(resultadoValidacion);

            var colorExistente = await _colorRepository
                .GetByDetailsAsync(color);

            if (colorExistente.Nombre == color.Nombre! &&
                colorExistente.CodigoHexadecimal == color.CodigoHexadecimal) 

                return colorExistente;
            
            try
            {
                Color resultado = await _colorRepository
                    .AddAsync(color);

                if (!(resultado.CodigoHexadecimal.Length > 0))
                    throw new AppValidationException("Operación ejecutada pero no generó cambios en la DB");

                colorExistente = await _colorRepository
                    .GetByDetailsAsync(color);
            }
            catch (DbOperationException)
            {
                throw;
            }

            return colorExistente;
        }

        public async Task<Color> UpdateAsync(Color color)
        {
            color.Nombre = color.Nombre!.Trim();
            color.CodigoHexadecimal = color.CodigoHexadecimal!.Trim();
            
            string resultadoValidacion = EvaluateColorDetailsAsync(color);

            if (!string.IsNullOrEmpty(resultadoValidacion))
                throw new AppValidationException(resultadoValidacion);

            //Validamos primero si existe un color con ese Id
            var colorExistente = await _colorRepository
                .GetByIdAsync(color.Id);

            if (colorExistente.Id == Guid.Empty)
                throw new AppValidationException($"No existe un color con el Guid {color.Id} que se pueda actualizar");

            //Si existe y los datos son iguales, se retorna el objeto para garantizar idempotencia
            if (colorExistente.Equals(color))
                return colorExistente;

            try
            {
                
                Color resultado = await _colorRepository
                    .UpdateAsync(color);
                
                if (!(resultado.CodigoHexadecimal.Length > 0))
                    throw new AppValidationException("Operación ejecutada pero no generó cambios en la DB");

                colorExistente = await _colorRepository
                    .GetByIdAsync(color.Id);
            }
            catch (DbOperationException)
            {
                throw;
            }

            return colorExistente;
            
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            bool resultadoAccion;
            
            Color color = await _colorRepository
                .GetByIdAsync(id);

            if (color.Id == Guid.Empty)
                throw new AppValidationException($"Color no encontrado con el id {id}");

            //Validar si el color tiene pigmentos asociados
            var coloresAsociadas = await _pigmentoRepository.GetByColorIdAsync(id);

            if (coloresAsociadas.Count != 0)
                throw new AppValidationException($"El color {color.Nombre} no se puede eliminar porque tiene pigmentos asociados");

            try
            {
                resultadoAccion = await _colorRepository
                    .DeleteAsync(id);

                if (!resultadoAccion)
                    throw new DbOperationException("Operación ejecutada pero no generó cambios en la DB");
            }
            catch (DbOperationException)
            {
                throw;
            }

            return resultadoAccion;
            
        }
        
        private static string EvaluateColorDetailsAsync(Color color)
        {
            if (color.Nombre!.Length == 0)
                return "No se puede insertar un color con nombre nulo";
            
            if (color.CodigoHexadecimal!.Length == 0)
                return "No se puede insertar un color con codigo hexadecimal nulo";
            
            var regex = new Regex("^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})$");

            if (!regex.IsMatch(color.CodigoHexadecimal))
                return "El código hexadecimal no tiene un formato válido (#RGB o #RRGGBB)";
            
            return string.Empty;
        }
    }
}

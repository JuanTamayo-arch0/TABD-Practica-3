using pigmentos.API.Exceptions;
using pigmentos.API.Interfaces;
using pigmentos.API.Models;

namespace pigmentos.API.Services
{
    public class PigmentoService
    {
        private readonly IPigmentoRepository _pigmentoRepository;
        private readonly IFamiliaRepository _familiaRepository;
        private readonly IColorRepository _colorRepository;

        public PigmentoService(IPigmentoRepository pigmentoRepository, IFamiliaRepository familiaRepository, IColorRepository colorRepository)
        {
            _pigmentoRepository = pigmentoRepository;
            _familiaRepository = familiaRepository;
            _colorRepository = colorRepository;
        }

        public async Task<IEnumerable<Pigmento>> GetAllAsync()
        {
            return await _pigmentoRepository.GetAllAsync();
        }

        public async Task<Pigmento> GetByIdAsync(Guid id)
        {
            return await _pigmentoRepository.GetByIdAsync(id);
        }

        public async Task<IEnumerable<Pigmento>> GetByFamiliaIdAsync(Guid familiaId)
        {
            return await _pigmentoRepository.GetByFamiliaIdAsync(familiaId);
        }

        public async Task<IEnumerable<Pigmento>> GetByColorIdAsync(Guid colorId)
        {
            return await _pigmentoRepository.GetByColorIdAsync(colorId);
        }

        public async Task<Pigmento> AddAsync(Pigmento pigmento)
        {
            
            pigmento.NombreComercial = pigmento.NombreComercial!.Trim();
            pigmento.FormulaQuimica = pigmento.FormulaQuimica!.Trim();
            pigmento.NumeroCi = pigmento.NumeroCi!.Trim();

            string resultadoValidacion = EvaluatePigmentoDetailsAsync(pigmento);

            if (!string.IsNullOrEmpty(resultadoValidacion))
                throw new AppValidationException(resultadoValidacion);
            try
            {
                return await _pigmentoRepository.AddAsync(pigmento);
            }
            catch (DbOperationException)
            {
                throw;
            }

            
        }

        public async Task<Pigmento> UpdateAsync(Pigmento pigmento)
        {
            
            pigmento.NombreComercial = pigmento.NombreComercial!.Trim();
            pigmento.FormulaQuimica = pigmento.FormulaQuimica!.Trim();
            pigmento.NumeroCi = pigmento.NumeroCi!.Trim();
            
            string resultadoValidacion = EvaluatePigmentoDetailsAsync(pigmento);

            if (!string.IsNullOrEmpty(resultadoValidacion))
                throw new AppValidationException(resultadoValidacion);

            //Validamos primero si existe un pigmento con ese Id
            var pigmentoExistente = await _pigmentoRepository
                .GetByIdAsync(pigmento.Id);

            if (pigmentoExistente.Id == Guid.Empty)
                throw new AppValidationException($"No existe un color con el Guid {pigmento.Id} que se pueda actualizar");

            //Si existe y los datos son iguales, se retorna el objeto para garantizar idempotencia
            if (pigmentoExistente.Equals(pigmento))
                return pigmentoExistente;

            try
            {
                
                Pigmento resultado = await _pigmentoRepository
                    .UpdateAsync(pigmento);
                
                if (!(resultado.NombreComercial.Length > 0))
                    throw new AppValidationException("Operación ejecutada pero no generó cambios en la DB");

                pigmentoExistente = await _pigmentoRepository
                    .GetByIdAsync(pigmento.Id);
            }
            catch (DbOperationException)
            {
                throw;
            }

            return pigmentoExistente;
            
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            bool resultadoAccion;
            
            Pigmento pigmento = await _pigmentoRepository
                .GetByIdAsync(id);

            if (pigmento.Id == Guid.Empty)
                throw new AppValidationException($"Color no encontrado con el id {id}");
            
            try
            {
                resultadoAccion = await _pigmentoRepository
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
        
        private static string EvaluatePigmentoDetailsAsync(Pigmento pigmento)
        {
            if (pigmento.NombreComercial!.Length == 0)
                return "No se puede insertar un pigmento con nombre comercial nulo";
            
            if (pigmento.FormulaQuimica!.Length == 0)
                return "No se puede insertar un pigmento con una formula quimica nula";
            
            if (pigmento.NumeroCi!.Length == 0)
                return "No se puede insertar un pigmento con un numero CI nulo";

            if (pigmento.FamiliaQuimicaId.Equals(null))
                return "No se puede insertar un pigmento sin información de la familia quimica del pigmento";

            if (pigmento.ColorPrincipalId.Equals(null))
                return "No se puede insertar un pigmento sin información de la familia quimica del pigmento";

            return string.Empty;
            
        }

    }
}

using pigmentos.API.Models;
using pigmentos.API.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using pigmentos.API.Exceptions;

namespace pigmentos.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PigmentosController : ControllerBase
    {
        private readonly PigmentoService _pigmentoService;

        public PigmentosController(PigmentoService pigmentoService)
        {
            _pigmentoService = pigmentoService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var pigmentos = await _pigmentoService.GetAllAsync();
            return Ok(pigmentos);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var pigmento = await _pigmentoService.GetByIdAsync(id);
            if (pigmento == null)
            {
                return NotFound();
            }
            return Ok(pigmento);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Pigmento pigmento)
        {
            
            try
            {
                var newPigmento = await _pigmentoService.AddAsync(pigmento);
                return CreatedAtAction(nameof(GetById), new { id = newPigmento.Id }, newPigmento);
                
            }
            catch (AppValidationException error)
            {
                return BadRequest($"Error de validación: {error.Message}");
            }
            catch (DbOperationException error)
            {
                return BadRequest($"Error de operacion en DB: {error.Message}");
            }
            
        }

        [HttpPut]
        public async Task<IActionResult> Update(Pigmento pigmento)
        {
            
            try
            {
                var updatedPigmento = await _pigmentoService.UpdateAsync(pigmento);
                return Ok(updatedPigmento);
                
            }
            catch (AppValidationException error)
            {
                return BadRequest($"Error de validación: {error.Message}");
            }
            catch (DbOperationException error)
            {
                return BadRequest($"Error de operacion en DB: {error.Message}");
            }
            
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            
            try
            {
                var result = await _pigmentoService.DeleteAsync(id);
                if (!result)
                {
                    return NotFound();
                }
                return NoContent();
            }
            catch (AppValidationException error)
            {
                return BadRequest($"Error de validación: {error.Message}");
            }
            catch (DbOperationException error)
            {
                return BadRequest($"Error de operacion en DB: {error.Message}");
            }
            
        }

        
    }
}

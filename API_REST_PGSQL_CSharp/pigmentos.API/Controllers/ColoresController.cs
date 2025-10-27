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
    public class ColoresController : ControllerBase
    {
        private readonly ColorService _colorService;
        private readonly PigmentoService _pigmentoService;

        public ColoresController(ColorService colorService, PigmentoService pigmentoService)
        {
            _colorService = colorService;
            _pigmentoService = pigmentoService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var colores = await _colorService.GetAllAsync();
            return Ok(colores);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var color = await _colorService.GetByIdAsync(id);
            if (color == null)
            {
                return NotFound();
            }
            return Ok(color);
        }
        
        [HttpGet("{id}/pigmentos")]
        public async Task<IActionResult> GetPigmentosByColor(Guid id)
        {
            var pigmentos = await _pigmentoService.GetByColorIdAsync(id);
            return Ok(pigmentos);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Color color)
        {
            
            try
            {
                var newColor = await _colorService.AddAsync(color);
                return CreatedAtAction(nameof(GetById), new { id = newColor.Id }, newColor);
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
        public async Task<IActionResult> Update(Color color)
        {
            var updatedColor = await _colorService.UpdateAsync(color);
            return Ok(updatedColor);
        }
        
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var result = await _colorService.DeleteAsync(id);
            if (!result)
            {
                return NotFound();
            }
            return NoContent();
        }
    }
}

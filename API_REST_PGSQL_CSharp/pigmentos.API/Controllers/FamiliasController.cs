using pigmentos.API.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace pigmentos.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FamiliasController : ControllerBase
    {
        private readonly FamiliaService _familiaService;
        private readonly PigmentoService _pigmentoService;

        public FamiliasController(FamiliaService familiaService, PigmentoService pigmentoService)
        {
            _familiaService = familiaService;
            _pigmentoService = pigmentoService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var familias = await _familiaService.GetAllAsync();
            return Ok(familias);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var familia = await _familiaService.GetByIdAsync(id);
            if (familia == null)
            {
                return NotFound();
            }
            return Ok(familia);
        }

        [HttpGet("{id}/pigmentos")]
        public async Task<IActionResult> GetPigmentosByFamilia(Guid id)
        {
            var pigmentos = await _pigmentoService.GetByFamiliaIdAsync(id);
            return Ok(pigmentos);
        }
    }
}

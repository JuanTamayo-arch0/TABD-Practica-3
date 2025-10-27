using System.Text.Json.Serialization;

namespace pigmentos.API.Models
{
    public class Pigmento
    {
        [JsonPropertyName("id")]
        public Guid Id { get; set; }

        [JsonPropertyName("nombre_comercial")]
        public string? NombreComercial { get; set; }

        [JsonPropertyName("formula_quimica")]
        public string? FormulaQuimica { get; set; }

        [JsonPropertyName("numero_ci")]
        public string? NumeroCi { get; set; }

        [JsonPropertyName("familia_quimica_id")]
        public Guid FamiliaQuimicaId { get; set; }

        [JsonPropertyName("color_principal_id")]
        public Guid ColorPrincipalId { get; set; }
    }
}

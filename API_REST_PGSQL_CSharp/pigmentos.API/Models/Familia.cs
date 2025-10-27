using System.Text.Json.Serialization;

namespace pigmentos.API.Models
{
    public class Familia
    {
        [JsonPropertyName("id")]
        public Guid Id { get; set; }

        [JsonPropertyName("nombre")]
        public string? Nombre { get; set; }

        [JsonPropertyName("descripcion")]
        public string? Descripcion { get; set; }
    }
}

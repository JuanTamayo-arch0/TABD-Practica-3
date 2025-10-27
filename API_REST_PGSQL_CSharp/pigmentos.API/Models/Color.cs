using System.Text.Json.Serialization;

namespace pigmentos.API.Models
{
    public class Color
    {
        [JsonPropertyName("id")]
        public Guid Id { get; set; }

        [JsonPropertyName("nombre")]
        public string? Nombre { get; set; }

        [JsonPropertyName("codigo_hexadecimal")]
        public string? CodigoHexadecimal { get; set; }
    }
}

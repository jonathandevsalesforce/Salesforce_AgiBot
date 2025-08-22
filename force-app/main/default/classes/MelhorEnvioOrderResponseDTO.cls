public class MelhorEnvioOrderResponseDTO {
    public String id;
    public String status;
    public String protocol;
    public Decimal price;
    public String tracking;
    public String self_tracking;
    public String generated_at;
    public String posted_at;
    public String delivered_at;
    public String created_at;
    public String updated_at;
    public ToDTO to;
    
    public class ToDTO {
        public String name;
        public String phone;
        public String email;
        public String document;
    }
}
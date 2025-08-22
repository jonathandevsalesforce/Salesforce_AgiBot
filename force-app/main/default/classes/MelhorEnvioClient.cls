public virtual with sharing class MelhorEnvioClient {
    
    private static final String NC = 'NamedMelhorEnvio';
    
    private static String get(String relativePath) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:' + NC + relativePath);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json'); // opcional para GET
        Http http = new Http();
        HttpResponse res = http.send(req);
        Integer code = res.getStatusCode();
        if (code == 200) return res.getBody();
        if (code == 403) return res.getBody(); // token inválido
        if (code == 404) return res.getBody(); // nada encontrado
        if (code == 401) throw new CalloutException('401 Unauthorized: verifique token/Permission Set/External Credential.');
        throw new CalloutException('Erro Melhor Envio: ' + code + ' - ' + res.getBody());
    }
    
    public static String searchByQuery(String q) {
        if (String.isBlank(q)) throw new CalloutException('Parâmetro query é obrigatório.');
        return get('/me/orders/search?q=' + EncodingUtil.urlEncode(q, 'UTF-8'));
    }
    
    // Para desserializar o JSON para o objeto completo
    public static MelhorEnvioApiResponse getResponseObject(String jsonResponse) {
        return (MelhorEnvioApiResponse) JSON.deserialize(jsonResponse, MelhorEnvioApiResponse.class);
    }
    
    public static List<MelhorEnvioOrderResponseDTO> mapResponseToDTO(MelhorEnvioApiResponse resp) {
        List<MelhorEnvioOrderResponseDTO> dtos = new List<MelhorEnvioOrderResponseDTO>();
        
        if (resp != null && resp.data != null) {
            for (MelhorEnvioApiResponse.Data item : resp.data) {
                MelhorEnvioOrderResponseDTO dto = new MelhorEnvioOrderResponseDTO();
                dto.id = item.id;
                dto.status = item.status;
                dto.protocol = item.protocol;
                dto.price = item.price;
                dto.tracking = item.tracking;
                dto.self_tracking = item.self_tracking;
                dto.generated_at = item.generated_at;
                dto.posted_at = item.posted_at;
                dto.delivered_at = item.delivered_at;
                dto.created_at = item.created_at;
                dto.updated_at = item.updated_at;
                
                if (item.to != null) {
                    dto.to = new MelhorEnvioOrderResponseDTO.ToDTO();
                    dto.to.name = item.to.name;
                    dto.to.phone = item.to.phone;
                    dto.to.email = item.to.email;
                    dto.to.document = item.to.document;
                }
                dtos.add(dto);
            }
        }
        return dtos;
    }

    public static void saveDeliveryLogs(List<MelhorEnvioOrderResponseDTO> dtos, String externalId) {
        if (dtos == null || dtos.isEmpty()) {
            System.debug('Nenhum DTO para salvar no Delivery_Log__c');
            return;
        }

        List<DeliveryLog__c> logs = new List<DeliveryLog__c>();

        for (MelhorEnvioOrderResponseDTO dto : dtos) {
            DeliveryLog__c log = new DeliveryLog__c();
            log.External_Id__c = externalId;
            log.Status__c = dto.status;
            log.Protocol__c = dto.protocol;
            log.Price__c = dto.price;
            log.Tracking__c = dto.tracking;
            log.SelfTracking__c = dto.self_tracking;

            // Campos de data/hora (se estiverem em formato convertido para Datetime, prox. exemplo)
            log.GeneratedAt__c = tryParseDateTime(dto.generated_at);
            log.PostedAt__c = tryParseDateTime(dto.posted_at);
            log.Delivered_At__c = tryParseDateTime(dto.delivered_at);
            log.Created_At__c = tryParseDateTime(dto.created_at);
            log.Updated_At__c = tryParseDateTime(dto.updated_at);

            if (dto.to != null) {
                log.Recipient_Name__c = dto.to.name;
                log.RecipientPhone__c = dto.to.phone;
                log.RecipientEmail__c = dto.to.email;
                log.RecipientDocument__c = dto.to.document;
            }
            logs.add(log);
        }

        
        try {
            insert logs;
        } catch (Exception e) {
            System.debug('Erro ao inserir Delivery_Log__c: ' + e.getMessage());
            // Opcional: lançar exceção, tratar erro ou logar em outro lugar conforme sua necessidade
        }
    }

    // Método utilitário para converter String ISO8601 para Datetime (retorna null se inválido)
    @TestVisible
    private static Datetime tryParseDateTime(String dtStr) {
        if (String.isBlank(dtStr)) return null;
        try {
            return Datetime.valueOfGmt(dtStr);
        } catch (Exception e) {
            System.debug('Falha ao converter data: ' + dtStr);
            return null;
        }
    }
}
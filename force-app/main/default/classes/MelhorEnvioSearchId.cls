public with sharing class MelhorEnvioSearchId {
    
    @InvocableMethod(label='Pesquisar Etiqueta Dinâmica (Melhor Envio)')
    public static List<Output> searchByTracking(List<InputTracking> inputs) {
        if (inputs == null || inputs.isEmpty()) {
            throw new FlowException('Nenhum dado recebido.');
        }
        
        List<Output> outs = new List<Output>();
        
        // Regex para os formatos esperados
        Pattern patternId = Pattern.compile('^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
        Pattern patternProtocol = Pattern.compile('^ORD-\\d{8}\\d+$');
        Pattern patternTrackingBR = Pattern.compile('^[a-zA-Z0-9]+BR$');
        
        for (InputTracking i : inputs) {
            try {
                String valor = (i != null && i.tracking != null) ? i.tracking.trim() : null;
                
                if (valor == null || valor.startsWith('ME')) {
                    Output errorOutput = new Output();
                    errorOutput.error = 'Valor inválido: não pode iniciar com "ME".';
                    outs.add(errorOutput);
                    continue;
                }
                
                // Validação de padrão alternativo
                Boolean validaId = patternId.matcher(valor).matches();
                Boolean validaProtocol = patternProtocol.matcher(valor).matches();
                Boolean validaTrackingBR = patternTrackingBR.matcher(valor).matches();
                
                if (!validaId && !validaProtocol && !validaTrackingBR && valor != null) {
                    Output errorOutput = new Output();
                    errorOutput.error = 'Valor inválido: deve ser um ID, protocolo ORD ou código de rastreamento';
                    outs.add(errorOutput);
                    continue;
                } else {
                    
                    String jsonResponse = MelhorEnvioClient.searchByQuery(valor);
                    // Aqui eu recebo o json completo que precisa ser tratado para retornar o status e ademais da API
                    MelhorEnvioApiResponse resp = MelhorEnvioClient.getResponseObject(jsonResponse);
                    // Aqui realiza a chamada no JSON sendo tratado e desserializado para a classe de DTO
                    List<MelhorEnvioOrderResponseDTO> dtos = MelhorEnvioClient.mapResponseToDTO(resp);
                    // Aqui separo apenas os valores que eu vou usar do JSON para retorno
                    MelhorEnvioClient.saveDeliveryLogs(dtos, valor); // Faço a chamada para a criação do Log com os dados da AP
                    
                    S3Storage.saveToS3Sim(dtos[0].protocol, jsonResponse);

                    // Para cada DTO, criar um Output individual e popular campos com valores do DTO / podemos retornar qualquer um deles no front pro usuário.
                    for (MelhorEnvioOrderResponseDTO dto : dtos) {
                        Output o = new Output();
                        o.id = dto.id;
                        o.status = dto.status;
                        o.protocol = dto.protocol;
                        o.price = dto.price;
                        o.tracking = dto.tracking;
                        o.self_tracking = dto.self_tracking;
                        o.generated_at = dto.generated_at;
                        o.posted_at = dto.posted_at;
                        o.delivered_at = dto.delivered_at;
                        o.created_at = dto.created_at;
                        o.updated_at = dto.updated_at;
                        if (dto.to != null) {
                            o.to_name = dto.to.name;
                            o.to_phone = dto.to.phone;
                            o.to_email = dto.to.email;
                            o.to_document = dto.to.document;
                        }
                        outs.add(o);
                    }
                }
            } catch (Exception e) {
                Output errorOutput = new Output();
                errorOutput.error = 'Erro: ' + e.getMessage();
                outs.add(errorOutput);
            }
        }
        return outs;
    }
    
    public class InputTracking {
        @InvocableVariable(required=true)
        public String tracking;
    }
    
    public class Output {
        @InvocableVariable public String id;
        @InvocableVariable public String status;
        @InvocableVariable public String protocol;
        @InvocableVariable public Decimal price;
        @InvocableVariable public String tracking;
        @InvocableVariable public String self_tracking;
        @InvocableVariable public String generated_at;
        @InvocableVariable public String posted_at;
        @InvocableVariable public String delivered_at;
        @InvocableVariable public String created_at;
        @InvocableVariable public String updated_at;
        
        // Campos do destinatário "to"
        @InvocableVariable public String to_name;
        @InvocableVariable public String to_phone;
        @InvocableVariable public String to_email;
        @InvocableVariable public String to_document;
        
        @InvocableVariable public String error; // para mensagens de erro
    }
    
    public class FlowException extends Exception { }
}
@IsTest
public class MelhorEnvioClientTest {

    // Mock básico para resposta HTTP com corpo JSON e status configurável
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String body;
        public MockHttpResponseGenerator(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(statusCode);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            return res;
        }
    }

    // Caso sucesso com dados válidos e inserção de logs
    @IsTest
    static void testSearchByQuery_Success() {
        String jsonResponse = '{ "data": [ {'+
            '"id":"9fabc682-b850-4d67-a244-08e819ee3ad8",'+
            '"status":"ENTREGUE",'+
            '"protocol":"ORD-202508243576",'+
            '"price":35.5,'+
            '"tracking":"PY320841BR",'+
            '"self_tracking":"https://tracking.exemplo/PY320841BR",'+
            '"generated_at":"2025-08-20T10:00:00Z",'+
            '"posted_at":"2025-08-20T12:00:00Z",'+
            '"delivered_at":"2025-08-22T09:00:00Z",'+
            '"created_at":"2025-08-19T09:00:00Z",'+
            '"updated_at":"2025-08-22T09:05:00Z",'+
            '"to": {'+
                '"name":"Cliente Teste",'+
                '"phone":"123456789",'+
                '"email":"cliente@teste.com",'+
                '"document":"12345678900"'+
            '}'+
        '}]}';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, jsonResponse));
        Test.startTest();
        String response = MelhorEnvioClient.searchByQuery('PY320841BR');
        Test.stopTest();
        System.assert(response.contains('ENTREGUE'));

        MelhorEnvioApiResponse resp = MelhorEnvioClient.getResponseObject(response);
        System.assertNotEquals(null, resp);
        System.assert(resp.data.size() == 1);

        List<MelhorEnvioOrderResponseDTO> dtos = MelhorEnvioClient.mapResponseToDTO(resp);
        System.assert(dtos.size() == 1);
        MelhorEnvioClient.saveDeliveryLogs(dtos, 'PY320841BR');
    }

    // Caso resposta 403 (token inválido)
    @IsTest
    static void testSearchByQuery_403() {
        String body = '{"message":"Invalid token"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(403, body));
        Test.startTest();
        String response = MelhorEnvioClient.searchByQuery('query-invalida');
        Test.stopTest();
        System.assert(response.contains('Invalid token'));
    }

    // Caso resposta 404 (nenhum resultado)
    @IsTest
    static void testSearchByQuery_404() {
        String body = '{"message":"Not found"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(404, body));
        Test.startTest();
        String response = MelhorEnvioClient.searchByQuery('query-inexistente');
        Test.stopTest();
        System.assert(response.contains('Not found'));
    }

    // Caso resposta 401 (Unauthorized) deve lançar exceção
    @IsTest
    static void testSearchByQuery_401_Exception() {
        String body = '{"message":"Unauthorized"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(401, body));
        Test.startTest();
        try {
            MelhorEnvioClient.searchByQuery('any');
            System.assert(false, 'Deveria lançar CalloutException');
        } catch (CalloutException e) {
            System.assert(e.getMessage().contains('401 Unauthorized'));
        }
        Test.stopTest();
    }

    // Caso resposta inesperada código diferente dos tratados deve lançar exceção
    @IsTest
    static void testSearchByQuery_UnexpectedStatus_Exception() {
        String body = '{"error":"Internal Server Error"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, body));
        Test.startTest();
        try {
            MelhorEnvioClient.searchByQuery('any');
            System.assert(false, 'Deveria lançar CalloutException');
        } catch (CalloutException e) {
            System.assert(e.getMessage().contains('Erro Melhor Envio: 500'));
        }
        Test.stopTest();
    }


@IsTest
static void testTryParseDateTime() {
    Datetime dt = MelhorEnvioClient.tryParseDateTime('2025-08-20T10:00:00Z');
    System.assertNotEquals(null, dt);
    
    dt = MelhorEnvioClient.tryParseDateTime(null);
    System.assertEquals(null, dt);
    
    dt = MelhorEnvioClient.tryParseDateTime('invalid date');
    System.assertEquals(null, dt);
}


}

// Helper class para expor métodos privados para teste (se desejar testar tryParseDateTime privada)
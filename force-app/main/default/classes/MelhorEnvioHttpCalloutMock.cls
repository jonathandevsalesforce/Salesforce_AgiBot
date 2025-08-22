@IsTest
public class MelhorEnvioHttpCalloutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Aqui é o json de resposta da api Melhor Envio simulado.
        String jsonResponse = '{'+
            '"id":"9fabc682-b850-4d67-a244-08e819ee3ad8",'+
            '"status":"ENTREGUE",'+
            '"protocol":"ORD-202508243576",'+
            '"tracking":"PY320841BR",'+
            '"price":35.50,'+
            '"self_tracking":"https://tracking.exemplo/PY320841BR",'+
            '"generated_at":"2025-08-20T10:00:00Z",'+
            '"posted_at":"2025-08-20T12:00:00Z",'+
            '"delivered_at":"2025-08-22T09:00:00Z",'+
            '"created_at":"2025-08-19T09:00:00Z",'+
            '"updated_at":"2025-08-22T09:05:00Z"'+
        '}';

        // Cria a resposta HTTP que será retornada pela chamada simulada
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200); // HTTP 200 OK
        return res;
    }
}
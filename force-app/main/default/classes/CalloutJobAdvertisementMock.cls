@isTest
global class CalloutJobAdvertisementMock implements HttpCalloutMock {
    
    Integer statusCode;
    String token;
    
    public CalloutJobAdvertisementMock(Integer statusCode, String token) {
    	this.statusCode  = statusCode;
        this.token = token;
  	}
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
    	response.setHeader('Content-Type', 'application/json');
    	String serialized;
    	if(request.getEndpoint().contains('services/oauth2/token')) {
      		serialized = '{"'+ token +'":"FAKE-ACCESS-TOKEN"}';
    	} else{
      		serialized = '{"Name":"OurName"}';
    	}
    	response.setBody(serialized);
    	response.setStatusCode(statusCode);
        return response;
    }
}
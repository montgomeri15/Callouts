@isTest
global class CalloutJobAdvertisementMock implements HttpCalloutMock {
    CalloutResumeRecordsForMock calloutResumeRecords = new CalloutResumeRecordsForMock();
    
    Integer statusCode;
    String token;
    String externalId;
    
    public CalloutJobAdvertisementMock(Integer statusCode, String token, String externalId) {
    	this.statusCode  = statusCode;
        this.token = token;
        this.externalId = externalId;
  	}
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
    	response.setHeader('Content-Type', 'application/json');
    	String serialized;
    	if(request.getEndpoint().contains('services/oauth2/token')) {
      		serialized = '{"'+ token +'":"FAKE-ACCESS-TOKEN"}';
        } else if(request.getEndpoint().contains('resumeEndpoint')){
            serialized = calloutResumeRecords.getRecordsInString();
        } else{
      		serialized = '{"Name":"OurName", "Position_ID__c":"'+ externalId +'"}';
    	}
    	response.setBody(serialized);
    	response.setStatusCode(statusCode);
        return response;
    }
}
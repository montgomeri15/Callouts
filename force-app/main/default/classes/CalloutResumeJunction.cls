public class CalloutResumeJunction {
    public class ResponseException extends Exception {}
    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}    
	}
    
    public static HttpRequest createRequestForService(String token, String method){
		HttpRequest finalRequest = new HttpRequest();
        finalRequest.setHeader('Authorization','Bearer ' + token);
        finalRequest.setHeader('Content-Type','application/json');
        finalRequest.setHeader('accept','application/json');
  		finalRequest.setMethod(method);
        finalRequest.setEndpoint('https://na59.salesforce.com/services/apexrest/resumeJunctionEndpoint/');
		return finalRequest;
	}
    
    public static HttpResponse getCalloutResponseContents() {   
    	Http ourHttp = new Http();
        HttpRequest requestForToken = CalloutJobAdvertisement.createRequestForToken('GET');
        HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);
        
        List<Job_Application__c> jobApplicationsList = new List<Job_Application__c>();

		if(objAuthenticationInfo.ACCESS_TOKEN != null) {
            HttpRequest requestForService = createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'GET');
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('ALL EXISTING Resume Junctions:  ' + responseService.getBody());
                jobApplicationsList = (List<Job_Application__c>)JSON.deserialize(responseService.getBody(), List<Job_Application__c>.class);
                for(Job_Application__c temporaryJobApplication: jobApplicationsList){
                	temporaryJobApplication.Id =null;
            	}
                insert jobApplicationsList;
                return responseService;
            }
            throw new ResponseException(System.Label.Status_code_is_not_200);
        }
        throw new ResponseException(System.Label.Access_Token_is_null);
    }
}
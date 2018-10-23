public class CalloutJobAdvertisementHelper {
    public class ResponseException extends Exception {}
    
    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}    
	}
    
    public static String GenerateJSON(Position__c pos){
		Map<String, String> fieldMap = new Map<String, String>{
			'Status__c' => 'Archived'
             };
        String serialized = JSON.serialize(fieldMap);         
        return serialized;
     }
    
    @future(callout = true)
    public static void changeStatusCallout(Id positionId){
        Http ourHttp = new Http();
        HttpRequest request = CalloutJobAdvertisement.httpRequest('GET');
    	HttpResponse response = ourHttp.send(request);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            Position__c ourPosition = [SELECT Id, Name, Status__c
                           	   		   FROM Position__c
                           	   		   WHERE Id =: positionId];
            HttpRequest finalRequest = CalloutJobAdvertisement.finalHttpRequest(objAuthenticationInfo.ACCESS_TOKEN, 'POST', ourPosition.Id + '?_HttpMethod=PATCH');
            finalRequest.setBody(GenerateJSON(ourPosition));
            System.debug('Job Advertisement TO CHANGE:  ' + GenerateJSON(ourPosition));
            HttpResponse finalResponse = ourHttp.send(finalRequest);
            if(finalResponse.getStatusCode() == 200) {
                System.debug('All is ok! Status code is 200.');
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
}
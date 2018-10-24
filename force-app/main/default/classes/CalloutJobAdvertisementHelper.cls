public class CalloutJobAdvertisementHelper {
    public class HelperResponseException extends Exception {}
    
    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}
	}
    
    public static String generateJSON(Position__c pos){
		Map<String, String> fieldMap = new Map<String, String>{
			'Status__c' => 'Archived'
             };
        String serialized = JSON.serialize(fieldMap);         
        return serialized;
     }
    
    @future(callout = true)
    public static void changeStatusCallout(Id positionId){
        Http ourHttp = new Http();
        HttpRequest requestForToken = CalloutJobAdvertisement.createRequestForToken('GET');
    	HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            Position__c ourPosition = [SELECT Id, Name, Status__c
                           	   		   FROM Position__c
                           	   		   WHERE Id =: positionId];
            HttpRequest requestForService = CalloutJobAdvertisement.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'POST', ourPosition.Id + '?_HttpMethod=PATCH');
            requestForService.setBody(generateJSON(ourPosition));
            System.debug('Job Advertisement TO CHANGE:  ' + generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('All is ok! Status code is 200.');
            }else {
            	throw new HelperResponseException('Status code is not 200.');
            }
        } else{
            throw new HelperResponseException('Access Token is null.');
        }
    }
}
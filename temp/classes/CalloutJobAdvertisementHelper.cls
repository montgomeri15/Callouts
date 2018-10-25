public class CalloutJobAdvertisementHelper {
    public class HelperResponseException extends Exception {}
    
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
        CalloutJobAdvertisement.OAuth2 objAuthenticationInfo = (CalloutJobAdvertisement.OAuth2)JSON.deserialize(responseToken.getbody(), CalloutJobAdvertisement.OAuth2.class);

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
            	throw new HelperResponseException(System.Label.Status_code_is_not_200);
            }
        } else{
            throw new HelperResponseException(System.Label.Access_Token_is_null);
        }
    }
}
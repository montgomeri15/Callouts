public class CalloutJobAdvertisementHelper {
    public class HelperResponseException extends Exception {}
    
    public static String generateJSON(){
		Map<String, String> fieldMap = new Map<String, String>{
			'Status__c' => 'Archived'
             };
        String serialized = JSON.serialize(fieldMap);         
        return serialized;
     }
    
    @future(callout = true)
    public static void changeStatusCallout(String positionId, String ourPosition){
        System.debug('positionId: ' + positionId);
        Http ourHttp = new Http();
        HttpRequest requestForToken = RequestClass.createRequestForToken('GET');
    	HttpResponse responseToken = ourHttp.send(requestForToken);
        CalloutJobAdvertisement.OAuth2 objAuthenticationInfo = (CalloutJobAdvertisement.OAuth2)JSON.deserialize(responseToken.getbody(), CalloutJobAdvertisement.OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            System.debug('positionId: ' + positionId);
            HttpRequest requestForService = RequestClass.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'POST', 'jobAdvertisementEndpoint/' + positionId + '?_HttpMethod=PATCH');
            requestForService.setBody(generateJSON());
            System.debug('Job Advertisement TO CHANGE:  ' + generateJSON());
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() != 200) {
                throw new HelperResponseException(System.Label.Status_code_is_not_200);
            }
        } else{
            throw new HelperResponseException(System.Label.Access_Token_is_null);
        }
    }
}
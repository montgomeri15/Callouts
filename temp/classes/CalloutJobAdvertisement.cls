public class CalloutJobAdvertisement {
    public class ResponseException extends Exception {}

    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}    
	}
    
    public static Position__c getPosition(Id positionId){
        Position__c ourPosition = [SELECT Id, Name, Location__c, Job_Description__c, Salary_Range__c, Skills_Required__c, Education__c, Hiring_Manager__r.Name, Email__c, Phone__c
                     	   		   FROM Position__c
                                   WHERE Id =: positionId];
        return ourPosition;
    }
    
    public static String generateJSON(Position__c pos){
		Map<String, String> fieldMap = new Map<String, String>{
			'Name' => pos.Name,
			'Description__c' => pos.Job_Description__c,
            'Salary__c' => pos.Salary_Range__c,
			'Skills_Required__c' => pos.Skills_Required__c,
			'Education__c' => pos.Education__c,
			'Manager_Name__c' => pos.Hiring_Manager__r.Name,
			'Email__c' => pos.Email__c,
			'Phone__c' => pos.Phone__c,
			'Position_ID__c' => pos.Id
        };       
        String serialized = JSON.serialize(fieldMap);         
        return serialized;
     }

    public static HttpResponse getCalloutResponseContents() {      
    	Http ourHttp = new Http();
        HttpRequest requestForToken = RequestClass.createRequestForToken('GET');  //Создаем HTTP-запрос на отправку токен-данных.
        HttpResponse responseToken = ourHttp.send(requestForToken);  //Отправляем HTTP-запрос и получаем ответ в JSON-формате.
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null) {
            HttpRequest requestForService = RequestClass.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN,
                                                                                 'GET',
                                                                                 'jobAdvertisementEndpoint');
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('ALL EXISTING Job Advertisements:  ' + responseService.getBody());
                return responseService;
            }
            throw new ResponseException(System.Label.Status_code_is_not_200);
        }
        throw new ResponseException(System.Label.Access_Token_is_null);
    }
    
    public static HttpResponse postCalloutResponseContents(Id positionId) {
        Http ourHttp = new Http();
        HttpRequest requestForToken = RequestClass.createRequestForToken('POST'); 
        HttpResponse responseToken = ourHttp.send(requestForToken);      
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);
        
        if(objAuthenticationInfo.ACCESS_TOKEN != null) {
            Position__c ourPosition = getPosition(positionId);
            HttpRequest requestForService = RequestClass.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN,
                                                                                 'POST',
                                                                                 'jobAdvertisementEndpoint');
            requestForService.setBody(generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);
            System.debug(responseService.getStatusCode());
            if(responseService.getStatusCode() == 200) {
                System.debug('CREATED Job Advertisement:  ' + responseService.getBody());
                return responseService;
            }
            throw new ResponseException(System.Label.Status_code_is_not_200);
        }
        throw new ResponseException(System.Label.Access_Token_is_null);
    }
        
    public static HttpResponse deleteCalloutResponseContents(Id positionId){
        Http ourHttp = new Http();
        HttpRequest requestForToken = RequestClass.createRequestForToken('GET');
    	HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);
        
        if(objAuthenticationInfo.ACCESS_TOKEN != null) {
            Position__c ourPosition = getPosition(positionId);
            HttpRequest requestForService = RequestClass.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN,
                                                                                 'DELETE',
                                                                                 'jobAdvertisementEndpoint/' + ourPosition.Id);
            requestForService.setBody(generateJSON(ourPosition));
            System.debug('Job Advertisement BEFORE DELETION:  ' + generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);

            if(responseService.getStatusCode() == 200) {
                System.debug('NO CONTENT. ' + responseService.getBody());
                return responseService;
            }
            throw new ResponseException(System.Label.Status_code_is_not_200);
        }   
        throw new ResponseException(System.Label.Access_Token_is_null); 
    }
    
    public static HttpResponse putCalloutResponseContents(Id positionId){
        Http ourHttp = new Http();
        HttpRequest requestForToken = RequestClass.createRequestForToken('GET');
    	HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);
        
        if(objAuthenticationInfo.ACCESS_TOKEN != null) {
            Position__c ourPosition = getPosition(positionId);
            HttpRequest requestForService = RequestClass.createRequestForService(objAuthenticationInfo.ACCESS_TOKEN,
                                                                                 'POST',
                                                                                 'jobAdvertisementEndpoint/' + ourPosition.Id + '?_HttpMethod=PATCH');
            requestForService.setBody(generateJSON(ourPosition));
            System.debug('Job Advertisement TO CHANGE:  ' + generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                return responseService;
            }
            throw new ResponseException(System.Label.Status_code_is_not_200);
        }
        throw new ResponseException(System.Label.Access_Token_is_null);
    }
}
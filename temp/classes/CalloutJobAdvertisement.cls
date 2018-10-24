public class CalloutJobAdvertisement {
    public class ResponseException extends Exception {}
    
    static String consumerKey = '3MVG9zlTNB8o8BA0XTN2CO6T58S141MYGoKwpPNaqqNeDih8dq05nznO1uhv0d_wri59hb1dhe1oqyTNKtg_m';
	static String consumerSecret = '3281958042781871073';
	static String username = 'yagamiraito765@gmail.com';
	static String password = 'mypassword1sOQZsZi0SDkBm8rAn2bRgzja';
    static String request = 'grant_type=password&client_id=' + consumerKey +'&client_secret=' + consumerSecret +
        							'&username=' + username + '&password=' + password;
    
    public static String buildAccessTokenBody(){
        String requestBody = request;
        return request;
    }
    
    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}    
	}
    
    public static Position__c getPosition(Id positionId){
        Position__c ourPosition = [SELECT Id, Name, Location__c, Job_Description__c, Salary_Range__c, Skills_Required__c, Education__c,
                     	   		   Hiring_Manager__r.Name, Email__c, Phone__c
                     	   		   FROM Position__c WHERE Id =: positionId];
        return ourPosition;
    }
    
    public static HttpRequest createRequestForToken(String service){
        String requestBody = buildAccessTokenBody();
        HttpRequest ourRequest = new HttpRequest();
        ourRequest.setBody(requestBody);
		ourRequest.setMethod(service);
    	ourRequest.setEndpoint('https://na59.salesforce.com/services/oauth2/token');  //Стандартная ссылка для токена
        return ourRequest;
    }
    
    public static HttpRequest createRequestForService(String token, String method, String endpointUrl){
		HttpRequest finalRequest = new HttpRequest();
        finalRequest.setHeader('Authorization','Bearer ' + token);
        finalRequest.setHeader('Content-Type','application/json');
        finalRequest.setHeader('accept','application/json');
  		finalRequest.setMethod(method);
        finalRequest.setEndpoint('https://na59.salesforce.com/services/apexrest/jobAdvertisementEndpoint/' + endpointUrl);
		return finalRequest;
	}
    
    public static String generateJSON(Position__c pos){
		Map<String, String> fieldMap = new Map<String, String>{
			'Name' => pos.Name,
			'Description__c' => pos.Job_Description__c,
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
        HttpRequest requestForToken = createRequestForToken('GET');  //Создаем HTTP-запрос на отправку токен-данных.
        HttpResponse responseToken = ourHttp.send(requestForToken);  //Отправляем HTTP-запрос и получаем ответ в JSON-формате.
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            HttpRequest requestForService = createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'GET', '');
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('ALL EXISTING Job Advertisements:  ' + responseService.getBody());
                return responseService;
            }else {
                throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
    
    public static HttpResponse postCalloutResponseContents(Id positionId) {
        Http ourHttp = new Http();
        HttpRequest requestForToken = createRequestForToken('POST'); 
        HttpResponse responseToken = ourHttp.send(requestForToken);      
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            Position__c ourPosition = getPosition(positionId);
            HttpRequest requestForService = createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'POST', '');
            requestForService.setBody(generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('CREATED Job Advertisement:  ' + responseService.getBody());
                return responseService;
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
        
    public static HttpResponse deleteCalloutResponseContents(Id positionId){
        Http ourHttp = new Http();
        HttpRequest requestForToken = createRequestForToken('GET');
    	HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            Position__c ourPosition = getPosition(positionId);
            HttpRequest requestForService = createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'DELETE', ourPosition.Id);
            requestForService.setBody(generateJSON(ourPosition));
            System.debug('Job Advertisement BEFORE DELETION:  ' + generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                System.debug('NO CONTENT. ' + responseService.getBody());
                return responseService;
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
    
    public static HttpResponse putCalloutResponseContents(Id positionId){
        Http ourHttp = new Http();
        HttpRequest requestForToken = createRequestForToken('GET');
    	HttpResponse responseToken = ourHttp.send(requestForToken);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(responseToken.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            Position__c ourPosition = getPosition(positionId);
            HttpRequest requestForService = createRequestForService(objAuthenticationInfo.ACCESS_TOKEN, 'POST', ourPosition.Id + '?_HttpMethod=PATCH');
            requestForService.setBody(generateJSON(ourPosition));
            System.debug('Job Advertisement TO CHANGE:  ' + generateJSON(ourPosition));
            HttpResponse responseService = ourHttp.send(requestForService);
            if(responseService.getStatusCode() == 200) {
                return responseService;
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
}
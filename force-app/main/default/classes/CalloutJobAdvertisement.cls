public class CalloutJobAdvertisement {
    public class ResponseException extends Exception {}
    public static Position__c ourPosition{get;set;}
    
    public static String accessTokenBody(){  //Токен-данные
        String consumerKey = '3MVG9zlTNB8o8BA0XTN2CO6T58S141MYGoKwpPNaqqNeDih8dq05nznO1uhv0d_wri59hb1dhe1oqyTNKtg_m';
		String consumerSecret = '3281958042781871073';
		String username = 'yagamiraito765@gmail.com';
		String password = 'mypassword1sOQZsZi0SDkBm8rAn2bRgzja';
    	String request = 'grant_type=password&client_id=' + consumerKey +'&client_secret=' + consumerSecret +
            			 '&username=' + username + '&password=' + password;
        return request;
    }
    
    public class OAuth2{
 		public String ACCESS_TOKEN{get;set;}    
	}
    
    public static HttpRequest httpRequest(String service){
        String requestBody = accessTokenBody();
        HttpRequest ourRequest = new HttpRequest();
        ourRequest.setBody(requestBody);
		ourRequest.setMethod(service);
    	ourRequest.setEndpoint('https://na59.salesforce.com/services/oauth2/token');  //Стандартная ссылка для токена
        return ourRequest;
    }
    
    public static HttpRequest finalHttpRequest(String token, String method, String endpointUrl){
		HttpRequest finalRequest = new HttpRequest();
        finalRequest.setHeader('Authorization','Bearer ' + token);
        finalRequest.setHeader('Content-Type','application/json');
        finalRequest.setHeader('accept','application/json');
  		finalRequest.setMethod(method);
        finalRequest.setEndpoint('https://na59.salesforce.com/services/apexrest/jobAdvertisementEndpoint/' + endpointUrl);
		return finalRequest;
	}
    
    public static String GenerateJSON(Position__c pos){
		Map<String, String> fieldMap = new Map<String, String>{
			'Name' => pos.Name,
			'Description__c' => pos.Job_Description__c,
			'Skills_Required__c' => pos.Skills_Required__c,
			'Education__c' => pos.Education__c,
			'Manager_Name__c' => pos.Hiring_Manager__r.Name,
			'Email__c' => pos.Email__c,
			'Phone__c' => pos.Phone__c,
			'Position_ID__c' => pos.Id};       
        String serialized = JSON.serialize(fieldMap);         
        return serialized;
     }

    public static HttpResponse getCalloutResponseContents() {      
    	Http ourHttp = new Http();
        HttpRequest request = httpRequest('GET');  //Создаем HTTP-запрос на отправку токен-данных.
        HttpResponse response = ourHttp.send(request);  //Отправляем HTTP-запрос и получаем ответ в JSON-формате.
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            HttpRequest finalRequest = finalHttpRequest(objAuthenticationInfo.ACCESS_TOKEN, 'GET', '');
            HttpResponse finalResponse = ourHttp.send(finalRequest);
            if(finalResponse.getStatusCode() == 200) {
                System.debug('ALL EXISTING Job Advertisements:  ' + finalResponse.getBody());
                return finalResponse;
            }else {
                throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
    
    public static HttpResponse postCalloutResponseContents(String positionId) {  //'a0A1r00002vIrEVEA0'
        Http ourHttp = new Http();
        HttpRequest request = httpRequest('POST'); 
        HttpResponse response = ourHttp.send(request);      
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            Position__c ourPosition = [SELECT Id, Name, Location__c, Job_Description__c, Salary_Range__c, Skills_Required__c, Education__c,
                     	   			   Hiring_Manager__r.Name, Email__c, Phone__c, Status__c
                     	   			   FROM Position__c WHERE Id =: positionId];
            HttpRequest finalRequest = finalHttpRequest(objAuthenticationInfo.ACCESS_TOKEN, 'POST', '');
            finalRequest.setBody(GenerateJSON(ourPosition));
            HttpResponse finalResponse = ourHttp.send(finalRequest);
            if(finalResponse.getStatusCode() == 200) {
                System.debug('CREATED Job Advertisement:  ' + finalResponse.getBody());
                return finalResponse;
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
        
    public static HttpResponse deleteCalloutResponseContents(Id positionId){  //'a0A1r00002vIrEVEA0'
        Http ourHttp = new Http();
        HttpRequest request = httpRequest('GET');
    	HttpResponse response = ourHttp.send(request);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            ourPosition = [SELECT Id, Name, Location__c, Job_Description__c, Salary_Range__c, Skills_Required__c, Education__c,
                     Hiring_Manager__r.Name, Email__c, Phone__c, Status__c
                     FROM Position__c WHERE Id =: positionId];
            HttpRequest finalRequest = finalHttpRequest(objAuthenticationInfo.ACCESS_TOKEN, 'DELETE', ourPosition.Id);
            finalRequest.setBody(GenerateJSON(ourPosition));
            System.debug('Job Advertisement BEFORE DELETION:  ' + GenerateJSON(ourPosition));
            HttpResponse finalResponse = ourHttp.send(finalRequest);
            if(finalResponse.getStatusCode() == 200) {
                System.debug('NO CONTENT. ' + finalResponse.getBody());
                return finalResponse;
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
    
    public static HttpResponse putCalloutResponseContents(Id positionId){  //'a0A1r00002vIrEVEA0'
        Http ourHttp = new Http();
        HttpRequest request = httpRequest('GET');
    	HttpResponse response = ourHttp.send(request);
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);

		if(objAuthenticationInfo.ACCESS_TOKEN != null){
            ourPosition = [SELECT Id, Name, Location__c, Job_Description__c, Salary_Range__c, Skills_Required__c, Education__c,
                     Hiring_Manager__r.Name, Email__c, Phone__c, Status__c
                     FROM Position__c WHERE Id =: positionId];
            HttpRequest finalRequest = finalHttpRequest(objAuthenticationInfo.ACCESS_TOKEN, 'POST', ourPosition.Id + '?_HttpMethod=PATCH');
            finalRequest.setBody(GenerateJSON(ourPosition));
            System.debug('Job Advertisement TO CHANGE:  ' + GenerateJSON(ourPosition));
            HttpResponse finalResponse = ourHttp.send(finalRequest);
            if(finalResponse.getStatusCode() == 200) {
                return finalResponse;
            }else {
            	throw new ResponseException('Status code is not 200.');
            }
        }
        throw new ResponseException('Access Token is null.');
    }
}
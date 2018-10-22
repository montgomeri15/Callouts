@isTest
private class CalloutJobAdvertisementTest {
    
    static Position__c insertPosition(){
        Position__c position = new Position__c(Name = 'OurName');
        insert position;
        return position;
    }
    
    static String insertAccessTokenBody(){  //Токен-данные
        /*Settings__c settings = new Settings__c(Name = 'OurSettings',
                               				   ConsumerKey__c = '234234234',
                               				   ClientSecret__c = '678678678',
                               				   Username__c = 'mail@mail.com',
                               				   SecurityToken__c = '12312321213',
                               				   Password__c = 'mypassword1');
        insert settings;
        
        String consumerKey = settings.ConsumerKey__c;
		String consumerSecret = settings.ClientSecret__c;
		String username = settings.Username__c;
		String password = settings.Password__c + settings.SecurityToken__c;
    	String request = 'grant_type=password&client_id=' + consumerKey +'&client_secret=' + consumerSecret +
            			 '&username=' + username + '&password='+password;*/
        
        String consumerKey = '234234234';
		String consumerSecret = '678678678';
		String username = 'mail@mail.com';
		String password = '12312321213';
    	String request = 'grant_type=password&client_id=' + consumerKey +'&client_secret=' + consumerSecret +
            			 '&username=' + username + '&password='+password;
        
        return request;
    }
    
    //GET
    
    @isTest
    static void testGetCallout() {         
        String request = insertAccessTokenBody();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest();
  		HttpResponse response = CalloutJobAdvertisement.getCalloutResponseContents();
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName"}';
        
    	System.debug('GET Callout:   ' + response.getBody());
        System.assert(contentType == 'application/json');
    	System.assertEquals(actualValue, expectedValue);
    	System.assertEquals(200, response.getStatusCode());
	}
    
    @isTest
    static void testGetCalloutNot200() {         
        String request = insertAccessTokenBody();
        HttpResponse response;      
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
 		try {
            Test.startTest();
  			response = CalloutJobAdvertisement.getCalloutResponseContents();
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
		}
	}
    
    @isTest
    static void testGetCalloutNoToken() {         
        String request = insertAccessTokenBody();
        HttpResponse response;  
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
 		try {
            Test.startTest();
  			response = CalloutJobAdvertisement.getCalloutResponseContents();
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
		}
	}
        
    //POST
    
    @isTest
    static void testPostCallout() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest(); 
 		HttpResponse response = CalloutJobAdvertisement.postCalloutResponseContents(testPosition.Id);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName"}';
        
    	System.debug('POST Callout:   ' + response.getBody());	
        System.assert(contentType == 'application/json');
    	System.assertEquals(actualValue, expectedValue);
    	System.assertEquals(200, response.getStatusCode());  
	}
    
    @isTest
    static void testPostCalloutNot200() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;     
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
 		try {
            Test.startTest();
  			response = CalloutJobAdvertisement.postCalloutResponseContents(testPosition.Id);
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
		}
	}
    
    @isTest
    static void testPostCalloutNoToken() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
 		try {
            Test.startTest();
  			response = CalloutJobAdvertisement.postCalloutResponseContents(testPosition.Id);
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
		}
	}
    
    //DELETE
    
    @isTest
    static void testDeleteCallout() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest(); 
 		HttpResponse response = CalloutJobAdvertisement.deleteCalloutResponseContents(testPosition.Id);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName"}';
        
    	System.debug('DELETE Callout:   ' + response.getBody());
        System.assert(contentType == 'application/json');    	
    	System.assertEquals(actualValue, expectedValue);
    	System.assertEquals(200, response.getStatusCode());   
	}
    
    @isTest
    static void testDeleteCalloutNot200() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
 		try {
            Test.startTest(); 
  			response = CalloutJobAdvertisement.deleteCalloutResponseContents(testPosition.Id);
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
		}
	}
    
    @isTest
    static void testDeleteCalloutNoToken() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
 		try {
            Test.startTest();
  			response = CalloutJobAdvertisement.deleteCalloutResponseContents(testPosition.Id);
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
		} 
	}
    
    //PUT
    
    @isTest    
    static void testPutCallout(){
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest(); 
 		HttpResponse response = CalloutJobAdvertisement.putCalloutResponseContents(testPosition.Id);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName"}';
        
    	System.debug('PUT Callout:   ' + response.getBody());
        System.assert(contentType == 'application/json');
    	System.assertEquals(actualValue, expectedValue);
    	System.assertEquals(200, response.getStatusCode());
    }
    
    @isTest
    static void testPutCalloutNot200() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
 		try {
            Test.startTest(); 
  			response = CalloutJobAdvertisement.putCalloutResponseContents(testPosition.Id);
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
		}
	}
    
    @isTest
    static void testPutCalloutNoToken() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
 		try {
            Test.startTest();
  			response = CalloutJobAdvertisement.putCalloutResponseContents(testPosition.Id);
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
		}
	}
}
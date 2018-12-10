@isTest
private class CalloutJobAdvertisementTest {
    
    static Position__c insertPosition(){
        Position__c position = new Position__c(Name = 'OurName');
        insert position;
        return position;
    }
    
    static String insertAccessTokenBody(){  //Токен-данные
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
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', ''));
        
        Test.startTest();
  			HttpResponse response = CalloutJobAdvertisement.getCalloutResponseContents();
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName", "Position_ID__c":""}';
        
    	System.debug('GET Callout:   ' + response.getBody());
        System.assert(contentType == 'application/json');
    	System.assertEquals(actualValue, expectedValue);
    	System.assertEquals(200, response.getStatusCode());
	}
    
    @isTest
    static void testGetCalloutNot200() {         
        String request = insertAccessTokenBody();
        HttpResponse response;      
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', ''));
        
 		try {
            Test.startTest();
  				response = CalloutJobAdvertisement.getCalloutResponseContents();
            Test.stopTest();
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Status_code_is_not_200, e.getMessage());
		}
	}
    
    @isTest
    static void testGetCalloutNoToken() {         
        String request = insertAccessTokenBody();
        HttpResponse response;  
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', ''));
        
 		try {
            Test.startTest();
  				response = CalloutJobAdvertisement.getCalloutResponseContents();
            Test.stopTest();
            System.assertEquals(200, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Access_Token_is_null, e.getMessage());
		}
	}
        
    //POST
    
    @isTest
    static void testPostCallout() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', ''));
        
        Test.startTest();
 			HttpResponse response = CalloutJobAdvertisement.postCalloutResponseContents(testPosition.Id);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName", "Position_ID__c":""}';
        
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
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', ''));
        
 		try {
            Test.startTest();
  				response = CalloutJobAdvertisement.postCalloutResponseContents(testPosition.Id);
            Test.stopTest();
            System.assertEquals(500, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Status_code_is_not_200, e.getMessage());
		}
	}
    
    @isTest
    static void testPostCalloutNoToken() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', ''));
        
 		try {
            Test.startTest();
  				response = CalloutJobAdvertisement.postCalloutResponseContents(testPosition.Id);
            Test.stopTest();
            System.assertEquals(200, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Access_Token_is_null, e.getMessage());
		}
	}
    
    //DELETE
    
    @isTest
    static void testDeleteCallout() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
 			HttpResponse response = CalloutJobAdvertisement.deleteCalloutResponseContents(testPosition.Id);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName", "Position_ID__c":"'+ testPosition.Id +'"}';
        
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
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', testPosition.Id));
        
 		try {
            Test.startTest(); 
  				response = CalloutJobAdvertisement.deleteCalloutResponseContents(testPosition.Id);
            Test.stopTest();
            System.assertEquals(500, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Status_code_is_not_200, e.getMessage());
		}
	}
    
    @isTest
    static void testDeleteCalloutNoToken() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', testPosition.Id));
        
 		try {
            Test.startTest();
  				response = CalloutJobAdvertisement.deleteCalloutResponseContents(testPosition.Id);
            Test.stopTest();
            System.assertEquals(200, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Access_Token_is_null, e.getMessage());
		} 
	}
    
    //PUT
    
    @isTest    
    static void testPutCallout(){
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest(); 
 			HttpResponse response = CalloutJobAdvertisement.putCalloutResponseContents(testPosition.Id);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        String expectedValue = '{"Name":"OurName", "Position_ID__c":"'+ testPosition.Id +'"}';
        
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
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', testPosition.Id));
        
 		try {
            Test.startTest(); 
  				response = CalloutJobAdvertisement.putCalloutResponseContents(testPosition.Id);
            Test.stopTest();
            System.assertEquals(500, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Status_code_is_not_200, e.getMessage());
		}
	}
    
    @isTest
    static void testPutCalloutNoToken() {         
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', testPosition.Id));
        
 		try {
            Test.startTest();
  				response = CalloutJobAdvertisement.putCalloutResponseContents(testPosition.Id);
            Test.stopTest();
            System.assertEquals(200, response.getStatusCode());
		} catch(CalloutJobAdvertisement.ResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Access_Token_is_null, e.getMessage());
		}
	}
    
    //TRIGGER
    
    @isTest
    static void testUpdateStatusTrigger() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        testPosition.Status__c = 'Closed';
        update testPosition;
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        	CalloutJobAdvertisementHelper.changeStatusCallout(testPosition.Id, JSON.serialize(testPosition));
        Test.stopTest();
        System.assertEquals(1, Limits.getFutureCalls());  //Методы Limits возвращают конкретный предел, напр. кол-во вызовов метода.
        												  //getFutureCalls() возвращает количество future-методов, которые были выполнены (не обязательно завершены). 
    }
    
    @isTest
    static void testDeletePositionTrigger() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        delete testPosition;
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        	CalloutJobAdvertisementHelper.changeStatusCallout(testPosition.Id, JSON.serialize(testPosition));
        Test.stopTest();
        System.assertEquals(1, Limits.getFutureCalls()); 
    }
    
    @isTest
    static void testUpdateStatusTriggerNot200() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        testPosition.Status__c = 'Closed';
        update testPosition;
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', testPosition.Id));
        
        try {
            Test.startTest();
  				CalloutJobAdvertisementHelper.changeStatusCallout(testPosition.Id, JSON.serialize(testPosition));
            Test.stopTest();
		} catch(CalloutJobAdvertisementHelper.HelperResponseException e) {
            System.debug('ERROR 200:   ' + e);
            System.assertEquals(System.Label.Status_code_is_not_200, e.getMessage());
		}
        System.assertEquals(1, Limits.getFutureCalls());
    }
    
    @isTest
    static void testUpdateStatusTriggerNoToken() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        testPosition.Status__c = 'Closed';
        update testPosition;
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', testPosition.Id));
        
        try {
            Test.startTest();
  				CalloutJobAdvertisementHelper.changeStatusCallout(testPosition.Id, JSON.serialize(testPosition));
            Test.stopTest();
		} catch(CalloutJobAdvertisementHelper.HelperResponseException e) {
            System.debug('TOKEN ERROR:   ' + e);
            System.assertEquals(System.Label.Access_Token_is_null, e.getMessage());
		}
        System.assertEquals(1, Limits.getFutureCalls());
    }
    
    @isTest
    static void testUpdateStatusTriggerWrongStatus() {
        String request = insertAccessTokenBody();
        Position__c testPosition = insertPosition();
        testPosition.Status__c = 'New';
        update testPosition;
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        	CalloutJobAdvertisementHelper.changeStatusCallout(testPosition.Id, JSON.serialize(testPosition));
        Test.stopTest();
        System.assertEquals(0, Limits.getFutureCalls());
    }
}
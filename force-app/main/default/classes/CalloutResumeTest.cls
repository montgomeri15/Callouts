@isTest
private class CalloutResumeTest {
    static CalloutResume calloutResume = new CalloutResume();
    static CalloutResumeRecordsForMock calloutResumeRecords = new CalloutResumeRecordsForMock();
    
    static Candidate__c insertCandidate(){
        Candidate__c candidate = new Candidate__c(
            First_Name__c = 'Name'
        );
        insert candidate;
        return candidate;
    }
    
    static ContentVersion getContentVersion(Id candidateId){
        ContentVersion contentVersion = new Contentversion(
            Title = 'TestTitle',
            PathOnClient = 'TestPath',
            VersionData = EncodingUtil.base64Decode(calloutResumeRecords.photoCode),
            FirstPublishLocationId = candidateId
        ); 
        return contentVersion;
    }
    
    static String insertAccessTokenBody(){
        String consumerKey = '234234234';
		String consumerSecret = '678678678';
		String username = 'mail@mail.com';
		String password = '12312321213';
    	String request = 'grant_type=password&client_id=' + consumerKey +'&client_secret=' + consumerSecret +
            			 '&username=' + username + '&password='+password;
        return request;
    }
    
    @isTest
    static void testGetCallout() {
        Candidate__c testCandidate = insertCandidate();
        List<Id> candidateIds = new List<Id>{ testCandidate.Id };
 
        ContentVersion contentVersion = getContentVersion(testCandidate.Id);
        List<ContentVersion> contentVersionListTest = new List<ContentVersion>{ contentVersion };
        insert contentVersionListTest;
        
        String request = insertAccessTokenBody();
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', ''));

        Test.startTest();
        	List<Candidate__c> candidatesList = calloutResume.getCalloutResponseContents();
        	HttpResponse response = calloutResume.responseService;
        	List<ContentVersion> contentVersionList = calloutResume.getContentVersionList(candidateIds);
        	calloutResume.deletePreviousFiles(candidateIds);
        	Database.executeBatch(new BatchResume(), 1000);
        Test.stopTest();
        
 		String contentType = response.getHeader('Content-Type');
        String actualValue = response.getBody();
        
        System.assert(contentType == 'application/json');
    	System.assertEquals(200, response.getStatusCode());
        System.assertEquals(candidatesList.size(), 1000);
        System.assertEquals(contentVersionListTest.get(0).Id, contentVersionList.get(0).Id);
	}
    
    @isTest
    static void testGetCalloutNot200() {         
        String request = insertAccessTokenBody();
        List<Candidate__c> candidatesList;
        HttpResponse response;
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', ''));
        
 		try {
            Test.startTest();
            	candidatesList = calloutResume.getCalloutResponseContents();
  				response = calloutResume.responseService;
            Test.stopTest();
		} catch(calloutResume.ResponseException e) {
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Status_code_is_not_200, e.getMessage());
            System.assertEquals(candidatesList, null);
		}
	}
    
    @isTest
    static void testGetCalloutNoToken() {         
        String request = insertAccessTokenBody();
        List<Candidate__c> candidatesList;
        HttpResponse response;    
 		Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', ''));
        
 		try {
            Test.startTest();
  				candidatesList = calloutResume.getCalloutResponseContents();
  				response = calloutResume.responseService;
            Test.stopTest();
            System.assertEquals(200, response.getStatusCode());
		} catch(calloutResume.ResponseException e) {
            System.assertEquals(response, null);
            System.assertEquals(System.Label.Access_Token_is_null, e.getMessage());
            System.assertEquals(candidatesList, null);
		}
	}
}
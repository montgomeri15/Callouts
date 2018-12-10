@isTest
private class FileUploaderTest {
        
    static Candidate__c insertCandidate(){
        Candidate__c testCandidate = new Candidate__c(
            First_Name__c = 'Candidate'
        );
        insert testCandidate;
        return testCandidate;
    }
    
    private static List<Candidate__c> candidatesList(){
        List<Candidate__c> candidates = [SELECT Id, First_Name__c
                                         FROM Candidate__c
                                         WHERE First_Name__c =: 'Candidate'];
        return candidates;
    }
    
    static ContentVersion getContentVersion(Id candidateId){
        ContentVersion contentVersion = new Contentversion(
            Title = 'TestTitle',
            PathOnClient = 'TestPath',
            VersionData = EncodingUtil.base64Decode('/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0//Z'),
            FirstPublishLocationId = candidateId
        ); 
        return contentVersion;
    }
  
    @isTest
    static void uploadTestFile(){
        Candidate__c candidate = insertCandidate();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(candidate);
        FileUploaderController controllerClass = new FileUploaderController(controller);
        
        ContentVersion contentVersion = getContentVersion(candidate.Id);
        insert contentVersion;
        controllerClass.title = contentVersion.Title;
        controllerClass.pathOnClient = contentVersion.PathOnClient;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'image/jpeg';
                
        Test.startTest();
        	controllerClass.uploadFile();
        Test.stopTest();        
        
        System.assertEquals(false, ApexPages.hasMessages());
    }
    
    //BAD SCENARIOS
    
    @isTest
    static void uploadWithoutPathOnClient(){
        Candidate__c candidate = insertCandidate();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(candidate);
        FileUploaderController controllerClass = new FileUploaderController(controller);
        
        ContentVersion contentVersion = getContentVersion(candidate.Id);
        insert contentVersion;
        controllerClass.title = contentVersion.Title;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'image/jpeg';
                
        Test.startTest();
        	controllerClass.uploadFile();
        Test.stopTest();        
        
        System.assertEquals(true, ApexPages.hasMessages());
    }
    
    @isTest
    static void uploadWithoutVersionData(){
        Candidate__c candidate = insertCandidate();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(candidate);
        FileUploaderController controllerClass = new FileUploaderController(controller);
        
        ContentVersion contentVersion = getContentVersion(candidate.Id);
        insert contentVersion;
        controllerClass.title = contentVersion.Title;
        controllerClass.pathOnClient = contentVersion.PathOnClient;
        controllerClass.contentType = 'image/jpeg';
                
        Test.startTest();
        	controllerClass.uploadFile();
        Test.stopTest();        
        
        System.assertEquals(true, ApexPages.hasMessages());
    }
    
    @isTest
    static void uploadOverMaxSize(){
        Candidate__c candidate = insertCandidate();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(candidate);
        FileUploaderController controllerClass = new FileUploaderController(controller);
        
        controllerClass.IMAGE_MAX_SIZE = 0;
        
        ContentVersion contentVersion = getContentVersion(candidate.Id);
        insert contentVersion;
        controllerClass.title = contentVersion.Title;
        controllerClass.pathOnClient = contentVersion.PathOnClient;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'image/jpeg';
                
        Test.startTest();
        	controllerClass.uploadFile();
        Test.stopTest();        
        
        System.assertEquals(true, ApexPages.hasMessages());
    }
    
    @isTest
    static void uploadWrongContentType(){
        Candidate__c candidate = insertCandidate();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(candidate);
        FileUploaderController controllerClass = new FileUploaderController(controller);
        
        ContentVersion contentVersion = getContentVersion(candidate.Id);
        insert contentVersion;
        controllerClass.title = contentVersion.Title;
        controllerClass.pathOnClient = contentVersion.PathOnClient;
        controllerClass.versionData = contentVersion.VersionData;
        controllerClass.contentType = 'doc';
                
        Test.startTest();
        	controllerClass.uploadFile();
        Test.stopTest();        
        
        System.assertEquals(true, ApexPages.hasMessages());
    }
}
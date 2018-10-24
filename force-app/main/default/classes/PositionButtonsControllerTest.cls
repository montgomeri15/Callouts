@isTest
private class PositionButtonsControllerTest {
    
    static Position__c insertPosition(){
        Position__c position = new Position__c(Name = 'Test Name');
        insert position;
        return position;
    }
    
    //POST
    
    @isTest
    static void testPostButton(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest();
        PositionButtonsController.postJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Posted', PositionButtonsController.positionStatus);
        System.assertEquals('Congratulations! Your Job Advertisement posted successfully. Now you can remove or update this advertisement.',
                            PositionButtonsController.successResultMessage);
    }
    
    @isTest
    static void testPostButtonNot200(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
        Test.startTest();
        PositionButtonsController.postJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals('Posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testPostButtonNoToken(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id); 
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
        Test.startTest();
        PositionButtonsController.postJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals('Posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    //DELETE
    
    @isTest
    static void testDeleteButton(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Not posted', PositionButtonsController.positionStatus);
        System.assertEquals('Job Advertisement deleted successfully. If you want to work with this record just post a new advertisement.',
                            PositionButtonsController.successResultMessage);
    }
    
    @isTest
    static void testDeleteButtonNot200(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);    
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals('Not posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testDeleteButtonNoToken(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals('Not posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    //PUT
    
    @isTest
    static void testPutButton(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN'));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Job Advertisement updated successfully. All changes in the Position transferred to this advertisement.',
                            PositionButtonsController.successResultMessage);
    }
    
    @isTest
    static void testPutButtonNot200(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id);
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN'));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testPutButtonNoToken(){
        Position__c testPosition = insertPosition();
    	PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', testPosition.Id); 
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE'));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
}
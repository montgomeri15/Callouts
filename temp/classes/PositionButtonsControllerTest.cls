@isTest
private class PositionButtonsControllerTest {
    
    static void checkCurrentPage(Position__c position){
        PageReference pageRef = Page.PositionButtonsVF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', position.Id);
        PositionButtonsController controller = new PositionButtonsController(new ApexPages.StandardController(position));
    }
    
    static Position__c insertPosition(){
        Position__c position = new Position__c(Name = 'Test Name');
        insert position;
        checkCurrentPage(position);
        return position;
    }
    
    //POST
    
    @isTest
    static void testPostButton(){
        Position__c testPosition = insertPosition();
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', ''));
        
        Test.startTest();
        PositionButtonsController.postJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Posted', PositionButtonsController.positionStatus);
        System.assertEquals(System.Label.Post_JobAdv_Success_Result_Message, PositionButtonsController.successResultMessage);
    }
    
    @isTest
    static void testPostButtonNot200(){
        Position__c testPosition = insertPosition();
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', ''));
        
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
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', ''));
        
        Test.startTest();
        PositionButtonsController.postJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals('Posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testPostButtonExistsAlready(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.postJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    //DELETE
    
    @isTest
    static void testDeleteButton(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Not posted', PositionButtonsController.positionStatus);
        System.assertEquals(System.Label.Delete_JobAdv_Success_Result_Message, PositionButtonsController.successResultMessage);
    }
    
    @isTest
    static void testDeleteButtonNot200(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testDeleteButtonNoToken(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testDeleteButtonDoesNotExists(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', 'Something'));
        
        Test.startTest();
        PositionButtonsController.deleteJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Not posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    //PUT
    
    @isTest
    static void testPutButton(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals(System.Label.Update_JobAdv_Success_Result_Message, PositionButtonsController.successResultMessage);
    }
    
    @isTest
    static void testPutButtonNot200(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(500, 'ACCESS_TOKEN', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testPutButtonNoToken(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'OTHER_WORDS_HERE', testPosition.Id));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
    
    @isTest
    static void testPutButtonDoesNotExists(){
        Position__c testPosition = insertPosition();
    	Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', 'Something'));
        
        Test.startTest();
        PositionButtonsController.updateJobAdvertisement();
        Test.stopTest();
        
        System.assertEquals(PositionButtonsController.position.Id, testPosition.Id);
        System.assertEquals('Not posted', PositionButtonsController.positionStatus);
        System.assertNotEquals(null, PositionButtonsController.errorResultMessage);
    }
}
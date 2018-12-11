@isTest
private class CalloutEmailSendingTest {
    
    @isTest
    static void testEmailUtility(){
        CalloutEmailSending calloutEmailSending = new CalloutEmailSending();
        
        Test.StartTest();
        calloutEmailSending.notifyAdministrator(new List<String>{ 'test@test.com' }, 'error');
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
 
        System.assertEquals(1, invocations, 'An email has not been sent');
    }
}
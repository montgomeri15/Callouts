@isTest
private class ScheduleResumeTest {
    
    @isTest
    static void test(){
        Test.setMock(HttpCalloutMock.class, new CalloutJobAdvertisementMock(200, 'ACCESS_TOKEN', ''));
        SchedulableContext sc = null;
		ScheduleResume tsc = new ScheduleResume();
        
        Test.startTest();
			tsc.execute(sc);
        Test.stopTest();
    }
}
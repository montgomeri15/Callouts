global class ScheduleResume implements Schedulable {
    
    global void execute(SchedulableContext SC){
        
        BatchResume batchResume = new BatchResume();
        database.executebatch(batchResume);
    }
}
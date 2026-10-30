trigger JobsTrigger on Job__c (after update) {
    map<Id, Integer> completedByWorker = new map<Id, Integer>();
    for(Job__c job : trigger.new){
        Job__c oldJob = trigger.oldMap.get(job.Id);
        if(job.Status__c == 'Completed' && oldJob.Status__c != 'Completed' && job.Worker__c != null){
            Integer current = completedByWorker.containsKey(job.Worker__c) ? completedByWorker.get(job.Worker__c) : 0;
            completedByWorker.put(job.Worker__c, current+1);
        }
    }  
    if(!completedByWorker.isEmpty()){
        List<Worker__c> worker = [select Id, Jobs_completed__c from Worker__c where Id IN : completedByWorker.keySet()];
        for(Worker__c w : worker){
            w.Jobs_completed__c = (w.Jobs_completed__c == null ? 0 : w.Jobs_completed__c) + completedByWorker.get(w.Id);
        }
        update worker;
    }
}
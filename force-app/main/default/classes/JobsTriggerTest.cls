@isTest
private class JobsTriggerTest{
    
    @isTest
    static void completingJobsIncrementsWorkerCounter(){
        Worker__c w = new Worker__c(First_Name__c = 'Test', Last_Name__c = 'Worker', Phone_Number__c = '9999999999', Area_Pincode__c = '533876', Status__c = 'Pending');
        insert w;
        
        Customer__c c = new Customer__c(First_Name__c = 'Test', Last_Name__c = 'Customer');
        insert c;
        
        Skill__c s = new Skill__c(Name = 'Electrical', Category__c = 'Electrical');
        insert s;
        
        Service_Request__c sr = new Service_Request__c(Customer_SP__c = c.Id, Skill__c = s.Id, Status__c = 'New', Number_of_workers__c = 1);
        insert sr;
        
        List<Job__c> jobs = new List<Job__c>{
            new Job__c(Service_Request__c = sr.Id, Worker__c = w.Id, Status__c = 'Assigned', Amount__c = 100),
            new Job__c(Service_Request__c = sr.Id, Worker__c = w.Id, Status__c = 'Assigned', Amount__c = 100)
        };
        insert jobs;
        
        List<Job__c> toUpdate = new List<Job__c>();
        for(Job__c j : jobs){
            toUpdate.add(new Job__c(Id = j.Id, Status__c = 'Completed'));
        }
        Test.startTest();
        update toUpdate;
        Test.stopTest();
        
        w = [select Jobs_completed__c from Worker__c where Id = :w.Id];
        System.assertEquals(2, w.Jobs_completed__c, 'Two completed jobs should add 2 to the counter ');
    }
}
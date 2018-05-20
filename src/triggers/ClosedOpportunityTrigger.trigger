trigger ClosedOpportunityTrigger on Opportunity (before insert, before update) {
    Task[] tasks = new Task[0];
    for(Opportunity o : Trigger.new) {
        if (o.StageName == 'Closed Won') {
            Task t = new Task(Subject = 'Follow Up Test Task', WhatId = o.Id);
            tasks.add(t);
        }
    }
    if(tasks.size() > 0) insert tasks;
}
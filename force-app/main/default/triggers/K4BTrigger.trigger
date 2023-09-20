trigger K4BTrigger on K4B_Onboarding__c (before insert, after update) {
    new K4BTriggerHandler().run();
}
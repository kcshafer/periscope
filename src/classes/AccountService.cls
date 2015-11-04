public with sharing class AccountService {
    public static void manageAccounts(String braintreeId, String name) {
        //check if an account exists with the braintree id
        List<Account> accts = [SELECT Id, ParentId, Braintree_Id__c, Name FROM Account WHERE Braintree_Id__c = :braintreeId OR Name = :name];
        Account braintreeAcct;
        Account nameAcct;

        //get the braintree id or named account
        for(Account a : accts) {
            if(a.Braintree_Id__c == braintreeId) {
                braintreeAcct = a;
                break;
            }
            else if(a.Name == name) {
                nameAcct = a;
            }
        }

        //check if we have a braintree account find the parent account
        if(braintreeAcct != null) {
            //get the parent account by name
            List<Account> parentAccts = [SELECT Id FROM Account WHERE Name = :name AND Braintree_Id__c != :braintreeId AND ParentId = null];
            //make sure we have one account
            if(parentAccts.size() == 1) {
                braintreeAcct.ParentId = parentAccts[0].Id;
                update braintreeAcct;
            }
            else {
                throw new PeriscopeException('No parent account found.');
            }
        }
        else {
            Account acct = new Account(Name=name);
            //check if we have a name account, create a new account with that name assign the nameAcct as parent
            if(nameAcct != null) {
                acct.ParentId = nameAcct.Id;
            }

            insert acct;
        }
    }
}
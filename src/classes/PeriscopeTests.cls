@isTest
private class PeriscopeTests {
    
    public static testMethod void test_id_match_with_parent_success() {
        ////////////////////////////////////////
        //// test success match with bt id /////
        //// and parent match by name //////////
        ////////////////////////////////////////

        Account a = new Account(Name='Test 1', Braintree_Id__c='12345');
        Account pa = new Account(Name='Test 2');
        insert new List<Account>{a,pa};

        PeriscopeAPIService.PeriscopeRequest pr = new PeriscopeAPIService.PeriscopeRequest();
        pr.braintree_id = '12345';
        pr.name         = 'Test 2';

        test.startTest();
            PeriscopeAPIService.PeriscopeResult res = PeriscopeAPIService.doPost(pr);
        test.stopTest();

        a = [SELECT ParentId FROM Account WHERE Id = :a.Id];

        system.assertEquals(pa.Id, a.ParentId);
        system.assertEquals(200, res.status_code);
        system.assertEquals('Success', res.status);
    }
    
    public static testMethod void  test_id_match_no_parent_fail() {
        ////////////////////////////////////////
        //// test fail - match with bt id //////
        //// and no parent match b /////////////
        ////////////////////////////////////////

        Account a = new Account(Name='Test 1', Braintree_Id__c='12345');
        insert a;

        PeriscopeAPIService.PeriscopeRequest pr = new PeriscopeAPIService.PeriscopeRequest();
        pr.braintree_id = '12345';
        pr.name         = 'Test 2';

        test.startTest();
            PeriscopeAPIService.PeriscopeResult res = PeriscopeAPIService.doPost(pr);
        test.stopTest();

        a = [SELECT ParentId FROM Account WHERE Id = :a.Id];

        system.assertEquals(null, a.ParentId);
        system.assertEquals(400, res.status_code);
        system.assertEquals('No parent account found.', res.status);
    }

    public static testMethod void test_account_match_name_success() {
        ////////////////////////////////////////
        //// test success match account by /////
        //// name and created parent ///////////
        ////////////////////////////////////////

        Account a = new Account(Name='Test 1', Braintree_Id__c='12345');
        insert a;

        PeriscopeAPIService.PeriscopeRequest pr = new PeriscopeAPIService.PeriscopeRequest();
        pr.braintree_id = '54321';
        pr.name         = 'Test 1';

        test.startTest();
            PeriscopeAPIService.PeriscopeResult res = PeriscopeAPIService.doPost(pr);
        test.stopTest();

        List<Account> accts = [SELECT Id FROM Account WHERE Name = 'Test 1'];
        
        system.assertEquals(2, accts.size());
        system.assertEquals(200, res.status_code);
        system.assertEquals('Success', res.status);
    }

    public static testMethod void test_account_no_match_create_success() {
        ////////////////////////////////////////
        //// test success no match account /////
        //// by name => created acct ///////////
        ////////////////////////////////////////

        PeriscopeAPIService.PeriscopeRequest pr = new PeriscopeAPIService.PeriscopeRequest();
        pr.braintree_id = '54321';
        pr.name         = 'Test 1';

        test.startTest();
            PeriscopeAPIService.PeriscopeResult res = PeriscopeAPIService.doPost(pr);
        test.stopTest();

        List<Account> accts = [SELECT Id FROM Account WHERE Name = 'Test 1'];
        
        system.assertEquals(1, accts.size());
        system.assertEquals(200, res.status_code);
        system.assertEquals('Success', res.status);
    }

    public static testMethod void test_account_no_id_request_fail() {
        ////////////////////////////////////////
        //// test success match account by /////
        //// name and created parent ///////////
        ////////////////////////////////////////

        PeriscopeAPIService.PeriscopeRequest pr = new PeriscopeAPIService.PeriscopeRequest();
        pr.braintree_id = null;
        pr.name         = 'Test 1';

        test.startTest();
            PeriscopeAPIService.PeriscopeResult res = PeriscopeAPIService.doPost(pr);
        test.stopTest();

        system.assertEquals(400, res.status_code);
        system.assertEquals('Braintree Id cannot be null', res.status);
    }
    
}
@isTest
private class test_ContactTrigger {
    static testMethod void sets_email_when_no_email_exists_and_website_exists(){
    	Account nowebsiteAccount = new Account();
    	nowebsiteAccount.Name = 'nowebsiteAccount';
    	insert nowebsiteAccount;

    	Account httpsAccount = new Account();
    	httpsAccount.Name = 'httpsAccount';
    	httpsAccount.Website = 'https://test.com';
    	insert httpsAccount;

    	Account httpsWWWAccount = new Account();
    	httpsWWWAccount.Name = 'httpsAccount';
    	httpsWWWAccount.Website = 'https://www.test.com';
    	insert httpsWWWAccount;

    	Account httpAccount = new Account();
    	httpAccount.Name = 'httpAccount';
    	httpAccount.Website = 'http://test.com';
    	insert httpAccount;

    	Account httpWWWAccount = new Account();
    	httpWWWAccount.Name = 'httpWWWAccount';
    	httpWWWAccount.Website = 'http://www.test.com';
    	insert httpWWWAccount;

    	Account subdomainAccount = new Account();
    	subdomainAccount.Name = 'subdomainAccount';
    	subdomainAccount.Website = 'http://test.test.com';
    	insert subdomainAccount;

    	Contact noEmailContact = new Contact();
    	noEmailContact.FirstName = 'https';
    	noEmailContact.LastName = 'Contact';
    	noEmailContact.AccountId = nowebsiteAccount.Id;
    	insert noEmailContact;

    	Contact reloaded_noEmailContact = [SELECT Email FROM Contact WHERE Id = :noEmailContact.Id];

    	System.assertEquals('', reloaded_noEmailContact.Email);

    	Contact httpsContact = new Contact();
    	httpsContact.FirstName = 'https';
    	httpsContact.LastName = 'Contact';
    	httpsContact.AccountId = httpsAccount.Id;
    	insert httpsContact;

    	Contact reloaded_httpsContact = [SELECT Email FROM Contact WHERE Id = :httpsContact.Id];

    	System.assertEquals('https.contact@test.com', reloaded_httpsContact.Email);

    	Contact httpsWWWContact = new Contact();
    	httpsWWWContact.FirstName = 'https';
    	httpsWWWContact.LastName = 'WWWContact';
    	httpsWWWContact.AccountId = httpsWWWAccount.Id;
    	insert httpsWWWContact;

    	Contact reloaded_httpsWWWContact = [SELECT Email FROM Contact WHERE Id = :httpsWWWContact.Id];

    	System.assertEquals('https.wwwcontact@test.com', reloaded_httpsWWWContact.Email);

    	Contact httpContact = new Contact();
    	httpContact.FirstName = 'http';
    	httpContact.LastName = 'Contact';
    	httpContact.AccountId = httpAccount.Id;
    	insert httpContact;

    	Contact reloaded_httpContact = [SELECT Email FROM Contact WHERE Id = :httpContact.Id];

    	System.assertEquals('http.contact@test.com', reloaded_httpContact.Email);

    	Contact httpWWWContact = new Contact();
    	httpWWWContact.FirstName = 'http';
    	httpWWWContact.LastName = 'WWWContact';
    	httpWWWContact.AccountId = httpWWWAccount.Id;
    	insert httpWWWContact;

    	Contact reloaded_httpWWWContact = [SELECT Email FROM Contact WHERE Id = :httpWWWContact.Id];

    	System.assertEquals('http.wwwcontact@test.com', reloaded_httpWWWContact.Email);

    	Contact subdomainContact = new Contact();
    	subdomainContact.FirstName = 'subdomain';
    	subdomainContact.LastName = 'Contact';
    	subdomainContact.AccountId = subdomainAccount.Id;
    	insert subdomainContact;
    	
    	Contact reloaded_subdomainContact = [SELECT Email FROM Contact WHERE Id = :subdomainContact.Id];

    	System.assertEquals('subdomain.contact@test.com', reloaded_subdomainContact.Email);
    }
}
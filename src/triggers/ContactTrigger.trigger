trigger ContactTrigger on Contact ( before insert ) {
	// Before Insert
	if ( Trigger.isBefore && Trigger.isInsert ){
		// Grab All Account Ids for website attribute query
		Id[] accountIds = new Id[0];
		for ( Contact c : Trigger.new ) {
			accountIds.add(c.AccountId);
		}
		// For query performance, query all at once
		Account[] accounts = [SELECT Id, Website FROM Account WHERE Id IN :accountIds];
		Map<Id,String> accountIdToWebsite = new Map<Id,String>();
		// Create a map of Account Id to website String
		for ( Account a : accounts ) {
			accountIdToWebsite.put(a.Id, a.Website);
		}
		// For each contact
		for ( Contact c : Trigger.new ) {
			// If there is an empty email field and the contact has an account
			if ( String.isEmpty(c.Email) && c.AccountId != null ) {
				// As well as the account has a website
				if ( !String.isEmpty( accountIdToWebsite.get(c.AccountId) ) ) {
					String email = '';
					// Concat First and Last name
					if ( !String.isEmpty(c.FirstName) && !String.isEmpty(c.LastName) ) {
						email = c.FirstName + '.' + c.LastName;
					}
					// Use only Last Name if no first
					if ( String.isEmpty(c.FirstName) && !String.isEmpty(c.LastName) ) {
						email = c.LastName;
					}
					// just in case the required LastName is removed
					if ( !String.isEmpty(c.FirstName) && String.isEmpty(c.LastName) ) {
						email = c.FirstName;
					}
					// If for some reason no first or last name, continue in loop
					if ( email == '' ) continue;
					// Grab website off Account Map
					String url = accountIdToWebsite.get(c.AccountId);
					// Split the website by the period character
					String[] parts = accountIdToWebsite.get(c.AccountId).split('\\.');
					try{
						// Grab the domain name and the (com|net|org|whatever)
						email = email + '@' + parts[parts.size()-2] + '.' + parts[parts.size()-1]; 
						// Strip the https:// or http://
						email = email.replaceFirst('https://','').replaceFirst('http://','');
						// Assign the email
						c.Email = email;
					}catch(System.ListException e){ 
						// Catch the list out of bounds exception if for some reason there are no period characters, Send a message to the logs
						System.debug('Could not update Contact Id: \'' + c.Id + '\' Email with Parent Account Id: \'' + c.AccountId + '\' Website: \'' + accountIdToWebsite.get(c.AccountId) + '\'');
					}
				}
			}	
		}
	}
}
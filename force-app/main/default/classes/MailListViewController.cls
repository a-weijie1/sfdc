public with sharing class MailListViewController 
{    
    // Constructor with no implementation...
    public MailListViewController(){}

    @AuraEnabled
    public static string submitAction()
    {
        Id currentUserId = UserInfo.getUserId();
        
        if (hasExistingSignUp(currentUserId))
            return 'Sorry, your User is already signed up to Wired Brain Mail.';

        User currentUser = retrieveUser(currentUserId);
        signUp(currentUser);        
        String signedUpMessage = 'You\'re now signed up, ' + currentUser.FirstName + '!';
        return signedUpMessage;
    }

    @AuraEnabled
    public static string unsubscribe()
    {
        Id currentUserId = UserInfo.getUserId();
        if (hasExistingSignUp(currentUserId))
            return addUnsubcribeDate(currentUserId);

        return 'Could not locate an existing sign up to unsubscribe to. I think you\'re fine!';
    }

    public static string addUnsubcribeDate(Id userId)
    {
        System.debug('Unsubscribing User: ' + userId);
        Wired_Mail_Sign_Up__c currentUserSignup = [SELECT Id, 
                                                        User__c,
                                                        Sign_Up_Date__c, 
                                                        Unsubscribe_Date__c 
                                                    FROM Wired_Mail_Sign_Up__c
                                                    WHERE Sign_Up_Date__c != null
                                                        AND Unsubscribe_Date__c = null
                                                        AND User__c = :userId
                                                    LIMIT 1];

        update new Wired_Mail_Sign_Up__c(Id = currentUserSignup.Id, Unsubscribe_Date__c = Date.today());
        System.debug('User unsubscribed');
        return 'You\'re now unsubscribed. No more Wired Announcements for you!';        
    }

    public static Boolean hasExistingSignUp(Id userId)
    {
        List<Wired_Mail_Sign_Up__c> existingSignUps = [SELECT Id, User__c 
                                                        FROM Wired_Mail_Sign_Up__c 
                                                        WHERE User__c = :userId
                                                        AND Unsubscribe_Date__c = null];
        
        if (existingSignUps.size() > 0)
            return true;
        else
            return false;
    }
    
    public static User retrieveUser(Id userId)
    {
        User currentUser = [SELECT Id, FirstName, LastName, Email
                             FROM User WHERE Id = :userId];
        return currentUser;
    }

    public static Wired_Mail_Sign_Up__c signUp(User user)
    {        
        Wired_Mail_Sign_Up__c signup = new Wired_Mail_Sign_Up__c(
            User__c = user.Id,
            Sign_Up_Date__c = Date.today()
        );
        insert signup;
        System.enqueueJob(new WiredAnnouncementsSharing(new List<User>{user}));
        return signup;
    }
}

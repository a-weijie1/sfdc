public without sharing class TestingService 
{
    public void generalTestSetup()
    {
        Profile adminProfile = [SELECT Id, Name 
                                FROM Profile
                                WHERE Name = 'System Administrator' 
                                LIMIT 1];

        insert new User(FirstName='Test', 
            LastName='User',
            Username = 'testuser@elegacorp.com',
            Email = 'testuser@elegacorp.com',
            Alias = 'tuser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'America/Chicago',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = adminProfile.Id,
            LanguageLocaleKey = 'en_US');
    }

    public User getTestUser()
    {
        User currentUser = [SELECT Id, FirstName, LastName 
                            FROM User 
                            WHERE FirstName = 'Test'
                                AND LastName = 'User'
                            LIMIT 1];
        return currentUser;
    }
}
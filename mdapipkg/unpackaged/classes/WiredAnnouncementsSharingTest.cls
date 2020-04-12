@isTest
private class WiredAnnouncementsSharingTest 
{
    @testsetup
    static void setup()
    {
      new TestingService().generalTestSetup();
    }
    
    @isTest
    static void getRecentAnnouncements()
    {
        insert new Wired_Announcement__c(
            Subject__c = 'Introducing Test!',
            Body__c = 'We\'re proud to announce a brand new test, featuring...'
        );

        // No real Users are needed to test the query for retrieving recent announcements...
        List<User> emptyUsersList = new List<User>();

        Test.startTest();
        List<Wired_Announcement__c> announcements = new WiredAnnouncementsSharing(emptyUsersList).getRecentAnnouncements();
        Test.stopTest();

        System.assertEquals(1, announcements.size(), 
            'No announcements retrieved from query');
    }

    @isTest
    static void getExistingShares()
    {
        User testUser = new TestingService().getTestUser();
        System.assert(testUser != null, 'Test User not found');

        Test.startTest();
        Id announcementId = null;
        System.runAs(testUser)
        {
            Wired_Announcement__c announcement = new Wired_Announcement__c(
                Subject__c = 'Now Share This',
                Body__c = 'This is an announcement that should get shared, honestly...'
            );
            insert announcement;
            announcementId = announcement.Id;
        }

        Map<Id, Set<Id>> userIdToParentIds = new WiredAnnouncementsSharing(new List<User>{testUser}).getExistingShares(new Set<Id>{announcementId});
        Test.stopTest();

        Map<Id, Set<Id>> expectedSet = new Map<Id, Set<Id>>{testUser.Id => new Set<Id>{announcementId}};
        System.assertEquals(expectedSet, userIdToParentIds, 
            'userIdToParentIds output from getExistingShares not as expected');
    }

    @isTest
    static void grantViewSharing()
    {
        User testUser = new TestingService().getTestUser();
        
        // Create 200 recent Announcements
        List<Wired_Announcement__c> recentAnnouncements = new List<Wired_Announcement__c>();
        Integer numberOfAnnouncements = 200;
        for (Integer i = 0, j = numberOfAnnouncements; i < j; i++)
            recentAnnouncements.add(new Wired_Announcement__c(
                Subject__c = 'Robotic Announcement ' + String.valueOf(i),
                Body__c = 'Beep boop, robotic announcement generated, beep boop boop...'
            ));
        insert recentAnnouncements;

        Set<Id> announcementIds = new Set<Id>();
        for (Integer x = 0, y = recentAnnouncements.size(); x < y; x++)
            announcementIds.add(recentAnnouncements[x].Id);

        Test.startTest();
        System.enqueueJob(new WiredAnnouncementsSharing(new List<User>{testUser}));
        Test.stopTest();

        List<Error__c> errors = [SELECT Id FROM Error__c];
        
        System.assertEquals(0, errors.size(), 
            'Errors found');

        List<Wired_Announcement__Share> shares = [SELECT Id, ParentId, UserOrGroupId
                                                FROM Wired_Announcement__Share
                                                WHERE UserOrGroupId = :testUser.Id
                                                    AND ParentId IN :announcementIds];

        System.assertEquals(200, shares.size(), 
            'Number of shares not as expected');
    }
}
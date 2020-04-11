public without sharing class WiredAnnouncementsSharing implements Queueable {
    
    public List<User> users;
    
    public WiredAnnouncementsSharing(List<User> users) 
    {
        this.users = users;
    }

    public void execute(QueueableContext context)
    {
        grantViewSharing();
    }

    public void grantViewSharing()
    {
        List<Wired_Announcement__c> recentAnnouncements = getRecentAnnouncements();
        Set<Id> recentAnnouncementIds = new Set<Id>();
        for (Wired_Announcement__c announcement : recentAnnouncements)
            recentAnnouncementIds.add(announcement.Id);

        Map<Id, Set<Id>> userIdToExistingShares = getExistingShares(recentAnnouncementIds);
        
        List<Wired_Announcement__Share> sharesToInsert = new List<Wired_Announcement__Share>();
        for (User user : this.users)
            for (Wired_Announcement__c announcement : recentAnnouncements)
                if (!userIdToExistingShares.containsKey(user.Id)
                    || !userIdToExistingShares.get(user.Id).contains(announcement.Id))
                    sharesToInsert.add(new Wired_Announcement__Share(
                        ParentId = announcement.Id,
                        UserOrGroupId = user.Id,
                        AccessLevel = 'Read'
                    ));
        
        if (sharesToInsert.isEmpty())
            return;

        System.debug('Inserting ' + sharesToInsert.size() + ' shares...');
        Database.SaveResult[] insertResults = Database.insert(sharesToInsert, false);

        List<Error__c> errors = new List<Error__c>();
        for (Database.SaveResult result : insertResults)
            if (!result.isSuccess())
                for (Database.Error error : result.getErrors())
                    errors.add(new Error__c(
                        Error_Message__c = error.getMessage()
                    ));

        if (errors.size() > 0)
            insert errors;
    }

    public List<Wired_Announcement__c> getRecentAnnouncements()
    {
        List<Wired_Announcement__c> recentAnnouncements = [SELECT Id, Name,
                                                                CreatedDate
                                                            FROM Wired_Announcement__c
                                                            WHERE CreatedDate >= :Date.today() - 31];
        
        return recentAnnouncements;
    }

    public Map<Id, Set<Id>> getExistingShares(Set<Id> announcementIds)
    {
        Set<Id> userIds = new Set<Id>();
        for (User user : this.users)
            userIds.add(user.Id);

        List<Wired_Announcement__Share> existingShares = [SELECT Id,
                                                                ParentId,
                                                                UserOrGroupId,
                                                                AccessLevel
                                                        FROM Wired_Announcement__Share
                                                        WHERE UserOrGroupId IN :userIds
                                                        AND ParentId IN :announcementIds];
        
        Map<Id, Set<Id>> userIdToParentIds = new Map<Id, Set<Id>>();
        for (Wired_Announcement__Share share : existingShares)
            for (User user : this.users)
                if (userIdToParentIds.containsKey(user.Id))
                    userIdToParentIds.get(user.Id).add((Id) share.ParentId);
                else
                    userIdToParentIds.put(user.Id, new Set<Id>{share.ParentId});

        return userIdToParentIds;
    }
}

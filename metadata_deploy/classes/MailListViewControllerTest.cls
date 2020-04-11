@isTest
private class MailListViewControllerTest 
{    
    @testsetup
    static void setup()
    {
        new TestingService().generalTestSetup();
    }
    
    @isTest
    static void submitAction()
    {
        Test.startTest();
        String signupMessage = MailListViewController.submitAction();
        Test.stopTest();

        System.assert(signupMessage.contains('You\'re now signed up,'), 
            'Message does not indicate success');
    }

    @isTest
    static void hasExistingSignUp()
    {
        User testUser = new TestingService().getTestUser();
        
        Wired_Mail_Sign_Up__c currentUserSignUp = new Wired_Mail_Sign_Up__c(
            User__c = testUser.Id,
            Sign_Up_Date__c = Date.today()
        );
        insert currentUserSignUp;

        Test.startTest();
        Boolean signedUp = MailListViewController.hasExistingSignUp(testUser.Id);
        Test.stopTest();

        System.assertEquals(true, signedUp, 'Should indicate current User already signed up');
    }

    @isTest
    static void retrieveUser()
    {
        User testUser = new TestingService().getTestUser();
        Test.startTest();
        User user = MailListViewController.retrieveUser(testUser.Id);
        Test.stopTest();
        System.assertEquals(testUser.Id, user.Id, 'Current user ID not retrieved successfully');
    }

    @isTest
    static void signUp()
    {
        User testUser = new TestingService().getTestUser();
        User currentUser = MailListViewController.retrieveUser(testUser.Id);

        Test.startTest();
        Wired_Mail_Sign_Up__c signUp = MailListViewController.signUp(currentUser);
        Test.stopTest();

        System.assert(signUp.Id != null, 'Sign Up not successfully inserted');
    }
}

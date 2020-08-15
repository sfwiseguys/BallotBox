@isTest(SeeAllData = false)
public class wbb_VoteControllerTest {

    /*
    * @Method Name                    :  getTestingUser
    * @Description                    :  Creates a Test User
    * @Return Type                    :  User
    * @Parameters                     :  None
    */
    public static User getTestingUser() {

        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'System Administrator'].Id;
        u = new User(profileId = pId, email = uniqueName + '@test' + uniqueName + '.gmail.com',
                     Username = uniqueName + '@test' + uniqueName +  'gmail.com',
                     alias = 'uqusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'GMT');
        insert u;
        system.assertNotEquals(NULL, u);
        return u;
    }

    /*
    * @Method Name                    :  setup
    * @Description                    :  Creates Setup data for the test class
    * @Return Type                    :  User
    * @Parameters                     :  None
    */

    @TestSetup static void setup() {

        Team__c oTeam = new Team__c(Name = 'Test Team');
        insert oTeam;
        system.assertNotEquals(NULL, oTeam);

        List<Title__c> lTitle = new List<Title__c>();
        For(Integer i = 1; i < 5; i++) {
            Title__c oT = new Title__c(Name = 'Test Title ' + i, Team__c = oTeam.Id, Order__c = i, Title_Description__c  = 'Test Description ' + i);
            lTitle.add(oT);
        }
        insert lTitle;
        system.assertNotEquals(NULL, lTitle);

        List<Candidate__c > lCan = new List<Candidate__c >();
        For(Integer i = 1; i < 10; i++) {
            Candidate__c  oCan = new Candidate__c (Name = 'Test Candidate ' + i, Team__c = oTeam.Id, Email__c = 'TestEmail' + i + '@gmail.com');
            lCan.add(oCan);
        }
        insert lCan;
        system.assertNotEquals(NULL, lCan);

        Nominee__c  oNom = new Nominee__c (Title__c  = lTitle[0].id, Candidate__c = lCan[2].id);
        insert oNom;
        oNom = new Nominee__c (Title__c  = lTitle[0].id, Candidate__c = lCan[3].id);
        insert oNom;
        system.assertNotEquals(NULL, oNom);

    }

    /*
    * @Method Name                    :  test_verifyCandidate
    * @Description                    :  Method to Test verifyCandidate
    * @Return Type                    :  None
    * @Parameters                     :  None
    */

    static testMethod void test_verifyCandidate() {
        User u = getTestingUser();
        System.runAs(u) {
            Test.StartTest();
            system.assertEquals(wbb_VoteController.verifyCandidate('fail@w.com').voterName, '');
            system.assertNotEquals(wbb_VoteController.verifyCandidate('TestEmail1@gmail.com').voterName, '');
            Test.StopTest();
        }
    }


    /*
    * @Method Name                    :  test_castVote
    * @Description                    :  Method to Test castVote
    * @Return Type                    :  None
    * @Parameters                     :  None
    */

    static testMethod void test_castVote() {
        User u = getTestingUser();
        List<Title__c> lTitle = new List<Title__c>();
        lTitle = [SELECT id FROM Title__c LIMIT 100];

        List<Candidate__c > lCan = new List<Candidate__c >();
        lCan = [SELECT id, Name FROM Candidate__c LIMIT 100];

        map<string, string> mVote = new map<string, string>();
        mVote.put(lTitle[0].id, lCan[2].Name);
        mVote.put(lTitle[1].id, lCan[2].Name);
        mVote.put(lTitle[2].id, lCan[2].Name);

        System.runAs(u) {
            Test.StartTest();
            string voterID = wbb_VoteController.verifyCandidate('TestEmail1@gmail.com').voterID;
            system.assertNotEquals(wbb_VoteController.castVote(mVote, voterID), NULL);
            system.assertNotEquals([SELECT id FROM Vote__c LIMIT 100].size(), 0);
            system.assertNotEquals(wbb_VoteController.verifyCandidate('TestEmail1@gmail.com').lBox, NULL);
            Test.StopTest();
        }
    }


}
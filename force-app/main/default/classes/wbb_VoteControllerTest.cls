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
        integer randomInt = integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'System Administrator'].Id;
        u = new User(profileId = pId, email = uniqueName + '@test' + uniqueName + '.gmail.com',
                     Username = uniqueName + '@test' + uniqueName +  'gmail.com',
                     alias = 'uqusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'GMT');
        insert u;
        system.assertNotEquals(NULL, u,'Assertion Failed for getTestingUser');
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
        system.assertNotEquals(NULL, oTeam,'Assertion Failed for oTeam insert');

        List<Title__c> lTitle = new List<Title__c>();
        for(integer i = 1; i < 5; i++) {
            Title__c oT = new Title__c(Name = 'Test Title ' + i, Team__c = oTeam.Id, Order__c = i, Title_Description__c  = 'Test Description ' + i);
            lTitle.add(oT);
        }
        insert lTitle;
        system.assertNotEquals(NULL, lTitle,'Assertion Failed for lTitle insert');

        List<Candidate__c > lCan = new List<Candidate__c >();
        for(integer i = 1; i < 10; i++) {
            Candidate__c  oCan = new Candidate__c (Name = 'Test Candidate ' + i, Team__c = oTeam.Id, Email__c = 'TestEmail' + i + '@gmail.com');
            lCan.add(oCan);
        }
        insert lCan;
        system.assertNotEquals(NULL, lCan,'Assertion Failed for lCan insert');

        Nominee__c  oNom = new Nominee__c (Title__c  = lTitle[0].id, Candidate__c = lCan[2].id);
        insert oNom;
        oNom = new Nominee__c (Title__c  = lTitle[0].id, Candidate__c = lCan[3].id);
        insert oNom;
        system.assertNotEquals(NULL, oNom,'Assertion Failed for oNom Insert');

    }

    /*
    * @Method Name                    :  test_getTitleBoxes
    * @Description                    :  Method to Test getTitleBoxes
    * @Return Type                    :  None
    * @Parameters                     :  None
    */

    static testMethod void test_getTitleBoxes() {
        User u = getTestingUser();
        System.runAs(u) {
            Test.StartTest();
            system.assertEquals(wbb_VoteController.getTitleBoxes('fail@w.com').voterName, '','Assertion Failed for wbb_VoteController.getTitleBoxes negative case');
            system.assertNotEquals(wbb_VoteController.getTitleBoxes('TestEmail1@gmail.com').voterName, '','Assertion Failed for wbb_VoteController.getTitleBoxes positive case');
            Test.StopTest();
        }
    }


    /*
    * @Method Name                    :  test_castVote
    * @Description                    :  Method to Test castVote & fetchVoteCount
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
            string voterID = wbb_VoteController.getTitleBoxes('TestEmail1@gmail.com').voterID;
            system.assertNotEquals(wbb_VoteController.castVote(mVote, voterID), NULL,'Assertion Failed for wbb_VoteController.castVote');
            system.assertEquals([SELECT id FROM Vote__c LIMIT 100].size(), 3,'Assertion Failed for Vote Size count');
            system.assertNotEquals(wbb_VoteController.getTitleBoxes('TestEmail1@gmail.com').voterName, '','Assertion Failed for wbb_VoteController.getTitleBoxes positive case');
            system.assertNotEquals(wbb_VoteController.fetchVoteCount(lTitle[0].id).size(), 0,'Assertion Failed for wbb_VoteController.fetchVoteCount positive case');
            Test.StopTest();
        }
    }
}
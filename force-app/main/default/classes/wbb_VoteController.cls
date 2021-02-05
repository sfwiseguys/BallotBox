/**********   Apex Controller for the Ballot Box Vote Now LWC **********/
// Making Class as without sharing to allow GUEST SITE Users to interact with Data, without enforcing Record Level Security

public without sharing class wbb_VoteController {


    /********** Method to Verify the Candidate EMAIL with a Team's Candidate record for authenticity and return Voter Wrapper with Title Boxes **********/
    @AuraEnabled
    public static wVoteWrapper getTitleBoxes(string canEmail) {
        Candidate__c oCan = new Candidate__c();
        list<Candidate__c> lCan = new List<Candidate__c>();
        wVoteWrapper oWrap = new wVoteWrapper();
        if (string.isNotBlank(canEmail)) {
            canEmail = string.escapeSingleQuotes(canEmail);
            canEmail = canEmail.toLowerCase();
            lCan = [SELECT id, Name, Email__c, Team__c, Team__r.Name FROM Candidate__c WHERE Email__c = :canEmail ORDER BY LastModifiedDate DESC LIMIT 1];

            if (!lCan.isEmpty() && string.isNotBlank(lCan[0].Team__c)) {
                oCan = lCan[0];
                list<Title__c> lTitles = new List<Title__c>();
                list<Candidate__c> lAllCan = new List<Candidate__c>();
                lAllCan = [SELECT Name, Email__c FROM Candidate__c WHERE Team__c = :oCan.Team__c AND Email__c != :oCan.Email__c ORDER BY Name ASC LIMIT 200];
                lTitles = [
                    SELECT
                        id,
                        Name,
                        Title_Description__c,
                        (SELECT id, Candidate__c, Candidate__r.Name, Candidate__r.Email__c FROM Nominees__r WHERE Candidate__r.Email__c != :oCan.Email__c ORDER BY Name ASC),
                        (SELECT id, Voted_For__c FROM Votes__r WHERE Voted_By__c = :oCan.Id)
                    FROM Title__c
                    WHERE Team__c = :oCan.Team__c
                    ORDER BY Order__c ASC NULLS LAST, LastModifiedDate ASC, Name ASC
                    LIMIT 100
                ];
                oWrap.assign(oCan, lAllCan, lTitles);
            }
        }

        return oWrap;
    }

    /********** Method to INSERT Votes against a particular candidate **********/
    @AuraEnabled
    public static list<Vote__c> castVote(map<string, string> mvote, string voterID) {
        list<Vote__c> lVotes = new List<Vote__c>();
        if (mvote != null && string.isNotBlank(voterID)) {
            voterID = string.escapeSingleQuotes(voterID);
            for (String titleid : mvote.keyset()) {
                Vote__c oVote = new Vote__c();
                oVote.Title__c = titleid;
                oVote.Voted_By__c = voterID;
                oVote.Voted_For__c = mvote.get(titleid);
                lVotes.add(oVote);
            }
            if (!lVotes.isEmpty()) {
                insert lVotes;
            }
        }
        return lVotes;
    }

    /********** Method to Fetch Votes against a particular Title, for chart results **********/
    @AuraEnabled
    public static list<AggregateResult> fetchVoteCount(string titleID) {
        list<AggregateResult> lVoteWinners = new List<AggregateResult>();
        if (String.isNotBlank(titleID)) {
            lVoteWinners = [SELECT COUNT(id), Voted_For__c FROM Vote__c WHERE Title__c = :titleID GROUP BY Voted_For__c ORDER BY COUNT(id) DESC];
        }
        return lVoteWinners;
    }

    // Completely Voter Details Wrapper Class
    public class wVoteWrapper {
        @AuraEnabled
        public string voterName;
        @AuraEnabled
        public string voterID;
        @AuraEnabled
        public string teamName;
        @AuraEnabled
        public list<wVoterBox> lBox;

        public wVoteWrapper() {
            this.voterName = '';
            this.voterID = '';
            this.teamName = '';
            this.lBox = new List<wVoterBox>();
        }

        // Method to assign Candidate/Nominee against filtered Title Voter Boxes
        public void assign(Candidate__c oCan, list<Candidate__c> lAllCan, list<Title__c> lTitles) {
            this.voterName = oCan.Name;
            this.voterID = oCan.Id;
            this.teamName = oCan.Team__r.Name;
            this.lBox = new List<wVoterBox>();
            for (Title__c oTitle : lTitles) {
                this.lBox.add(new wVoterBox(lAllCan, oTitle)); // form Each Title Box for individual Vote
            }
        }
    }

    // Single Title Record Wrapper Class to display in LWC
    public class wVoterBox {
        @AuraEnabled
        public string titleId;
        @AuraEnabled
        public string titlename;
        @AuraEnabled
        public string titleDescription;
        @AuraEnabled
        public boolean hasNominees;
        @AuraEnabled
        public list<wOptionWrapper> lOptions;
        @AuraEnabled
        public string votedFor;
        @AuraEnabled
        public boolean hasVoted;

        public wVoterBox() {
        }

        // Method to Specify the Candidate/Nominee List for each Title to vote
        public wVoterBox(list<Candidate__c> lAllCan, Title__c oTitle) {
            this.titleId = oTitle.Id;
            this.titlename = oTitle.Name;
            this.titleDescription = oTitle.Title_Description__c;
            this.hasNominees = false;
            this.lOptions = new List<wOptionWrapper>();
            this.votedFor = '';
            this.hasVoted = false;

            if (!oTitle.Nominees__r.isEmpty()) {
                this.hasNominees = true;
                for (Nominee__c oNom : oTitle.Nominees__r) {
                    this.lOptions.add(new wOptionWrapper(oNom.Candidate__r.Name, oNom.Candidate__r.Name));
                }
            } else {
                for (Candidate__c oC : lAllCan) {
                    this.lOptions.add(new wOptionWrapper(oC.Name, oC.Name));
                }
            }
            // Below, for populating Voted Results for Chart
            if (oTitle.Votes__r.isEmpty()) {
                this.votedFor = '';
                this.hasVoted = false;
            } else {
                this.votedFor = oTitle.Votes__r[0].Voted_For__c;
                this.hasVoted = true;
            }
        }
    }

    // Picklist Option Wrapper Class
    public class wOptionWrapper {
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;

        public wOptionWrapper(string lab, string val) {
            this.label = lab;
            this.value = val;
        }
    }
}

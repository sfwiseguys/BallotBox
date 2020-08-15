# Ballot Box
An Lightning Web Component App for carrying out Voting among a Team. Exposed as a Public Site in Salesforce

---

## App Highlights

The App provisions an Admin to create a Team with relevant Candidates who can Vote among themselves on Titles- All built on Salesforce!

This App, when exposed as a public Salesforce Site, allows Users to cast their Vote using their configured Email Id in the Candidate records, without any Login hassle! 

![](.images/BallotBoxSite.png)

![](.images/IronManVote.png)

![](.images/NickFuryVote.png)


The pre-built Voting rules are - 
- Voter can cast only one Vote per Title
- Voter cannot vote for oneself in any of the Titles
- Few Titles may have a pre-filtered list of *Nominees*, others will display all the Team Members

Our recommended Method is to share the Public Salesfore Site URL with the Users all at once to ensure Simultaneous Votes are being cast and the Salesforce Admin can then view the results in a Wall of Fame Ballot Box Dashboard as shown below - 

![](.images/DashboardWallOfFame.png)

---

## Installation & Site Setup

The Setup steps are as below- 
1. Either Install [this Unmanaged Package](https://www.google.com) into your Salesforce Org, or follow below Deployment Steps.
2. In App Launcher, select the **Ballot Box** app to view the Tab contents and create a Team record first, followed by Titles and Candidates. Remember to create Team Candidate records with a Unique Email ID that they will use in the Public Site to determine their voter identity.
3. Create Data Records - Team , All Team Candidates, All Team Titles as shown below- 

![](.images/TitlesListView.png)

![](.images/CandidateForm.png)

![](.images/IronManQuestion.png)


4. If needed, you can create few Nominee records under the Titles so that only they show up as options during Voting and not All the Team Candidates. If no nominees created, then by default, All Candidates will be in the options list for That Title.
5. You can preview how your configured data looks to an end user (Voter) in the **Vote Now!** tab
6. As an Admin, Configure the Salesforce Site in your Salesforce Org as instructed separately below.
7. Once Site is configured, you can share the Site Link with Voters and let the fun begin !

###  Site Setup


### Deployment

If Unable to Install the unmanaged package, then you can deploy the contents of this repository in your Developer Edition Org or a Sandbox-

1. Clone this repository in your local machine:

    ```
    git https://github.com/sfwiseguys/BallotBox
    cd BallotBox
    ```

2. Authorize your org and provide it with an alias (example **mydevorg** in the command below):

    ```
    sfdx force:auth:web:login -s -a mydevorg
    ```

3. Run this command in a terminal to deploy this app in your Org

    ```
    sfdx force:source:deploy -p force-app
    ```

4. If your org isn't already open, open it now using this command:

    ```
    sfdx force:org:open -u mydevorg

    ```

5. Post deployment, you can configure the Salesforce Site and the Records as instructed above and let the voting begin!

---

## Authors

* **Waseem Ali Sabeel** - *Ballot Box components* - [@WaseemAliSabeel](https://github.com/WaseemAliSabeel) :cowboy_hat_face:

---

## Support

Reach out at one of the following places!

- Website at [sfwiseguys.wordpress.com](https://sfwiseguys.wordpress.com) :tophat:
- Twitter at [@sfwiseguys](https://twitter.com/sfwiseguys)

---

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2020 :copyright:  [sfwiseguys.wordpress.com](https://sfwiseguys.wordpress.com) :shipit:

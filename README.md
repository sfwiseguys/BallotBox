# Ballot Box
An Lightning Web Component App for a Voting Titles among a Team. Exposed as a Public Site.

---

## App Highlights

The App provisions an Admin to create a Team in with the relevant Candidates who can Vote among themselves on Team Titles- All built on Salesforce!

This App, when exposed as a public Salesforce Site, allows Users to cast their Vote using their configured Email Id in the Candidate records, without any Login hassle! 

![](.images/BallotBoxSite.png)

![](.images/IronManVote.png)

![](.images/NickFuryVote.png)


The pre-built Voting rules are - 
- Voter can cast only one Vote per Title
- Voter cannot vote for oneself in any of the Titles
- Few Titles may have a pre-filtered list of *Nominees*, others will display all the Team Members

Our recommended Method is to share the Public Salesfore Site URL with the Users all at once to ensure Simultaneous Votes are being cast and the Salesforce Admin can then View the results on the WALL OF FAME Dashboard.

![](.images/DashboardWallOfFame.png)


The Setup steps are very simple - 
- Either Install this Unmanaged Package into your Salesforce Org, or follow below Deployment Steps
- Configure the Salesforce Site in your Salesforce Org and instructed below
- Create Data Records - Team , All Team Candidates, All Team Titles as shown below- 

![](.images/TitlesListView.png)

![](.images/CandidateForm.png)


- If needed, you can create few Nominee records under the Titles so that only they show up as options during Voting and not All the Team Candidates. If no nominees created, then by default, All Candidates will be in the options list for That Title.

---

## Deployment & Site Setup
Kindly follow these steps to deploy the contents of this repository in your Developer Edition Org or a Sandbox.

1. Clone this repository in your local machine:

    ```
    git https://github.com/sfwiseguys/BallotBox
    cd BallotBox
    ```

1. Authorize your org and provide it with an alias (example **mydevorg** in the command below):

    ```
    sfdx force:auth:web:login -s -a mydevorg
    ```

1. Run this command in a terminal to deploy this app in your Org

    ```
    sfdx force:source:deploy -p force-app
    ```

1. If your org isn't already open, open it now using this command:

    ```
    sfdx force:org:open -u mydevorg

    ```

1. (Site Setup Instructions here)

1. In App Launcher, select the **Ballot Box** app to view the contents and set up a Team first, followed by Titles and Candidates. Remember -  create Team Candidate records with a Unique Email ID that they will use in the Public Site (created above) to determine their voter identity.

---

## Authors

* **Waseem Ali Sabeel** - *Initial components* - [@WaseemAliSabeel](https://github.com/WaseemAliSabeel) :cowboy_hat_face:

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

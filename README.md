# Ballot Box
An Lightning Web Component App for a Voting Titles among a Team. Exposed as a Public Site.

---

## App Highlights

(app images here)
![](.images/BallotBoxSite.png)

second below
![](BallotBoxSite.png)


third below
![](images/BallotBoxSite.png)


fourth below
![](/images/BallotBoxSite.png)

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

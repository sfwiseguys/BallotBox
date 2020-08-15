import {LightningElement, track} from 'lwc';

import verifyCandidate from "@salesforce/apex/wbb_VoteController.verifyCandidate";
import castVote from "@salesforce/apex/wbb_VoteController.castVote";

export default class Wbb_votenow extends LightningElement {

    @track candidateEmail;
    @track voterName;
    @track teamName;
    @track lBox;
    @track loading;
    @track loaderror;
    @track incorrectemail;
    @track badvoter;
    @track NoMoreVotes;
    @track voteCasted;
    @track fillAllAlert;
    darkmode = true;

    voterID;
    voteMap = new Map();


    /************** On Enter press- Method to verify the Candidate is part of the Team eligible to Vote **************/
    bindCandidateEmail(event) {
        this.candidateEmail = event.target.value;
        if (event.keyCode === 13) {
            this.handleBeginVoting();
        }
    }

    /************** Method to verify the Candidate and obtain Title boxes to vote **************/
    handleBeginVoting() {
        this.incorrectemail = false;
        this.badvoter = false;
        if (this.candidateEmail && this.template.querySelector(".emailinput").validity.valid) {
            this.loading = true;
            this.loaderror = '';
            this.NoMoreVotes = false;
            //Imperative Apex Call
            verifyCandidate({
                    canEmail: this.candidateEmail
                })
                .then(result => {
                    if (result && result.voterName) {
                        this.voterName = result.voterName;
                        this.voterID = result.voterID;
                        this.teamName = result.teamName;
                        this.lBox = result.lBox;
                        if (!result.lBox || !result.lBox.length) {
                            this.NoMoreVotes = true;
                        }
                    } else {
                        this.badvoter = true;
                    }
                    this.checkmode();
                    this.loading = false;
                })
                .catch(error => {
                    this.loaderror = JSON.stringify(error);
                    this.loading = false;
                });
        } else {
            this.incorrectemail = true;
        }
    }


    /************** Method to Map Title to Vote casted **************/
    handleChange(event) {
        let titleid = event.currentTarget.getAttribute("data-titleid");
        let value = event.detail.value;
        this.voteMap.set(titleid, value);
    }


    /************** getter Method to conditionally show hide buttons **************/
    get showbuttons() {
        return !this.voteCasted ? !this.NoMoreVotes : false;
    }

    /************** getter Method disable voting button **************/
    get disablevoting() {
        return this.candidateEmail ? false : true;
    }

    /************** getter Method for Dynamic Footer Year value **************/
    get currentYear() {
        return new Date().getFullYear();
    }


    /************** Method to reset all user-selected votes **************/
    handleResetVote() {
        let allselections = this.template.querySelectorAll(".voteselect");
        for (let index = 0; index < allselections.length; index++) {
            allselections[index].value = undefined;
        }
        this.voteMap = new Map();
    }


    /************** Method to Call Apex to Insert All Votes **************/
    handleCastVote() {
        this.fillAllAlert = false;
        if (!this.voteMap.size || this.voteMap.size !== this.lBox.length) {
            this.fillAllAlert = true;
            return;
        }

        this.loading = true;
        this.voteCasted = false;

        // Imperative Apex Call
        castVote({
                mvote: Object.fromEntries(this.voteMap),
                voterID: this.voterID
            })
            .then(result => {
                if (result && result.length) {
                    this.voteCasted = true;
                }
                this.checkmode();
                this.loading = false;
            })
            .catch(error => {
                this.loaderror = JSON.stringify(error);
                this.loading = false;
            });
    }


    /************** Method to check and switch Full HTML between Dark mode and Light mode **************/
    checkmode() {

        if (!this.darkmode) {
            // Remove Dark Mode styles
            Array.from(this.template.querySelectorAll(".lgc-bg-inverse")).forEach(
                ele => {
                    ele.classList.add("not-dark");
                    ele.classList.remove("lgc-bg-inverse");
                }
            );
            Array.from(this.template.querySelectorAll(".slds-text-color_inverse")).forEach(
                ele => {
                    ele.classList.add("not-dark-text");
                    ele.classList.remove("slds-text-color_inverse");
                }
            );
            Array.from(this.template.querySelectorAll(".dark-bg")).forEach(
                ele => {
                    ele.classList.add("light-bg");
                    ele.classList.remove("dark-bg");
                }
            );
        } else {
            // Enable Dark Mode Styles
            Array.from(this.template.querySelectorAll(".not-dark")).forEach(
                ele => {
                    ele.classList.add("lgc-bg-inverse");
                    ele.classList.remove("not-dark");
                }
            );
            Array.from(this.template.querySelectorAll(".not-dark-text")).forEach(
                ele => {
                    ele.classList.add("slds-text-color_inverse");
                    ele.classList.remove("not-dark-text");
                }
            );
            Array.from(this.template.querySelectorAll(".light-bg")).forEach(
                ele => {
                    ele.classList.add("dark-bg");
                    ele.classList.remove("light-bg");
                }
            );
        }
    }

    /************** Method to Toggle between Dark mode and Light mode **************/
    togglemode() {
        this.darkmode = !this.darkmode;
        this.checkmode();
    }
}
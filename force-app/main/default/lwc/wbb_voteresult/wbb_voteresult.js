import { LightningElement, track, api } from "lwc";
import fetchVoteCount from "@salesforce/apex/wbb_VoteController.fetchVoteCount";

import { loadScript } from "lightning/platformResourceLoader";
import chartjs from "@salesforce/resourceUrl/chartjs";

export default class Wbb_voteresult extends LightningElement {
    @api titleId;
    chartInitialized = false;
    @track pollCounter = 0;
    @track chart;
    @track chartConfig = {
        type: "horizontalBar",
        data: {
            labels: [],
            datasets: [
                {
                    label: " # of Votes",
                    data: [],
                    backgroundColor: [
                        "rgba(0,255,127, 0.7)",
                        "rgba(255,69,0, 0.7)",
                        "rgba(0,255,255, 0.7)",
                        "rgba(255,0,255, 0.7)",
                        "rgba(255,255,255, 0.7)",
                        "rgba(255,255,0, 0.7)",
                        "rgba(138,43,226, 0.7)",
                        "rgba(210,180,140, 0.7)",
                        "rgba(173,255,47, 0.7)",
                        "rgba(178,34,34, 0.7)",
                        "rgba(0,191,255, 0.7)",
                        "rgba(255, 206, 86, 0.7)",
                        "rgba(75, 192, 192, 0.7)",
                        "rgba(153, 102, 255, 0.7)",
                        "rgba(255, 159, 64, 0.7)",
                        "rgba(210,105,30, 0.7)",
                        "rgba(255,255,255, 0.7)",
                        "rgba(128,128,0, 0.7)",
                        "rgba(255,69,0, 0.5)",
                        "rgba(0,255,255, 0.5)",
                        "rgba(255,0,255, 0.5)"
                    ],
                    borderColor: [
                        "rgba(0,255,127, 1)",
                        "rgba(255,69,0, 1)",
                        "rgba(0,255,255, 1)",
                        "rgba(255,0,255, 1)",
                        "rgba(255,255,255, 1)",
                        "rgba(255,255,0, 1)",
                        "rgba(138,43,226, 1)",
                        "rgba(210,180,140, 1)",
                        "rgba(173,255,47, 1)",
                        "rgba(178,34,34, 1)",
                        "rgba(0,191,255, 1)",
                        "rgba(255, 206, 86, 1)",
                        "rgba(75, 192, 192, 1)",
                        "rgba(153, 102, 255, 1)",
                        "rgba(255, 159, 64, 1)",
                        "rgba(210,105,30, 1)",
                        "rgba(255,255,255, 1)",
                        "rgba(128,128,0, 1)",
                        "rgba(255,69,0, 1)",
                        "rgba(0,255,255, 1)",
                        "rgba(255,0,255, 1)"
                    ],
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                xAxes: [
                    {
                        ticks: {
                            beginAtZero: true,
                            fontColor: "#FFF"
                        }
                    }
                ],
                yAxes: [
                    {
                        ticks: {
                            fontColor: "#FFF",
                            fontSize: 15
                        }
                    }
                ]
            },
            legend: {
                display: false
            },
            gridLines: {
                display: false
            }
        }
    };

    /************** Method to call imperative apex in polled manner and update chart with results **************/
    pollVoteCount() {
        if (this.titleId) {
            // Imperative Apex call
            fetchVoteCount({
                titleID: this.titleId
            })
                .then(result => {
                    for (let bar of result) {
                        this.updateChart(bar.Voted_For__c, bar.expr0);
                    }
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }

    /************** Method to update chart label and count, for the polled vote results from Apex **************/
    updateChart(label, count) {
        if (this.chart.data.labels.includes(label)) {
            let labelIndex = this.chart.data.labels.indexOf(label);
            this.chart.data.datasets[0].data[labelIndex] = count;
        } else {
            this.chart.data.labels.push(label);
            this.chart.data.datasets[0].data.push(count);
        }
        this.chart.update(); // Updates ChartJS chart
    }

    /************** Lifecycle hook Method to load the Chart JS library, create chart and initiate polling, Just Once **************/
    renderedCallback() {
        if (this.chartInitialized) {
            return;
        }
        this.chartInitialized = true;
        loadScript(this, chartjs)
            .then(() => {
                const ctx = this.template.querySelector("canvas.chart").getContext("2d");
                this.chart = new window.Chart(ctx, this.chartConfig);
                this.pollVoteCount(); // Called first to load chart content
                let intervalId = window.setInterval(
                    function() {
                        this.pollCounter++;
                        // Imperative Apex call
                        this.pollVoteCount(); // called inside the Poller function
                        if (this.pollCounter >= 50) {
                            // Stop polling after overall ~4 minutes.
                            window.clearInterval(intervalId);
                        }
                    }.bind(this),
                    5000
                );
            })
            .catch(error => {
                console.error(error);
            });
    }
}

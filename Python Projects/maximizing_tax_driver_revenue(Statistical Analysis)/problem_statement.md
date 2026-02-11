### Problem Statement

In the fast paced taxi booking sector, making the most of revenue is essential for long term success and driver happiness.
Our goal is to use data-driver insights to **maximise revenue streams** for taxis drivers in order to meet this need.
Our research aims to determine whether have an impact on fare pricing by focusing on the relationship between 
payment type and fare amount.

---

### Objective
This project's main goal is to run A/B teststo examine the relationship between the total fare and the payment method. We used Python 
**Hypothesis Testing** and descriptive statistics to extract useful information that can help taxi drivers generate more cash. In particular,
we want to find out if there is a big difference in the fares for those who pay with credit cards versur for those who pay with cash.

---

### Research Question 
**Is there a relatinoship between total fare amount and payment type?**

Can we nudge customers towards payment methods that generate higher revenue for drivers, without negatively impacting customer experience?

---

### Data Overview
For this analysis, we utilized the comprehensive dataset of NYC Taxi Trip records, used data engineering and feature engineering procedures to concentrate solely on the relevant columns essential for our investigation.

**Relevant columns used for this research:**
- passenger_count (1 to 5)
- payment_type (card or cash)
- fare_amount
- trip_distance (miles)
- duration (minutes)

---

### Methodology
| Step | Description |
| :--- | :--- |
| Descriptive Analysis | Performed statistical analysis to summarize key aspects of the data, focusing on fare amounts and fare types |
| Hypothesis Testing | Conducted a T-test to evaluate the relationship between payment type and fare amount, testing the hypothesis that different payment methods influence fare amounts |
| Regression Analysis | Implemented linear regression to explore the relationship between trip duration (calculated from pickup and dropoff times) and fare amount |

---

### Journey Insights
- Customers paying with cards tend to have a slightly higher average trip distance and fare amount compared to those paying with cash.
- Indicates that customers prefers to pay more with cards when they have high fare amount and long trip distance.

---

### Recommendations
> Encourage customers to pay with credit cards to capitalize on the potential for generating more revenue for taxi drivers.
> Implementing strategies such as offering incentives or discounts for credit card transactions to incentivize customers to choose this payment method.
> Provide seamless and secure credit card payment options to enhance customer convenience and encourage adoption of this payment method. 

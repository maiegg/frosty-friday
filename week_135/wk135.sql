/*
Constraints:
Do not use the ACCOUNTADMIN role.
The email must be sent using Snowflake’s built-in notification system.
The alert must fire only when new rows are present. (So no timed checks)
You must use a warehouse you have access to.

Expected Outcome:
When a new row is inserted into the table, you receive an email with a message confirming that new data has landed.

Bonus Challenges:
Include useful metadata (like a row count or timestamp) in the email.
Allow the alert to be reused for different tables or emails with minimal changes.
Log when the alert was triggered and what it detected.
*/


CREATE NOTIFICATION INTEGRATION seeds_insert_notification
  TYPE=EMAIL
  ENABLED=TRUE
  ALLOWED_RECIPIENTS=('maggieowilson@gmail.com');

Call a stored procedure to send the notification.
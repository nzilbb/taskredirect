# taskredirect
Hexagon module for redirecting web-based experiment participants to their tasks

Hexagon is an open-source content management system written in Java:
[https://sourceforge.net/projects/hexagoncms/]

This module allows administrators to add task definitions that have a
configurable description, consent form, and URL.

Participants are shown the description and consent, asked for their
email address, and then redirected to the URL (with a unique ID
appended to it).

Features:
 * The task administrator can be notified by email each time a
 participant is forwarded to the task URL
 * Participants (as identified by the email address) can only perform
 the task once
 * Tasks can be manually deactivated
 * Tasks can be automatically deacivated when a configurable number of
 participants is reached
 * A set of tickboxes can be added to the consent form, for more
 finely-grained consent, or to sign up for rewards, feedback, etc.
 * A list of participants with email address and unique ID, and
 ticked checkboxes, can be exported as CSV
 * The participant list can be filtered by checkbox ticks

## Making the module

```
cd META-INF
ant
```

This creates *taskredirect.jar* which can be installed as a module in a
Hexagon site.
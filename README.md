
# DCZoomConnector

# Introduction

 DCZoom Connector is an integrated app that aims at providing an easy-to-use interface that can be placed on any Salesforce object record to fascilitate in setting up Zoom meetings and webinars. 

The app is Lightning compatible and has a similar UI for both the Salesforce Classic as well as Lightning experience.

# Known Issues

1. When Deleting a meeting, Zoom does not send out an email to notify invitees that the meeting is Cancelled.

# Workarounds
1. Deleting a meeting - You can delete a meeting from the zoom server.Once done on the server then all invitees will be notified


# Unsupported
1. If the meeting is deleted from the zoom server then all invitees will get a cancelled email, but this is not propagated back to salesforce, therefore the salesforce zoom record is 
   not updated to reflect a cancellation

# DCZoom Documentation

1. Zoom Meeting User Guide : [dcZoomConnector v1.11 ](https://datacolada.atlassian.net/wiki/spaces/CK/pages/3456040961/Zoom+Meeting+User+Guide).
2. Zoom Meeting Oauth Integration Setup Guide  [dcZoomConnector v1.11 ](https://datacolada.atlassian.net/wiki/spaces/CK/pages/3455975425/Zoom+Meeting+Oauth+Integration+Setup+Guide).
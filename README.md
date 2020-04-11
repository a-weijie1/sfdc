# Salesforce Sharing and Security Fundamentals
### Course Examples
This is the repository for the Salesforce Sharing and Security Fundamentals course on Pluralsight. It contains components utilized throughout the course. 

## Installation To A Developer Org
After registering a new developer org, it is possible to install these components into the org for the purpose of experimentation outside the course video materials.

Replace <yourusername@pluralsight.com> in these command line examples with your own username.

*Authenticate into your Salesforce Developer Org using your own username and password via the web auth method.*
```
sfdx force:auth:web:login
```

*Deploy to your Developer Org using the Metadata API.*

```
sfdx force:mdapi:deploy -u <yourusername@pluralsight.com> -d metadata_deploy -w 8
```

That's it! After the metadata deployment shows as successful, your components are installed and ready to go. You can then begin tinkering and learning using your own tools and ideas.
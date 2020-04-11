# Introduction
Hi guys! Welcome to my sfdc dev repo!

## Steps to how i got here

1. Create a Salesforce Project in VS so as to get the necessary folder structures and all for deployment later on.
2. Go to the directory created in step 1
3. git init
4. git add
5. git commit -m 'comment'
6. Create a repo in github
7. git remote set-url origin https://github.com/a-weijie1/sfdc-dev.git
8. git push -u origin master

*Replace <https://github.com/a-weijie1/sfdc-dev.git> with the correct url*

```
sfdx force:auth:web:login
```

*Deploy to your Org using the Metadata API.*

```
sfdx force:mdapi:deploy -u <yourusername@pluralsight.com> -d metadata_deploy -w 8
```
# Introduction
Hi guys! Welcome to my sfdc dev repo!

## Steps To Follow

### Initialization
1. Create a Salesforce Project in VS so as to get the necessary folder structures and all for deployment later on.
2. Go to the directory created in step 1
3. git init
4. git add
5. git commit -m 'comment'
6. Create a repo in github
7. git remote set-url origin https://github.com/a-weijie1/sfdc-dev.git
*Replace <https://github.com/a-weijie1/sfdc-dev.git> with the correct url*
8. git push -u origin master

## Deployment to SFDC

*Build the release-artifact, convert the source to metadata format*
```
sfdx force:source:convert --rootdir force-app --outputdir tmp_convert
```
Create a zip file

```
jar -cfM winter19.zip tmp_convert
```

*Deploy to your Org using the Metadata API and use --help for reference*
```
sfdx force:mdapi:deploy --help 
```
```
sfdx force:mdapi:deploy --checkonly --zipfile winter19.zip --targetusername production-org \
--testlevel RunSpecifiedTests --runtests TestLanguageCourseTrigger
```
```
sfdx force:mdapi:deploy --targetusername production-org --validateddeployrequestid jobID
```
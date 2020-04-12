# Introduction
Hi guys! Welcome to my sfdc repo!

## Steps To Follow

### GIT
1. Branches initialization - git checkout -b uat master && git checkout -b sit master && git checkout -b hotfix master && git 

## Deployment strategies

### Setting up Salesforce DX from existing package in SFDC
1. Ensure package exists in SFDC (create it otherwise)
2. Login into Dev Hub (to manage scratch orgs)
```
sfdx force:auth:web:login
```
3. Create a Salesforce DX project
```
sfdx force:project:create --projectname <whateveryouwant>
```
4. Login into SFDC
```
sfdx force:auth:web:login
```
5. Export package
```
sfdx force:mdapi:retrieve -r ./<yourtargetoutputdirectory> -p <packagetobeexported>
```
6. Convert Metadata to DX Project structure (force-app folder will be created)
```
sfdx force:mdapi:convert 
```
7. Create Scratch org
```
sfdx force:org:create 
```
8. Push metadata into scratch org
```
sfdx force:source:push
```
9. Open Scratch Org and play!!
```
sfdx force:org:open
```
10. Pull any changes
```
sfdx force:source:pull
```
11. Implement new features outside of scratch org and push it into scratch org (sample apex class created)
```
sfdx force:apex:class:create --classname <anythingyouwant> --outputdir force-app/main/default/classes
sfdx force:source:push
```


### Setting up Salesforce DX without package creation
1. Login into Dev Hub (to manage scratch orgs)
```
sfdx force:auth:web:login
```
2. Create a Salesforce DX project
```
sfdx force:project:create --projectname <whateveryouwant>
```
3. Login into SFDC
```
sfdx force:auth:web:login
```
4. Export package
```
sfdx force:mdapi:retrieve -r ./<yourtargetoutputdirectory>
```
5. Everything is the same as above


### Deploying changes back to SFDC
1. Pull everything from scratch org
```
sfdx force:source:pull
```
2. Convert DX structure to metadata project
```
sfdx force:source:convert -r <preconverteddir> -d <postconverteddir>
```
3. Deploy!!!
```
sfdx force:mdapi:deploy -d <metadatadir>
```

### Removing SFDC components
1. In the directory to be deployed, ensure destructiveChanges.xml and package.xml are present
2. destructiveChanges.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <name>CustomObject</name>
    <members>SAMPLE__c</members>
  </types>
  <version>43.0</version>
</Package>
``` 
3. package.xml should be empty
```
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <version>43.0</version>
</Package>
``` 
4. Deploy!!!


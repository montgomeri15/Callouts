# SFDX  App
## Job Advertisements endpoint, VF pages, controllers and tests
# Instructions
1. Open a new Terminal window and use the following command to create a unique directory to do your work in:
```
mkdir callouts_project
cd callouts_project
```

2. Use this command to clone the app repository:
```
git clone https://github.com/montgomeri15/Callouts.git
```

3. Open the directory:
```
cd Callouts
```

4. If you haven’t already done so, authenticate with your hub org. Type the following command, then login with your hub org credentials and accept to provide access to Salesforce DX:
```
sfdx force:auth:web:login -d -a DevHub
```

5. Create a new scratch org:
```
sfdx force:org:create -s -f config/project-scratch-def.json -a  myscratchorg
```

6. Push the app to the scratch org:
```
sfdx force:source:push
```

7. Assign the permission set to the default user:
```
sfdx force:user:permset:assign -n Callouts_Perm_Set
```

8. Open the scratch org:
```
sfdx force:org:open
```


### Needed classes - Test's coverage:
* CalloutJobAdvertisement - 100%
* CalloutJobAdvertisementTrigger - 81%
* CalloutJobAdvertisementHelper - 100%
* RequestClass - 100%
* CalloutResume - 86%
* BatchResume - 94%
* CalloutResumeRecordsForMock - 100%
* FileUploaderController - 93%

### Needed VF pages:
* FileUploaderVF
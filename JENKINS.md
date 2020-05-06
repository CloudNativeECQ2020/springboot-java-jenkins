# ci/cd using jenkins 

Jenkins listens by default on port 8080

Following https://dzone.com/articles/learn-how-to-setup-a-cicd-pipeline-from-scratch
1. [start jenkins](#start-jenkins-service)
1. [load jenkins port 8080](#load-jenkins)
1. [start jenkins](#start-jenkins)
1. [start jenkins](#start-jenkins)
## start jenkins service
First `systemctl start jenkins`
```
tricia@acerubuntu1804:~/ecq/springboot-java$ systemctl status jenkins
● jenkins.service - LSB: Start Jenkins at boot time
   Loaded: loaded (/etc/init.d/jenkins; generated)
   Active: active (exited) since Fri 2020-05-01 21:34:44 EDT; 4 days ago
     Docs: man:systemd-sysv-generator(8)
    Tasks: 0 (limit: 4597)
   CGroup: /system.slice/jenkins.service

May 01 21:34:15 acerubuntu1804 systemd[1]: Starting LSB: Start Jenkins at boot time...
May 01 21:34:40 acerubuntu1804 jenkins[1399]: Correct java version found
May 01 21:34:40 acerubuntu1804 jenkins[1399]:  * Starting Jenkins Automation Server jenkins
May 01 21:34:42 acerubuntu1804 su[1968]: Successful su for jenkins by root
May 01 21:34:42 acerubuntu1804 su[1968]: + ??? root:jenkins
May 01 21:34:42 acerubuntu1804 su[1968]: pam_unix(su:session): session opened for user jenkins by (uid=0)
May 01 21:34:44 acerubuntu1804 jenkins[1399]:    ...done.
May 01 21:34:44 acerubuntu1804 systemd[1]: Started LSB: Start Jenkins at boot time.
```
## load jenkins
load the web page
![load web page](img/jenkins1.PNG)
create the project (freestyle)
![create the project](img/jenkins-create-job.PNG)
set up the git repo (must use https)
todo check if there is a jenkins plugin to use ssh repo url
![add git repo](img/jenkins-add-repo.PNG)
add git credentials https://www.jenkins.io/doc/book/using/using-credentials/ & https://plugins.jenkins.io/credentials/ & https://github.com/jenkinsci/credentials-plugin/blob/master/docs/user.adoc
![add git credentials](img/jenkins-add-cred.PNG)
set build triggers
![set build triggers](img/jenkins-build-trigger.PNG)
build script [jenkinsbuild.sh](jenkinsbuild.sh)
![set build script](img/jenkins-build-script.PNG)
post build action  (email, needs to be local as system is not set to use an smtp relay/server
![set post build action](img/jenkins-post-build-action.PNG)


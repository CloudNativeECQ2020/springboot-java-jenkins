# install jenkins on korra
java & maven installed

1. install [repo & key](#repo-&-key)
1. install [package](#install)
1. [start & enable](#start-&-enable) the system
1. FIXED cannot load as of now, problems with firewall, opened a ticket with the helpdesk
1.  see [google doc](https://docs.google.com/document/d/1stFH2Eq3EjCleLTMwAIYoXY0AYmG0QlgW1FxiY8FWoU/edit?usp=sharing) for further steps
## repo & key
```
[tricia@korra ~]$ curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
[jenkins]
name=Jenkins-stable
baseurl=http://pkg.jenkins.io/redhat-stable
gpgcheck=1
[tricia@korra ~]$ sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
```
## install
```
[tricia@korra ~]$ sudo yum install jenkins
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * elrepo: muug.ca
 * elrepo-kernel: muug.ca
 * epel: mirror.siena.edu
 * remi-safe: mirrors.uni-ruse.bg
 * webtatic: uk.repo.webtatic.com
Resolving Dependencies
--> Running transaction check
---> Package jenkins.noarch 0:2.222.3-1.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================================================================
 Package                      Arch                        Version                            Repository                    Size
================================================================================================================================
Installing:
 jenkins                      noarch                      2.222.3-1.1                        jenkins                       63 M

Transaction Summary
================================================================================================================================
Install  1 Package

Total size: 63 M
Installed size: 63 M
Is this ok [y/d/N]: y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : jenkins-2.222.3-1.1.noarch                                                                                   1/1
  Verifying  : jenkins-2.222.3-1.1.noarch                                                                                   1/1

Installed:
  jenkins.noarch 0:2.222.3-1.1

Complete!
[tricia@korra ~]$
```
## start & enable
```
[tricia@korra ~]$ systemctl status jenkins
● jenkins.service - LSB: Jenkins Automation Server
   Loaded: loaded (/etc/rc.d/init.d/jenkins; bad; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:systemd-sysv-generator(8)
[tricia@korra ~]$ sudo systemctl enable jenkins
jenkins.service is not a native service, redirecting to /sbin/chkconfig.
Executing /sbin/chkconfig jenkins on
[tricia@korra ~]$ sudo systemctl start jenkins
[tricia@korra ~]$ sudo systemctl status jenkins
● jenkins.service - LSB: Jenkins Automation Server
   Loaded: loaded (/etc/rc.d/init.d/jenkins; bad; vendor preset: disabled)
   Active: active (running) since Thu 2020-05-07 13:55:57 EDT; 4s ago
     Docs: man:systemd-sysv-generator(8)
  Process: 2309 ExecStart=/etc/rc.d/init.d/jenkins start (code=exited, status=0/SUCCESS)
    Tasks: 25
   Memory: 226.3M
   CGroup: /system.slice/jenkins.service
           └─2340 /etc/alternatives/java -Dcom.sun.akuma.Daemon=daemonized -Djava.awt.headless=true -DJENKINS_HOME=/var/lib/j...

May 07 13:55:56 korra systemd[1]: Starting LSB: Jenkins Automation Server...
May 07 13:55:56 korra runuser[2321]: pam_unix(runuser:session): session opened for user jenkins by (uid=0)
May 07 13:55:57 korra runuser[2321]: pam_unix(runuser:session): session closed for user jenkins
May 07 13:55:57 korra jenkins[2309]: Starting Jenkins [  OK  ]
May 07 13:55:57 korra systemd[1]: Started LSB: Jenkins Automation Server.
[tricia@korra ~]$
```


#Jira dockerized

Forked from [atlassian-docker](https://bitbucket.org/atlassianlabs/atlassian-docker).

Deploy a working jira installation via docker. Works exceptionally well with [dokku](https://github.com/dokku-alt/dokku-alt).

Current Jira version: **6.3**


##Deployment with dokku

Setup a postgresql database on your server with dokku:

```
$ dokku postgres:create jira
```

Clone this repo and add your server's dokku url to your repositories' remotes (let's call our app ```jira``` as well):

```
$ git clone https://github.com/UlTriX/jira-docker
$ cd jira-docker
$ git remote add dokku dokku@your-server.com:jira
```

Deploy:

```
$ git push dokku master
```

Grab a hot beverage. This may take some time. The docker container is built from scratch.

**Your app is not ready for production yet!**

###Persistence

To link the database to our app we need to:

```
$ dokku postgres:link jira jira
```

The DB credentials should be spit out right now and are available in the ENV variable $DATABASE_URL on build time. You can get them after the app is deployed via ```dokku config jira```.

We need to create a mounted volume to persist the jira config files, attachments and whatnot. To do this create a folder on your server, which is going to contain the persistant data files.

I put that right inside my app folder:
```
mkdir -p /home/dokku/jira/data
```

dokku allows us to pass additional arguments to ```docker run``` via a DOCKER_ARGS file sitting inside the app folder. We are passing arguments to mount the data folder to the /opt/atlassian-home directory in the container:

```
dokku docker-options:add jira deploy "-v /home/dokku/jira/data:/opt/atlassian-home"
```

Redeploy the app or ```dokku ps:rebuild jira```

###Setup

Go to [http://jira.your-server.com](http://jira.your-server.com) (or whatever app name you chose).

Maybe jira could obtain your database credentials automatically. On setup choose 'external database'.
If asked for credentials put in the credentials you obtained earlier.

**You're done!**

##Deployment without dokku-alt

Coming soon!


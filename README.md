About
=====

This runs on `slacktalker.dev.saucelabs.net`.  The main web application is running via nginx and uwsgi.  All code is deployed under the sauce user.  There's no fancy upstart script for uwsgi -- it's just running as a background job.

After a day or so, the web application seems to quit working.  I wouldn't be surprised if this is related to mysql having gone away, but I can't see the traceback for the error.  There's a cron job to restart the web process every few hours.  It's a terrible hack, but oh well.  2 nines of availability should be enough.

Loading New Data
================

Unfortunately, we don't have a Slack Plus account, so loading new chat data must be done semi-manually.  Basically, get an export from here: `https://get.slack.help/hc/en-us/articles/201658943-Exporting-your-team-s-Slack-history`

Drop the zip file in `/home/sauce/slack-export.zip` and make sure the owner and group are both `sauce`.  The cron jobs should load the new data automatically.

Deploying
=========

As *your user*, run `update_repo.sh` to change to the sauce user and pull down the latest git commit.  You'll need to have SSH agent forwarding enabled when connecting to the box.  Then, change to the sauce user and run `launch_uwsgi.sh`.

Files
=====

Setup / Deployment
------------------

 * `launch_uwsgi.sh` - Creates a socket for nginx to make requests to the application.
 * `iptables.rules` - Prevents access from baddies.  Can be loaded via `sudo iptables-restore < iptables.rules`
 * `nginx-sites-enabled-default` - Should be copied as `/etc/nginx/sites-enabled/default`
 * `settings.py.example` - Should be copied to `settings.py` and modified accordingly.

Data-loading
------------

 * `parse_users.py` - takes the `users.json` file from the slack export and loads up the users into the users table
 * `parse_words.py` - loads up words from the various channels and puts them into the database
 * `model.py` - the models for interacting with the DB.  If run directly, this will build the tables needed for loading data
 * `crontab.sauce` - the crontab responsible for looking for updated data and auto-loading it

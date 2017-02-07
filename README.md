# Node and Ruby Sidekiq Together <3

_IMPORTANT: This is a developer focused demo. It's expected that you understand enough Node/JavaScript and Ruby to understand what the code is doing._

This project is a quick demo of how you can use Node.js on the API/server process and Ruby Sidekiq on the worker process. No need to install Node or Ruby on your own system because this repo ships with a virtual machine ready to go and demo. If you don't already have [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com) installed, please do so before running the set up instructions below.

## Running the Demo

First clone the repo to your local machine and change directories into the project:

```
- git clone https://github.com/joshmosh/node-and-sidekiq-together.git
- cd node-and-sidekiq-together
```

Next you need to provision your virtual machine. Vagrant makes this very easy:

```
- vagrant up --provision
```

Last you'll need to `ssh` into the machine so you can do the live demo. I recommend you open up two Terminals (tabs) or shell environments so you can run the Node process and Ruby process side by side and watch the logs. Once the ssh session is started you'll need to change directories to the `/vagrant` folder to see the project root.

```
- vagrant ssh
- cd /vagrant
```

In the first shell environment, start the Node API:

```
- node app.js
```

In the second shell environment, start the Ruby worker:

```
- bundle exec sidekiq -r ./worker.rb
```

Lastly you'll need to create a resource by sending a `POST` request to the Node API:

```
curl -X "POST" "http://localhost:3005/people" \
     -H "Content-Type: application/json" \
     -d $'{
  "first_name": "John",
  "last_name": "Snow"
}'
```

This API request should return a `201 Created` status and the Ruby Sidekiq worker will kick off immediately to process the person that was just created.
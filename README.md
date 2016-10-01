# README
## Monitoring Agent Application

An application that fetch information on the machine such as cpu usage, disk usage and processes. You can find the server application here https://github.com/warrenchaudhry/monitoring_server.

*Note:* This application uses ActionCable for realtime streaming of data.

## Prerequisites
----
You will need the following things properly installed on your computer.

* [Ruby](http://ruby-lang.org) (with RubyGems and Bundler)
* [Redis](http://redis.io/)
* [Git](http://git-scm.com/)


## Installation
___
Clone the repository or download and uncompress the code

```
$ git clone git@github.com:warrenchaudhry/monitoring_agent.git
$ cd monitoring_agent
```

###### Rails application installation

1. Install the Rubygems dependencies

  ```
  $ bundle install
  ```

  It is highly recommended for you to use a virtual environment with user-based libraries instead of system-based. Check out https://rvm.io , for example.

1. Install Redis

  Follow the instructions [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04).
  Once installed, make sure that redis is running. You can check by:

  ```
  $ redis-cli
  ```

1. Rename `config/application.yml.example` to `config/application.yml`

  ```
  $ mv config/application.yml.example config/application.yml
  ```

2. Update the credentials:

  `METRICS_URL` - the url of the parent server who watches the client servers

  `SERVER_TOKEN` - the token which will serve as authentication key when throwing data on the parent server.

  `SECRET_KEY_BASE` - update only when on production mode by:
  ```
  rake secret
  ```
  `HOST` - e.g. http://localhost:3001
  `ACTION_CABLE_URL` - e.g wss://localhost:3001/cable

0. Run the tests

```
$ rake
```

0. Start the application

```
$ rails s -p 3001
```

1. Visit your application at http://localhost:3001




----
### Author's Info
##### Software
* Darwin  14.5.0 `Darwin Kernel Version 14.5.0: Mon Aug 29 21:14:16 PDT 2016; root:xnu-2782.50.6~1/RELEASE_X86_64 x86_64`
* Ruby `ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-darwin14]`
* Rails `5.0.0.1`
* Gem `2.6.7`
* Bundler `Bundler version 1.13.1`

![Rasbora Logo](rasbora-rogie.png)

# Rasbora

Rasbora is a shell script that sets you up a Ruby app server in a box. 

# This project is under active development. Please check back soon!

Rasbora is intended to exist in small infrastructures--i.e., one or two servers. The whole point is to use your own DigitalOcean, AWS, Linode, GC, or whatever VPS provider without having to dive into Capistrano, Chef, or Puppet. 

Think of Rasbora as a way to rapidly create a remote server for a Ruby application. A server-in-a-box, if you will. 

# Usage

You can see what the script does by examining `rasbora.sh`. At the time of this commit, it's about 80% done. 

## Milestones

### v0.0.5

The following is an example of what 0.0.0 will yield:

```
Your new application has been scaffolded!

App URL: https://my-todo-app.lawsonry.com
Repo: git@mercury.tld:/my-todo-app.git

Instructions: 

On your workstation, clone your new repo:
git clone jessefish@mercury.tld:/my-todo-app.git
When you're ready to push changes:
git push -u origin master
```

### v0.2.0

This version will yield the following commands:

* `rasbora new "my-app-name"`: Creates a new app at `my-app-name.yourserver.com` and sends you the relevant git information to get started immediately.

* `rasbora new "my-app-name": The default new application command, which uses PostgreSQL as the DB.
* `rasbora new "my-app-name" -d mysql`: Create a new app and use MySQL as the DB.
* `rasbora new "my-app-name" -d mariadb`: Create a new app and use MariaDB as the DB.

### v0.3.0

This version will yield the following commands:

* Rasbora allows multiple apps to be deployed and configured at the same time. 
* `rasbora list`: Gives you a list of all currently hosted Ruby apps.
## Contributing

Note: ~< v0.1.0 of Rasbora is written in Bash, with the very real possibility that it will be ported to Ruby for v>0.1.0. Keep that in mind as you push changes to the shell script. 

1. `git clone`
2. `cd rasbora`
3. `vim rasbora.sh`
4. "Why am I using Vim? What is wrong with me?"
5. Realize you're going to use Vim anyway. 
6. :wq!
7. git 

Please adhere to the Code of Conduct.

## Contributing

1. Clone
2. Do things
3. Submit merge request

## Authors

See the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Special thanks to [Rogie](https://github.com/rogie) for the use of the rasbora logo aka the "Gillustration" :D
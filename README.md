![Rasbora Logo](rasbora-rogie.png)

# Rasbora

Rasbora is a CLI toolkit written in Ruby for efficiently and easily provisioning a remote VPS to host Ruby applications. 

# This project is under active development. Please check back soon!

Rasbora is intended to exist in small infrastructures--i.e., one or two servers. The whole point is to use your own DigitalOcean, AWS, Linode, GC, or whatever VPS provider without having to dive into Chef or Puppet. 

Think of Rasbora as a way to rapidly create a remote server for a Ruby application. A server-in-a-box, if you will. 

## Milestones

### v0.1.0

```
$> ras new "my-todo-app" --server lawsonry.com

Who will be the deploying user? jessefish
What is jessefish's password? *************
Thanks! I'm setting things up now.

...................

Your new application has been scaffolded!

App URL: https://my-todo-app.lawsonry.com
Repo: git@mercury.tld:/my-todo-app.git

Instructions: 

On your workstation, clone your new repo:

git clone jessefish@mercury.tld:/my-todo-app.git

When you're ready to push changes:

git push -u origin master
```

## Development

1. `git clone`
2. `cd rasbora && bundle install`

## Contributing

1. Clone
2. Do things
3. Submit merge request

## Authors

See the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Special thanks to [Rogie](https://github.com/rogie) for the use of the rabora logo aka the "Gillustration" :D
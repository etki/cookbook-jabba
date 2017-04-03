# Pre-release notice

This project is a work-in-progress and not yet ready for production.

# jabba Cookbook

Installs [Jabba][jabba] - java version manager.

## Requirements

### Platforms

- Ubuntu 12.04, 14.04, 16.04
- Debian 7.11, 8.2 
- CentOS 6.5, 7.2

The specified platforms have been tested, however, the cookbook is 
trivial and should work nearly anywhere.

### Chef

- Chef 12.0 or later

## Resources

### jabba

Installs Jabba for target user at target location. If user is not set,
performs global installation (by default in `/usr/local/share/jabba`) 
and symlinks the binary to `/usr/local/bin/jabba`. This is not (yet)
suited for Windows, of course.

```ruby
jabba 'latest' do
  version 'latest'
  user 'etki'
  directory '.jabba'
  action :install, :delete
end
```

| Attribute   | Constraints                        | Default       | Explanation |
|:------------|:-----------------------------------|:--------------|:------------|
| `version`   | Existing Jabba version             | `latest`      | Jabba version to install |
| `user`      | Existing user or nil               | nil           | User JDK will be installed for |
| `directory` |                                    | `.jabba` or `/usr/local/share/jabba`  | Directory for Jabba root, will be created automatically |
| `action`    | `:install` or `:delete`            | `:install`    | |

### jabba_jdk

Installs JDK for target user. If user is not set, it will perform 
global installation.

**NB:** Jabba for specified user has to be installed in advance.
This may change in the future

```ruby
jabba_jdk '1.8' do
  version 'zulu@1.8'
  url 'tgz+http://example.com/distribution.tar.gz'
  user 'etki'
  directory '.jabba'
  action :install, :delete
end
```

| Attribute   | Constraints                        | Default       | Explanation |
|:------------|:-----------------------------------|:--------------|:------------|
| `version`   | Jabba-compatible JDK version       | Resource name | JDK version to install |
| `url`       | See [Jabba readme][jabba]          | nil           | Custom installer URL|
| `user`      | Existing user or nil               | nil           | User JDK will be installed for |
| `directory` | Directory where Jabba is installed | `.jabba`      | Directory with Jabba, relative to user home or absolute |
| `action`    | `:install` or `:delete`            | `:install`    | |

### jabba_default

Sets or removes default JDK version. Basically just a wrapper around
`jabba_alias`.

```ruby
jabba_default '1.6.65' do
  version '1.6.65'
  user 'etki'
  directory '.jabba'
  action :set, :unset
end
```

| Attribute   | Constraints                             | Default       | Explanation |
|:------------|:----------------------------------------|:--------------|:------------|
| `version`   | Jabba-compatible JDK version            | Resource name | JDK version to set as default |
| `user`      | Existing user or nil                    | nil           | Target user |
| `directory` | Directory where user Jabba is installed | `.jabba`      | Directory with Jabba, relative to user home or absolute |
| `action`    | `:set` or `:unset`                      | `:set`        | |

### jabba_alias

Sets or removes Jabba alias.

```ruby
jabba_alias 'default' do
  version '1.6.65'
  user 'etki'
  directory '.jabba'
  action :create, :delete
end
```

| Attribute   | Constraints                              | Default       | Explanation |
|:------------|:-----------------------------------------|:--------------|:------------|
| `name`      |                                          | Resource name | Alias name  |
| `version`   | Existing Jabba JDK installation          | | |
| `user`      | Existing user or nil                     | nil           | User JDK will be installed for |
| `directory` | Directory where user Jabba is installed  | `.jabba`      | Directory with Jabba, relative to user home or absolute |
| `action`    | `:create` or `:delete`                   | `:create`     | |

### jabba_link

```ruby
jabba_link 'system@1.8.72' do
  version 'system@1.8.72'
  target '/Library/Java/JavaVirtualMachines/jdk1.8.0_72.jdk'
  user 'etki'
  directory '.jabba'
  action :create, :delete
end
```

| Attribute   | Constraints                             | Default       | Explanation |
|:------------|:----------------------------------------|:--------------|:------------|
| `version`   | Jabba-compatible JDK version name       | Resource name | |
| `target`    | Existing non-Jabba JDK installation     |               | |
| `user`      | Existing user or nil                    | nil           | User JDK will be installed for |
| `directory` | Directory where user Jabba is installed | `.jabba`      | Directory with Jabba, relative to user home or absolute |
| `action`    | `:create` or `:delete`                  | `:create`     | |

## Recipes

While resources are fun for fine-grained control, end user (that's you)
most likely would love to not to have boilerplate, so there are some 
predefined recipes.

Recipes use attributes with following structure:

```yml
system:
  directory: /usr/local/share/jabba
  install: '0.6.1'
  jdk:
    - zulu@1.7
    - zulu@1.8
  default_jdk: zulu@1.7
  alias:
    1.7: zulu@1.7
    1.8: zulu@1.8
  link:
    system@1.8.72: /Library/Java/JavaVirtualMachines/jdk1.8.0_72.jdk
user:
  etki:
    directory: .jabba
    install: latest
    jdk:
      - zulu@1.6
      - zulu@1.7
      - zulu@1.8
    default_jdk: zulu@1.8
    alias:
      1.6: zulu@1.6
      1.7: zulu@1.7
      1.8: zulu@1.8
    link: [] # empty array could be omitted, shown for clarity
```

Each key in structure (in `system` or `user.%user%` section) 
corresponds with same-named recipe. Every attribute is optional and 
be set to noop default if not present.

### jabba::default

Simply runs `jabba::install`, `jabba::jdk`, `jabba::default_jdk`, 
`jabba::alias` and `jabba::link` one by one.

### jabba::install

Installs Jabba version specified in `system.install` and 
`user.%user%.install` attributes.

User may 

### jabba::jdk

Installs JDKs specified in `system.jdk` and `user.%user%.jdk` 
attributes.

### jabba::default_jdk

Sets JDK versions specified in `system.default_jdk` and 
`user.%user%.default_jdk` attributes.

### jabba::alias

Sets JDK aliases specified in `system.alias` and `user.%user%.alias`
attributes.

### jabba:link

Sets JDK links specified in `system.link` and `user.%user%.link` 
attributes.

## Conventions

This cookbook uses semantic versioning convention, however, cookbook is
considered unstable until 1.0.0 is released, so minor versions may
introduce breaking changes as well. Post-1.0.0 releases should be used
safely with `~> MAJOR.MINOR` constraint.

Cookbook is developed using git-flow convention: `master` is pointing 
to the most fresh release, `dev` stands for next release, 
`release/major.minor` branches exist for bug hunting, every version
may be referenced as `MAHOR.MINOR.PATCH` tag.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request for `dev` branch using Github

## License and Authors

License: MIT  
Authors: 
 - Etki <etki@etki.me>
 
All rights for the commandline utility belong to [Jabba][jabba] 
authors.

  [jabba]: https://github.com/shyiko/jabba

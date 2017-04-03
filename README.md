# Pre-release notice

This project is a work-in-progress and not yet ready for production.

# jabba Cookbook

Installs [Jabba][jabba] - Java version manager.

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

Installs Jabba for target user.

```ruby
jabba 'latest' do
  version 'latest'
  user 'etki'
  action :install, :delete
end
```

| Attribute   | Constraints                        | Default       | Explanation                     |
|:------------|:-----------------------------------|:--------------|:--------------------------------|
| `version`   | Existing Jabba version or 'latest' | Resource name | Jabba version to install        |
| `user`      | Existing user                      |               | User Java will be installed for |
| `action`    | `:install` or `:delete`            | `:install`    |                                 |

### jabba_java

Installs Java for target user.

**NB:** Jabba for specified user has to be installed in advance.
This may change in the future

```ruby
jabba_java '1.8' do
  version 'zulu@1.8'
  url 'tgz+http://example.com/distribution.tar.gz'
  user 'etki'
  action :install, :delete
end
```

| Attribute   | Constraints                   | Default       | Explanation                     |
|:------------|:------------------------------|:--------------|:--------------------------------|
| `version`   | Jabba-compatible Java version | Resource name | Java version to install         |
| `url`       | See [Jabba readme][jabba]     | nil           | Custom install URL              |
| `user`      | Existing user                 |               | User Java will be installed for |
| `action`    | `:install` or `:delete`       | `:install`    |                                 |

### jabba_default

Sets or removes default Java version. Basically just a wrapper around
`jabba_alias`.

```ruby
jabba_default '1.6.65' do
  version '1.6.65'
  user 'etki'
  action :create, :delete
end
```

| Attribute   | Constraints                   | Default       | Explanation                    |
|:------------|:------------------------------|:--------------|:-------------------------------|
| `version`   | Jabba-compatible Java version | Resource name | Java version to set as default |
| `user`      | Existing user or nil          | nil           | Target user                    |
| `action`    | `:create` or `:delete`        | `:create`     |                                |

### jabba_alias

Sets or removes Jabba alias.

```ruby
jabba_alias 'default' do
  version '1.6.65'
  user 'etki'
  action :create, :delete
end
```

| Attribute   | Constraints                      | Default       | Explanation                  |
|:------------|:---------------------------------|:--------------|:-----------------------------|
| `name`      |                                  | Resource name | Alias name                   |
| `version`   | Existing Jabba Java installation |               |                              |
| `user`      | Existing user                    |               | User Java will be linked for |
| `action`    | `:create` or `:delete`           | `:create`     |                              |

### jabba_link

```ruby
jabba_link 'system@1.8.72' do
  version 'system@1.8.72'
  target '/Library/Java/JavaVirtualMachines/jdk1.8.0_72.jdk'
  user 'etki'
  action :create, :delete
end
```

| Attribute   | Constraints                          | Default       | Explanation                     |
|:------------|:-------------------------------------|:--------------|:--------------------------------|
| `version`   | Jabba-compatible Java version name   | Resource name | Java name in Jabba              |
| `target`    | Existing non-Jabba Java installation |               | Link target                     |
| `user`      | Existing user                        |               | User Java will be installed for |
| `action`    | `:create` or `:delete`               | `:create`     |                                 |

## Recipes

While resources are fun for fine-grained control, end user (that's you)
most likely would love to not to have boilerplate, so there are some 
predefined recipes.

Recipes use attributes with following structure:

```yml
user:
  etki:
    install: latest
    java:
      - zulu@1.6
      - zulu@1.7
      - zulu@1.8
    default: zulu@1.8
    alias:
      1.6: zulu@1.6
      1.7: zulu@1.7
      1.8: zulu@1.8
    link: [] # empty array could be omitted, shown for clarity
```

Each key in structure under `user.%user%` section corresponds with 
same-named recipe. Every attribute is optional and would be set to 
noop default if not present.

### jabba::default

Simply runs `jabba::install`, `jabba::java`, `jabba::default_java`, 
`jabba::alias` and `jabba::link` one by one.

### jabba::install

Installs Jabba version specified in `user.%user%.install` attributes.

### jabba::java

Installs Java versions specified in `user.%user%.java` attributes.

### jabba::default_java

Sets Java versions specified in `user.%user%.default` attributes.

### jabba::alias

Sets Java aliases specified in `user.%user%.alias` attributes.

### jabba::link

Sets Java links specified in `user.%user%.link` attributes.

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

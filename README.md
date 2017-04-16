# Digicert CLI

[![CircleCI](https://circleci.com/gh/abunashir/digicert-cli.svg?style=svg&circle-token=479409dc95a0866bfeefd87a285202d7e883b51c)](https://circleci.com/gh/abunashir/digicert-cli)

The CLI for the Digicert API

## Usages

### Order

This CLI provides an easier interface to list the orders from the Digicert API.
To retrieve the list of the certificate orders please we can use

```sh
bin/digicert order:list
```

In case you have a specific `order_id` and you want to retrieve the details for
that orders, then please use the list interface with `-o` option.

```sh
bin/digicert order:list -o 123_456_789
```

Digicert does not have any a direct interface to filter certificate orders,
but we have added the following interface to partially support order filtering.
It usages the `list` interface to retrieve all of the orders and that apply
filters on top of those results. Currently supported options are `common_name`
and `product_type`.

```sh
bin/digicert order:find -c "ribosetest.com" -p "ssl_plus"
```

## Development

We are following Sandi Metz's Rules for this gem, you can read the
[description of the rules here][sandi-metz] All new code should follow these
rules. If you make changes in a pre-existing file that violates these rules you
should fix the violations as part of your contribution.

### Setup

Clone the repository.

```sh
git clone https://github.com/abunashir/digicert-cli
```

Setup your environment.

```sh
bin/setup
```

Run the test suite

```sh
bin/rspec
```

## Contributing

First, thank you for contributing! We love pull requests from everyone. By
participating in this project, you hereby grant [Ribose Inc.][riboseinc] the
right to grant or transfer an unlimited number of non exclusive licenses or
sub-licenses to third parties, under the copyright covering the contribution
to use the contribution by all means.

Here are a few technical guidelines to follow:

1. Open an [issue][issues] to discuss a new feature.
1. Write tests to support your new feature.
1. Make sure the entire test suite passes locally and on CI.
1. Open a Pull Request.
1. [Squash your commits][squash] after receiving feedback.
1. Party!


## Credits

This gem is developed, maintained and funded by [Ribose Inc.][riboseinc]

[riboseinc]: https://www.ribose.com
[issues]: https://github.com/abunashir/digicert-cli/issues
[squash]: https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature
[sandi-metz]: http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers

# Digicert CLI

[![Build
Status](https://travis-ci.org/riboseinc/digicert-cli.svg?branch=master)](https://travis-ci.org/riboseinc/digicert-cli)

The CLI for the Digicert API

## Usages

### Orders

This CLI provides an easier interface to list the orders from the Digicert API.
To retrieve the list of the certificate orders we can use

```sh
digicert order list
```

Digicert does not have any a direct interface to filter certificate orders,
but we have added partial support for filtering, to filter the orders by any
specific criteria please pass those as option to the `order list` interface.
Currently supported options are `common_name` and `product_type`.

```sh
digicert order list -c "ribosetest.com" -p "ssl_plus"
```

### Single Order

Use `find` interface to retrieve a single order, this interface supports all
default filters.

```sh
digicert order find -c "ribosetest.com" -p "ssl_plus" --status expired
```

This interface also allow us to specific a flag in case we only want to find
the `id` for the resource.

```sh
digicert order find -c "ribosetest.com" -p "ssl_plus" --status expired --quiet
```

### Reissue an order

To reissue an existing order, we can use the following interface.

```sh
digicert order reissue --order_id 12345 --crt full_path_to.csr
```

### Reissue and download a certificate

To reissue an order and save that reissued certificate to a specific path we can
use the following interface.

```sh
digicert order reissue --order_id 123456 --output /full/download/path
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

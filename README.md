# Digicert CLI

[![Build
Status](https://travis-ci.org/riboseinc/digicert-cli.svg?branch=master)](https://travis-ci.org/riboseinc/digicert-cli)
[![Code
Climate](https://codeclimate.com/github/riboseinc/digicert-cli/badges/gpa.svg)](https://codeclimate.com/github/riboseinc/digicert-cli)
[![Gem
Version](https://badge.fury.io/rb/digicert-cli.svg)](https://badge.fury.io/rb/digicert-cli)

The [Digicert CLI] is a tool that allows us to manage Digicert orders,
certificates and etc using [Digicert Ruby Client].

## Configure

We need to setup our API key before we want to use the CLI. For simplicity we
have add an easier interface to setup the Digicert API KEY. To setup your key
please use the following interface.

```sh
digicert config DIGICERT_API_KEY
```

## Usages

### Getting Help

We have been trying to simplify the `CLI` with proper `help` documentation. Each
of the `command` and `subcommand` should provide you the basic usages guide with
the list of supported options.

Normally the parent command should fire up the `help` documentation, but if it
does not then you can explicitly call the `help` command or pass `-h` flags with
any of the action and that should fire up the documentation. For example

```sh
$ digicert help
```

```sh
Commands:
  digicert certificate     # Manage Digicert Certificates
  digicert config API_KEY  # Configure The CLI Client
  digicert csr             # Fetch/generate Certificate CSR
  digicert help [COMMAND]  # Describe available / One specific command
  digicert order           # Manage Digicert Orders
```

The above command lists the available commands with a basic description and as
you might have notice, it also ships with a `help` command which can be used to
up the usages documentation for it's nested command.

```sh
# digicert order -h
$ digicert help order
```

```sh
Commands:
  digicert order find              # Find a digicert order
  digicert order help [COMMAND]    # Describe subcommands or one specific
  digicert order list              # List digicert orders
  digicert order reissue ORDER_ID  # Reissue digicert order
```

Hopefully you get the idea, we will try our best to keep this guide up to date
but whenever you need some more information please add the `-h` flags with any
commands or subcommands and you should see what you need.

### Orders

#### Listing Orders

Listing orders is pretty simple with the CLI, once we have our API key
configured then we can list all of our orders using the `list` interface

```sh
$ digicert order list
```

```sh
+---------------+---------------+------------------+-------------+-------------+
| Id            | Product Type  | Common Name      | Status      | Expiry      |
+---------------+---------------+------------------+-------------+-------------+
| xxxxx65       | ssl_wildcard  | *.ribosetest.com | expired     | 2018-06-25  |
| xxxxx20       | ssl_wildcard  | *.ribosetest.com | issued      | 2018-06-15  |
| xxxxx06       | ssl_wildcard  | *.ribosetest.com | revoked     | 2018-05-09  |
+---------------+---------------+------------------+-------------+-------------+
```

The above interface without any option will list out all of the orders we have
with Digicert, but sometime we might need to filter those listings, and that's
where can can use the filter options. This interface supports filter options
through the `--filter` option and expect the value to be in `key:value` format.

For example, if we want to retrieve all of the orders that has product type of
`ssl_wildcard` then we can use

```sh
$ digicert order list --filter 'product_name_id:ssl_wildcard'
```

It will only list the orders with the `ssl_wildcard` product type, Currently the
supported filters options are `date_created`, `valid_till`, `status`, `search`,
`common_name` and `product_name_id`. Please [check the wiki] for more up to date
supported filtering options.

#### Find an order

We can use the `find` interface to retrieve a single order, by default it will
print the details in the console. This interface also supports filter options.

One important thing to remember, it will only retrieve one single entry, so if
you have multiple orders in your specified terms then it will only retrieve the
most recent one form that list.

```sh
$ digicert order find --filter 'common_name:ribosetest.com' 'product_name_id:ssl_plus'
```

```sh
#<Digicert::ResponseObject id=xxx04, certificate=#<Digicert::ResponseObject
..........................id=xxxx08 price=xxxx, product_name_id="ssl_plus">
```

But if you don't care about that much of data and only need the `ID` then you
can pass the `--quiet` flags to reduce the noises and retrieve only the id.

#### Reissue an order

To reissue a non-expired order we can use the `reissue` interface and pass the
order id to it. By default it will reissue the order using the existing details
but if we want to update the `CSR` then we can pass the certificate file as
`--crt`.

```sh
$ digicert order reissue 12345 --crt path_to_the_new_csr.csr
```

```sh
Reissue request xxxxx8 created for order - 123456
```

Pretty cool right? The above interface also support some other option that we
can use to download the recently reissued order. To download, all we need to do
is just provide a valid path and it will automatically download the certificates

```sh
$ digicert order reissue 123456 --output /path/to/downloads
```

```sh
Reissue request 1xxxxx created for order - 123456

Fetch attempt 1..
Downloaded certificate to:

/path/to/downloads/123456.root.crt
/path/to/downloads/123456.certificate.crt
/path/to/downloads/123456.intermediate.crt
```

### Certificate

#### Fetch a certificate

The `fetch` interface will retrieve the certificate for any specific orders, by
default it will print out the detail in the console but if we only want the `ID`
then we can pass the `--quiet` flags with it.

```sh
$ digicert certificate fetch 123456789 --quiet
```

#### Download a certificate

To download a certificate we can use the same `fetch` interface but with the
`--output` option. Based on the `--output` option `fetch` interface will fetch
the certificates and download the `root`, `intermediate` and `certificate` to
the output path, to download a certificate we can do

```sh
$ digicert certificate fetch 123456 --output /path/to/downloads
```

The above interface supports downloading a certificate and it expects us to
provide the `order-id`, but if we only care about download then we can also use
the `download` interface. It acts pretty much similar but it let's us specify
the `order-id` or `certificate-id`.

```sh
$ digicert certificate download --order-id 654321 --output /downloads
$ digicert certificate download --certificate-id 123456 --output /downloads
```

#### List duplicate certificates

Digicert allows us to duplicate a certificate and if we want to list all of the
duplicates then we can use the `duplicates` interface. This interface expects us
to provide the `order-id` to list the duplicates

```sh
$ digicert certificate duplicates 123456
```

```sh
+----------+-------------------+------------------+----------+--------------+
| Id       | Common Name       | SAN Names        | Status   | Validity     |
+----------+-------------------+------------------+----------+--------------+
| xxxxx19  | *.ribosetest.com  | *.ribosetest.com | approved | xxxxx-xxxxxx |
|          |                   | ribosetest.com   |          |              |
+----------+-------------------+------------------+----------+--------------+
```

### CSR

#### Fetch an order's CSR

If we need to retrieve the `CSR` for any specific order then we can use the
following interface and it will return the `CSR` content in the console.

```sh
digicert csr fetch 123456
```

#### Generate a new CSR

Digicert gem usages a third party library to generate a CSR, and we have also
included that in the CLI to make the `CSR` generation process simpler, to
generate a new `CSR` using an existing order details we can use

```sh
digicert csr generate --oreder-id 12345 --key full_path_to_the.key
```

Generate `CSR` with `--common-name` and `san`

```sh
digicert csr generate --common-name ribosetest.com --order-id 1234 \
  --san test1.ribosetest.com test2.ribosetest.com --key path_to_key_file
```

## Development

We are following Sandi Metz's Rules for this gem, you can read the
[description of the rules here][sandi-metz] All new code should follow these
rules. If you make changes in a pre-existing file that violates these rules you
should fix the violations as part of your contribution.

### Setup

Clone the repository.

```sh
git clone https://github.com/riboseinc/digicert-cli
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
[issues]: https://github.com/riboseinc/digicert-cli/issues
[squash]: https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature
[sandi-metz]: http://robots.thoughtbot.com/post/50655960596/sandi-metz-rules-for-developers
[Digicert CLI]: https://github.com/riboseinc/digicert-cli
[Digicert Ruby Client]: https://github.com/riboseinc/digicert
[check the wiki]: https://github.com/riboseinc/digicert-cli/wiki

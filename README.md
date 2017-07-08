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

The `CLI` commands are heavily dependent on the Digicert API. Please
[follow the instruction here] to request an API Key from Digicert, Once you have
your API key then you can configure it using the `config` command.

```sh
$ digicert config DIGICERT_API_KEY
```

## Usages

### Getting Help

We have been trying to simplify the `CLI` with proper `help` documentation. Each
of the `command` and `subcommand` should provide you the basic usages guide with
the list of supported options.

The parent command should fire up the `help` documentation, but if it does not
then you can explicitly call the `help` command or pass `-h` flags with any of
the command and that should fire up the documentation. For example

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

The above command lists the available commands with a basic description. As you
might have noticed, it also ships with a `help` command which can be used to
fire up the usages guide and options for it's nested command.

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

Hopefully you get the idea, we are trying our best to keep this guide up to date
but whenever you need some more information please add the `-h` flags with any
commands or subcommands and you should see more accurate help documentation.

### Orders

#### Listing Orders

The `CLI` made listing Digicert orders pretty simple, once we have our API key
configured then we can list all of our orders using the `order list` command.

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

The above command without any option will list out all of our Digicert orders,
but if we need to filter those orders then we can do that by passing `--filter`
option and the expected values as in `key:value` pair.

For example, to list all of the orders that has product type of `ssl_wildcard`
we can use the following and it will list only the filtered orders.

```sh
$ digicert order list --filter 'product_name_id:ssl_wildcard'
```

Supported filters options are `date_created`, `valid_till`, `status`, `search`,
`common_name` and `product_name_id`. Please [check the wiki] for more uptodate
filter options list.

#### Find an order

To find an order we can use `order find` command, by default it will print the
order details in the console but this command also supports the normal filter
options as described on the listing order section.

One important thing to remember, it will only retrieve one single entry, so if
you have multiple orders in your specified terms then it will only retrieve the
most recent one from that list.

```sh
$ digicert order find --filter 'common_name:ribosetest.com' 'product_name_id:ssl_plus'
```

```sh
#<Digicert::ResponseObject id=xxx04, certificate=#<Digicert::ResponseObject
..........................id=xxxx08 price=xxxx, product_name_id="ssl_plus">
```

Lots of information? Well, if you don't need that much details and only need the
`ID` then you can pass the `--quiet` flags and it will only print the order id.

#### Reissue an order

To reissue a non-expired order we can use the `order reissue` command and pass
the order id. By default it will reissue the order using the existing details
but we can update that by passing the certificate CSR as`--crt`

```sh
$ digicert order reissue 12345 --crt path_to_the_new_csr.csr
```

```sh
Reissue request xxxxx8 created for order - 123456
```

Pretty cool right? The above command also support `--output` option that we
can use to download the reissued certificates. To download we need to provide a
valid path and it will automatically download the certificates to it

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

The `certificate fetch` command retrieves the certificate for any specific order,
by default it will print out the certificate detail in the console but if we can
change it by passing additional option to it. Like the `--quiet` flags will only
return the certificate id instead of all the details

```sh
$ digicert certificate fetch 123456789 --quiet
```

#### Download a certificate

To download a certificate we can use the same `certificate fetch` command but
with the `--output` option. Based on the `--output` option this command will
fetch and download the certificates to the provided path.

```sh
$ digicert certificate fetch 123456 --output /path/to/downloads
```

The `fetch` command only works with the `order_id` but what if we have the
certificate id? Well, we have another command `certificate download` which
supports both the `--order-id` and the `certificate-id`.

```sh
$ digicert certificate download --order-id 654321 --output /downloads
$ digicert certificate download --certificate-id 123456 --output /downloads
```

#### List duplicate certificates

Digicert allows us to duplicate a certificate and if we want to list all of the
duplicates then we can use the `certificate duplicates` command. It expects us
to provide the `order-id` to list all the duplicates

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

Retrieving a `CSR` is pretty easy, if we have an order id and we want retrieve
it's `CSR` then we can use the `csr fetch` command and it will print out the
details in the console.

```sh
$ digicert csr fetch 123456
```

#### Generate a new CSR

Digicert gem usages a third party library to generate a CSR, and this CLI
included that to simply the `CSR` generation, so if we need to generate a new
`CSR` then we can use the `csr generate` command and pass the order id with a
key file and it will generate a new CSR.

```sh
$ digicert csr generate --oreder-id 12345 --key /path/to/the/key-file.key
```

This command also supports custom details like `common-name` and `san`. We can
pass those as `--common-name` and the `--san` and it will use those to generate
the `CSR`

```sh
$ digicert csr generate --common-name ribosetest.com --order-id 1234 \
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
[follow the instruction here]: https://www.digicert.com/rest-api

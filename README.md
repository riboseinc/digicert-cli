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

### Orders

Listing Digicert orders are pretty simple, we can list all of our orders using

```sh
digicert order list
```

This interface also support filtering orders based on some specific attributes,
for example if we want to list all the order for one specific product type
`ssl_plus`, then we can do

```sh
digicert order list --filter 'status:pending,processing' \
'common_name:ribosetest.com' 'valid_till:<2017-05-11'
```

The supported filters options are `date_created`, `valid_till`, `status`,
`search`, `common_name` and `product_name_id`. Please [check the wiki] for more
details on those

You can also use `--help` with any top level command to see what options are
available for that specific parent command.

#### Single Order

To retrieve a single order we can use the `find` interface. It supports all the
filters options and if there are more than one order then it will return the
most recent one and print out the details in the console.

This interface also support `--quiet` option, which we can used to retrieve the
order id for any specific order. This might be useful to when we are doing it
through some automated script.

```sh
digicert order find --filter 'common_name:ribosetest.com' \
  'product_name_id:ssl_plus' 'status:pending,processing'
```

#### Reissue an order

Reissuing an order is pretty simple, if we have an `order-id` then we can
reissue the certificate using the existing details. This interface also supports
additional option to provide new csr and it will use it while reissuing the
certificate. To reissue an order

```sh
digicert order reissue 12345 --crt full_path_to.csr
```

#### Reissue & download

Once an order is reissued then we can download it by providing `--output`
option to the `reissue` interface. One important thing to note, Digicert
requires sometime to reissue an certificate, so downloading process might take
sometime as it tries to retrieve the reissued order in a specific time interval.

```sh
digicert order reissue 123456 --output /full/download/path
```

### Certificate

#### Fetch a certificate

The `fetch` interface on `certificate` will allow us to fetch the certificate
for any specific order. By default this interface will print out the details to
the console, but it also support one additional `--quiet` option to return only
the id of the certificate.

```sh
digicert certificate fetch 123456789 --quiet
```

#### Download a certificate

To download a certificate we can use the same `fetch` interface but with the
`--output` option. Based on the `--output` option `fetch` interface will fetch
the certificates and download `root`, `intermedia` and `certificate` to the path

```sh
digicert certificate fetch 123456 --output full_path_to_download
```

But it also has another dedicated `download` interface, which behave the same
way but only downloads the content and it supports both the `--order-id` and
`--certificate-id`, so if we only need to download any certificate by it's id
then we can use this interface.

```ruby
digicert certificate download --order-id 654321 --output /downloads
digicert certificate download --certificate-id 123456 --output /downloads
```

#### List duplicate certificates

If we need to list the duplicate certificates for any specific order then we can
use the following interface, and it will list the duplicate certificates with
some important attributes.

```ruby
digicert certificate duplicates 123456
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

#!/bin/bash

# USAGE:
# export API_DIGICERT_KEY="MY KEY"
# export API_DIGICERT_ACCOUNT_ID="ACCOUNT ID"
# ./build_cert.sh reissue -o 00900495 -n star_ribose_com -c "*.ribose.com"
# ./build_cert.sh retrieve -o 00900495 -n star_ribose_com

# TODO: as certificate generation takes time, if we run two "reissues" in
# parallel, only the last one will be generated and therefore we lose the first
# request! Use the "comments" field to store some unique number that we can
# match later on retrieval to ensure it is the same request.

readonly __progname=$(basename $0)
readonly api_digicert_key="${API_DIGICERT_KEY}"
readonly digicert_account_id="${API_DIGICERT_ACCOUNT_ID}"

#digicert_orders="
#star_ribose_com:00900495
#www_ribose_com:00900495
#"
#star_ribose_com:00427785

readonly digicert_api_user="-u \"${digicert_account_id}:${api_digicert_key}\""
readonly digicert_contenttype="-H \"Content-Type: application/vnd.digicert.rest-v1+json\""
readonly curl_cmd="curl -s"

errx() {
	printf "$__progname: $@\n" >&2
	exit 1
}

mkjson() {
  local readonly tmpfile=$(mktemp) || \
	errx "Failed to create temp file"
  echo '{
  "comments": "COMMENTS",
  "common_name": "COMMONNAME",
  "sans": "SANS",
  "server_type": 2,
  "csr": "CSRS"
}' > ${tmpfile} || \
	errx "Failed to write temp json file"

  echo ${tmpfile}
}

retrieve_cert() {
  local order_id=$1
  local name=$2
  local destination=$3

  local digicert_api_url_retrieve="https://api.digicert.com/order/${order_id}/certificate"
  local responsejson=${destination}/retrieve.response.json

  cmd="${curl_cmd} \
    ${digicert_api_user} \
    ${digicert_contenttype} \
    -o ${responsejson} \
    ${digicert_api_url_retrieve}"

  echo "------- CURL COMMAND IS -------" >&2
  echo ${cmd} >&2
  echo "------- CURL COMMAND END -------" >&2

  eval ${cmd} >&2 || \
	errx "curl failed"

  # If the certificate is not yet available, CURL still returns success.
  # However, the response json will be:
  # {"errors":[{"code":"cert_unavailable_processing","description":"Unable to download certificate, the certificate has not yet been issued.  Try back in a bit."}]}

  # exit 2 if the cert isn't ready
  cat ${responsejson} | grep -q "the certificate has not yet been issued" && \
	exit 2

  echo "------- JSON RETRIEVED IS -------" >&2
  cat ${responsejson} >&2
  printf "\n" >&2
  echo "------- JSON RETRIEVED END -------" >&2

  local has_error=$(jq -r '.errors[]? | has("description")' ${responsejson})

  if [ "${has_error}" == "true" ]; then
	printf "\n\n******** Retrieval error ********: \n $(jq -r '.errors[]' ${responsejson})\n\n" >&2
	errx "Failed to retrieve certificate."
  fi

  local filename=""
  for key in certificate intermediate root pkcs7; do
    filename=${destination}/${name}.${key}
    echo "Generating $filename..." >&2
    # sed removes the empty lines
    # tr removes the \r's (Ctrl-M's)
    jq -r ".certs.${key}" ${responsejson} | sed '/^$/d' | tr -d $'\r' > ${filename}
  done

  filename=${destination}/${name}.chain
  echo "Generating $filename..." >&2
  cat ${destination}/${name}.{intermediate,root} > ${filename}

  filename=${destination}/${name}.pem
  echo "Generating $filename..." >&2
  cat ${destination}/${name}.{certificate,intermediate,root} > ${filename}

  echo "Retrieve certificate complete." >&2
}

# Note: if we change the Common Name, there will be a long wait before the cert
# is ready.
reissue_cert() {
  local order_id=$1
  local name=$2
  local destination=$3

  local cn="*.ribose.com"
  [[ "$4" ]] && \
	cn=$4

  local cipher_type=$5
  local sans="" # "www-afnj8x.ribose.com,www-xfgho3.ribose.com"
  [[ "$6" ]] && \
	sans=$6

  local method_reissue="-X REISSUE"
  local digicert_api_url_reissue="https://api.digicert.com/order/${order_id}"
  local responsejson=${destination}/reissue.response.json
  local jsonpath=$(mkjson)
  local keypath=${destination}/${name}.key
  local pkeypath=${destination}/${name}.pkey
  local csrpath=${destination}/${name}.csr
  local csrsubj="/C=US/ST=Delaware/L=Wilmington/O=Ribose Inc./CN=${cn}"
  local genkey_cmd=""
  local gencsr_cmd=""

  if [ "${cipher_type}" == "rsa" ]; then
    gencsr_cmd="openssl req -new -newkey rsa:2048 -nodes -out ${csrpath} -keyout ${keypath} -subj \"${csrsubj}\""
    echo "${gencsr_cmd}" >&2
    eval "$gencsr_cmd" || \
	errx "Failed to generate CSR (certificate signing request)"
  else
    genkey_cmd="openssl ecparam -out ${pkeypath} -name prime256v1 -genkey"
    gencsr_cmd="openssl req -new -key ${pkeypath} -nodes -out ${csrpath} -subj \"${csrsubj}\""

    if [ "${genkey_cmd}" ]; then
      echo ${genkey_cmd} >&2
      $genkey_cmd || \
	errx "Failed to generate certificate key"
    fi

    # AWS IAM EC certificate needs to remove ""
    # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/ssl-server-cert.html
    # When you specify an ECDHE-ECDSA private key for a certificate that you will
    # upload to IAM, you must delete the lines containing "-----BEGIN EC
    # PARAMETERS-----" and "-----END EC PARAMETERS-----", and the line in between
    # these lines.

    local readonly key_demarc="/^-----BEGIN EC PRIVATE KEY-----\$/,\$!d"
    local keypath=${destination}/${name}.key
    echo "Generating $keypath..." >&2
    extract_key_cmd="cat ${pkeypath} | sed '${key_demarc}' > ${keypath}"
    echo ${extract_key_cmd} >&2
    eval ${extract_key_cmd} || \
	errx "Failed to extract private key from pkey file"

    echo "${gencsr_cmd}" >&2
    eval "$gencsr_cmd" || \
	errx "Failed to generate CSR (certificate signing request)"
  fi

  # input
  local csrcontent=$(<${csrpath})
  # template
  local jsoncontent=$(<${jsonpath})
  echo "${jsoncontent//COMMONNAME/${cn}}" > ${jsonpath}
  local jsoncontent=$(<${jsonpath})
  echo "${jsoncontent//COMMENTS/${sans}}" > ${jsonpath}
  local jsoncontent=$(<${jsonpath})
  echo "${jsoncontent//SANS/${sans}}" > ${jsonpath}
  local jsoncontent=$(<${jsonpath})
  echo "${jsoncontent//CSRS/${csrcontent}}" > ${jsonpath}

  echo "------- JSON TO BE SUBMITTED IS -------" >&2
  cat ${jsonpath} >&2
  echo "------- JSON TO BE SUBMITTED END -------" >&2

  cmd="${curl_cmd} \
    ${digicert_api_user} \
    ${method_reissue} \
    ${digicert_contenttype} \
    -o ${responsejson} \
    --data @${jsonpath} \
    ${digicert_api_url_reissue}"

  echo "------- CURL COMMAND IS -------" >&2
  echo ${cmd} >&2
  echo "------- CURL COMMAND END -------" >&2

  eval ${cmd} >&2 || \
	errx "curl failed"

  echo "------- JSON RETRIEVED IS -------" >&2
  cat ${responsejson} >&2
  printf "\n" >&2
  echo "------- JSON RETRIEVED END -------" >&2

  local has_error=$(jq -r '.errors[]? | has("description")' ${responsejson})
  if [ "${has_error}" == "true" ]; then
	printf "\n\n******** Reissue error ********:\n $(jq -r '.errors[]' ${responsejson})\n\n" >&2
	errx "Failed to reissue certificate."
  fi

  echo "Reissue certificate request submitted. Waiting for it to be available." >&2
}

usage() {
  local progname=$(basename $__progname)
  echo "Usage: $progname"
  echo "  $progname (command: reissue | retrieve) (options)"
  echo "  $progname retrieve -n <certificate-name> -o <order-id> [-p <path>]"
  echo "  $progname reissue -n <certificate-name> -o <order-id> -c '<common-name>' [-s <comma-separated SANS: abc.com,bbc.com>] [-p <path>] [-t <cipher type: ec | rsa>]"
  echo "  Note: if you want to generate a wildcard certificate (common name starts with *), remember to quote it in the -c option!!!"

  exit 1;
} >&2

main() {
	if ([ -z $API_DIGICERT_KEY ] || [ -z $API_DIGICERT_ACCOUNT_ID ]); then
		echo "You must specify these environment variables for authentication: API_DIGICERT_KEY, API_DIGICERT_ACCOUNT_ID" >&2
		exit 1
	fi

	[ ! $1 ] && \
		usage

	local readonly cmd=$1;
	shift

	([ "${cmd}" != "retrieve" ] && [ "${cmd}" != "reissue" ]) && \
		usage

	local sans=""
	local cipher_type="rsa"

  while getopts ":n:o:c:s:p:i:h:t:" o; do
    case "${o}" in
      n)
        name=${OPTARG}
        ;;
      o)
        order_id=${OPTARG}
        ;;
      c)
        common_name=${OPTARG}
        ;;
      s)
        sans=${OPTARG}
        ;;
      p)
        certpath=${OPTARG}
        ;;
      t)
        cipher_type=${OPTARG}
        ;;
      i)
        iid=${OPTARG}
        ;;
      h)
        usage
        ;;
      *)
        usage
        ;;
    esac
  done
  shift $((OPTIND-1))

  [ -z "${name}" ] && \
    errx "Must provide '-n' certificate name"

  [ -z "${order_id}" ] && \
    errx "Must provide '-o' order_id"

  if [ -z ${certpath} ]; then
	certpath=$(pwd)/${name}
	mkdir -p ${certpath} || \
		errx "mkdir -p ${certpath}"
  fi

  [ ${cmd} == "reissue" ] && [ -z "${common_name}" ] && \
	errx "Must provide '-c' common name for reissue"

  ${cmd}_cert ${order_id} ${name} ${certpath} ${common_name} ${cipher_type} "${sans}"
  echo
}

main "$@"

# ./reissue_certificate.sh -o 00900495 -n star_ribose_com -c *.ribose.com

exit 0

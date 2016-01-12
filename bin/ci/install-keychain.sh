#!/usr/bin/env bash

mkdir -p "${HOME}/.calabash"

CODE_SIGN_DIR="${HOME}/.calabash/calabash-codesign"

if [ -e "${CODE_SIGN_DIR}" ]; then
  # In CI, make sure we are on the master with no changes
  if [ -n "${JENKINS_HOME}" ] || [ -n "${TRAVIS}" ]; then
    (cd "${CODE_SIGN_DIR}" && git reset --hard)
    (cd "${CODE_SIGN_DIR}" && git checkout master)
    (cd "${CODE_SIGN_DIR}" && git pull)
  fi
else
  if [ -z "${TRAVIS}" ]; then
    git clone \
      git@github.com:calabash/calabash-codesign.git \
      "${CODE_SIGN_DIR}"
  else
    git clone \
      https://github.com/calabash/calabash-codesign.git \
      "${CODE_SIGN_DIR}"
  fi

  if [ "$?" != "0" ]; then
    echo "ERROR: Could not clone the calabash/calabash-codesign repo."
    echo "ERROR: Do you have permissions?"
    exit 1
  fi
fi

(cd "${CODE_SIGN_DIR}" && ios/create-keychain.sh)
(cd "${CODE_SIGN_DIR}" && ios/import-profiles.sh)

API_TOKEN=`${CODE_SIGN_DIR}/ios/find-xtc-credential.sh api-token | tr -d '\n'`

# Install the API token where briar can find it.
mkdir -p "${HOME}/.calabash/test-cloud"
echo $API_TOKEN > "${HOME}/.calabash/test-cloud/calabash-ios-ci"

if [ ! -e "${HOME}/.xamarin" ]; then
  # Bug in Briar. :(
  ln -s "${HOME}/.calabash" "${HOME}/.xamarin"
fi

# Bug in Briar. :(
touch "${HOME}/.calabash/test-cloud/ios-sets.csv"


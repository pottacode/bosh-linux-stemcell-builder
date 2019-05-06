#!/usr/bin/env bash

set -e

export TERM=xterm

boshagent_version=$(cat boshagent-version/number)
export PATH=/usr/local/ruby/bin:/usr/local/go/bin:$PATH
export GOPATH=$(pwd)/bosh-agent-bluebosh

echo "------------- Initializing bosh-agent git repo -------------"
mkdir -p bosh-agent-bluebosh/src/github.com/cloudfoundry
git clone https://github.com/bluebosh/bosh-agent
mv bosh-agent bosh-agent-bluebosh/src/github.com/cloudfoundry

pushd bosh-agent-bluebosh/src/github.com/cloudfoundry/bosh-agent
git remote add upstream https://github.com/cloudfoundry/bosh-agent

echo "------------- Merging target community bosh-agent to last sl one -------------"
echo "(If any conflict, please fix manually)"
last_branch_sl=`git branch -a | grep remotes/origin/sl | tail -1 | awk -F '\/' '{print $3}'`
git checkout $last_branch_sl
echo $TERM
git branch
git checkout -b sl-v$boshagent_version $last_branch_sl
git branch
git fetch upstream
git config --global user.email "gubin@cn.ibm.com"
git config --global user.name "Bin Gu"
git pull --no-edit upstream refs/tags/v$boshagent_version

echo "------------- Running unit test -------------"
echo "(If failed, please fix manually)"
chown -R bosh $(realpath $PWD/../../../../..)
su bosh -c "env PATH=$PATH GOPATH=$GOPATH bin/test-unit"

echo "------------- Building new sl bosh-agent and rename -------------"
bin/build-linux-amd64
mv out/bosh-agent ../../../../../boshagent-out/bosh-agent-$boshagent_version-sl-linux-amd64

echo "------------- Push to bluebosh -------------"
git push --set-upstream https://$GITHUB_USER:$GITHUB_PASSWORD@github.com/bluebosh/bosh-agent sl-v$boshagent_version
popd

echo "------------- Getting bosh-agent sha1sum -------------"
sha1_value=`sha1sum boshagent-out/bosh-agent-$boshagent_version-sl-linux-amd64 | awk -F ' ' '{print $1}'`
echo "$sha1_value  boshagent-out/bosh-agent-$boshagent_version-sl-linux-amd64" | shasum -c -

echo "New bosh agent url:"
echo "https://s3.amazonaws.com/ng-bosh-softlayer-agent/bosh-agent-$boshagent_version-sl-linux-amd64"
echo "New bosh agent sha1sum:"
echo $sha1_value

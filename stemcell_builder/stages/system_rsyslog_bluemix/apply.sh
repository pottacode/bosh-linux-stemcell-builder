#!/usr/bin/env bash

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash
source $base_dir/lib/prelude_bosh.bash

echo "echo the version of rsyslog before upgrade"
run_in_chroot $chroot "rsyslogd -v"

run_in_chroot $chroot "
cat /etc/resolv.conf
cp /etc/resolv.conf /etc/resolv.conf.1
echo nameserver 8.8.8.8 >> /etc/resolv.conf
add-apt-repository -y ppa:adiscon/v8-stable
"
pkg_mgr install -o Dpkg::Options::="--force-confold" "rsyslog rsyslog-gnutls rsyslog-mmjsonparse rsyslog-relp"

echo "echo the version of rsyslog after upgrade"
run_in_chroot $chroot "
#ln -sf /lib/init/upstart-job /etc/init.d/rsyslog
#update-rc.d rsyslog defaults
rsyslogd -v
systemctl disable rsyslog.service
mv /etc/resolv.conf.1 /etc/resolv.conf
cat /etc/resolv.conf
"

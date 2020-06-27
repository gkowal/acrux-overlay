# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for restic"
ACCT_USER_ID=390
ACCT_USER_GROUPS=( restic )
ACCT_USER_HOME=/var/lib/restic
ACCT_USER_HOME_OWNER=restic:restic
ACCT_USER_HOME_PERMS=700
ACCT_USER_SHELL=/bin/bash

acct-user_add_deps

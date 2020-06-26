# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for restic"
ACCT_USER_ID=390
ACCT_USER_GROUPS=( restic )

acct-user_add_deps

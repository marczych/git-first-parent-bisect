# git-first-parent-bisect

## Motivation

`git bisect` is a powerful tool to detect when bugs were introduced. This is
especially true when using `git bisect run`. However, bisecting with complex
branching and merging sometimes results in invalid or incorrect results because
bisect lands on temporary commits that don't build. Oftentimes, you want to
only test the commits that were made _on_ a particular branch (e.g. `master`)
and skip all of the intermediate commits on branches that were merged into
`master`.

## Usage

```bash
git-first-parent-bisect "$good_commit" "$bad_commit"
```

Where `$good_commit` is the commit where the code was good and `$bad_commit` is
the commit later in history that has bad code. This leaves the user in a
bisecting state with use the usual `git bisect {good,bad,run}` commands
available to find the offending commit.


# Example

The `test-branch` in this repo has some very simple scripts and a bug in it
which we will attempt to find with `git bisect`.

Here's the history at the moment:

```
*   91dfb2e - (test-branch) Merge branch 'test-add-help' into test-branch (2 minutes ago) <Marc Zych>
|\
| * 64fa862 - (test-add-help) Nevermind, back to bash with help (2 minutes ago) <Marc Zych>
| * 55bd3f4 - Another broken commit (3 minutes ago) <Marc Zych>
| * 9c05c5e - Print rather than return (3 minutes ago) <Marc Zych>
| * 2a4b634 - Read stdin (4 minutes ago) <Marc Zych>
| * 8099d34 - Test: Switch to python (21 hours ago) <Marc Zych>
* |   f6b44c2 - Merge branch 'test-more-tests' into test-branch (20 hours ago) <Marc Zych>
|\ \
| |/
|/|
| * 07eddea - (test-more-tests) Fix tests (21 hours ago) <Marc Zych>
| * b6d3555 - More test cases (21 hours ago) <Marc Zych>
| * 5567014 - WIP: Assert function (21 hours ago) <Marc Zych>
|/
* 94d9fd8 - Initial test commit (21 hours ago) <Marc Zych>
```

`HEAD`, `91dfb2e` is currently broken but the initial commit, `94d9fd8`, works
as intended. Let's try normal `git bisect` first:

```
$ git bisect start
$ git bisect bad 91dfb2e
$ git bisect good 94d9fd8
```

This leaves you in a bisecting state. We can take advantage of the test script
by running `git bisect run ./test.sh`.

```
$ git bisect run ./test.sh
running ./test.sh
Bisecting: 2 revisions left to test after this (roughly 1 step)
[b6d355596280afc8dcc60af5056e45d85578c84c] More test cases
running ./test.sh
Failed!
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[556701408f8c0bd3c2665921cdde68963f3a6c7f] WIP: Assert function
running ./test.sh
Failed!
556701408f8c0bd3c2665921cdde68963f3a6c7f is the first bad commit
commit 556701408f8c0bd3c2665921cdde68963f3a6c7f
Author: Marc Zych <marczych@gmail.com>
Date:   Sat Mar 23 19:40:55 2019 -0700

    WIP: Assert function

:100755 100755 245448a30c3e19e899fc22f5821d3d041effcb4c 86649be17b4d716cc8d0b589181f71950c40bcce M      test.sh
bisect run success
```

This is correct in that the test fails on `5567014` but it is fixed on the
`test-more-tests` branch before it gets merged to master so it isn't the commit
we're looking for.

We can instead use `git-first-parent-bisect` to find the commit on `master`
that introduced the failing test:

```
$ git-first-parent-bisect 94d9fd8 91dfb2e
$ git bisect run ./test.sh
running ./test.sh
There are only 'skip'ped commits left to test.
The first bad commit could be any of:
9c05c5e68a344c3a2f53522a319d3b9025da34be
2a4b634e61e2aefcfe800e71d164c4f83e28a078
55bd3f4e1e5b084649059764b821210c908e976c
64fa8629cc5d3a0ed2082bd832ba16514cc336e9
8099d346f8f62ad1a9dccba44c2feea7fb548878
91dfb2eb2cd192b716f3682e2315d482dae2e375
We cannot bisect more!
bisect run cannot continue any more
```

All of the listed commits are the potentially broken ones in the
`test-add-help` branch which _does_ introduce the test failure to master. While
the exact commit wasn't found, you can easily bisect on that branch to narrow
it down further.

--------------

This script was inspired by this StackOverflow answer: https://stackoverflow.com/a/5650992/1135611

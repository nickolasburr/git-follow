# Git Follow

`git follow` follows the lifetime changes of a file (including renames) through the history of a Git repository. As such, it will only display commits where the file was affected, providing a simplified log and patch diff format.

### Installation

To use `git follow`, you need to add the executable somewhere in your `PATH` (e.g. `/usr/local/bin/git-follow`). One solution would be to use `curl` to fetch the latest version:

```shell
cd /usr/local/bin && curl -O https://raw.githubusercontent.com/nickolasburr/git-follow/master/git-follow
```

And make sure the file is executable via `chmod`:

```shell
# in /usr/local/bin (or wherever you put it)
chmod u+x git-follow
```

### Environment Variables

You can set environment variables to customize the output of `git follow`. The following are currently available:

+ `$git_log_diff`: Defaults to `side-by-side` ([`--color-words`](https://git-scm.com/docs/git-log#git-log---color-wordsltregexgt)). Set to `undef` to display `inline`.
+ `$git_no_pager`: Defaults to `undef`. Set to `--no-pager` to prevent Git from using the default pager (e.g. `less`) to display log entries, patch diffs, etc.

### Flags

Options can be specified to provide specific commit information via the use of flags. If no flags are given, all applicable commits will be shown.

+ `-f, --first`: Show the first commit where the file was added to the repository
+ `-F, --func name`: Show all changes for function `name` in the given file
+ `-l, --last [n]`: Show the last _n_ commits where the file was modified (or the last commit, if _n_ is omitted)
+ `-L, --lines n [m]`: Show all changes between lines `n` and `m`. If only one number is given, it will serve as the starting boundary to EOF
+ `-r, --range <startref> [<endref>]`: Show all changes between `<startref>` and `<endref>`. If `<endref>` is omitted, defaults to `HEAD`. See [git-revisions](https://git-scm.com/docs/gitrevisions#_specifying_revisions) for syntax.
+ `-R, --reverse`: Show all changes in reverse order, from oldest to newest
+ `-T, --total`: Show the total number of commits, as an integer

### Usage

**Display the first commit when the file was added to the repository and Git initiated tracking**

```shell
git follow --first composer.json
```

**Display the last 5 commits, where the file was added, modified, and/or deleted** (see [`--diff-filter`](https://git-scm.com/docs/git-log#git-log---diff-filterACDMRTUXB82308203) for details)

```shell
git follow --last 5 composer.json
```

**Display the last commit where lines 5 to EOF were affected**

```shell
git follow --last --lines 5 -- composer.json
```

**Display the last 3 commits where lines 10 through 15 were affected**

```shell
git follow --last 3 --lines 10 15 composer.json
```

**Display all commits where function `funcname` was affected**

```shell
git follow --func funcname archive.c
```

**Only show commits that affected `worktree.c` in the range from fifth ancestor of `master` (`master@{5}`) to `master`**

```shell
git follow --range master@{5} -- worktree.c
...
git follow --range 5 -- worktree.c # same as above (assuming the currently checked out branch is `master`)
```

**Display all commits which occurred between two days and one hour ago and affected `apply.c`**<sup>[1](#relative-format)</sup>

```shell
git follow --range 'master@{2 days ago}' 'master@{1 hour ago}' -- apply.c
```

**Display the total number of commits (as an integer) that affected `rebase.c`**

```shell
git follow --total -- rebase.c
```

<a name="#relative-format">1</a>: If you give a relative time/date that includes spaces (e.g. 10 minutes ago), you need to delimit the string with single or double quotes.

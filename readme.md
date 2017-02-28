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

### Flags

Options can be specified to provide specific commit information via the use of flags. If no flags are given, all applicable commits will be shown.

+ `-f, --first`: Show the first commit where the file was added to the repository
+ `-F, --func name`: Show all changes for function `name` in the given file
+ `-l, --last [n]`: Show the last _n_ commits where the file was modified (or the last commit, if _n_ is omitted)
+ `-L, --lines n [m]`: Show all changes between lines `n` and `m`. If only one number is given, it will serve as the starting boundary to EOF
+ `-r, --reverse`: Show all changes in reverse order, from oldest to newest

### Environment Variables

You can set environment variables to customize the output of `git follow`. The following are currently available:

+ `$git_no_pager`: Defaults to `undef`. Set to `--no-pager` to prevent Git from using the default pager (e.g. `less`) to display log entries, patch diffs, etc.
+ `$git_log_diff`: Defaults to `side-by-side` ([`--color-words`](https://git-scm.com/docs/git-log#git-log---color-wordsltregexgt)). Set to `undef` to display `inline`.

### Usage

**Display the first commit when the file was added to the repository and Git initiated following**

```shell
git follow --first composer.json
```

**Display the last 5 commits, where the file was added, modified, and/or deleted** (see [`--diff-filter`](https://git-scm.com/docs/git-log#git-log---diff-filterACDMRTUXB82308203) for details)

```shell
git follow --last 5 composer.json
```

**Display the last commit where lines 5 to EOF were affected**

```shell
git follow --last --lines 5 composer.json
```

**Display the last 3 commits where lines 10 through 15 were affected**

```shell
git follow --last 3 --lines 10 15 composer.json
```

**Display all commits where function `funcname` was affected**

```shell
git follow --func funcname filename.c
```


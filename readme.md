# git-follow(1)

`git-follow` follows the lifetime changes of a pathspec (including renames) through the history of a Git repository, providing a simplified log and patch diff format.

### Installation

To use `git-follow`, you need to add the executable to your `PATH` (e.g. `/usr/local/bin`).

```shell
cd /usr/local/bin && curl -sSL -O https://raw.githubusercontent.com/nickolasburr/git-follow/master/git-follow
```

Make sure the file is executable via `chmod`:

```shell
# => /usr/local/bin
chmod u+x git-follow
```

`git-follow` also provides a man page for reference. To install the man page:

```shell
cd /usr/share/man/man1 && curl -sSL -O https://raw.githubusercontent.com/nickolasburr/git-follow/master/git-follow.1
```

Once installed, you can view the man page by specifying the `--help` flag option: `git follow --help`.

### Environment

You can set environment variables to customize the output of `git-follow`. The following are currently available:

+ `$GIT_LOG_DIFF`: Diff presentation mode. Defaults to side by side (see [`--color-words`](https://git-scm.com/docs/git-log#git-log---color-wordsltregexgt) for details). Set to `undef` to display inline.
+ `$GIT_NO_PAGER`: Whether Git should use a pager or not. Defaults to true. Set to `--no-pager` to prevent Git from using the default pager (e.g. less) to display commits, patch diffs, etc.

### Options

Options can be specified to provide more refined information. If no options are given, all applicable commits will be shown.

+ `--first`, `-f`: Show the first commit where Git initiated tracking of the given pathspec.
+ `--func`, `-f funcname`: Show commits which affected function `funcname` in the given pathspec. See [git-log(1)](https://git-scm.com/docs/git-log#git-log--Lltfuncnamegtltfilegt) for details.
+ `--last`, `-l [n]`: Show the last `n` commits where the pathspec was affected. Omitting `n` defaults to the last commit.
+ `--lines`, `-L n [m]`: Show commits which affected lines `n` and `m`. Omitting `m` defaults to EOF boundary.
+ `--range`, `-r <startref> [<endref>]`: Show commits between `<startref>` and `<endref>`. Omitting `<endref>` defaults to `HEAD`. See [git-revisions(1)](https://git-scm.com/docs/gitrevisions) for details.
+ `--reverse`, `-R`: Show commits in reverse chronological order.
+ `--total`, `-T`: Show the total number of commits for the given pathspec.

### Examples

**Display the first commit when Git initiated tracking**

```shell
git follow --first composer.json
```

**Display the last 5 commits where the pathspec was affected** (see [`--diff-filter`](https://git-scm.com/docs/git-log#git-log---diff-filterACDMRTUXB82308203) for details)

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

**Only display commits which affected `worktree.c` in the range of fifth ancestor of `master` (`master@{5}`) to `HEAD`**

```shell
git follow --range master@{5} -- worktree.c
...
git follow --range 5 -- worktree.c # same as above (assuming the currently checked out branch is master)
```

**Display commits which occurred between two days ago and one hour ago, and affected `apply.c`**<sup>[1](#relative-format)</sup>

```shell
git follow --range 'master@{2 days ago}' 'master@{1 hour ago}' -- apply.c
```

**Display the total number of commits (as an integer) which affected `rebase.c`**

```shell
git follow --total -- rebase.c
```

<a name="#relative-format">1</a>: If you give a relative time/date that includes spaces (e.g. 10 minutes ago), you need to delimit the string with single or double quotes.

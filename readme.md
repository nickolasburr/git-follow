# git-follow(1)

`git-follow` follows lifetime changes of a pathspec through the history of a Git repository, providing a simplified log and patch diff format.

## Installation

You can install `git-follow` via Homebrew or manually. See the [tap repository](https://github.com/nickolasburr/homebrew-git-follow) for tap-specific information.

### Homebrew

```shell
brew tap nickolasburr/git-follow
brew install git-follow
```

### Manual

Add `git-follow` to your `PATH` (e.g. `/usr/local/bin`).

```shell
cd /usr/local/bin && curl -sSL -O https://raw.githubusercontent.com/nickolasburr/git-follow/master/git-follow
```

Make sure the file is executable via `chmod`:

```shell
# => /usr/local/bin
chmod +x git-follow
```

`git-follow` also provides a man page for reference. To install the man page:

```shell
cd /usr/share/man/man1 && curl -sSL -O https://raw.githubusercontent.com/nickolasburr/git-follow/master/git-follow.1.gz
```

Once installed, you can view the man page by either specifying the `--help` option (e.g. `git follow --help`) or by typing `man git-follow`.

## Environment

You can set environment variables to customize the output of `git-follow`. The following are currently available:

+ `GIT_FOLLOW_DIFF_MODE`: Diff mode. Defaults to inline. See [`--word-diff`](https://git-scm.com/docs/git-log#git-log---word-diffltmodegt), [`--color-words`](https://git-scm.com/docs/git-log#git-log---color-wordsltregexgt), et al. of git-log(1) for syntax.
+ `GIT_FOLLOW_LOG_FORMAT`: Log format. See [`--format`](https://git-scm.com/docs/git-log#git-log---formatltformatgt) of git-log(1) for syntax.
+ `GIT_FOLLOW_NO_PAGER`: No pager mode. Defaults to 0. Set to 1 to prevent Git from using a pager. See [`--no-pager`](https://git-scm.com/docs/git#git---no-pager) of git(1) for details.

## Options

Options can be specified to provide more refined information. If no options are given, all applicable commits will be shown.

+ `--branch`, `-b` `<branchref>`: Show commits specific to a branch.
+ `--first`, `-f`: Show first commit where Git initiated tracking of pathspec.
+ `--func`, `-F` `<funcname>`: Show commits which affected function `<funcname>` in pathspec. See [`-L`](https://git-scm.com/docs/git-log#git-log--Lltfuncnamegtltfilegt) of git-log(1) for details.
+ `--last`, `-l` `[<count>]`: Show last `<count>` commits where pathspec was affected. Omitting `<count>` defaults to last commit.
+ `--lines`, `-L` `<start>` `[<end>]`: Show commits which affected lines `<start>` to `<end>`. Omitting `<end>` defaults to EOF boundary.
+ `--no-patch`, `-N`: Suppress diff output. See [`--no-patch`](https://git-scm.com/docs/git-log#git-log---no-patch) of git-log(1) for details.
+ `--range`, `-r` `<startref>` `[<endref>]`: Show commits in range `<startref>` to `<endref>`. Omitting `<endref>` defaults to `HEAD`. See gitrevisions(1) for details.
+ `--reverse`, `-R`: Show commits in reverse chronological order.
+ `--tag`, `-t` `<tagref>`: Show commits specific to a tag.
+ `--total`, `-T`: Show total number of commits for pathspec.
+ `--version`, `-V`: Show current version number.

## Notes

Like standard Git builtins, git-follow supports an optional pathspec delimiter [--] to help disambiguate options, option arguments, and refs from pathspecs.

## Examples

**Display commits on branch `topic` which affected `blame.c`**

```shell
git follow --branch topic -- blame.c
```

**Display first commit where Git initiated tracking of `branch.c`**

```shell
git follow --first -- branch.c
```

**Display last 5 commits which affected `column.c`** (See [`--diff-filter`](https://git-scm.com/docs/git-log#git-log---diff-filterACDMRTUXB82308203) of git-log(1) for details)

```shell
git follow --last 5 -- column.c
```

**Display last commit where lines 5 through `EOF` were affected in `diff.c`**

```shell
git follow --last --lines 5 -- diff.c
```

**Display last 3 commits where lines 10 through 15 were affected in `bisect.c`**

```shell
git follow --last 3 --lines 10 15 -- bisect.c
```

**Display commits where function `funcname` was affected in `archive.c`**

```shell
git follow --func funcname -- archive.c
```

**Display commits in range `fifth ancestor of master` (`master@{5}`) to `HEAD` which affected `worktree.c`**

```shell
git follow --range master@{5} -- worktree.c
...
git follow --range 5 -- worktree.c # same as above (assuming the currently checked out branch is master)
```

**Display commits in range `2 days ago` and `1 hour ago` which affected `apply.c`**<sup>[1](#relative-format)</sup>

```shell
git follow --range 'master@{2 days ago}' 'master@{1 hour ago}' -- apply.c
```

**Display commits up to tag `v1.5.3` which affected `graph.c`**

```shell
git follow --tag v1.5.3 -- graph.c
```

**Display total number of commits which affected `rebase.c`**

```shell
git follow --total -- rebase.c
```

<a name="#relative-format">1</a>: If you give a relative time/date that includes spaces (e.g. 10 minutes ago), you need to delimit the string with single or double quotes.

## See Also

[git(1)](https://git-scm.com/docs/git), [git-branch(1)](https://git-scm.com/docs/git-branch), [git-check-ref-format(1)](https://git-scm.com/docs/git-check-ref-format), [git-config(1)](https://git-scm.com/docs/git-config), [git-diff(1)](https://git-scm.com/docs/git-diff), [git-log(1)](https://git-scm.com/docs/git-log), [git-remote(1)](https://git-scm.com/docs/git-remote), [gitrevisions(1)](https://git-scm.com/docs/gitrevisions), [git-tag(1)](https://git-scm.com/docs/git-tag)

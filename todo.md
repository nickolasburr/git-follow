# Todo List

### Known Bugs

None, yet.

### Upcoming Features

+ Add `--branch` flag to specify a branch other than the currently checked out branch
+ Add `--merges` flag to also include merge commits (merge commits are suppressed, by default. see [`--no-merges`](https://git-scm.com/docs/git-log#git-log---no-merges))
+ Add `--no-patch` flag to prevent displaying a patch diff (shows patch with stat, by default. see [`--patch-with-stat`](https://git-scm.com/docs/git-log#git-log---patch-with-stat))
+ Add `--no-renames` flag to prevent following renames of a file
+ Add `--pickaxe` flag to search for a generic string in a file

### Potential Features

+ Add `--cherry-picked` flag to only display cherry-picked commits<sup>[1](#cherry-picked)</sup>
+ Add `--diff-algorithm` flag to specify the diff algorithm (see [`--diff-algorithm`](https://git-scm.com/docs/git-log#git-log---diff-algorithmpatienceminimalhistogrammyers) for syntax)

<a name="#cherry-picked">1</a>: This feature is actually quite complex to implement and impossible to guarantee 100% accuracy. Git branches are transient in nature, and when a cherry-picked commit is applied to a branch, the end user has the ability to mask distinguishing properties (see [`git cherry-pick --no-commit`](https://git-scm.com/docs/git-cherry-pick#git-cherry-pick---no-commit) for an example), making it impossible to trace its origins. Likewise, this feature will either be considerably naive (and noted as such) or not implemented at all.

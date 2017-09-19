# Todo List

### Known Bugs

None reported.

### Upcoming Features

+ Add `--pickaxe` flag to search for a generic string in a file.

### Potential Features

+ Add `--cherry-picked` flag to only display cherry-picked commits<sup>[1](#cherry-picked)</sup>
+ Add `--diff-algorithm` flag to specify the diff algorithm (see [`--diff-algorithm`](https://git-scm.com/docs/git-log#git-log---diff-algorithmpatienceminimalhistogrammyers) for details)

<a name="#cherry-picked">1</a>: This feature can never guarantee 100% accuracy. Git branches are transient in nature, and when a cherry-picked commit is applied to a working tree, the user has the ability to mask distinguishing properties (see [`git cherry-pick --no-commit`](https://git-scm.com/docs/git-cherry-pick#git-cherry-pick---no-commit) for an example), making it impossible to trace its origins. As such, this feature will either be considerably naive (and noted as such) or not implemented at all.

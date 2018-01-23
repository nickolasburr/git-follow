# Todo

## Bugs

None reported.

## Features

#### Upcoming

+ Add `--diff-algorithm` option to specify the diff algorithm. Also includes support for `--minimal`, `--patience`, and `--histogram` options.
+ Add `--verbose` option to allow output of internal details to the user. This can be especially useful for debugging.

#### Potential

+ Add `--blame` option to annotate diff output with git-blame(1) style annotations.
+ Add `--cherry-picked` option to only display cherry-picked commits<sup>[1](#cherry-picked)</sup>

<a name="#cherry-picked">1</a>: This feature will never guarantee 100% accuracy. Git branches are transient in nature, and when a cherry-picked commit is applied, the user has the ability to mask distinguishing properties (see [`--no-commit`](https://git-scm.com/docs/git-cherry-pick#git-cherry-pick---no-commit) of git-cherry-pick(1) for an example), making it impossible to trace its origins. As such, this feature will either be considerably naive (and noted as such) or not implemented at all.

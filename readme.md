# Git Track

`git track` tracks the lifetime changes of a file (including renames) through the history of a Git repository. As such, it will only display commits where the file was modified, providing a simplified log and diff format.

Options can be specified to provide specific commit information via the use of flags. If no flags are given, all applicable commits will be shown.

### Flags

+ `-f, --first`: Show the first commit where the file was added to the repository
+ `-F, --func name`: Show all changes for function `name` in the given file
+ `-l, --last [n]`: Show the last _n_ commits where the file was modified (or the last commit, if _n_ is omitted)
+ `-L, --lines n [m]`: Show all changes between lines `n` and `m`. If only one number is given, it will serve as the starting boundary to EOF
+ `-r, --reverse`: Show all changes in reverse order, from oldest to newest

### Environment Variables

You can change the default diff style to either _inline_ or _side-by-side_. The default diff style is _side-by-side_.

To update the default diff style, change `$git_log_default_diff` to the desired value.

### Usage

*Display the first commit for the file*

```shell
git track --first composer.json
```

*Display the last 5 commits for the file*

```shell
git track --last 5 composer.json
```

*Display lines 5 to EOF for the last commit*

```shell
git track --last --lines 5 composer.json
```

*Display changes to lines 10 through 15 in the last 3 commits*

```shell
git track --last 3 --lines 10 15 composer.json
```

*Display lifetime changes to the function `funcname` in filename.c*

```shell
git track --func funcname filename.c
```


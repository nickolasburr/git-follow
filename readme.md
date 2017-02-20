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

You can change the default diff style to either `--inline` or `--side-by-side`. The default diff style is `--side-by-side`.

To update the default diff style, change `$git_log_default_diff` to the desired value.

### Usage

```
git track --first composer.json
```

```
git track --last 5 composer.json
```

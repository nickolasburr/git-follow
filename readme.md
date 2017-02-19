# Git Track

`git track` will track lifetime changes of a file in a Git repository. This will display only commits pertinent to the file, with additional options available via flags.

### Example

```
git track --first composer.json
```

```
git track --last 5 git-track.sh
```

### Flags

+ `--first`: Show the first commit ever for the file
+ `--last [n]`: Show the last _n_ records for the file (or the last single commit, if _n_ is omitted)
+ `--func name`: Show all changes for function `name` in the given file
+ `--lines n m`: Show all changes between lines `n` and `m`. If only one number is given, that will serve as the starting point to the end of the file
+ `--oldest`: Show all changes in reverse order, from oldest to newest

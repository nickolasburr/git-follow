git-follow(1)
=============

``git-follow`` follows lifetime changes of a pathspec in Git, providing a simplified log and diff.

.. contents::
    :local:

Installation
------------

You can install ``git-follow`` via Homebrew or manually.

Homebrew
^^^^^^^^

.. code-block:: sh

   brew tap nickolasburr/pfa
   brew install git-follow

Manual
^^^^^^

.. code-block:: sh

   git clone https://github.com/nickolasburr/git-follow.git
   cd git-follow
   make
   make install

By default, files are installed to ``/usr/local``. You can install elsewhere by passing ``PREFIX`` to ``make install``.

.. code-block:: sh

   make install PREFIX="$HOME/.usr/local"

Configuration
-------------

git-config(1) settings can be used to customize the behavior of git-follow.

.. raw:: html

   <blockquote>
        <table frame="void" rules="none">
            <thead>
                <tr>
                    <th>Configuration</th>
                    <th>Description</th>
                    <th>Settings</th>
                    <th>Default</th>
                </tr>
            </thead>
            <tbody valign="top">
                <tr>
                    <td>
                        <kbd>
                            <span>follow.diff.mode</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Diff mode to use with git-diff(1), git-log(1), git-show(1), etc.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#Documentation/git-log.txt---word-diffltmodegt"><var>--word-diff</var></a> of git-log(1).</span>
                        </div>
                    </td>
                    <td>
                        <div>
                            <code>inline</code>
                        </div>
                        <div>
                            <code>sxs</code>
                        </div>
                        <div>
                            <code>colorsxs</code>
                        </div>
                    </td>
                    <td>
                        <div>
                            <code>inline</code>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>follow.log.format</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Log format to use with git-log(1).</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#Documentation/git-log.txt---formatltformatgt"><var>--format</var></a> of git-log(1) for syntax.</span>
                        </div>
                    </td>
                    <td>
                        <div>
                            <span>-</span>
                        </div>
                    </td>
                    <td>
                        <div>
                            <span>-</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>follow.pager.disable</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Disable pager used with git-diff(1), git-log(1), git-show(1), etc.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git#Documentation/git.txt---no-pager"><var>--no-pager</var></a> of git(1).</span>
                        </div>
                    </td>
                    <td>
                        <div>
                            <code>true</code>
                        </div>
                        <div>
                            <code>false</code>
                        </div>
                    </td>
                    <td>
                        <div>
                            <code>false</code>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
   </blockquote>

Options
-------

Options can be specified to provide more refined information. If no options are given, all applicable commits will be shown.

.. raw:: html

    <blockquote>
        <table frame="void" rules="none">
            <tbody valign="top">
                <tr>
                    <td>
                        <kbd>
                            <span>-b, --branch <var>BRANCH</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits for <var>BRANCH</var></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-f, --first</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show first commit where Git initiated tracking of pathspec.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-F, --func <var>FUNCNAME</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits for function <var>FUNCNAME</var>.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#git-log--Lltfuncnamegtltfilegt"><var>-L</var></a> of git-log(1).</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-l, --last <var>COUNT</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show last <var>COUNT</var> commits for pathspec.</span>
                        </div>
                        <div>
                            <span>Omit <var>COUNT</var> defaults to last commit.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-L, --lines <var>X[,Y]</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits for lines <var>X</var> through <var>Y</var>.</span>
                        </div>
                        <div>
                            <span>Omit <var>Y</var> defaults to <var>EOF</var>.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-M, --no-merges</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits which have a maximum of one parent.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#git-log---no-merges"><var>--no-merges</var></a> of git-log(1).</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-N, --no-patch</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Suppress diff output.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#git-log---no-patch"><var>--no-patch</var></a> of git-log(1).</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-O, --no-renames</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Disable rename detection.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#git-log---no-renames"><var>--no-renames</var></a> of git-log(1).</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-p, --pager</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Force pager when invoking git-log(1).</span>
                        </div>
                        <div>
                            <span>Overrides <var>follow.pager.disable</var> config value.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-P, --pickaxe <var>STRING</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits which change the frequency of <var>STRING</var> in revision history.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#Documentation/git-log.txt--Sltstringgt"><var>-S</var></a> of git-log(1).</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-r, --range <var>X[,Y]</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits in range <var>X</var> through <var>Y</var>.</span>
                        </div>
                        <div>
                            <span>Omit <var>Y</var> defaults to <var>HEAD</var>.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-R, --reverse</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits in reverse chronological order.</span>
                        </div>
                        <div>
                            <span>See <a href="https://git-scm.com/docs/git-log#git-log---walk-reflogs"><var>--walk-reflogs</var></a> of git-log(1).</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-t, --tag <var>TAG</var></span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show commits specific to tag <var>TAG</var>.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-T, --total</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show total number of commits for pathspec.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-h, --help, --usage</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show usage information.</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <kbd>
                            <span>-V, --version</span>
                        </kbd>
                    </td>
                    <td>
                        <div>
                            <span>Show current version number.</span>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </blockquote>

Notes
-----

Like standard Git builtins, ``git-follow`` supports an optional pathspec delimiter ``--`` to help disambiguate options, option arguments, and refs from pathspecs.

Examples
--------

Display commits on branch *topic* which affected *blame.c*

.. code-block:: sh

   git follow --branch topic -- blame.c

Display first commit where Git initiated tracking of *branch.c*

.. code-block:: sh

   git follow --first -- branch.c

Display last *5* commits which affected *column.c*

.. code-block:: sh

   git follow --last 5 -- column.c

Display last commit where lines *5-<EOF>* were affected in *diff.c*

.. code-block:: sh

   git follow --last --lines 5 -- diff.c

Display last *3* commits where lines *10-15* were affected in *bisect.c*

.. code-block:: sh

   git follow --last 3 --lines 10,15 -- bisect.c

Display commits where function *funcname* was affected in *archive.c*

.. code-block:: sh

   git follow --func funcname -- archive.c

Display commits in range from *aa03428* to *b354ef9* which affected *worktree.c*

.. code-block:: sh

   git follow --range aa03428,b354ef9 -- worktree.c

Display commits in range from tag *v1.5.3* to tag *v1.5.4* which affected *apply.c*

.. code-block:: sh

   git follow --range v1.5.3,v1.5.4 -- apply.c

Display commits up to tag *v1.5.3* which affected *graph.c*

.. code-block:: sh

   git follow --tag v1.5.3 -- graph.c

Display total number of commits which affected *rebase.c*

.. code-block:: sh

   git follow --total -- rebase.c

See Also
--------

* `git(1) <https://git-scm.com/docs/git>`_
* `gitrevisions(1) <https://git-scm.com/docs/gitrevisions>`_
* `git-branch(1) <https://git-scm.com/docs/git-branch>`_
* `git-check-ref-format(1) <https://git-scm.com/docs/git-check-ref-format>`_
* `git-config(1) <https://git-scm.com/docs/git-config>`_
* `git-diff(1) <https://git-scm.com/docs/git-diff>`_
* `git-log(1) <https://git-scm.com/docs/git-log>`_
* `git-remote(1) <https://git-scm.com/docs/git-remote>`_
* `git-tag(1) <https://git-scm.com/docs/git-tag>`_

# Конфигурация для Neovim 0.8+

Личная конфигурация для Neovim c упором на веб-разработку (vue3, js, ts).

## Зависимости

1. [Neovim 0.8.+](https://github.com/neovim/neovim);
2. [NerdFonts](https://www.nerdfonts.com);
3. [rigrep](https://github.com/BurntSushi/ripgrep);
4. [fd](https://github.com/sharkdp/fd);
5. `wget` или `curl`;
6. `git`;
7. `node`, `npm`;

Characters in {string} are queued for processing as if they come from a mapping or were typed by the user.

By default the string is added to the end of the typeahead buffer, thus if a mapping is still being executed the characters come after them.  Use the 'i' flag to insert before other characters, they will be executed next, before any characters from a mapping.

The function does not wait for processing of keys contained in {string}.

To include special keys into {string}, use double-quotes and "\..." notation |expr-quote|. For example, feedkeys("\<CR>") simulates pressing of the <Enter> key. But feedkeys('\<CR>') pushes 5 characters. The |<Ignore>| keycode may be used to exit the wait-for-character without doing anything.

{mode} is a String, which can contain these character flags:
'm'	Remap keys. This is default.  If {mode} is absent, keys are remapped.
'n'	Do not remap keys.
't'	Handle keys as if typed; otherwise they are handled as if coming from a mapping.  This matters for undo, opening folds, etc.
'i'	Insert the string instead of appending (see above).
'x'	Execute commands until typeahead is empty.  This is similar to using ":normal!".  You can call feedkeys() several times without 'x' and then one time with 'x' (possibly with an empty {string}) to execute all the typeahead.  Note that when Vim ends in Insert mode it will behave as if <Esc> is typed, to avoid getting stuck, waiting for a character to be typed before the script continues.
Note that if you manage to call feedkeys() while executing commands, thus calling it recursively, then all typeahead will be consumed by the last call.
'!'	When used with 'x' will not end Insert mode. Can be used in a test when a timer is set to exit Insert mode a little later.  Useful for testing CursorHoldI.

Return value is always 0.

Can also be used as a |method|:
GetInput()->feedkeys()

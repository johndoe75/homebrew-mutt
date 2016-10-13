# homebrew-mutt-patched

This repository was originally derived from
[sgeb/homebrew-mutt](https://github.com/sgeb/homebrew-mutt).

-

Convenience repository to add the [xlabel-patch](http://home.uchicago.edu/~dgc/mutt/#x-label) to mutt-1.7.x formula for homebrew.  The following feature is enabled with this formula:

- [X-Label](http://home.uchicago.edu/~dgc/mutt/#x-label):
  enable with `--with-xlabel-patch`.  Note that the original dgc patch was
  adjusted to fit for mutt-1.7.x.

## How to install

If you had previously installed the default homebrew mutt, you must uninstall
that version first:

```
> brew uninstall mutt
```

Then proceed with installation based on custom formula:

```bash
> brew tap johndoe75/mutt-patched
# There will be a warning regarding overriding existing formula 'mutt'

> brew options johndoe75/mutt-patched/mutt
# List of available options

> brew install johndoe75/mutt/mutt \
  --with-xlabel-patch \
# Compile and install customized mutt
```

## muttrc

Bind X-Label to a key for adding labels to messages.  E.g.

```
bind  index y           edit-label
```

I also like to see the label in message reader view:

```
ignore *
unignore x-label
hdr_order {replace with your setting} X-Label
```

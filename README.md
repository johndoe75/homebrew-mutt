# homebrew-mutt

This repository was originally forked from
[sgeb/homebrew-mutt](https://github.com/sgeb/homebrew-mutt).

-

Convenience repository with additional features to the mutt formula for homebrew.  The following features are enabled with this formula:

- [X-Label](http://home.uchicago.edu/~dgc/mutt/#x-label):
  enable with `--with-xlabel-patch`.  Note that the original dgc patch was
  adjusted to fit for mutt1.5.23.

From sgeb's repository this formula provides:

- [Sidebar](https://github.com/sgeb/homebrew-mutt/blob/master/patches/mutt-sidebar.patch):
  enable with `--with-sidebar-patch`.
  [[Source](http://www.lunar-linux.org/mutt-sidebar/)]

- [Gmail Server
  Search](https://github.com/sgeb/homebrew-mutt/blob/master/patches/patch-mutt-gmailcustomsearch.v1.patch):
  enable with `--with-gmail-server-search-patch`. Note that Gmail Server Search
  only works when directly connected to Gmail via IMAP.
  [[Source](http://permalink.gmane.org/gmane.mail.mutt.devel/19624)]

- [Gmail
  Labels](https://github.com/sgeb/homebrew-mutt/blob/master/patches/mutt-1.5.23-gmail-labels.sgeb.v1.patch):
  enable with `--with-gmail-labels-patch`. Originally based on [a
  patch](https://www.mail-archive.com/mutt-dev@mutt.org/msg07593.html) by Todd
  Hoffmann. Add `%?y?(%y)?` to your `index_format` to conditionally display the
  associated labels and make sure to disable `header_cache`. Labels 'Important'
  and 'Starred' are stripped from the list of labels. Note that Gmail Labels
  only work when directly connected to Gmail via IMAP.
  
## How to install

If you had previously installed the default homebrew mutt, you must uninstall
that version first:

```
> brew uninstall mutt
```

Then proceed with installation based on custom formula:

```bash
> brew tap johndoe75/mutt
# There will be a warning regarding overriding existing formula 'mutt'

> brew options johndoe75/mutt/mutt
# List of available options

> brew install johndoe75/mutt/mutt \
  --with-xlabel-patch \
  --with-sidebar-patch \
  --with-gmail-server-search-patch \
  --with-gmail-labels-patch
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

# My mutt version including xlabel patch

class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage "http://www.mutt.org/"
  url "ftp://ftp.mutt.org/pub/mutt/mutt-1.7.0.tar.gz"
  mirror "https://fossies.org/linux/misc/mutt-1.7.0.tar.gz"
  sha256 "1d3e987433d8c92ef88a604f4dcefdb35a86ce73f3eff0157e2e491e5b55b345"

  bottle do
    sha256 "32cc7f3bc105d83e94cb5f13afbda897e6486504c91a7559fe2e06af0cd0f45b" => :sierra
    sha256 "d6d8b79f1b714d1d6f94b82e81825958ea7aa507fa47d8aacdf9bee93132d5b7" => :el_capitan
    sha256 "90db768f00dc9d6c8e96a98f5d8f5a74c605b5bc46ea98871d99611da25184fb" => :yosemite
    sha256 "63d588e1c1487ff6bfffc51180ff644307ffc8e6463436b9a001706dffcc1368" => :mavericks
  end

  head do
    url 'http://dev.mutt.org/hg/mutt#default', :using => :hg

    resource 'html' do
      url 'http://dev.mutt.org/doc/manual.html', :using => :nounzip
    end
  end

  option "with-debug", "Build with debug option enabled"
  option "with-s-lang", "Build against slang instead of ncurses"
  # --> Added patches
  option "with-pgp-verbose-mime-patch" "Apply pgp-verbose-mime-patch"
  option "with-gmail-labels-patch", "Apply gmail labels patch"
  option "with-xlabel-patch", "Apply X-Label patch"
  # <-- Added patches

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "gettext" => :optional
  depends_on "gpgme" => :optional
  depends_on "libidn" => :optional
  depends_on "s-lang" => :optional

  conflicts_with "tin",
    :because => "both install mmdf.5 and mbox.5 man pages"

  conflicts_with "mutt", :because => "both install mutt binaries"

  # original source for this went missing, patch sourced from Arch at
  patch do
    url "https://raw.githubusercontent.com/sgeb/homebrew-mutt/master/patches/13-pgp-verbose-mime.patch"
    sha256 "ef9c19d4115a4d4a95af5a78cac2d7788592edc547e1fd9b0fe40f4ab04e1698"
  end if build.with? "pgp-verbose-mime-patch"

  patch do
    url "https://raw.githubusercontent.com/johndoe75/homebrew-mutt-patched/devel/patches/mutt-1.5.23-gmail-labels.sgeb.v1.patch"
    sha256 "2b80584e0e799d798f250f6559d6f9bb517ac4a7c47e739318eb8263c8f67a7c"
  end if build.with? "gmail-labels-patch"

  patch do
    url "https://raw.githubusercontent.com/johndoe75/homebrew-mutt-patched/master/patches/patch-1.7.1.xlabel"
    sha256 "7b33a445c49097f9967d6366998a8e47b20d75e19501c82221899386046e9632"
  end if build.with? "xlabel-patch"

  def install
    user_admin = Etc.getgrnam("admin").mem.include?(ENV["USER"])

    args = %W[
      --disable-dependency-tracking
      --disable-warnings
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --with-sasl
      --with-gss
      --enable-imap
      --enable-smtp
      --enable-pop
      --enable-hcache
      --with-tokyocabinet
      --enable-sidebar
      --enable-mailtool
      --with-regex
    ]

    # This is just a trick to keep 'make install' from trying
    # to chgrp the mutt_dotlock file (which we can't do if
    # we're running as an unprivileged user)
    args << "--with-homespool=.mbox" unless user_admin

    args << "--disable-nls" if build.without? "gettext"
    args << "--enable-gpgme" if build.with? "gpgme"
    args << "--with-slang" if build.with? "s-lang"

    if build.with? "debug"
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./prepare", *args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    if user_admin
      inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = admin"
    end

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  test do
    system bin/"mutt", "-D"
  end
end

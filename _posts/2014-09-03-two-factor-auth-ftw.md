---
layout: post
title:  "Two-factor Auth, FTW!"
date:   2014-09-03 12:00:00
author: joel_nimety
---

### Caveat Emptor

Some of you may have heard about the recent targeted [AppleID
hack](http://online.wsj.com/articles/apple-investigating-reports-of-icloud-vulnerabilities-1409608366).
Apple [could have done more](http://www.huffingtonpost.com/2014/09/01/icloud-bug-fixed_n_5748642.html)
to protect user accounts but barring cases of negligence it's silly to
think that security is the sole responsibility of the service provider.
If you appreciate the convenience of modern technology for accessing and
sharing your data (like I do) then it's on you to understand how your
data is shared and where it's stored.

The fact is, Apple and many other service providers provide a simple
opt-in security setting that can drastically decrease the risk of data
loss via brute force login.

### Enter Two-Factor Authentication

Two-factor authentication for your online accounts involves you, as an
Account holder, knowing two types of information:

  * Something only you know (e.g., password, security questions)
  * Something only you have (e.g., ATM card, smart card, mobile phone)

You're already using passwords to sign into your accounts, the second
factor is something you have.  Two common options are Soft Tokens, time
sensitive pin numbers presented to you via an app on your smart phone;
and SMS tokens, one time use pin numbers sent to you via text message.

SMS tokens are the easiest to use, and will work as long as you can
receive text messages at the configured phone number.  Soft Tokens
can be a bit of a pain when changing phones but work regardless of
internet/cell connectivity.  For most, SMS tokens are the best option
but if you're a power user consider using a Soft Token like [Google
Authenticator](https://support.google.com/accounts/answer/1066447?hl=en)
or [Authy](https://www.authy.com/consumers).

If you're interested in more detail,
[Wikipedia's Multi-Factor authentication
article](http://en.wikipedia.org/wiki/Multi-factor_authentication) is a
good start.

### What next?

Take a moment to think about the personal data you keep online and
consider enabling two-factor auth on all of your accounts that support
it.  Here's a short list of common services that offer
two factor auth:

  * [AppleID](http://support.apple.com/kb/ht5570) (ios devices, icloud, itunes, etc)
  * [Google](https://www.google.com/landing/2step/) (gmail, google apps, picasa, android devices, etc)
  * [Dropbox](https://www.dropbox.com/help/363)
  * [Facebook](https://www.facebook.com/note.php?note_id=10150172618258920)
  * [Twitter](https://blog.twitter.com/2013/getting-started-with-login-verification)

_IMPORTANT!_ Any service that offers two-factor auth should also provide
backup codes that can be used to restore access to your account should
you lose (or break) the "something you have".  These codes should be
printed and kept safe in a secure location, like a safe or a safe
deposit box. (Remember those?)

The victims of the recent AppleID hack could have enabled two-factor
authentication and saved themselves a lot of embarassment and grief.  So
what are you waiting for?  Go enable two-factor auth!

### P.S.

If you're wondering about Continuity Control supporting two-factor auth,
we plan on adding it as a per-client or per-user feature by the end of
this year.  Keep you eye out for this feature announcement!

##### :wq

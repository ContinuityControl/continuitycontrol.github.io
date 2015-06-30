---
layout: post
title: "Make t(we)mux Work for You"
author: tricia_ball
modified:
categories: terminal, tmux, wemux
excerpt: A bunch of tmux tweaks that made our lives better. Maybe they can make yours better, too!
tags: [tmux]
image:
  feature:
---

Even YOU can love tmux!


# Background tl;dr

I was introduced to the linux command line and vi while in college
something-something years ago.  As I did not want to drive to campus to do my
CS assignments, I would telnet into the lab, and cuss at my machine while
trying to use vi to do my homework.

Since then, I was glad I learned those skills, as they came in handy every now
and again, but I was never a power user, and used vi and the command line very
inefficiently.

When I started at Continuity this past January, I was thrown head-first into a
big pool of linux, and all of its wonderful tools. I went from developing in
the JetBrains' RubyMine IDE on a mac, to ssh-ing into the "cloud" and living in
linux with tmux and developing in vim.

My fingers fumbled while using tmux and navigating between tmux windows and vim
windows and trying to keep track of where I was. I found it all pretty
intimidating.

One day, however, I noticed a problem I wanted solved. I was looking to change
the color of tmux window titles depending on the title name, so I started
digging into tmux configuration. Honestly, I'm still looking for a solution
to this specific desire (so if you have an idea.... send me a tweet!), but
found plenty of other cool things along the way.


# The real meat (or tofu)

## Issue 1 - Not in expected directory:
I would create a new tmux window, run a command, and receive an "I have no
clue what you're talking about" error. Inevitably, I would create my new window
and it would take me to the directory in which I was in when I first logged in
to tmux. However, that often was that the directory where I would want to work.

### Solution
To resolve this, I updated the tmux configs (.tmux.conf) to have new windows open
in the same path as the current window.

```
# Newly created windows go to same path as current window
bind c new-window -c "#{pane_current_path}"
```

This allows me to choose which project path I'm working in after I am in my tmux session,
and allows me to switch projects mid-session, and can easily assume I'm in the correct
directory without having to double-check.

## Issue 2 - What tab am I trying to view?
Throughout the course of a tmux session, I often open and close several tmux
windows based on my needs.  By default, the tmux windows retain the same
identifying number. This means I can create 4 windows and close the first
three, causing the window now visually in the first slot, to be window #3 (on a
0 index) Although the window numbers are displayed, it still contradicts the
visual location of the window. This also caused confusion when creating a new
window, since that fills the first 'empty' window number causing me to have
window 0 in the first slot, and window 3 in the second.

### Solution
The solution for this issue is quite simple, as tmux has an option for this right out
of the box. Simply set the 'renumber-windows' option to 'on' like this:

```
# Renumber windows when one is deleted
set -g renumber-windows on
```

## Issue 3 - Which tab am I on again?
Tmux is great about indicating the current tab with an asterisk (\*), but for me, that's
a little too little for me to notice. I needed something a bit more obvious to remind
me which window I was using.

### Solution
With the help of Google, I came across this useful tmux post (http://taoofmac.com/space/cli/tmux).
In this article, I found lots of settings for colorings on the status bar. Below are the
two pieces that worked specifically with status bar and active window coloring. We
adjusted the colors to better suit our needs.

```
# default statusbar colors
set-option -ag status-bg black
set-option -ag status-fg default
set-option -ag status-attr default

# active window title colors
set-window-option -ag window-status-current-fg yellow
set-window-option -ag window-status-current-bg default
set-window-option -ag window-status-current-attr dim
```

The full version of our .tmux.conf file can be found here:
https://github.com/ContinuityControl/dotfiles/blob/master/home/.tmux.conf.


## Issue 4 - How much longer?
This is probably my favorite update to our setup. At Continuity, we work mostly in [pairs](https://en.wikipedia.org/wiki/Pair_programming).
We also have our developers spread across three states, and two timezones, yet we pair program with all developers. We work together
using an enhancement on tmux called [wemux](https://github.com/zolrath/wemux) where multiple clients can join in the same tmux session.

We also work using [Pomodoros](http://pomodorotechnique.com/) where we work in 25 minute bursts separated by 5 minute breaks. However,
with our developer team all spread out, it always felt clumsy setting a time, and trying to share it with the other half of the pair.

### Solution
Frustrated by this, I went out to create a timer that we could see in our shared tmux session. Lucky for me, I discovered
someone else had done the work of creating such a thing. All I had to do was add and configure it.

In my research, I came across the [Thyme](https://github.com/hughbien/thyme) gem for Ruby created by Hugh Bien (@hughbien).
All I had to do was install the gem, and integrate it in with our tmux configs. Of course, that didn't fully satisfy me, so
I added some extra *pizzazle*. I'll explain this more below.

First I had to add the gem to my Gemfile

```
gem 'thyme'
```

If you don't have a Gemfile, you can just install Thyme with:
```
$ gem install thyme
```

I then created the .thymerc file using much of the configuration shown in the gem's [README](https://github.com/hughbien/thyme/blob/master/README.md),
but added a few more specific options. Also, don't forget to turn tmux on with this file.

```
.
.
.
set :tmux, true
.
.
.

option :p, :pomodoro, 'start a pomodoro' do
  run
end

option :b, :break, 'start a break' do
  set :timer, 5*60
  run
end

option :l, :long_break, 'start a long break' do
  set :timer, 10*60
  run
end

option :m, 'minutes num', 'run with custom minutes' do |num|
  @timer = num.to_i * 60
  run
end
```

I then integrated it with tmux in the .tmux.conf file.

```
set-option -g status-right '#(cat ~/.thyme-tmux)'
set-option -g status-interval 1
```

I know, you're sayin' "What's so special about that, Trish?" Well, here's the pizzazle I promised.

I didn't want us to have to think about running

```
$ thyme -d
```

anytime we wanted to start a timer in the background. If that were the case, it
wouldn't get used, ever. So I added in some tmux key bindings and a tmux prompt.

```
bind t command-prompt -p "Timer type? p: pomoodoro; b: break; l: long break; m <mins>: custom minutes" "run -b 'thyme -d%1 %2'"
```

With this, all we have to do within tmux is run our tmux prefix (for us ctrl+A) and then 't'. The user is then prompted to enter
the type of timer to start. They can even enter 'm' and the number of minutes for the timer. This is handy if you forgot to start
a timer, or needed to pause a timer and restart at 'x' minutes.

That not enough?

Okay, it wasn't for me, either. Being on a remote server, passing sounds and messages over to our local machines did not seem like
a practical change. However, it wasn't super obvious when a timer ended. Because of this, I updated it so the status bar
turns magenta after a timer ends.

To do this, I used thyme's before and after hooks, and updated the colors using our Solarized color scheme.

```
before do
  `tmux set-option -g status-bg black`
end

after do |seconds_left|
  if @tmux
    `tmux set-option -g status-bg magenta`
  end
end
```

I also did not want to have to deal with a pink bar when I was not worried about the timer, so I added a reset option that hooked into my tmux
key binding.

```
option :r, :reset, 'reset status bar' do
  `tmux set-option -g status-bg black`
end
```

This allows us to use ctrl+A r to reset the status bar color.

## That's it for now
I am sure over time I will find some other useful tmux tweaks to put in place, but this is working well for us, now. Feel free to check out our public dotfiles repo if you
want to see any of these settings in full. Specifically, here is our [.thymerc](https://github.com/ContinuityControl/dotfiles/blob/master/home/.thymerc) and our [.tmux.conf](https://github.com/ContinuityControl/dotfiles/blob/master/home/.tmux.conf)

It's been a pleasure.

:wq

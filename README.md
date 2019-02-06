![header](https://i.imgur.com/EWlF8V8.png)

# Freelancer's Dashboard

This app is a work in progress and it's made for freelancers who need to keep a simple track of time and earnings. I'm still learning Swift, so bare with me :blush:

![](https://img.shields.io/github/issues/dragstor/freelancers-dashboard.svg?style=flat)![](https://img.shields.io/github/license/dragstor/freelancers-dashboard.svg?style=flat)![](https://img.shields.io/github/commit-activity/m/dragstor/freelancers-dashboard.svg?style=flat)![](https://img.shields.io/github/languages/code-size/dragstor/freelancers-dashboard.svg?style=flat)

## Features

- Dark and light appearance OOB
- Simple work timer
- Simple earnings overview
- Configurable
  - Maximum weekly working hours
  - Hourly rate (used to calculate earnings)
  - Autostart

# The App

App consists of the popover timer (sits in the status bar) and a main window with few features currently available.

##Main window

![main window](https://i.imgur.com/LvRVhjH.png)

The app itslef consists of a main window with (currently) just a few available features, such as:

- Time sheets
  - for today
  - for current week
- Earnings
- Preferences

## Popover Timer

![Popover Timer](https://i.imgur.com/6hIBtbt.png)

Perhaps the most useful feature - work timer. It's fully manual, so user has to start and stop the timer before and after they finish with work they want to log time for.

# 3rd party libraries & attributions

- sindresorhus's [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin)
- Icons & glyphs from https://icons8.com/ App

# TODO

- [ ] Enter worked hours into the timesheet upon stopping the timer
- [ ] Edit worked hours (from the timesheets)
- [ ] Implement calendar (extend timesheets)
- [ ] Automatically calculate earnings (based on timesheets)

# License

GPL 3.0

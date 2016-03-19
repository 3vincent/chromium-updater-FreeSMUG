Chromium Upgrader for Mac OS X
==============================
(using FreeSMUG builds)
-----------------------

[Chromium](http://www.chromium.org/) is a free open source Web browser based on [Webkit](http://webkit.org/) and represents a credible alternative to [Chrome](http://www.google.com/chrome), the Google Web browser.

While Chrome offers built-in automatic updates, Chromium.app strangely doesn't: you're supposed to download manually the latest build, unzip it and replace your previous version with it. As it may sound dead simple at first glance, this task can become especially boring when done on a daily basis. So this script will try to upgrade to latest OS X Chromium build on your system via the command line.

Installation
------------

I suggest installation to be done in `/usr/local` directory.

    $ cd /usr/local
    $ git clone git://github.com/mkody/chromium-updater-FreeSMUG.git getchromium
    $ ln -s /usr/local/getchromium/getchromium.sh /usr/local/bin/getchromium

Last, don't forget to add the execution bit to the script:

    $ chmod +x /usr/local/getchromium/getchromium.sh

Usage
-----

Run it that way:

    $ getchromium

**CAUTION**: The script will replace your previous installation of `Chromium.app`. Make backups if you're paranoid. Anyway, your profile will ever be safe because it's stored elsewhere on the system.

Notes
-----

This is a fork of [n1k0/chromium-updater](https://github.com/n1k0/chromium-updater) to update to the latest **FreeSMUG Chromium 64bit build** from command line.

I was using [n1k0/chromium-updater](https://github.com/n1k0/chromium-updater) before, but I wanted to use a more "stable" version and with PepperFlash integrated.

I'm using FreeSMUG Sourceforge RSS to get the latest version from them, mounting the archive and copying everything in place. You can sure change the destination path from the script.

The script is intended and only intended to be used on Mac OS X Snow Leopard (10.6.x) and up. Feel free to send any patch or pull request if you want to contribute enhancements.

Notes
-----

2016-03-18, 3vincent: I wanted to have a simple way to update FreeSmug-Chromium under OS X to the newest version, since neither the Chromium Plug-In nor the Sparkle Update Kit still work. I updated this script to make it work again, by adding the SSL/TLS Path to sourceforge (https://...) – Please look at the list of Contributers! I did not do anything valuable to make this script work the way it does other than adding one character "s". 

2016-03-19, 3vincent: Added an Update-Checker function
2016-03-19, 3vincent: Created a simple Daemon that checks for updates in the background. If an Update is available it notifies the User via Apple Script Alert: "Press OK to quit Chromium and install the update. Else cancel." You can install the Daemon with cron or launchd (Check http://launchd.info/ for more info on launchd.) A launchd file and installation guide will be available soon. 

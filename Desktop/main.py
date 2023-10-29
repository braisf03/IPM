from Presenter import Presenter

from View import MiAplicacion

import gettext

import os

import locale
locale.setlocale(locale.LC_ALL, '')
locale.bindtextdomain("App", "locale")
gettext.bindtextdomain("App", "locale")
gettext.textdomain("App")

if __name__ == "__main__":

    presenter = Presenter(view = MiAplicacion())
    presenter.run()
    
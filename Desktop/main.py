from Presenter import Presenter

from View import MiAplicacion

import gettext

import os

import locale
default_locale = "en_EN"


try:
    locale.setlocale(locale.LC_ALL, '')
except locale.Error as e:
    locale.setlocale(locale.LC_ALL, default_locale)
    print("Error al poner el idioma de tu pc:")

locale.bindtextdomain("App", "locale")
gettext.bindtextdomain("App", "locale")
gettext.textdomain("App")

if __name__ == "__main__":

    presenter = Presenter(view = MiAplicacion())
    presenter.run()
    
# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-siika

CONFIG += sailfishapp

SOURCES += src/siika.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    rpm/siika.spec \
    qml/pics/sc-fish6.png \
    qml/pics/sc-fish5.png \
    qml/pics/sc-fish4.png \
    qml/pics/sc-fish3.png \
    qml/pics/sc-fish2.png \
    qml/pics/sc-fish1.png \
    qml/pics/sc-fish0.png \
    qml/pics/eketux.png \
    qml/wavs/nomnom.wav \
    qml/wavs/kahenkilonsiika.wav \
    qml/pages/Siikapeli.qml \
    rpm/harbour-siika.spec \
    harbour-siika.desktop \
    qml/harbour-siika.qml \
    qml/pages/TietojaPage.qml \
    qml/components/TimedItem.qml \
    qml/components/Monja.qml \
    qml/components/Explosion.qml \
    qml/components/Bubbles.qml \
    qml/pics/tynnyri.png \
    qml/pics/explosion_red.png \
    qml/pics/explosion_black.png \
    qml/sounds/boom.wav \
    qml/pics/kupla.png


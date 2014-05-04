/*
    Explosion - Explosion animation with sound for siika

    Copyright (c) 2013 Kimmo Lindholm, (kimmoli) kimmo.lindholm@gmail.com

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

*/


import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Item
{
    id: explosion

    property int xCord: 100
    property int yCord: 100

    property variant figures: [ "../pics/explosion_red.png", "../pics/explosion_black.png" ]
    property variant intervals: [ 50, 100 ]

    property int stage: 0

    function blowUp()
    {
            stage = 0
            fig.source = figures[stage]
            fig.visible = true
            explosionTimer.interval = intervals[stage]
            if (boom.availability === Audio.Available)
                boom.play()
            explosionTimer.restart()
    }

    Item
    {
        Timer
        {
            id: explosionTimer
            repeat: false
            running: false
            onTriggered:
            {
                ++stage

                switch (stage)
                {
                    case 1 :
                        fig.source = figures[stage]
                        interval = intervals[stage]
                        restart()
                        break
                    case 2 :
                        fig.visible = false
                        break
                    default :
                        break
                }
            }
        }

        Image
        {
            id: fig
            x: xCord - fig.width/2
            y: yCord - fig.height/2
            smooth: true
            visible: false
        }


        Audio
        {
            id: boom
            source: "../sounds/boom.wav"
        }


    }
}

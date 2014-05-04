/*
    timedItem - a appearing falling clickable item for siika

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


Item
{
    id: timedItem

    property int xCord: 100
    property int yCord: 100
    property int timeToClick: 1000
    property bool fallsToBottom: false
    property int fallsTo: 0
    property bool canBeClicked: true

    property url source: ""
    signal itemExpired()
    signal itemClicked()

    property alias itemWidth: fig.width
    property alias itemHeight: fig.height

    /* Feedbacks during falling animation */
    function itemX()
    {
        return fig.x + (fig.width/2)
    }

    function itemY()
    {
        return fig.y + (fig.height/2)
    }

    property bool itemEnabled: false

    function enableItem()
    {
        itemEnabled = true
        canBeClicked = true
        fig.rotation = 0
        itemTimer.restart()
    }

    Item
    {
        Timer
        {
            id: itemTimer
            interval: timeToClick
            repeat: false
            running: false
            onTriggered:
            {

                if (!fallsToBottom)
                {
                    itemEnabled = false
                    timedItem.itemExpired()
                }
                else
                    fallingAnimation.restart()
            }
        }

        Timer
        {
            id: postDelay
            interval: 500
            repeat: false
            running:false
            onTriggered: itemEnabled = false
        }

        Image
        {
            id: fig
            x: xCord - fig.width/2
            y: yCord - fig.height/2
            smooth: true
            visible: itemEnabled
            source: timedItem.source
        }

        NumberAnimation
        {
            id: fallingAnimation
            target: fig
            property: "y"
            alwaysRunToEnd: false
            easing.type: Easing.Linear
            from: yCord
            to: fallsTo
            duration: 1.5*(960-yCord)
            running: false
            onStopped:
            {
                rotatingAnimation.stop()

                if (itemEnabled) /* Not stopped by click */
                {
                    canBeClicked = false
                    postDelay.restart()
                    timedItem.itemExpired()
                }
            }
            onStarted: rotatingAnimation.restart()
        }

        NumberAnimation
        {
            id: rotatingAnimation
            target: fig
            property: "rotation"
            alwaysRunToEnd: false
            easing.type: Easing.Linear
            from: 0
            to: xCord>270 ? -90 : 90
            duration: 1.5*(960-yCord)
            running: false
        }

        MouseArea
        {
            anchors.fill: fig
            enabled: (itemEnabled && canBeClicked)
            onPressed:
            {
                itemTimer.stop()
                itemEnabled = false
                if (fallsToBottom)
                    fallingAnimation.stop()
                timedItem.itemClicked()
            }
        }
    }
}

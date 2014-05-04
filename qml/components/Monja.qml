/*
    Monja - Green stuff at bottom of screen for siika

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


Rectangle
{
    id: monja
    property int level: 0

    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    height: (level < parent.height) ? ((level > 0) ? level : 0) : parent.height

    Behavior on level
    {
        NumberAnimation
        {
            easing.type: Easing.Linear
            duration: 1000
        }
    }

    gradient: Gradient
    {
        GradientStop { position: 0.0; color: "transparent" }
        GradientStop { position: 0.75; color: "lightgreen" }
        GradientStop { position: 1.0; color: "darkgreen" }
    }
}

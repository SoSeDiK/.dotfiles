import QtQuick
import QtQuick.Layouts

import ".."

Item {
    id: animatedDigit

    readonly property bool overflowAnim: true
    readonly property int baseAnimSpeed: 200
    readonly property int reverseAnimSpeed: 70
    readonly property int reverseStillTime: 20
    readonly property int baseOffset: 0

    required property int currentDigit

    property int animOffset: parent.height * 2
    property int animSpeed: baseAnimSpeed
    property int digitA: 0
    property int digitB: 0
    property bool upper: false

    implicitWidth: currentText.implicitWidth
    height: parent.height

    ClockDigit {
        id: currentText
        text: digitA
        y: baseOffset - ((height - font.pixelSize) / 4)
    }

    ClockDigit {
        id: previousText
        text: digitB
        y: animOffset
    }

    onCurrentDigitChanged: {
        if (height === 0) {
            if (upper) {
                digitB = currentDigit;
            } else {
                digitA = currentDigit;
            }
            return;
        }

        if (overflowAnim && currentDigit == 0) {
            animSpeed = reverseAnimSpeed;
            animOffset = -animOffset;
            if (animOffset != 0) {
                loopBackAnimator.loops = upper ? digitB : digitA;
                loopBackAnimator.running = true;
            }
            return;
        }

        if (upper) {
            digitB = currentDigit;
        } else {
            digitA = currentDigit;
        }
        upper = !upper;
        if (animOffset != 0) {
            currentDigitAnimation.start();
            previousDigitAnimation.start();
        }
    }

    Timer {
        id: loopBackAnimator
        running: false
        interval: reverseAnimSpeed + reverseStillTime
        repeat: true

        property int loops: 0

        onTriggered: {
            currentDigitAnimation.start();
            previousDigitAnimation.start();
            if (upper) {
                digitA = Math.max(0, loops - 1);
                digitB = loops;
            } else {
                digitA = loops;
                digitB = Math.max(0, loops - 1);
            }
            upper = !upper;
            loops--;

            if (loops < 0) {
                animOffset = -animOffset;
                animSpeed = baseAnimSpeed;
                loopBackAnimator.stop(); 
            }
        }
    }

    NumberAnimation {
        id: currentDigitAnimation
        target: currentText
        property: "y"
        from: (upper ? animOffset : baseOffset) - (!upper ? ((currentText.height - currentText.font.pixelSize) / 4) : 0)
        to: (upper ? baseOffset : -animOffset) - (upper ? ((currentText.height - currentText.font.pixelSize) / 4) : 0)
        duration: animSpeed
        easing.type: Easing.OutCubic
    }

    NumberAnimation {
        id: previousDigitAnimation
        target: previousText
        property: "y"
        from: (upper ? baseOffset : animOffset) - (!upper ? 0 : ((previousText.height - previousText.font.pixelSize) / 4))
        to: (upper ? -animOffset : baseOffset) - (upper ? 0 : ((previousText.height - previousText.font.pixelSize) / 4))
        duration: animSpeed
        easing.type: Easing.OutCubic
    }
}

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import ScreenInfo 1.0

Rectangle {
    id: displaySettingsRoot
    property ScreenInfo screenInfo
    property list<Item> screenComponents
    property alias fullScreen: activateFullScreenRadioButton.checked
    property bool stretchedLeftRight: false
    property size viewportSize: Qt.size(1920, 1080)
    property rect mainGeometry: Qt.rect(0,0,640,480)
    property int topMost
    property int bottomMost
    property int leftMost
    property int rightMost
    property bool applyableAsFullScreen
    property bool applyableAsStretched
    property bool mainVisible: true
    signal apply
    signal close
    width: 640
    height: 480
    color: "#dfe3ee"
    focus: true

    Component.onCompleted: {
        forceActiveFocus()
    }

    function layoutScreens() {
        var screenComponentsTmp = []
        var startX = 0
        var maxX = 0
        var maxY = 0
        for(var i in screenInfo.screens) {
            var screen = screenInfo.screens[i]
            maxX = Math.max(maxX, screen.geometry.x + screen.geometry.width)
            maxY = Math.max(maxY, screen.geometry.y + screen.geometry.height)
        }

        for(var i in screenInfo.screens) {
            var screen = screenInfo.screens[i]
            var xScale = screenArea.width / maxX * 0.8
            var yScale = screenArea.height / maxY * 0.8
            var scale = Math.min(xScale, yScale)
            var screenObject = screenRectComponent.createObject(screenArea)
            screenObject.screen = screen
            screenObject.x = screenArea.width * 0.1 + screen.geometry.x * scale
            screenObject.y = screenArea.height * 0.1 + screen.geometry.y * scale
            screenObject.width = screen.geometry.width * scale
            screenObject.height = screen.geometry.height * scale
            screenObject.use = true
            startX += screenObject.width + 10
            screenComponentsTmp.push(screenObject)
        }
        screenComponents = screenComponentsTmp
        updateGeometry()
    }

    function checkApplyability() {
        var applyableTmp = false
        var applyableStretchedTmp = false
        for(var i in screenComponents) {
            if(screenComponents[i].use) {
                applyableTmp = true
            }
        }
        applyableAsFullScreen = applyableTmp
        applyableAsStretched = applyableStretchedTmp
    }

    function updateGeometry() {
        if(!fullScreen) {
            mainGeometry.x = 0
            mainGeometry.y = 0
            mainGeometry.width = parent.width * 0.6
            mainGeometry.height = parent.height
            mainVisible = true
        } else {
            var mainMinX = 999999
            var mainMinY = 999999
            var mainMaxX = 0
            var mainMaxY = 0
            leftMost = 0;
            rightMost = 0;
            topMost = 0;
            bottomMost = 0;
            var leftMostPixel = 999999;
            var rightMostPixel = -999999;
            var topMostPixel = 999999;
            var bottomMostPixel = -999999;
            var mainInUse = false
            for(var i in screenComponents) {
                var screen = screenComponents[i].screen
                var geometry = screen.geometry
                var screenID = screen.id
                if(screenComponents[i].use) {
                    var screenLeftMostPixel = geometry.x;
                    var screenRightMostPixel = geometry.x + geometry.width;
                    var screenTopMostPixel = geometry.y;
                    var screenBottomMostPixel = geometry.y + geometry.height;
                    if(screenLeftMostPixel < leftMostPixel) {
                        leftMostPixel = screenLeftMostPixel;
                        leftMost = screenID;
                    }
                    if(screenRightMostPixel > rightMostPixel) {
                        rightMostPixel = screenRightMostPixel;
                        rightMost = screenID;
                    }
                    if(screenTopMostPixel < topMostPixel) {
                        topMostPixel = screenTopMostPixel;
                        topMost = screenID;
                    }
                    if(screenBottomMostPixel > bottomMostPixel) {
                        bottomMostPixel = screenBottomMostPixel;
                        bottomMost = screenID;
                    }
                    mainInUse = true
                    mainMinX = Math.min(mainMinX, geometry.x)
                    mainMinY = Math.min(mainMinY, geometry.y)
                    mainMaxX = Math.max(mainMaxX, geometry.x + geometry.width)
                    mainMaxY = Math.max(mainMaxY, geometry.y + geometry.height)
                }
            }
            mainGeometry.x = 0
            mainGeometry.y = 0

            mainGeometry.width = mainMaxX - mainMinX
            mainGeometry.height = mainMaxY - mainMinY

            mainVisible = mainInUse
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            screenInfo.fullScreenWindowUnderCursor()
        }
    }

    MouseArea {
        id: dummyArea
        anchors.fill: parent
        onClicked: {

        }
    }

    ColumnLayout {
        id: controls
        anchors {
            fill: parent
            margins: parent.width * 0.02
        }
        spacing: parent.width * 0.02

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "1) Select the screens on which you want the application to be fullscreened:"
        }

        Rectangle {
            id: screenArea
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#8b9dc3"
            Rectangle {
                anchors.fill: parent
                visible: !screenArea.enabled
                color: "white"
                opacity: 0.8
                z: 99
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Label {
                text: "2) On clicking Return/Enter, fullscreen should be"
            }
            RadioButton {
                id: activateFullScreenRadioButton
                exclusiveGroup: fullScreenGroup
                checked: true
                text: "Enabled"
            }

            RadioButton {
                exclusiveGroup: fullScreenGroup
                text: "Disabled"
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "3) Move the mouse pointer to the window you want to fullscreen (without clicking it) and press the Return/Enter key."
        }

        ExclusiveGroup {
            id: fullScreenGroup
        }
    }

    Component {
        id: screenRectComponent
        Rectangle {
            id: screenRect
            property bool selected: false
            property bool use: false
            property ScreenInfoScreen screen
            width: 100
            height: 60
            color: "#3b5998"
            border {
                color: "#dfe3ee"
                width: parent.width * 0.01
            }
            Rectangle {
                color: screenRect.use ? "#dfe3ee" : "#3b5998"
                border.width: 1
                border.color: "#f7f7f7"
                anchors.fill: parent
                anchors.margins: parent.width * 0.1
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    screenRect.use = !screenRect.use
                    checkApplyability()
                    updateGeometry()
                }
            }

        }
    }
}

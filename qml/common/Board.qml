/*
  Copyright (C) 2015-2021 Jolla Ltd.
  Copyright (C) 2015-2021 Slava Monich <slava.monich@jolla.com>

  You may use this file under the terms of the BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer
       in the documentation and/or other materials provided with the
       distribution.
    3. Neither the names of the copyright holders nor the names of its
       contributors may be used to endorse or promote products derived
       from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//import QtQuick 1.1  // Harmattan
import QtQuick 2.0  // Sailfish
import harbour.lines 1.0

Image {
    id: board
    sourceSize.width: width
    sourceSize.height: height
    fillMode: Image.PreserveAspectFit
    source: "images/board.svg"
    height: width

    property variant theme
    property variant game
    property real cellSize: height/Lines.Rows
    property bool animateSelection: true

    signal gameOverPanelClicked()
    signal ballBounced()
    signal moveFinished()

    Component.onCompleted: {
        gameOverOpacityBehavior.animation = theme.opacityAnimation.createObject(gameOver)
    }

    GridView {
        id: grid
        interactive: false
        anchors.fill: parent
        cellHeight: cellSize
        cellWidth: cellSize
        model: LinesModel { game: board.game }
        delegate: BoardCell {
            width: grid.cellWidth
            height: grid.cellHeight
            game: board.game
            row: model.row
            column: model.column
            color: model.color
            state: model.state
            animateSelection: board.animateSelection
            onBallBounced: board.ballBounced()
            onMoveFinished: board.moveFinished()
        }
        focus: true
    }

    GameOver {
        id: gameOver
        theme: board.theme
        anchors.centerIn: grid
        width: cellSize*7
        height: cellSize*3
        visible: opacity > 0
        opacity: game.over ? 1 : 0
        text: game.newRecord ? qsTr("message-new-record") : qsTr("message-game-over")
        Behavior on opacity { id: gameOverOpacityBehavior }
        onPanelClicked: board.gameOverPanelClicked()
    }
}

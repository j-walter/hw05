import "phoenix_html";

import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";

import Game from "./game";

function ready(channel, state) {
  let root = document.getElementById('root');
  ReactDOM.render(<Game state={state} channel={channel} />, root);
}

function start() {
  let gameName = prompt("Please specify a game name", "Game");
  let channel = socket.channel("game:" + gameName, {});
  channel.join()
    .receive("ok", state0 => {
      console.log("Joined successfully", state0);
      ready(channel, state0);
    })
    .receive("error", resp => { console.log("Unable to join", resp); });
}

// Use jQuery to delay until page loaded.
$(start);


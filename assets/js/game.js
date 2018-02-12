import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default class Game extends React.Component {
  constructor(props) {
    super(props);
    this.state = this.props.state;
    var check = this.check.bind(this);
  }

  reset() {
   this.props.channel.push("reset", {}).receive("ok", state => {
      this.setState(state)
    });
  }

  check() {
    if (this.state.selectedIds) {
      this.props.channel.push("check", {}).receive("ok", state => {
        this.setState(state);
      });
      setTimeout(() => this.check(), 100);
    }
  }

  toggle(params) {
    this.props.channel.push("toggle", {id: params.id}).receive("ok", state => {
      this.setState(state);
      setTimeout(() => this.check(), 500);
    });
  }
  
  render() {
    var toggle = this.toggle.bind(this);
    return (
      <div>
        <h4>
          Clicks: {this.state.clicks}
        </h4>
        <div className="tiles">
          {this.state.tiles.map((v, i) => <Tile key={i} id={i} value={v.value} isSolved={v.isSolved} toggle={toggle} />)}
        </div>
        <div className="clear" /><br />
        <Button onClick={ () => this.setState(this.reset()) }>Reset</Button>
      </div>
    )
  }

}

function Tile(params) {
  var outerStyle = {color: (params.isSolved ? "green" : "black")};
  var value = (!params.value ? "\u00A0" : params.value);
  return (
    <div className="tile" style={outerStyle} onClick={() => params.toggle(params)} >
      <div>
        {value}
      </div>
    </div>
  )
}

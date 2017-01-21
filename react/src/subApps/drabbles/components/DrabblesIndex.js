import React, { Component } from 'react';
import DrabbleFormContainer from '../containers/DrabbleFormContainer';

class DrabblesIndex extends Component {
  constructor(props) {
    super(props)
  }

  render(){

    return(
      <div className='row'>
        <div className='small-12 columns'>
          <DrabbleFormContainer />
        </div>
      </div>
    );
  }
}

export default DrabblesIndex;

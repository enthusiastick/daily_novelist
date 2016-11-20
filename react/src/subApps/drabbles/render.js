import React from 'react';
import ReactDOM from 'react-dom';
import { browserHistory } from 'react-router';
import { syncHistoryWithStore } from 'react-router-redux';
import Root from './components/Root';
import configureStore from '../../sharedResources/store/configureStore';

const store = configureStore();
const history = syncHistoryWithStore(browserHistory, store);

let render = element => {
  ReactDOM.render(
    <Root store={store} history={history} />,
    element
  );
};

export default render;

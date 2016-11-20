import 'babel-polyfill';
import React from 'react';
import ReactDOM from 'react-dom';
import renderDrabbles from './subApps/drabbles/render';

$(function() {
  let reactDrabbles = document.getElementById(
    'react-drabbles'
  );
  if (reactDrabbles) {
    renderDrabbles(reactDrabbles);
  }
});

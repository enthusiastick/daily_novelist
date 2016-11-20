import React from 'react';
import { Router, Route } from 'react-router';

import DrabblesContainer from '../subApps/drabbles/containers/DrabblesContainer';

let routes = (
  <Route path="/">
    <Route path="drabbles" component={DrabblesContainer} />
  </Route>
);

export default routes;

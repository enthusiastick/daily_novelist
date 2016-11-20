import React from 'react';
import { connect } from 'react-redux';
import DrabblesIndex from '../components/DrabblesIndex';

const mapStateToProps = (state) => {
  return {}
}

const mapDispatchToProps = (dispatch) => {
  return {}
}

const DrabblesContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(DrabblesIndex)

export default DrabblesContainer;

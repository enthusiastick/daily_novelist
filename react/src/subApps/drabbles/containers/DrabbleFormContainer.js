import React, { Component } from 'react';
import { reduxForm } from 'redux-form';
import DrabbleForm from '../components/DrabbleForm';
// import { postDrabble } from '../actions/postDrabble';

let onSubmit = (formFields, dispatch) => {
  alert('You clicked the button!')
  // return dispatch(postQuestionComment(formFields));
}

let validate = (formFields) => {
  const errors = {};
  return errors;
}

export default reduxForm({
  form: 'drabbleForm',
  validate,
  onSubmit
})(DrabbleForm);

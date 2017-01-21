import React, { Component } from 'react';
import { Field } from 'redux-form';

let WrappedReduxField = ({ input, label, meta: { touched, error }, type, id }) => {
  let inputType = <textarea {...input} type={type} id={id} rows="15" />;

  return (
    <div>
      <div>
        <label htmlFor={id}> { label } </label>
      </div>
      <div>
        { touched && error && <span style={{color: 'red'}}>{error}</span> }
      </div>
      <div>
        { inputType }
      </div>
    </div>
  )
}

let DrabbleForm = ({handleSubmit, error, pristine, submitting}) => {
  return(
    <form onSubmit={handleSubmit}>
      <Field
        id="new-drabble-body"
        key="body"
        name="body"
        type="textarea"
        component={WrappedReduxField}
      />
      <button type="submit" className="button">
        Submit
      </button>
      <div>
        { error && <span style={{color: 'red'}}>{ error }</span> }
      </div>
    </form>
  )
}

export default DrabbleForm;

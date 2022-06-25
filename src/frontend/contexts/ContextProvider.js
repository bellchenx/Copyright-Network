import React, {createContext, useContext, useState} from 'react'

const StateContext = createContext();

const initialState = {
  userProfile: false,
}

export const ContextProvider = ({children}) => {
  return (
    <StateContext.Provider
      value={{test: 'test'}}
    >
      {children}
    </StateContext.Provider>
  )
}
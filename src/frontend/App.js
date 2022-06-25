import React, {useEffect} from 'react';
import{TooltipComponent} from '@syncfusion/ej2-react-popups';
import {FiSettings} from 'react-icons/fi';

import {Navbar, Sidebar} from './components';
import {Canvas, Home} from './pages';
import './App.css';

import { useStateContext} from './contexts/ContextProvider'
import { BrowserRouter, Routes, Route } from 'react-router-dom';

const App = () => {
  const {activeMenu} = useStateContext();
  return (
    <div>
      <BrowserRouter>
        <div className="flex relative dark:bg-main-dark-bg">
          <div className="fixed right-4 bottom-4"
            style={{zIndex: '1000'}}
          >
            <TooltipComponent content="Settings" position="Top">
              <button type="button"
                className="text-3xl p-3 hover:drop-shadow-xl hover:bg-light-gray text-white"
                style={{background: 'blue', borderRadius: '50%'}}
              >
                <FiSettings/>
              </button>
            </TooltipComponent>
          </div>
          {activeMenu ? (
            <div className="w-72 fixed sidebar dark:bg-secondary-dark-bg bg-white">
              <Sidebar/>
            </div>
          ) : (
            <div className="w-0 dark:bg-secondary-dark-bg">
              <Sidebar/>
            </div>
          )}
          <div className={`dark:bg-main-bg bg-main-bg min-h-screen w-full ${activeMenu ? 'md:ml-72' : 'flex-2'}`}>
            <div className="fixed md:static bg-main-bg dark:bg-main-dark-bg navbar w-full">
              <Navbar/>
            </div>
            <div>
              <Routes>
                {/* Dashboard */}
                <Route path = "/" element={<Home/>}/>
                {/* Apps */}
                <Route path = "/canvas" element={<Canvas/>}/>
              </Routes>
            </div>
          </div>
        </div>
      </BrowserRouter>
    </div>
  )
}

export default App
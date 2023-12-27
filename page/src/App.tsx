import React from 'react';
import { createGlobalStyle } from 'styled-components';
import NavigationBar from './components/NavigationBar';
import Router from './Router';
import { HashRouter } from 'react-router-dom';

function App() {
  return (
  <>
  <HashRouter>
    <NavigationBar/>
    <Router />
  </HashRouter>
  </>
  );
}

export default App;

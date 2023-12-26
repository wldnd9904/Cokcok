import React from 'react';
import { createGlobalStyle } from 'styled-components';
import NavigationBar from './components/NavigationBar';
import Router from './Router';

function App() {
  return (
  <>
    <NavigationBar />
    <Router />
  </>
  );
}

export default App;

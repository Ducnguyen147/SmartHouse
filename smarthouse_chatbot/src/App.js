import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom'
import Theme from './layouts/Theme';
import ChatbotPage from"./pages";

function App() {
  return (

      <Router>
        <Theme >
            <Routes>
                <Route path={"/"} element={<ChatbotPage/>}/>
            </Routes>
        </Theme>
      </Router>
  );
}

export default App;

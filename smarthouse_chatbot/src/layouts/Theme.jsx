import React from 'react';
import { ThemeProvider } from 'styled-components';


// all available props
const theme = {
    background: 'transparent', // was #f5f8fb, now transparent
    fontFamily: 'Helvetica Neue',
    headerBgColor: '#223245',
    headerFontColor: '#fff',
    headerFontSize: '15px',
    botBubbleColor: '#223245',
    botFontColor: '#fff',
    userBubbleColor: '#fff',
    userFontColor: '#223245',
  };


const ThemedExample = ({children}) => (
    <ThemeProvider theme={theme}>
        {children}
    </ThemeProvider>
);

export default ThemedExample;
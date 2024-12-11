import React from 'react';
import { ThemeProvider } from 'styled-components';


// all available props
const theme = {
    background: '#f5f8fb',
    fontFamily: 'Helvetica Neue',
    headerBgColor: '#0028ef',
    headerFontColor: '#fff',
    headerFontSize: '15px',
    botBubbleColor: '#0028ef',
    botFontColor: '#fff',
    userBubbleColor: '#fff',
    userFontColor: '#4a4a4a',
};


const ThemedExample = ({children}) => (
    <ThemeProvider theme={theme}>
        {children}
    </ThemeProvider>
);

export default ThemedExample;
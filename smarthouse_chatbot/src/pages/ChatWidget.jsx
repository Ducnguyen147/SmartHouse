import React, { useRef, useState, useEffect} from 'react';
import { Widget, addResponseMessage , toggleMsgLoader ,toggleWidget } from 'react-chat-widget';
import 'react-chat-widget/lib/styles.css';
import '../styles/widget.css';
import ChatButton from './ChatBottun';
import { ReactComponent as CloseIcone } from '../resources/images/close.svg';
const Chatbot = () => {
    const [isChatOpen, setIsChatOpen] = useState(true);
    const [isTyping, setIsTyping] = useState(false);
    const [color, setColor] = useState('#161617');
    const timeoutIds = useRef([])
    const times = useRef(0)



   // const timeoutIds = useRef([]);
    timeoutIds.current.forEach((id) => clearTimeout(id));
    timeoutIds.current = [];
    //const [currentMessage, setCurrentMessage] = useState('');
    const [responseParts, setResponseParts]= useState([]);


    const handleNewUserMessage = async (message) => {
        timeoutIds.current.forEach((id) => clearTimeout(id));
        timeoutIds.current = [];
        setIsTyping(true)
        toggleMsgLoader()
        //console.log(isTyping)
        let response = await fetch('http://localhost:5000/llm/text-generatio', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(
                {
                    model: "mistralai/Mistral-7B-Instruct-v0.3",
                    user_query: message,
                    max_new_tokens: 1000,
                    stream: false
                }
            ),
        }).then(res => res.json())
        let temp =""
        temp  = response?.generated_text?.toString();
        let responseString = JSON.parse(temp.replace(/'/g, '"'))
        
        

        setResponseParts( ()=> (responseString !== undefined  && responseString.length >0)
            ? responseString.split(' ') : "How can I help you".split(' '))
console.log("in get func "+responseParts)
if(color === 'black'){
    toggleMsgLoader();
    addResponseMessage(responseString);
    setColor('#161617')
}
        setIsTyping(false);
    };
   // useEffect(() => {toggleWidget();})
    useEffect(() => {
        console.log("responseParts in use effect "+ responseParts)
        const fetchData = async () => {
            const data = await someAsyncFunction(); // Simulate async work
            if(times.current != 0) {

                Promise.all(data).then(value => {
                       // toggleMsgLoader();
                        setIsTyping(false)
                        setColor('black');
                    }
                )

            }
            times.current= 1;
            //setColor("blue");


        };
       fetchData();

    }, [responseParts]);

    async function someAsyncFunction() {
        // Simulate API call or async
        console.log("responseParts i async func "+ responseParts)
        return  responseParts.map((responsePart, index)=>( new Promise((resolve) =>
            setTimeout(() => resolve( responsePart), index*100)
        ).then(res => res)
        ));


    }


    const handleToggleChat = () => {
        toggleWidget(); // Built-in method to toggle the chat widget
        setIsChatOpen(!isChatOpen); // Update state for your own logic
    };

    return (
        <div className="App" style={{color: `${color}`, background: '#eeeeee'}}>
            {
                isChatOpen
                ? <button className={"btn-style"} onClick={handleToggleChat}></button>
                : <button className={"btn-style-close"} onClick={handleToggleChat}>
                   <span style={{ color: "#ffffff", fontSize: "24px" }}>X</span>
                    </button>
}
            
            <div >
                <Widget
                    handleNewUserMessage={handleNewUserMessage}
                    title="Your Smart Assistant"
                    subtitle=""
                    senderPlaceHolder="Type your message..."
                    showTyping={isTyping}
                />
            </div>

        </div>
    );
};

export default Chatbot;

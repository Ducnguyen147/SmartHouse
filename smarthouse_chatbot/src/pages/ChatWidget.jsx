import React, { useRef, useState, useEffect} from 'react';
import { Widget, addResponseMessage , toggleMsgLoader ,toggleWidget } from 'react-chat-widget';
import 'react-chat-widget/lib/styles.css';
import '../styles/widget.css';

const Chatbot = () => {
    const [isChatOpen, setIsChatOpen] = useState(false);
    const [isTyping, setIsTyping] = useState(false);
    const [color, setColor] = useState('#223245');
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
        let response = await fetch('http://localhost:5000/llm/text-generation', {
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

        let responseString= response?.generated_text?.toString();

        let validJsonString = responseString.replace(/'/g, '"');

        let data;
        try {
        data = JSON.parse(validJsonString);
        } catch (err) {
        console.error("Invalid JSON format in response:", err);
        data = [];
        }

        // 2. Transform each device into a human-readable phrase.
        //    - Convert "True" to "has been turned on" or "False" to "has been turned off".
        //    - Use the device and room information in a sentence.

        function humanizeStatus(device, status, room) {
        let isOn = status.toLowerCase() === "true";
        let action = isOn ? "has been turned on" : "has been turned off";
        return `The ${device} in ${room} ${action}`;
        }

        // 3. Map over all devices and create a combined sentence.
        const transformedResponse = data.map(item => {
        return humanizeStatus(item.device, item.status, item.room);
        }).join('\n ');

        setResponseParts( ()=> (transformedResponse !== undefined  && transformedResponse.length >0)
            ? transformedResponse.split(' ') : "How can I help you".split(' '))
console.log("in get func "+responseParts)
if(color === 'black'){
    toggleMsgLoader();
    addResponseMessage(transformedResponse);
    setColor('#161617')
}
        setIsTyping(false);
    };
   // useEffect(() => {})
    useEffect(() => {
        console.log("responseParts in use effect "+ responseParts)
        const fetchData = async () => {
            const data = await someAsyncFunction(); // Simulate async work
            if(times.current !== 0) {

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
        <div className="App" style={{color: `${color}`}}>
            <button className={"btn-style"} onClick={handleToggleChat}>
            </button>
            <div style={{position: "absolute"}}>
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

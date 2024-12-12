import React, { useRef } from 'react';

function ChatButton() {
  const iframeRef = useRef(null);

  const toggleChat = () => {
    // Send a postMessage to the Flutter iframe
    iframeRef.current.contentWindow.postMessage(
      { action: 'toggle_chat' },
      '*' // Replace '*' with specific origin for security
    );
  };

  return (
    <div>
      {/* Show/Hide Button */}
      <button onClick={toggleChat}>
        Show/Hide Chat
      </button>

      {/* Iframe Embedding Flutter App */}
      <iframe
        ref={iframeRef}
        src="http://localhost:56007"
        title="Flutter App"
        style={{ width: '100%', height: '100vh', border: 'none' }}
      ></iframe>
    </div>
  );
}

export default ChatButton;

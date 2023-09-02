import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

ReactDOM.render(
  <React.StrictMode>
    <App />
    <ToastContainer pauseOnFocusLoss={false} position="bottom-center" style={{zIndex: 100}} />
  </React.StrictMode>,
  document.getElementById('root')
);

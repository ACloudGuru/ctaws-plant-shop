import logo from './logo.svg';
import './App.css';
import React, { useState, useEffect } from "react";

const apiUrl = `http://${window.location.hostname}:8080`;

function App() {
  const [itemData, setItemData] = useState({});

  useEffect(() => {
    getItemsWithFetch();
  }, []);

  const getItemsWithFetch = async () => {
    const response = await fetch(apiUrl);
    const jsonData = await response.json();
    setItemData(jsonData);
  };

  return (
    <div className="App">
      <header className="App-header">
        <h2>Plant Shop</h2>
      </header>
      <div className="items-container">
        {itemData.items?.map(item => (
          <div className="item-card">
            <h4>{item.name}</h4>
            <h5>{item.description}</h5>
            <h6>${item.price}</h6>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;

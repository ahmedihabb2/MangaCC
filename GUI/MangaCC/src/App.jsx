import { useState } from 'react'

import Code from './components/Code/Code';
import Actions from './components/Actions/Actions';
import Logs from './components/Logs/Logs';

import logo from './assets/logo.png'
import './App.css'

function App() {
  const [code, setCode] = useState("// Write your code here\nint main() {\n\treturn 0;\n}")
  return (

    <main>
      <header>
        <img src={logo} alt="logo" />
        <h1>MangaCC</h1>
      </header>
      <div className="code-area">
        <h2>Code Area</h2>
        <Code code={code} setCode={setCode} />
      </div>
      <div className="quadruples">
        <h2>Quadruples</h2>
      </div>
      <div className="symbol-table">
        <h2>Symbol Table</h2>
      </div>
      <Logs />
      <Actions code={code} />
    </main>
  )
}

export default App

/**
 * 
 * .split("\n")
      .map((line, i) => `<span class='editorLineNumber'>${i + 1}</span>${line}`)
      .join("\n");
 */


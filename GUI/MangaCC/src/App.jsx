import { useState } from 'react'

import Code from './components/Code/Code';
import Actions from './components/Actions/Actions';
import Logs from './components/Logs/Logs';
import Quads from './components/Quads/Quads';
import SymbolTable from './components/SymbolTable/SymbolTable';

import logo from './assets/logo.png'
import './App.css'

function App() {
  const [code, setCode] = useState("// Write your code here\nint main() {\n\treturn 0;\n}")
  const [warnings, setWarnings] = useState([])
  const [errors, setErrors] = useState([])
  const [quads, setQuads] = useState([])
  const [status, setStatus] = useState('')
  const [symbolTable, setSymbolTable] = useState([])
  return (

    <main>
      <header>
        <img src={logo} alt="logo" />
        <h1>MangaCC</h1>
      </header>
      <div className="code-area">
        <h2>Code Area</h2>
        <Code code={code} setCode={setCode} setStatus={setStatus} />
      </div>
      <Quads quads={quads} />
      <SymbolTable symbolTable={symbolTable} />
      <Logs warnings={warnings} errors={errors} />
      <Actions code={code} setErrors={setErrors} setWarning={setWarnings}
        status={status} setStatus={setStatus} setQuads={setQuads} setSymbolTable={setSymbolTable} />
    </main>
  )
}

export default App

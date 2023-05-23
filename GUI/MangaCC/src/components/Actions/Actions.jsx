import { useState } from 'react'
import Button from '@mui/material/Button';
import './Actions.css'
const Actions = ({ code, setWarning, setErrors, setQuads, status, setStatus, setSymbolTable }) => {
    const [loading, setLoading] = useState(false)

    return (
        <div className="actions">
            <Button variant="contained" disabled={loading} onClick={() => {
                setLoading(true)
                setStatus('Loading')
                // send a request to the backend
                fetch('http://localhost:3000/generate', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ "code": code })
                })
                    .then(res => res.json())
                    .then(
                        (result) => {
                            const { warnings, errors, quads, symbolTable } = result
                            setWarning(warnings)
                            setErrors(errors)

                            setLoading(false)
                            if (errors.length > 0) {
                                setStatus('Error')
                                setSymbolTable([])
                                setQuads([])
                            }
                            else {
                                if (warnings.length > 0) {
                                    setStatus('Warning')
                                }
                                else {
                                    setStatus('Success')
                                }
                                setSymbolTable(symbolTable)
                                setQuads(quads)
                            }


                        }
                    ).catch((error) => {
                        setLoading(false)
                        setStatus('Error')
                        console.log(error)
                    })
            }} sx={
                {
                    backgroundColor: '#07a',
                    fontSize: '18px'
                }
            }>Generate</Button>
            <div className='status' style={
                {
                    color: status === 'Error' ? 'red' : status === 'Success' ? 'green' : status === 'Warning' ? 'orange' : 'black',
                }
            }>Status: {status}</div>
        </div>
    );
}

export default Actions;
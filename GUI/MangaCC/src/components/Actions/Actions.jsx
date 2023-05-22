import { useState } from 'react'
import Button from '@mui/material/Button';
import './Actions.css'
const Actions = ({ code, setWarning, setErrors, setQuads, status, setStatus }) => {
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
                            const { warnings, errors, quads } = result
                            setWarning(warnings)
                            setErrors(errors)
                            setQuads(quads)
                            setLoading(false)
                            if (errors.length > 0) {
                                setStatus('Error')
                            }
                            else {
                                setStatus('Success')
                            }


                        }
                    )
            }}>Generate</Button>

            <Button variant="contained">Step</Button>
            <div className='status'>Status: {status}</div>
        </div>
    );
}

export default Actions;
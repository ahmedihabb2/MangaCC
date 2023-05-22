import Button from '@mui/material/Button';
const Actions = ({ code }) => {
    return (
        <div className="actions">
            <Button variant="contained" onClick={() => {
                // send a request to the backend
                fetch('http://localhost:3000/generate', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ "code": code })
                })
                    .then(res => res.json())
                    .then(data => console.log(data))
            }}>Generate</Button>

            <Button variant="contained">Step</Button>
        </div>
    );
}

export default Actions;
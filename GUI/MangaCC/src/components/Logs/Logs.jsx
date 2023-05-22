import Alert from '@mui/material/Alert';
import './Logs.css'

const Logs = () => {
    return (
        <div className="logs">
            <h2>Logs</h2>
            <div className="logs-content">
                <Alert severity="error">This is an error alert — check it out!</Alert>
                <Alert severity="warning">This is a warning alert — check it out!</Alert>
                <Alert severity="error">This is an error alert — check it out!</Alert>
                <Alert severity="warning">This is a warning alert — check it out!</Alert>
                <Alert severity="error">This is an error alert — check it out!</Alert>
                <Alert severity="warning">This is a warning alert — check it out!</Alert>
            </div>
        </div>
    );
}

export default Logs;
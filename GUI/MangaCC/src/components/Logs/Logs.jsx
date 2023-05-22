import Alert from '@mui/material/Alert';
import './Logs.css'

const Logs = ({ warnings, errors }) => {
    return (
        <div className="logs">
            <h2>Logs</h2>
            <div className="logs-content">
                {warnings && warnings.map((warning, i) => <Alert key={i} severity="warning">{warning}</Alert>)}
                {errors && errors.map((error, i) => <Alert key={i} severity="error">{error}</Alert>)}
            </div>
        </div>
    );
}

export default Logs;
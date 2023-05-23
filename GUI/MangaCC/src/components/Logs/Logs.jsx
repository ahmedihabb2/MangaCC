import Alert from '@mui/material/Alert';
import './Logs.css'

const Logs = ({ warnings, errors }) => {
    return (
        <div className="logs">
            <h2>Logs</h2>
            <div className="logs-content">
                {warnings && warnings.map((warning, i) => <Alert key={i} severity="warning" sx={
                    {
                        fontSize: '18px'
                    }
                }>{warning}</Alert>)}
                {errors && errors.map((error, i) => <Alert key={i} severity="error" sx={
                    {
                        fontSize: '18px'
                    }
                }>{error}</Alert>)}
                {
                    (warnings.length === 0 && errors.length === 0) &&
                    <Alert severity="success" sx={
                        {
                            fontSize: '18px'
                        }
                    }>Parsing Done</Alert>
                }
            </div>
        </div>
    );
}

export default Logs;
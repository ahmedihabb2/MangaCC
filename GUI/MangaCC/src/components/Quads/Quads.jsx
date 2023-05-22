import './Quads.css';
const Quads = ({ quads }) => {
    return (
        <div className="quadruples">
            <h2>Quadruples</h2>
            <div className="quadruples-content">
                {quads && quads.map((quad, i) => <p key={i} className="quad">{quad}</p>)}
            </div>
        </div>
    );
}

export default Quads;
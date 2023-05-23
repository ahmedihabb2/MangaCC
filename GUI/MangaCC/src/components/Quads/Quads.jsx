import './Quads.css';
const Quads = ({ quads }) => {
    const stack = ['PUSH', 'POP']
    const operations = ['ADD', 'SUB', 'MUL', 'DIV', 'MOD', 'AND', 'OR', 'NOT', 'XOR']
    const jumps = ['JUMP', 'JUMPZERO', 'JMPNONZERO']
    const conditions = ['EQ', 'NE', 'LT', 'LE', 'GT', 'GE']
    const conversions = ['Convi', 'Convf']
    return (
        <div className="quadruples">
            <h2>Quadruples</h2>
            <div className="quadruples-content">
                {quads && quads.map((quad, i) => <p key={i} className="quad">{quad.split(' ').map((word, i) => {
                    if (i === 0) {
                        return <span key={i} className="quad-type" style={
                            {
                                color: stack.includes(word) ? '#07a' : operations.includes(word) ? 'green' : jumps.includes(word) ? 'red' : conditions.includes(word) ? 'purple' : conversions.includes(word) ? 'orange' : 'black'
                            }
                        }>{word} {" "}</span>
                    }
                    else {
                        return <span key={i} className="quad-word">{word}{" "}</span>
                    }
                })

                }</p>)}
            </div>
        </div>
    );
}

export default Quads;
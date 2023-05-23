import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import './SymbolTable.css'
const SymbolTable = ({ symbolTable }) => {
    const headerStyle = {
        fontWeight: "bold",
        fontSize: "18px",
    }
    const symbolStyle = {
        fontSize: "18px",
        padding: "10px"
    }
    return (
        <div className="symbol-table">
            <h2>Symbol Table</h2>

            <div className="symbol-table-content">
                <TableContainer>
                    <Table sx={{ minWidth: 400 }} stickyHeader aria-label="simple table">
                        <TableHead>
                            <TableRow>
                                <TableCell sx={headerStyle}>Name</TableCell>
                                <TableCell sx={headerStyle}>Type</TableCell>
                                <TableCell sx={headerStyle}>Value</TableCell>
                                <TableCell sx={headerStyle}>Line</TableCell>
                                <TableCell sx={headerStyle} >Scope</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {symbolTable.map((symbol, i) => {
                                return (
                                    <>
                                        {
                                            <TableCell key={symbol} colSpan={5} sx={
                                                {
                                                    backgroundColor: "#07a",
                                                    fontWeight: "bold",
                                                    fontSize: "16px",
                                                    color: "white",
                                                    padding: "10px"
                                                }
                                            }>
                                                Line: {symbol.line}
                                            </TableCell>
                                        }
                                        {
                                            symbol.data.map((variable, j) => {
                                                return (
                                                    <TableRow
                                                        key={j + i}
                                                        sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                                                    >
                                                        <TableCell sx={symbolStyle} component="th" scope="row">{variable.name}</TableCell>
                                                        <TableCell sx={symbolStyle} >{variable.type}</TableCell>
                                                        <TableCell sx={symbolStyle} >{variable.value}</TableCell>
                                                        <TableCell sx={symbolStyle} >{variable.line}</TableCell>
                                                        <TableCell sx={symbolStyle} >{variable.scope}</TableCell>
                                                    </TableRow>
                                                )
                                            }
                                            )
                                        }
                                    </>
                                )
                            }
                            )

                            }
                        </TableBody >
                    </Table>
                </TableContainer>

            </div>
        </div>
    );
}

export default SymbolTable;
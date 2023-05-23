import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import './SymbolTable.css'
const SymbolTable = ({ symbolTable }) => {
    return (
        <div className="symbol-table">
            <h2>Symbol Table</h2>

            <div className="symbol-table-content">
                <TableContainer>
                    <Table sx={{ minWidth: 400 }} stickyHeader aria-label="simple table">
                        <TableHead>
                            <TableRow>
                                <TableCell>Name</TableCell>
                                <TableCell>Type</TableCell>
                                <TableCell>Value</TableCell>
                                <TableCell>Line</TableCell>
                                <TableCell>Scope</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {symbolTable.map((symbol, i) => {
                                return (
                                    <>
                                        {
                                            <TableCell key={symbol} colSpan={5} sx={
                                                {
                                                    backgroundColor: "#3f51b5",
                                                    fontWeight: "bold",
                                                    fontSize: "16px",
                                                    color: "white"
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
                                                        <TableCell component="th" scope="row">
                                                            {variable.name}
                                                        </TableCell>
                                                        <TableCell>{variable.type}</TableCell>
                                                        <TableCell>{variable.value}</TableCell>
                                                        <TableCell>{variable.line}</TableCell>
                                                        <TableCell>{variable.scope}</TableCell>
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
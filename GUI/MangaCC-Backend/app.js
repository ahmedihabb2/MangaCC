const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { exec } = require("child_process");
const fs = require('fs');
const PORT = 3000;

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.status(200);
    res.send("Welcome to root URL of Server");
});

app.post('/generate', (req, res) => {
    const { code } = req.body;

    // save code a text file
    try {
        fs.writeFileSync('test.c', code, 'utf8', { flag: 'w+' });
    } catch (err) {
        console.error(err);
    }
    // run a command to compile and run the code
    console.log("Compiling and Running the code");
    exec("./mangcc < test.c", (error, stdout, stderr) => {
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
        /*if (error) {
            console.log(`error: ${error.message}`);
            res.status(400);
            res.send(error.message);
            return;
        }*/

        // open console_logs.txt and read the output
        console.log("Reading the output");
        let warnings = []
        let errors = []

        try {
            const data = fs.readFileSync('console_logs.txt', 'utf8');
            const lines = data.split(/\r?\n/);
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].includes("Warning:")) {
                    warnings.push(lines[i]);
                } else if (lines[i].includes("Error:")) {
                    errors.push(lines[i]);
                }
            }
        } catch (err) {
            console.error(err);
        }

        let quads = []
        try {
            const data = fs.readFileSync('quads.txt', 'utf8');
            const lines = data.split(/\r?\n/);
            for (let i = 0; i < lines.length; i++) {
                quads.push(lines[i]);
            }
        } catch (err) {
            console.error(err);
        }

        let symbolTable = []
        try {
            const data = fs.readFileSync('symbol_table.txt', 'utf8');
            const lines = data.split(/\r?\n/);

            for (let i = 0; i < lines.length - 1; i++) {
                let num = parseInt(lines[i]);
                i += 2;
                let current = []
                while (i < lines.length & lines[i][0] != "=") {
                    let currentLine = lines[i].replaceAll(',', '').split(' ');
                    current.push({
                        name: currentLine[0], type: currentLine[1], value: currentLine[2],
                        line: currentLine[3], scope: currentLine[8]
                    });
                    i++;
                }
                symbolTable.push({ line: num, data: current });
            }
        } catch (err) {
            console.error(err);
        }

        // send the output to client
        console.log("Sending the output to client");
        res.status(200);
        res.send({ warnings, errors, quads, symbolTable });
    });

})

app.listen(PORT, (error) => {
    if (!error)
        console.log("Server is Successfully Running, and App is listening on port " + PORT)
    else
        console.log("Error occurred, server can't start", error);
}
);
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

    exec("./build.sh test.c", (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            res.status(400);
            res.send(error.message);
            return;
        }

        console.log("Done");
        res.status(200);
        res.send({ output: "done" });
    });

})

app.listen(PORT, (error) => {
    if (!error)
        console.log("Server is Successfully Running, and App is listening on port " + PORT)
    else
        console.log("Error occurred, server can't start", error);
}
);

import Editor from 'react-simple-code-editor';
import Prism from 'prismjs/components/prism-core';
import { highlight, languages } from 'prismjs/components/prism-core';
import 'prismjs/plugins/normalize-whitespace/prism-normalize-whitespace'
import 'prismjs/plugins/show-invisibles/prism-show-invisibles'
import 'prismjs/components/prism-clike'
import 'prismjs/components/prism-c'
import 'prismjs/components/prism-cpp'
import 'prismjs/themes/prism.css';
import './Code.css'
const Code = ({ code, setCode }) => {

    const hightlightWithLineNumbers = (input, language) =>
        highlight(input, language)
            .split("\n")
            .map((line, i) => `<span class='editorLineNumber'>${i + 1}</span>${line}`)
            .join("\n");
    return (
        <Editor
            value={code}
            onValueChange={code => setCode(code)}
            highlight={code => hightlightWithLineNumbers(code, languages.cpp)}
            padding={10}
            textareaId="codeArea"
            className="editor"
            textareaClassName='text-area'
            tabSize={2}
            insertSpaces={true}
            style={{
                fontFamily: '"Fira code", "Fira Mono", monospace',
                fontSize: 18,
                outline: 0
            }}
        />
    );
}

export default Code;
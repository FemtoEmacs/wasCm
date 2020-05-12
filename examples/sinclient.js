const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./sin.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  console.log("=== Solução correta ===");
    console.log(instance.exports.sin(0.78539816));
        console.log(instance.exports.sine(0.78539816));
};

run();
